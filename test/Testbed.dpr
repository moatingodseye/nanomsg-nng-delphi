program Testbed;

uses
  Vcl.Forms,
  TestbedForm in 'TestbedForm.pas' {frmTestBed},
  nngdll in '..\nnglib\nngdll.pas',
  Test in 'Test.pas',
  BaThread in '..\basic\BaThread.pas',
  BaLogger in '..\basic\BaLogger.pas',
  LogForm in 'LogForm.pas' {frmLog},
  nngResponse in '..\nng\nngResponse.pas',
  Dummy in 'Dummy.pas',
  nngRequest in '..\nng\nngRequest.pas',
  nngProtocol in '..\nng\nngProtocol.pas',
  nng in '..\nng\nng.pas',
  nngListen in '..\nng\nngListen.pas',
  nngDial in '..\nng\nngDial.pas',
  nngPull in '..\nng\nngPull.pas',
  nngPush in '..\nng\nngPush.pas',
  nngSubscribe in '..\nng\nngSubscribe.pas',
  nngPublish in '..\nng\nngPublish.pas',
  nngBus in '..\nng\nngBus.pas',
  nngPair in '..\nng\nngPair.pas',
  nngBoth in '..\nng\nngBoth.pas',
  nngPacket in '..\nng\nngPacket.pas',
  nngConstant in '..\nng\nngConstant.pas',
  nngType in '..\nng\nngType.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTestBed, frmTestBed);
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
