unit TestbedForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Contnrs, Test, nng, baThread;

type
  TfrmTestBed = class(TForm)
    btnVersion: TButton;
    btnTest: TButton;
    lblVersion: TLabel;
    btnResponse: TButton;
    Label1: TLabel;
    Label2: TLabel;
    btnRequest: TButton;
    btnPush: TButton;
    btnPull: TButton;
    btnPublish: TButton;
    Subscribe: TButton;
    btnSPair: TButton;
    Label3: TLabel;
    btnCPair: TButton;
    btnPair: TButton;
    btnSBus: TButton;
    btnCBus: TButton;
    btnBus: TButton;
    procedure btnVersionClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure btnResponseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure btnRequestClick(Sender: TObject);
    procedure btnKickRequestClick(Sender: TObject);
    procedure btnPushClick(Sender: TObject);
    procedure btnPullClick(Sender: TObject);
    procedure btnPublishClick(Sender: TObject);
    procedure SubscribeClick(Sender: TObject);
    procedure btnSPairClick(Sender: TObject);
    procedure btnCPairClick(Sender: TObject);
    procedure btnPairClick(Sender: TObject);
    procedure btnSBusClick(Sender: TObject);
    procedure btnCBusClick(Sender: TObject);
    procedure btnBusClick(Sender: TObject);
  private
    { Private declarations }
    FTidy : TObjectList;
    FThread : TbaThread;
    procedure DoOnStop(ATest : TObject);
    procedure Monitor(ATest : TTest);
    procedure DoOnSyThread(ASender,AData : TObject);
    procedure Test(ANNG : TNNG);
  public
    { Public declarations }
  end;

var
  frmTestBed: TfrmTestBed;

implementation

{$R *.dfm}

uses
  nngdll, Dummy, Response, Request, Push, Pull, Publish, Subscribe, Both, Pair, Bus;

procedure TfrmTestBed.DoOnStop(ATest : TObject);
begin
  FThread.Kick;
end;
  
procedure TfrmTestBed.Monitor(ATest : TTest);
begin
  FThread.Lock;
  try
    FTidy.Add(ATest);
    ATest.OnStop := DoOnStop;
  finally
    FThread.UnLock;
  end;
  FThread.Kick;
end;
  
procedure TfrmTestBed.SubscribeClick(Sender: TObject);
begin
  Test(TSubscribe.Create);
end;

procedure TfrmTestBed.DoOnSyThread(ASender,AData : TObject);
var
  C : Integer;
  lTest : TTest;
begin
  FThread.Lock;
  try
    for C := FTidy.Count-1 downto 0 do begin
      lTest := FTidy[C] as TTest;
      if lTest.State=tsDone then
        FTidy.Delete(C);
    end;
  finally
    FThread.UnLock;
  end;
end;

procedure TfrmTestBed.Test(ANNG : TNNG);
var
  lTest : TTest;
begin
  lTest := TTest.Create(Anng);
  Monitor(lTest);
  lTest.Start;
end;

procedure TfrmTestBed.btnVersionClick(Sender: TObject);
begin
  lblVersion.Caption :=  nng_version();
end;

procedure TfrmTestBed.FormCreate(Sender: TObject);
begin
  FTidy := TObjectList.Create;
  FThread := TbaThread.Create(20,100);
  FThread.OnSyThread := DoOnSyThread;
end;

procedure TfrmTestBed.FormDestroy(Sender: TObject);
begin
  FThread.Free;
  FTidy.Free;
end;

procedure TfrmTestBed.btnBusClick(Sender: TObject);
begin
  Test(TBus.Create(bBoth));
end;

procedure TfrmTestBed.btnCBusClick(Sender: TObject);
begin
  Test(TCBus.Create);
end;

procedure TfrmTestBed.btnCPairClick(Sender: TObject);
begin
  Test(TCPair.Create);
end;

procedure TfrmTestBed.btnKickRequestClick(Sender: TObject);
var
  lControl : TControl;
  lTest : TTest;
begin
  lControl := Sender as TControl;
  lTest := TTest(lControl.Tag);
  lTest.Kick;
end;

procedure TfrmTestBed.btnPairClick(Sender: TObject);
begin
  Test(TPair.Create(bBoth));
end;

procedure TfrmTestBed.btnPublishClick(Sender: TObject);
begin
  Test(TPublish.Create);
end;

procedure TfrmTestBed.btnPullClick(Sender: TObject);
begin
  Test(TPull.Create);
end;

procedure TfrmTestBed.btnPushClick(Sender: TObject);
begin
  Test(TPush.Create);
end;

procedure TfrmTestBed.btnRequestClick(Sender: TObject);
begin
  Test(TRequest.Create);
end;

procedure TfrmTestBed.btnResponseClick(Sender: TObject);
begin
  Test(TResponse.Create);
end;

procedure TfrmTestBed.btnSBusClick(Sender: TObject);
begin
  Test(TSBus.Create);
end;

procedure TfrmTestBed.btnSPairClick(Sender: TObject);
begin
  Test(TSPair.Create);
end;

procedure TfrmTestBed.btnStopClick(Sender: TObject);
var
  lTest : TTest;
  lControl : TControl;
begin
  lControl := Sender as TControl;
  lTest := TTest(lControl.Tag);
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
