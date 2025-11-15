program debugServerTest;

uses
  Vcl.Forms,
  debugServerTestForm in 'debugServerTestForm.pas' {frmDebugServerTest},
  debugServer in 'debugServer.pas',
  Pull in '..\nng\Pull.pas',
  Push in '..\nng\Push.pas',
  nng in '..\nng\nng.pas',
  nngConstant in '..\nng\nngConstant.pas',
  nngType in '..\nng\nngType.pas',
  nngdll in '..\nnglib\nngdll.pas',
  Packet in '..\nng\Packet.pas',
  Dial in '..\nng\Dial.pas',
  Listen in '..\nng\Listen.pas',
  Protocol in '..\nng\Protocol.pas',
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
