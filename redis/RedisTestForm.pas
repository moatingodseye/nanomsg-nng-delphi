unit RedisTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Redis, nngPacket;

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
    edtValue: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    btnExist: TButton;
    btnRemove: TButton;
    btnSave: TButton;
    btnLoad: TButton;
    btnDestroy: TButton;
    btnDump: TButton;
    btnClear: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnExistClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDestroyClick(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure btnDumpClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    { Private declarations }
    FBuffer : Pointer;
    FSize : Integer;
    FMemory : TMemoryStream;
    FRedis : TRedis;
    FIn,FOut : TnngPacket;
    procedure Dump(AValue : TValue);
    procedure Log(AMessage : String);
    procedure DoOnChange(AValue : TValue);
  public
    { Public declarations }
  end;

var
  frmRedisTest: TfrmRedisTest;

implementation

{$R *.dfm}

procedure TfrmRedisTest.Dump(AValue : TValue);
begin
  Log(AValue.Dump);
end;

procedure TfrmRedisTest.Log(AMessage : String);
begin
  mmoLog.Lines.Add(AMessage);
end;

procedure TfrmRedisTest.DoOnChange(AValue : TValue);
begin
  Log('Change-'+AValue.Key);
  Dump(AValue);
end;

procedure TfrmRedisTest.btnAddClick(Sender: TObject);
var
  lValue : TValue;
begin
  lValue := TValue.Create(FRedis,edtKey.Text);
  if rdoInteger.Checked then
    lValue.AsInteger := StrToInt(edtValue.Text);
  if rdoFloat.Checked then
    lValue.AsFloat := StrToFloat(edtValue.Text);
  if rdoString.Checked then
    lValue.AsString := edtValue.Text;
  if rdoDate.Checked then
    lValue.AsDate := StrToDateTime(edtValue.Text);

  try
    FRedis.Add(lValue);
    Log('Add-'+lValue.Key);
    Dump(lVAlue);
  except
    on E : EListError do
      Log('OK:'+E.Message);
    on E : Exception do
      Log('Bad:'+E.Message);
  end;                
end;

procedure TfrmRedisTest.btnClearClick(Sender: TObject);
begin
  FRedis.Clear;
  mmoLog.Clear;
end;

procedure TfrmRedisTest.btnCreateClick(Sender: TObject);
begin
  FRedis := TRedis.Create;
  FRedis.OnChange := DoOnChange;
  FMemory := TMemoryStream.Create;
  FIn := TnngPacket.Create(128);
  FOut := TnngPacket.Create(128);
  GetMem(FBuffer,1024);
end;

procedure TfrmRedisTest.btnDestroyClick(Sender: TObject);
begin
  FreeMem(FBuffer,1024);
  FOut.Free;
  FIn.Free;
  FMemory.Free;
  FRedis.Free;
end;

procedure TfrmRedisTest.btnDumpClick(Sender: TObject);
begin
  Log(FRedis.Dump);
end;

procedure TfrmRedisTest.btnExistClick(Sender: TObject);
var
  lValue : TValue;
begin
  lValue := FRedis.Exist(edtKey.Text);
  if assigned(lValue) then begin
    Log('Found-'+lValue.Key);
    Dump(lValue);
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

procedure TfrmRedisTest.btnLoadClick(Sender: TObject);
begin
  FIn.Assign(FOut);
  Move(FIn.Buffer^,FBuffer^,FIn.Used);
  FSize := FIn.Used;
  Log(FIn.Dump);
  
  FMemory.Clear;
  FMemory.Seek(0,soFromBeginning);
  FMemory.Write(FBuffer^,FSize);
  FMemory.Seek(0,soFromBeginning);
  FRedis.Load(FMemory);
  Log(FRedis.Dump);
end;

procedure TfrmRedisTest.btnSaveClick(Sender: TObject);
begin
  FMemory.Clear;
  FRedis.Save(FMemory);

  FMemory.Seek(0,soFromBeginning);
  FSize := FMemory.Size;
  FMemory.Read(FBuffer^,FSize);
  FMemory.Clear;

  FOut.Used := FSize;
  Move(FBuffer^,FOut.Buffer^, FSize);

  FSize := 0;
  Log(FOut.Dump);
end;

end.
