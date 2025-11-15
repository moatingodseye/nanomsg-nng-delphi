program debugClientTest;

uses
  Vcl.Forms,
  debugClientTestForm in 'debugClientTestForm.pas' {frmDebugClientTest},
  debugClient in 'debugClient.pas',
  debugProtocol in 'debugProtocol.pas',
  Pull in '..\nng\Pull.pas',
  Push in '..\nng\Push.pas',
  Dial in '..\nng\Dial.pas',
  Listen in '..\nng\Listen.pas',
  nng in '..\nng\nng.pas',
  nngConstant in '..\nng\nngConstant.pas',
  nngType in '..\nng\nngType.pas',
  nngdll in '..\nnglib\nngdll.pas',
  BaThread in '..\basic\BaThread.pas',
  Packet in '..\nng\Packet.pas',
  Protocol in '..\nng\Protocol.pas',
  BaLogger in '..\basic\BaLogger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmDebugClientTest, frmDebugClientTest);
  Application.Run;
end.
