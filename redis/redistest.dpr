program redistest;

uses
  Vcl.Forms,
  RedisTestForm in 'RedisTestForm.pas' {frmRedisTest},
  redis in 'redis.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmRedisTest, frmRedisTest);
  Application.Run;
end.
