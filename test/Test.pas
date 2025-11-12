{$M+}
unit Test;

interface

uses
  System.Classes,
  baThread, baLogger, LogForm, NNG, nngType;
  
const
  tsNever = 0;
  tsReady = 1;
  tsDone  = 2;
  tsClose = 4;
  tsError = 5;
  
type
  TTest = class(TObject)
  strict private
    FNNG : TNNG;
    FLog : TbaLogger;
    FForm : TfrmLog;
    FOnStop : TNotifyEvent;
  private
  strict protected
    FState : Integer;
    procedure DoLog(AMessage : String); // synchronised
  protected
    procedure Log(ALevel :ELog; AMessage : String);
    procedure Error(ALevel : ELog; AMessage : String);
    procedure DoStop(Sender : TObject);
    procedure DoKick(Sender : TObject);
  public
    constructor Create(ANNG : TNNG); virtual;
    destructor Destroy; override;

    procedure Start;
    procedure Kick;
    procedure Stop;
    
    function State : Integer;

    property OnStop : TNotifyEvent read FOnStop write FOnStop;
  published
  end;
  
implementation

uses
  System.SysUtils;

procedure TTest.DoLog(AMessage : String);
begin
  if assigned(FForm) then
    FForm.Log(AMessage);
end;

procedure TTest.Log(ALevel : ELog; AMessage : String);
begin
  FLog.Log(cLog[ALevel]+AMessage);
end;

procedure TTest.Error(ALevel : ELog; AMessage : String);
begin
  FLog.Log(cLog[ALevel]+AMessage);
  FState := tsError;
end;

procedure TTest.DoKick(Sender : TObject);
begin
  FNNG.Kick;
end;

procedure TTest.DoStop(Sender : TObject);
begin
  Stop;
end;

constructor TTest.Create(ANNG : TNNG);
begin
  inherited Create;
  FNNG := ANNG;
  FNNG.OnLog := Log;
  FNNG.OnError := Error;
  FState := tsNever;
  FLog := TbaLogger.Create;
  FLog.OnLog := DoLog;
  FForm := TfrmLog.Create(Nil);
  FForm.Data := ANNG;
  FForm.OnStop := DoStop;
  FForm.OnKick := DoKick;
  FForm.Caption := FNNG.ClassName;
end;

destructor TTest.Destroy;
begin
  FLog.Free;
  FForm.Free;
  inherited;
end;

procedure TTest.Start;
begin
  FState := tsReady;
  FForm.Show;
  FNNG.Start;
end;

procedure TTest.Kick;
begin
  FNNG.Kick;
end;

procedure TTest.Stop;
begin
  FForm.Hide;
  FForm.Free;
  FForm := Nil;
  FNNG.Stop;
  FState := tsClose;
  if assigned(FOnStop) then
    FOnStop(Self);
end;

function TTest.State : Integer;
begin
  result := FState;
end;

end.
