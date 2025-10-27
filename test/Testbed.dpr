program Testbed;

uses
  Vcl.Forms,
  TestbedForm in 'TestbedForm.pas' {frmTestBed},
  nngdll in '..\nnglib\nngdll.pas',
  Test in 'Test.pas',
  BaThread in '..\basic\BaThread.pas',
  BaLogger in '..\basic\BaLogger.pas',
  LogForm in 'LogForm.pas' {frmLog},
  Response in 'Response.pas',
  Dummy in 'Dummy.pas',
  Request in 'Request.pas',
  Protocol in 'Protocol.pas',
  nng in '..\nnglib\nng.pas',
  Listen in 'Listen.pas',
  Dial in 'Dial.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTestBed, frmTestBed);
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
