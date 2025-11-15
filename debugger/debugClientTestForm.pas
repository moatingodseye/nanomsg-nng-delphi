unit debugClientTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, baLogger;

type
  TfrmDebugClientTest = class(TForm)
    Panel1: TPanel;
    btnStartup: TButton;
    btnShutdown: TButton;
    Label1: TLabel;
    edtHost: TEdit;
    Label2: TLabel;
    edtPort: TEdit;
    Panel2: TPanel;
    btnPrepare: TButton;
    Label3: TLabel;
    edtPUser: TEdit;
    edtPPass: TEdit;
    edtPHost: TEdit;
    mmoLog: TMemo;
    procedure btnStartupClick(Sender: TObject);
    procedure btnShutdownClick(Sender: TObject);
    procedure btnPrepareClick(Sender: TObject);
  private
    { Private declarations }
    FLog : TbaLogger;
    FClient : TObject;
    procedure DoLog(AMessage : String); //threaded!
    procedure Log(AMessage : String);
  public
    { Public declarations }
  end;

var
  frmDebugClientTest: TfrmDebugClientTest;

implementation

{$R *.dfm}

uses
  debugProtocol,
  debugClient;
  
procedure TfrmDebugClientTest.DoLog(AMessage: string);
begin
  FLog.Log(AMessage);
end;

procedure TfrmDebugClientTest.Log(AMessage : String);
begin
  mmoLog.Lines.Add(AMessage);
end;
  
procedure TfrmDebugClientTest.btnPrepareClick(Sender: TObject);
var
  lClient : TdebugClient;
  lCommand : TCommand;
begin
  lClient := FClient as TdebugClient;
  lCommand := TPrepare.Create(edtPUser.Text,edtPPass.Text,edtPHost.Text);
  lClient.Push(lCommand);
  Log('Push:'+edtPUser.Text+'/'+edtPPass.Text+'@'+edtPHost.Text);
  lCommand.Free;
end;

procedure TfrmDebugClientTest.btnShutdownClick(Sender: TObject);
var
  lClient : TdebugClient;
begin
  lClient := FClient as TdebugClient;
  lClient.Disconnect;
  lClient.Free;

  FClient := Nil;

  FLog.Free;
  FLog := Nil;
end;

procedure TfrmDebugClientTest.btnStartupClick(Sender: TObject);
var
  lClient : TdebugClient;
begin
  FLog := TbaLogger.Create;
  FLog.OnLog := Log;
  
  FClient := TdebugClient.Create(edtHost.Text,StrToInt(edtPort.Text));
  lClient := FClient as TdebugClient;
  lClient.OnLog := FLog.Log;

  lClient.Connect;
end;

end.
