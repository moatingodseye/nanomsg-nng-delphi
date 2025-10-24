program request;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nng in 'nng.pas',
  requester in 'requester.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Writeln('begin');
    Test;
    Writeln('end');
  except             
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
