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
    procedure btnKickClick(Sender: TObject);
  private
    { Private declarations }
    FOnKick : TNotifyEvent;
  public
    { Public declarations }
    procedure Log(AMessage : String);

    property OnKick : TNotifyEvent read FOnKick write FOnKick;
  end;

var
  frmLog: TfrmLog;

implementation

{$R *.dfm}

procedure TfrmLog.btnKickClick(Sender: TObject);
begin
  if assigned(FOnKick) then
    FOnKick(Self);
end;

procedure TfrmLog.Log(AMessage : String);
begin
  mmoLog.Lines.add(AMessage);
end;

end.
