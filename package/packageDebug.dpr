program packageDebug;

uses
  Vcl.Forms,
  PackageDebugForm in 'PackageDebugForm.pas' {frmPackageDebug},
  packageInterface in 'packageInterface.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPackageDebug, frmPackageDebug);
  Application.Run;
end.
