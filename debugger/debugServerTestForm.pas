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
    procedure btnStartupClick(Sender: TObject);
    procedure btnShutdownClick(Sender: TObject);
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

procedure TfrmDebugServerTest.DoOnPull(ACommand : TCommand);
begin
  Log('Pull:'+ACommand.ClassName);
end;

procedure TfrmDebugServerTest.btnShutdownClick(Sender: TObject);
var
  lServer : TdebugServer;
begin
  lServer := FServer as TdebugServer;
  lServer.Disconnect;
  while lServer.State<>statNull do begin
    Sleep(100);
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
