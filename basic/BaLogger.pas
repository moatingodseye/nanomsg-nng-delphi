{$M+}
unit BaLogger;

interface

uses
  Windows,
  System.SysUtils, System.Classes, System.Contnrs, BaThread;
   
type
  TDoLog = procedure(AMessage : String) of object;
  TbaLogger = class(TObject)
  private
    FThread : TbaThread;
    FWait : TObjectList;
    FOnLog : TDoLog;
  protected
    procedure DoSynchronise(ASender,AData : TObject);
  public
    constructor Create(AUsing : TDoLog);
    destructor  Destroy; override;

    procedure Log(AMessage : String);
  published
  end;
  
implementation

type
  TInternal = class(TObject)
  private
    FText : String;
  protected
  public
    constructor Create(AText : String);
    destructor Destroy; override;

    property Text : String read FText;
  published
  end;
  
constructor TInternal.Create(AText : String);
begin
  inherited Create;
  FText := AText;
end;

destructor TInternal.Destroy;
begin
  inherited;
end;

procedure TbaLogger.DoSynchronise(ASender,AData : TObject);
var
  C : Integer;
  lObj : TInternal;
begin
  { This is syncrhonised so can access forms etc }
  FThread.Lock;
  try
    for C := 0 to FWait.Count-1 do begin
      lObj := FWait[C] as TInternal;
      if assigned(FOnLog) then
        FOnLog(lObj.Text);
    end;
    FWait.Clear;
  finally
    FThread.Unlock;
  end;
end;

constructor TbaLogger.Create(AUsing : TDoLog);
begin
  inherited Create;
  FOnLog := AUsing;
  FWait := TObjectList.Create;
  FThread := TbaThread.Create(20);
  FThread.OnSyThread := DoSynchronise;
end;

destructor TbaLogger.Destroy;
begin
  FOnLog := Nil;
  FThread.Free;
  FWait.Free;
  inherited;
end;

procedure TbaLogger.Log(AMessage : string);
var
  S : String;
begin
  FThread.Lock;
  try
    FWait.Add(TInternal.Create(AMessage));
    FThread.Kick;
  finally
    FThread.UnLock;
  end;
end;

end.
