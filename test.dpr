program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  testlibnng in 'testlibnng.pas',
  nngdll in 'nnglib\nngdll.pas';

var
  Version : PAnsiChar;
begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    if LoadNNGLibrary then begin
      Version := nng_version();
      Writeln(Version);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
