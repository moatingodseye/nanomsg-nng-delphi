program publish;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nngdll in 'nnglib\nngdll.pas',
  publisher in 'publisher.pas';

begin
  try
    Writeln('Testing...');
    Test;
    Writeln('Finished.');
  except
    on E: Exception do
      Writeln('Exception:'+E.ClassName, ': ', E.Message);
  end;
end.
