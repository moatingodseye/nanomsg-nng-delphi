unit LogForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmLog = class(TForm)
    mmoLog: TMemo;
    pnlTop: TPanel;
    btnKick: TButton;
    btnStop: TButton;
    procedure btnKickClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
    FData : TObject;
    FOnStop,
    FOnKick : TNotifyEvent;
  public
    { Public declarations }
    procedure Log(AMessage : String);

    property Data : TObject read FData write FData;
    property OnStop : TNotifyEvent read FOnStop write FOnStop;
    property OnKick : TNotifyEvent read FOnKick write FOnKick;
  end;

var
  frmLog: TfrmLog;

implementation

{$R *.dfm}

procedure TfrmLog.btnKickClick(Sender: TObject);
begin
  if assigned(FOnKick) then
    FOnKick(FData);
end;

procedure TfrmLog.btnStopClick(Sender: TObject);
begin
  if assigned(FOnStop) then
    FOnStop(FData);
end;

procedure TfrmLog.Log(AMessage : String);
begin
  mmoLog.Lines.add(AMessage);
end;

end.
