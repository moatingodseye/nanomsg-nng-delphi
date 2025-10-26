program push;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nng in 'nng.pas',
  pusher in 'pusher.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Test;
  except                                                                   
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
