program redisclienttest;

uses
  Vcl.Forms,
  RedisClientTestForm in 'RedisClientTestForm.pas' {frmRedisClientTest},
  RedisClient in 'RedisClient.pas',
  redis in 'redis.pas',
  nng in '..\nng\nng.pas',
  nngdll in '..\nnglib\nngdll.pas',
  BaThread in '..\basic\BaThread.pas',
  Request in '..\nng\Request.pas',
  Dial in '..\nng\Dial.pas',
  Protocol in '..\nng\Protocol.pas',
  Response in '..\nng\Response.pas',
  Listen in '..\nng\Listen.pas',
  Publish in '..\nng\Publish.pas',
  RedisProtocol in 'RedisProtocol.pas',
  Packet in '..\nng\Packet.pas',
  BaLogger in '..\basic\BaLogger.pas',
  nngConstant in '..\nng\nngConstant.pas',
  nngType in '..\nng\nngType.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRedisClientTest, frmRedisClientTest);
  Application.Run;
end.
