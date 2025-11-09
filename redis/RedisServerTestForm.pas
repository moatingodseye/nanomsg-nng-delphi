unit RedisServerTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, RedisServer;

type
  TfrmRedisTestServer = class(TForm)
    Panel1: TPanel;
    btnStart: TButton;
    btnStop: TButton;
    Host: TLabel;
    edtHost: TEdit;
    mmoLog: TMemo;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
    FServer : TRedisServer;
    procedure DoOnLog(AMessage : String);
  public
    { Public declarations }
  end;

var
  frmRedisTestServer: TfrmRedisTestServer;

implementation

{$R *.dfm}

procedure TfrmRedisTestServer.DoOnLog(AMessage : String);
begin
  mmoLog.Lines.Add(AMessage);
end;

procedure TfrmRedisTestServer.btnStartClick(Sender: TObject);
begin
  FServer := TRedisServer.Create;
  FServer.Host := edtHost.Text;
  FServer.OnLog := DoOnLog;
  FServer.Start;
end;

procedure TfrmRedisTestServer.btnStopClick(Sender: TObject);
begin
  FServer.Stop;
  FServer.Free;
  FServer := Nil;
end;

end.
