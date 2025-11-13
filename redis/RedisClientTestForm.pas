unit RedisClientTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, RedisClient, baLogger;

type
  TfrmRedisClientTest = class(TForm)
    Panel1: TPanel;
    btnStart: TButton;
    btnStop: TButton;
    Host: TLabel;
    edtHost: TEdit;
    mmoLog: TMemo;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    rdoInteger: TRadioButton;
    edtKey: TEdit;
    btnAdd: TButton;
    rdoFloat: TRadioButton;
    rdoString: TRadioButton;
    rdoDate: TRadioButton;
    rdoObject: TRadioButton;
    edtValue: TEdit;
    btnExist: TButton;
    btnRemove: TButton;
    Label4: TLabel;
    edtPort: TEdit;
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
    { Private declarations }
    FLog : TbaLogger;
    FClient : TRedisClient;
    procedure DoLog(AMessage : String); //threaded!
    procedure DoOnLog(AMessage : String);
    procedure Log(AMessage : String);
  public                   
    { Public declarations }
  end;

var
  frmRedisClientTest: TfrmRedisClientTest;

implementation

{$R *.dfm}

uses
  Redis;

procedure TfrmRedisClientTest.DoLog(AMessage : String);
begin
  FLog.Log(AMessage); // logger caches and does a synchronised DoOnLog later.
end;

procedure TfrmRedisClientTest.DoOnLog(AMessage : String);
begin
  Log(AMessage);
end;

procedure TfrmRedisClientTest.Log(AMessage : String);
begin
  mmoLog.Lines.Add(AMessage);
end;

procedure TfrmRedisClientTest.btnStartClick(Sender: TObject);
begin
  FLog := TbaLogger.Create;
  FLog.OnLog := DoOnLog;
  
  FClient := TRedisClient.Create;
  FClient.Host := edtHost.Text;
  FClient.Port := StrToInt(edtPort.Text);
  FClient.OnLog := DoLog;
  FClient.Start;
end;

procedure TfrmRedisClientTest.btnStopClick(Sender: TObject);
begin
  FClient.Stop;
  FClient.Free;
  FClient := Nil;

  FLog.Free;
  FLog := Nil;
end;

procedure TfrmRedisClientTest.btnAddClick(Sender: TObject);
var
  lValue : TValue;
  lS : TStringList;
begin
  lValue := TValue.Create(Nil,edtKey.Text);
  if rdoInteger.Checked then
    lValue.AsInteger := StrToInt(edtValue.Text);
  if rdoFloat.Checked then
    lValue.AsFloat := StrToFloat(edtValue.Text);
  if rdoString.Checked then
    lValue.AsString := edtValue.Text;
  if rdoDate.Checked then
    lValue.AsDate := StrToDateTime(edtValue.Text);

  try
    lS := TStringList.Create;
    lValue.Dump(lS);
    Log('Add:'+lS.Text);
    lS.Free;
    FClient.Add(lValue);
  except
    on E : EListError do
      Log('OK:'+E.Message);
    on E : Exception do
      Log('Bad:'+E.Message);
  end;                
end;

end.
