program debugClientTest;

uses
  Vcl.Forms,
  debugClientTestForm in 'debugClientTestForm.pas' {frmDebugClientTest},
  debugClient in 'debugClient.pas',
  debugProtocol in 'debugProtocol.pas',
  nngPull in '..\nng\nngPull.pas',
  nngPush in '..\nng\nngPush.pas',
  nngDial in '..\nng\nngDial.pas',
  nngListen in '..\nng\nngListen.pas',
  nng in '..\nng\nng.pas',
  nngConstant in '..\nng\nngConstant.pas',
  nngType in '..\nng\nngType.pas',
  nngdll in '..\nnglib\nngdll.pas',
  BaThread in '..\basic\BaThread.pas',
  nngPacket in '..\nng\nngPacket.pas',
  nngProtocol in '..\nng\nngProtocol.pas',
  BaLogger in '..\basic\BaLogger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDebugClientTest, frmDebugClientTest);
  Application.Run;
end.
