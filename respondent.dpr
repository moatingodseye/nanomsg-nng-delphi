program respondent;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nngdll in 'nnglib\nngdll.pas',
  respondenter in 'respondenter.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Test;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
