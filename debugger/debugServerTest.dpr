program debugServerTest;

uses
  Vcl.Forms,
  debugServerTestForm in 'debugServerTestForm.pas' {frmDebugServerTest},
  debugServer in 'debugServer.pas',
  nngPull in '..\nng\nngPull.pas',
  nngPush in '..\nng\nngPush.pas',
  nng in '..\nng\nng.pas',
  nngConstant in '..\nng\nngConstant.pas',
  nngType in '..\nng\nngType.pas',
  nngdll in '..\nnglib\nngdll.pas',
  nngPacket in '..\nng\nngPacket.pas',
  nngDial in '..\nng\nngDial.pas',
  nngListen in '..\nng\nngListen.pas',
  nngProtocol in '..\nng\nngProtocol.pas',
  BaThread in '..\basic\BaThread.pas',
  debugProtocol in 'debugProtocol.pas',
  BaLogger in '..\basic\BaLogger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDebugServerTest, frmDebugServerTest);
  Application.Run;
end.
