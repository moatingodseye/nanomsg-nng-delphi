unit RedisTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Redis;

type
  TfrmRedisTest = class(TForm)
    Panel1: TPanel;
    btnCreate: TButton;
    Label1: TLabel;
    rdoInteger: TRadioButton;
    edtKey: TEdit;
    btnAdd: TButton;
    mmoLog: TMemo;
    rdoFloat: TRadioButton;
    rdoString: TRadioButton;
    rdoDate: TRadioButton;
    rdoObject: TRadioButton;
    edtValue: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnExist: TButton;
    btnRemove: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnExistClick(Sender: TObject);
  private
    { Private declarations }
    FRedis : TRedis;
    procedure Log(AMessage : String);
    procedure DoOnChange(AValue : TValue);
  public
    { Public declarations }
  end;

var
  frmRedisTest: TfrmRedisTest;

implementation

{$R *.dfm}

procedure TfrmRedisTest.Log(AMessage : String);
begin
  mmoLog.Lines.Add(AMessage);
end;

procedure TfrmRedisTest.DoOnChange(AValue : TValue);
begin
  Log('Change-'+AValue.Caption);
end;

procedure TfrmRedisTest.btnAddClick(Sender: TObject);
var
  lInt : TIntegerValue;
  lValue : TValue;
begin
  if rdoInteger.Checked then begin
    lInt := TIntegerValue.Create(FRedis,valInteger,edtKey.Text);
    lInt.Value := StrToInt(edtValue.Text);
    
    lValue := lInt;
  end;

  try
    FRedis.Add(lValue);
    Log('Add-'+lValue.Caption);
  except
    on E : EListError do
      Log('OK:'+E.Message);
    on E : Exception do
      Log('Bad:'+E.Message);
  end;                
end;

procedure TfrmRedisTest.btnCreateClick(Sender: TObject);
begin
  FRedis := TRedis.Create;
  FRedis.OnChange := DoOnChange;
end;

procedure TfrmRedisTest.btnExistClick(Sender: TObject);
var
  lValue : TValue;
begin
  lValue := FRedis.Exist(edtKey.Text);
  if assigned(lValue) then begin
    Log('Found-'+lValue.Caption);
  end else begin
    Log('Not found:'+edtKey.Text);
  end;
end;

procedure TfrmRedisTest.btnRemoveClick(Sender: TObject);
begin
  try
    FRedis.Remove(edtKey.Text);
    Log('Removed:'+ edtKey.Text);
  except
    Log('Not found:'+ edtKey.Text);
  end;
end;

end.
