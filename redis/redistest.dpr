program redistest;

uses
  Vcl.Forms,
  RedisTestForm in 'RedisTestForm.pas' {frmRedisTest},
  redis in 'redis.pas',
  nngPacket in '..\nng\nngPacket.pas',
  nngConstant in '..\nng\nngConstant.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRedisTest, frmRedisTest);
  Application.Run;
end.
