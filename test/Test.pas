unit Test;

interface

uses
  baThread, baLogger, LogForm, NNG;
  
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
  private
  strict protected
    FState : Integer;
    procedure DoLog(AMessage : String); // synchronised
  protected
    procedure Log(AMessage : String);
    procedure Error(AMessage : String);
    procedure OnKick(Sender : TObject);
  public
    constructor Create(ANNG : TNNG); virtual;
    destructor Destroy; override;

    procedure Start;
    procedure Kick;
    procedure Stop;
    
    function State : Integer;
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

procedure TTest.Log(AMessage : String);
begin
  FLog.Log(AMessage);
end;

procedure TTest.Error(AMessage : String);
begin
  FLog.Log(AMessage);
  FState := tsError;
end;

procedure TTest.OnKick(Sender : TObject);
begin
  FNNG.Kick;
end;

constructor TTest.Create(ANNG : TNNG);
begin
  inherited Create;
  FNNG := ANNG;
  FNNG.OnLog := Log;
  FNNG.OnError := Error;
  FState := tsNever;
  FLog := TbaLogger.Create(DoLog);
  FForm := TfrmLog.Create(Nil);
  FForm.OnKick := OnKick;
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
end;

function TTest.State : Integer;
begin
  result := FState;
end;

end.
