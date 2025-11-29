unit InPackageForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmInPackage = class(TForm)
    lblPut: TLabel;
    edtGet: TEdit;
    btnEvent: TButton;
    procedure btnEventClick(Sender: TObject);
  private
    { Private declarations }
    FOnEvent : TNotifyEvent;
  public
    { Public declarations }
    procedure Put(AValue : String);
    function Get : String;

    property OnEvent : TNotifyEvent read FOnEvent write FOnEvent;
  end;

var
  frmInPackage: TfrmInPackage;

implementation

{$R *.dfm}

procedure TfrmInPackage.Put(AValue : String);
begin
  lblPut.Caption := AValue;
end;

procedure TfrmInPackage.btnEventClick(Sender: TObject);
begin
  FOnEvent(Self);
end;

function TfrmInPackage.Get : String;
begin
  result := edtGet.Text;
end;

end.
