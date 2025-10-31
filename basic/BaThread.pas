{$M+}
unit BaThread;

interface

uses
  System.SyncObjs, System.Classes, System.SysUtils;

type
  TbaThread = class;
  TbaThreadEvent = procedure(ASender, AData : TObject) of object;

  TbaInternal = class(TThread)
  private
    FPeriod,
    FGranularity : Integer;
    FLast : Integer;
    FTarget : TbaThread;
    FLock : TCriticalSection;
    FSignal : TEvent;
    FBusy : Integer;
    FEnabled : Integer;
  protected
    procedure Execute; override;
    procedure Threaded;
    procedure Idle;
    
    property Target : TbaThread read FTarget write FTarget;
  public
    constructor Create(APeriod, AGranularity : Integer); 
    destructor  Destroy; override;

    procedure Lock;
    procedure UnLock;
    procedure Kick;
    procedure Finish;
    function Busy : Boolean;

    property Enabled : Integer read FEnabled write FEnabled;
  published
  end;

  TbaThread = class(TObject)
  private
    FThread : TbaInternal;
    FOnAsThread,
    FOnAsIdle : TbaThreadEvent; { Asynchronous/threaded }
    FOnSyThread,
    FOnSyIdle : TbaThreadEvent; { Synchronse/Synchoronised }
    FData : TObject;
  protected
    procedure Threaded(ASynchronised : Boolean);
    procedure Idle(ASynchronised : Boolean);
    procedure SetOnAsThread(AEvent : TbaThreadEvent);
    procedure SetOnAsIdle(AEvent : TbaThreadEvent);
    procedure SetOnSyThread(AEvent : TbaThreadEvent);
    procedure SetOnSyIdle(AEvent : TbaThreadEvent);
  public                                             
    constructor Create(APeriod, AGranularity : Integer); virtual;
    destructor  Destroy; override;
    
    procedure Lock;
    procedure UnLock;
    procedure Kick;
    procedure Finish;
    function  Busy : Boolean;
    procedure SetPeriod(APeriod : Integer);
    
    property Data : TObject read FData write FData;
    property OnAsThread : TbaThreadEvent read FOnAsThread write SetOnAsThread;
    property OnAsIdle : TbaThreadEvent read FOnAsIdle write SetOnAsIdle;
    property OnSyIdle : TbaThreadEvent read FOnSyIdle write SetOnSyIdle;
    property OnSyThread : TbaThreadEvent read FOnSyThread write SetOnSyThread;
  published
  end;

implementation

uses
  System.Math, WinAPI.Windows;
  
var
  uID : Integer = 0;
  
procedure TbaInternal.Execute;
var
  lTick : Integer;
begin
  {Perform the background thread}
  while not Terminated do begin
    case FSignal.WaitFor(FGranularity) of
      wrSignaled :
        if not Terminated then begin
          Inc(FBusy);
          { Kicked into life ... }
          if FBusy=1 then begin
            if assigned(FTarget) then begin
              if (FEnabled AND 1)=1 then
                FTarget.Threaded(False);
              if (FEnabled AND 4)=4 then
                Synchronize(Threaded);
            end;
          end;
          Dec(FBusy);
        end;
      wrTimeout : 
        if not Terminated then begin
          lTick := GetTickCount;
          if ((lTick-FLast)>FPeriod) or (lTick<FLast) then begin
            Inc(FBusy);
            if assigned(FTarget) then begin
              if (FEnabled AND 2)=2 then
                FTarget.Idle(False);   
              if (FEnabled AND 8)=8 then
                Synchronize(Idle);  
            end;
            Dec(FBusy);
            FLast := lTick;
          end;
        end;
    end;
  end;
end;

procedure TbaInternal.Threaded;
begin
  if assigned(FTarget) then
    FTarget.Threaded(True);
end;

procedure TbaInternal.Idle;
begin
  if assigned(FTarget) then
    FTarget.Idle(True);
end;

constructor TbaInternal.Create(APeriod, AGranularity : Integer);
begin
  FEnabled :=- 0;
  FLock := TCriticalSection.Create;
  Inc(uID);
  FSignal := TEvent.Create(nil, False, False, 'xbaThreadx'+IntToHex(uID));
  FBusy := 0;
  FTarget := Nil;
  FPeriod := APeriod;
  FGranularity := AGranularity;
  inherited Create(False);
//  Priority := tpIdle;
  FreeOnTerminate := False;
end;

destructor TbaInternal.Destroy;
begin
  FSignal.Free;
  FLock.Free;
  inherited;
end;

procedure TbaInternal.Lock;
begin
  FLock.Acquire;
end;

procedure TbaInternal.Kick;
begin
  FSignal.SetEvent;
end;

procedure TbaInternal.UnLock;
begin
  FLock.Release;
end;

procedure TbaInternal.Finish;
begin
//  FBusy := 9;
  FLock.Acquire;
  FTarget := Nil;
  try
    Kick;
    Terminate;
    WaitFor;
  finally
    FLock.Release;
  end;
end;

function TbaInternal.Busy : Boolean;
begin
  result := FBusy>0;
end;

function IIF(ACheck : Boolean; AYes, ANo : Integer) : Integer;
begin
  result := ANo;
  if ACheck then
    result := AYes;
end;

procedure TbaThread.SetOnAsThread(AEvent : TbaThreadEvent);
begin
  FOnAsThread := AEvent;
  FThread.Enabled := FThread.Enabled OR IIF(Assigned(FOnAsThread),1,0);
end;

procedure TbaThread.SetOnAsIdle(AEvent : TbaThreadEvent);
begin
  FOnAsIdle := AEvent;
  FThread.Enabled := FThread.Enabled OR IIF(Assigned(FOnAsIdle),2,0);
end;

procedure TbaThread.SetOnSyThread(AEvent : TbaThreadEvent);
begin
  FOnSyThread := AEvent;
  FThread.Enabled := FThread.Enabled OR IIF(Assigned(FOnSyThread),4,0);
end;

procedure TbaThread.SetOnSyIdle(AEvent : TbaThreadEvent);
begin
  FOnSyIdle := AEvent;
  FThread.Enabled := FThread.Enabled OR IIF(Assigned(FOnSyIdle),8,0);
end;

constructor TbaThread.Create(APeriod,AGranularity : Integer);
begin
  inherited Create;
  APeriod := Max(10,APeriod);
  AGranularity := Max(10,AGranularity);
  FOnSyThread := Nil;
  FOnAsThread := Nil;
  FOnSyIdle := Nil;
  FOnAsIdle := Nil;
  FThread := TbaInternal.Create(APeriod, AGranularity);
  FThread.Target := Self;
end;                               

destructor  TbaThread.Destroy;
begin
  FThread.Finish;
  FThread.Free;
  inherited;
end;

procedure TbaThread.Threaded(ASynchronised : Boolean);
begin
  if ASynchronised then
    if assigned(FOnSyThread) then
      FOnSyThread(Self,FData);
  if not ASynchronised then
    if assigned(FOnAsThread) then
      FOnAsThread(Self,FData);
end;

procedure TbaThread.Idle(ASynchronised : Boolean);
begin
  if ASynchronised then
    if assigned(FOnSyIdle) then
      FOnSyIdle(Self,FData);
  if not ASynchronised then
    if assigned(FOnAsIdle) then
      FOnAsIdle(Self,FData);
end;     

procedure TbaThread.Lock;
begin
  FThread.Lock;
end;

procedure TbaThread.UnLock;
begin
  FThread.UnLock;
end;

procedure TbaThread.Kick;
begin
  FThread.Kick;
end;

procedure TbaThread.Finish;
begin
  FThread.Finish;
end;

function  TbaThread.Busy : Boolean;
begin
  result := FThread.Busy;
end;

procedure TbaThread.SetPeriod(APeriod : Integer);
begin
  FThread.FPeriod := APeriod;
end;

procedure Initialise;
begin
  uID := GetTickCount;
end;

initialization
  Initialise;
  
end.
