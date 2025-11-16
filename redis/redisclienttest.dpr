program redisclienttest;

uses
  Vcl.Forms,
  RedisClientTestForm in 'RedisClientTestForm.pas' {frmRedisClientTest},
  RedisClient in 'RedisClient.pas',
  redis in 'redis.pas',
  nng in '..\nng\nng.pas',
  nngdll in '..\nnglib\nngdll.pas',
  BaThread in '..\basic\BaThread.pas',
  nngRequest in '..\nng\nngRequest.pas',
  nngDial in '..\nng\nngDial.pas',
  nngProtocol in '..\nng\nngProtocol.pas',
  nngResponse in '..\nng\nngResponse.pas',
  nngListen in '..\nng\nngListen.pas',
  nngPublish in '..\nng\nngPublish.pas',
  RedisProtocol in 'RedisProtocol.pas',
  nngPacket in '..\nng\nngPacket.pas',
  BaLogger in '..\basic\BaLogger.pas',
  nngConstant in '..\nng\nngConstant.pas',
  nngType in '..\nng\nngType.pas',
  redisConstant in 'redisConstant.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRedisClientTest, frmRedisClientTest);
  Application.Run;
end.
