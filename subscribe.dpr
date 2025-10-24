program subscribe;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nng in 'nng.pas',
  subscriber in 'subscriber.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Subscriber.Subscribe;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
