unit TestbedForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Contnrs, Test, baThread;

type
  TfrmTestBed = class(TForm)
    btnVersion: TButton;
    btnTest: TButton;
    lblVersion: TLabel;
    btnResponse: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnRequest: TButton;
    lblActive: TLabel;
    btnStopResponse: TButton;
    btnKick: TButton;
    btnStopRequest: TButton;
    procedure btnVersionClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnResponseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStopResponseClick(Sender: TObject);
    procedure btnRequestClick(Sender: TObject);
    procedure btnStopRequestClick(Sender: TObject);
  private
    { Private declarations }
    FTidy : TObjectList;
    FThread : TbaThread;
    procedure Monitor(ATest : TTest);
    procedure DoOnSyIdle(ASender,AData : TObject);
    procedure DoOnAsIdle(ASender,AData : TObject);
  public
    { Public declarations }
  end;

var
  frmTestBed: TfrmTestBed;

implementation

{$R *.dfm}

uses
  nngdll, Dummy, Response, Request;

procedure TfrmTestBed.Monitor(ATest : TTest);
begin
  FThread.Lock;
  try
    FTidy.Add(ATest);
  finally
    FThread.UnLock;
  end;
  FThread.Kick;
end;
  
procedure TfrmTestBed.DoOnSyIdle(ASender,AData : TObject);
var
  C : Integer;
  lTest : TTest;
begin
  lblActive.Caption := IntToStr(FTidy.Count);
  FThread.Lock;
  try
    for C := FTidy.Count-1 downto 0 do begin
      lTest := FTidy[C] as TTest;
      if lTest.State=tsDone then
        lTest.Stop; // close any forms, can't do that in asynch
    end;
  finally
    FThread.UnLock;
  end;
end;

procedure TfrmTestBed.DoOnAsIdle(ASender,AData : TObject);
var
  C : Integer;
  lTest : TTest;
begin
  FThread.Lock;
  try
    for C := FTidy.Count-1 downto 0 do begin
      lTest := FTidy[C] as TTest;
      if lTest.State=tsClose then
        FTidy.Delete(C); // frees
    end;
  finally
    FThread.UnLock;
  end;
end;

procedure TfrmTestBed.btnVersionClick(Sender: TObject);
begin
  lblVersion.Caption :=  nng_version();
end;

procedure TfrmTestBed.FormCreate(Sender: TObject);
begin
  FTidy := TObjectList.Create;
  FThread := TbaThread.Create(100);
//  FThread.OnSynchronise := DoOnSynchronise;
  FThread.OnSyIdle := DoOnSyIdle;
  FThread.OnAsIdle := DoOnAsIdle;  
end;

procedure TfrmTestBed.FormDestroy(Sender: TObject);
begin
  FThread.Free;
  FTidy.Free;
end;

procedure TfrmTestBed.btnRequestClick(Sender: TObject);
var
  lTest : TTest;
  lRequest : TRequest;
begin
  lRequest := TRequest.Create;
  lTest := TTest.Create(lRequest);
  btnStopRequest.Tag := Integer(lTest);
  Monitor(lTest);
  lTest.Start;
end;

procedure TfrmTestBed.btnResponseClick(Sender: TObject);
var
  lTest : TTest;
  lResponse : TResponse;
begin
  lResponse := TResponse.Create;
  lTest := TTest.Create(lResponse);
  btnStopResponse.Tag := Integer(lTest);
  Monitor(lTest);
  lTest.Start;
end;

procedure TfrmTestBed.btnStopRequestClick(Sender: TObject);
var
  lTest : TTest;
begin
  lTest := TTest(btnStopRequest.Tag);
  lTest.Stop;
end;

procedure TfrmTestBed.btnStopResponseClick(Sender: TObject);
var
  lTest : TTest;
begin
  lTest := TTest(btnStopResponse.Tag);
  lTest.Stop;
end;

procedure TfrmTestBed.btnTestClick(Sender: TObject);
var
  lTest : TTest;
  lDummy : TDummy;
begin
  lDummy := TDummy.Create;
  lTest := TTest.Create(lDummy);
  Monitor(lTest);
  lTest.Start;
end;

end.
