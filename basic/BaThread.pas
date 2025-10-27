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
    FPeriod : Integer;
    FTarget : TbaThread;
    FLock : TCriticalSection;
    FSignal : TEvent;
    FBusy : Integer;
  protected
    procedure Execute; override;
    procedure Threaded;
    procedure Idle;
    
    property Target : TbaThread read FTarget write FTarget;
  public
    constructor Create(APeriod : Integer); 
    destructor  Destroy; override;

    procedure Lock;
    procedure UnLock;
    procedure Kick;
    procedure Finish;
    function Busy : Boolean;
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
  public
    constructor Create(APeriod : Integer); virtual;
    destructor  Destroy; override;
    
    procedure Lock;
    procedure UnLock;
    procedure Kick;
    procedure Finish;
    function  Busy : Boolean;
    
    property Data : TObject read FData write FData;
    property OnAsThread : TbaThreadEvent read FOnAsThread write FOnAsThread;
    property OnAsIdle : TbaThreadEvent read FOnAsIdle write FOnAsIdle;
    property OnSyIdle : TbaThreadEvent read FOnSyIdle write FOnSyIdle;
    property OnSyThread : TbaThreadEvent read FOnSyThread write FOnSyThread;
  published
  end;

implementation

uses
  System.Math;
  
var
  uID : Integer = 1000;
  
procedure TbaInternal.Execute;
begin
  {Perform the background thread}
  while not Terminated do begin
    case FSignal.WaitFor(FPeriod) of
      wrSignaled :
        if not Terminated then begin
          Inc(FBusy);
          { Kicked into life ... }
          if FBusy=1 then begin
            if assigned(FTarget) then begin
              FTarget.Threaded(False);
              Synchronize(Threaded);
            end;
          end;
          Dec(FBusy);
        end;
      wrTimeout : 
        if not Terminated then begin
          Inc(FBusy);
          if assigned(FTarget) then begin
            FTarget.Idle(False);
            Synchronize(Idle);
          end;
          Dec(FBusy);
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

constructor TbaInternal.Create;
begin
  FLock := TCriticalSection.Create;
  Inc(uID);
  FSignal := TEvent.Create(nil, False, False, 'xbaThreadx'+IntToStr(uID));
  FBusy := 0;
  FTarget := Nil;
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

constructor TbaThread.Create(APeriod : Integer);
begin
  inherited Create;
  APeriod := Max(10,APeriod);
  FOnSyThread := Nil;
  FOnAsThread := Nil;
  FOnSyIdle := Nil;
  FOnAsIdle := Nil;
  FThread := TbaInternal.Create(APeriod);
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

end.
