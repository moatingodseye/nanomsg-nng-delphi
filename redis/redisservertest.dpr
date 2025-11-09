program redisservertest;

uses
  Vcl.Forms,
  RedisServerTestForm in 'RedisServerTestForm.pas' {frmRedisTestServer},
  RedisServer in 'RedisServer.pas',
  redis in 'redis.pas',
  Publish in '..\nng\Publish.pas',
  nng in '..\nnglib\nng.pas',
  Response in '..\nng\Response.pas',
  nngdll in '..\nnglib\nngdll.pas',
  Listen in '..\nng\Listen.pas',
  Protocol in '..\nng\Protocol.pas',
  BaThread in '..\basic\BaThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRedisTestServer, frmRedisTestServer);
  Application.Run;
end.
