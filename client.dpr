program Client;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  nngtestsub in 'nngtestsub.pas',
  nng in 'nng.pas';

begin
  try
    Test;
  except
    on E: Exception do
    begin
      Writeln('Error: ' + E.Message);
    end;
  end;
end.

