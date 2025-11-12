unit RedisServerTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, RedisServer, baLogger, nngType;

type
  TfrmRedisTestServer = class(TForm)
    Panel1: TPanel;
    btnStart: TButton;
    btnStop: TButton;
    Host: TLabel;
    edtHost: TEdit;
    mmoLog: TMemo;
    Label4: TLabel;
    edtPort: TEdit;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
    FLog : TbaLogger;
    FServer : TRedisServer;
    procedure DoLog(ALevel : ELog; AMessage : String); // could be threaded!
    procedure DoOnLog(AMessage : String);
    procedure Log(AMessage : String);
  public
    { Public declarations }
  end;

var
  frmRedisTestServer: TfrmRedisTestServer;

implementation

{$R *.dfm}

procedure TfrmRedisTestServer.DoLog(ALevel : ELog; AMessage : String); // could be threaded!
begin
  FLog.Log(cLog[ALevel]+AMessage); // cache for later
end;

procedure TfrmRedisTestServer.DoOnLog(AMessage : String);
begin
  Log(AMessage);
end;

procedure TfrmRedisTestServer.Log(AMessage : String);
begin
  mmoLog.Lines.Add(AMessage);
end;

procedure TfrmRedisTestServer.btnStartClick(Sender: TObject);
begin
  FLog := TbaLogger.Create;
  FLog.OnLog := DoOnLog;
  
  FServer := TRedisServer.Create;
  FServer.Host := edtHost.Text;
  FServer.Port := StrToInt(edtPort.Text);
  FServer.OnLog := DoLog;
  FServer.Start;
end;

procedure TfrmRedisTestServer.btnStopClick(Sender: TObject);
begin
  FServer.Stop;
  FServer.Free;
  FServer := Nil;

  FLog.Free;
  FLog := Nil;
end;

end.
