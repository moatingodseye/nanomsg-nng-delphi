unit debugServerTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, debugProtocol, baLogger;

type
  TfrmDebugServerTest = class(TForm)
    Panel1: TPanel;
    btnStartup: TButton;
    btnShutdown: TButton;
    Label1: TLabel;
    edtHost: TEdit;
    Label2: TLabel;
    edtPort: TEdit;
    Panel2: TPanel;
    mmoLog: TMemo;
    lblStatus: TLabel;
    tmTimer: TTimer;
    procedure btnStartupClick(Sender: TObject);
    procedure btnShutdownClick(Sender: TObject);
    procedure tmTimerTimer(Sender: TObject);
  private
    { Private declarations }
    FLog : TbaLogger;
    FServer : TObject;
    procedure Log(AMessage : String);
    procedure DoOnPull(ACommand : TCommand);
  public
    { Public declarations }
  end;

var
  frmDebugServerTest: TfrmDebugServerTest;

implementation

{$R *.dfm}

uses
  nngType,
  debugServer;

procedure TfrmDebugServerTest.Log(AMessage : String);
begin
  mmoLog.Lines.Add(AMessage);
end;

procedure TfrmDebugServerTest.tmTimerTimer(Sender: TObject);
var
  lServer : TdebugServer;
begin
  if assigned(FServer) then begin
    lServer := FServer as TdebugServer;
    lblStatus.Caption := lServer.Status;
  end else
    lblStatus.Caption := '';
end;

procedure TfrmDebugServerTest.DoOnPull(ACommand : TCommand);
var
  lPrepare : TPrepare;
begin
  Log('Pull:'+ACommand.ClassName);
  if ACommand is TPrepare then begin
    lPrepare := ACommand as TPrepare;
    Log('Prepare:'+lPrepare.Username+'/'+lPrepare.Password+'@'+lPrepare.Host);
  end;
end;

procedure TfrmDebugServerTest.btnShutdownClick(Sender: TObject);
var
  lServer : TdebugServer;
begin
  lServer := FServer as TdebugServer;
  lServer.Disconnect;
  while lServer.State<>statNull do begin
    Sleep(250);
    Application.ProcessMessages;
  end;
  lServer.Free;

  FServer := Nil;

  FLog.Free;
  FLog := Nil;
end;

procedure TfrmDebugServerTest.btnStartupClick(Sender: TObject);
var
  lServer : TdebugServer;
begin
  FLog := TbaLogger.Create;
  FLog.OnLog := Log;
  
  FServer := TdebugServer.Create(edtHost.Text,StrToInt(edtPort.Text));
  lServer := FServer as TdebugServer;
  lServer.OnLog := FLog.Log;

  lServer.OnPull := DoOnPull;
  lServer.Connect;
end;

end.
