program redisservertest;

uses
  Vcl.Forms,
  RedisServerTestForm in 'RedisServerTestForm.pas' {frmRedisTestServer},
  RedisServer in 'RedisServer.pas',
  redis in 'redis.pas',
  nngPublish in '..\nng\nngPublish.pas',
  nng in '..\nng\nng.pas',
  nngResponse in '..\nng\nngResponse.pas',
  nngdll in '..\nnglib\nngdll.pas',
  nngListen in '..\nng\nngListen.pas',
  nngProtocol in '..\nng\nngProtocol.pas',
  BaThread in '..\basic\BaThread.pas',
  RedisProtocol in 'RedisProtocol.pas',
  RedisClient in 'RedisClient.pas',
  nngRequest in '..\nng\nngRequest.pas',
  nngDial in '..\nng\nngDial.pas',
  nngPacket in '..\nng\nngPacket.pas',
  BaLogger in '..\basic\BaLogger.pas',
  nngConstant in '..\nng\nngConstant.pas',
  nngType in '..\nng\nngType.pas',
  redisConstant in 'redisConstant.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRedisTestServer, frmRedisTestServer);
  Application.Run;
end.
