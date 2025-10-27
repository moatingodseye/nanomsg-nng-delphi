program survey;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nngdll in 'nnglib\nngdll.pas',
  surveyor in 'surveyor.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Test;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
