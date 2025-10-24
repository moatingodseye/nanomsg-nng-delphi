program server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nng in 'nng.pas',
  nngtestpub in 'nngtestpub.pas';

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
