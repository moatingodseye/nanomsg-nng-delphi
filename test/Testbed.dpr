program Testbed;

uses
  Vcl.Forms,
  TestbedForm in 'TestbedForm.pas' {frmTestBed},
  nngdll in '..\nnglib\nngdll.pas',
  Test in 'Test.pas',
  BaThread in '..\basic\BaThread.pas',
  BaLogger in '..\basic\BaLogger.pas',
  LogForm in 'LogForm.pas' {frmLog},
  Response in '..\nng\Response.pas',
  Dummy in 'Dummy.pas',
  Request in '..\nng\Request.pas',
  Protocol in '..\nng\Protocol.pas',
  nng in '..\nnglib\nng.pas',
  Listen in '..\nng\Listen.pas',
  Dial in '..\nng\Dial.pas',
  Pull in '..\nng\Pull.pas',
  Push in '..\nng\Push.pas',
  Subscribe in '..\nng\Subscribe.pas',
  Publish in '..\nng\Publish.pas',
  Bus in '..\nng\Bus.pas',
  Pair in '..\nng\Pair.pas',
  Both in '..\nng\Both.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTestBed, frmTestBed);
  Application.CreateForm(TfrmLog, frmLog);
  Application.Run;
end.
