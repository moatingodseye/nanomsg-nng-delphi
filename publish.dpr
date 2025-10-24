program publish;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nng in 'nng.pas',
  publisher in 'publisher.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    publisher.Publish;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
