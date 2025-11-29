unit PackageDebugForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, packageInterface;

type
  TfrmPackageDebug = class(TForm)
    Panel1: TPanel;
    btnStartup: TButton;
    btnShutdown: TButton;
    Panel2: TPanel;
    btnPut: TButton;
    edtPut: TEdit;
    Panel3: TPanel;
    btnGet: TButton;
    edtGet: TEdit;
    Panel4: TPanel;
    mmoLog: TMemo;
    procedure btnStartupClick(Sender: TObject);
    procedure btnShutdownClick(Sender: TObject);
    procedure btnPutClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
  private
    { Private declarations }
    FPackage : HMODULE;
    FSetup : procedure;
    FMake : function : TInterfacedObject;
    FClass : TPersistent;
    FObj : TInterfacedObject;
    FForm : IInPackage;
    procedure DoOnEvent(ASender : TObject);
  public
    { Public declarations }
  end;

var
  frmPackageDebug: TfrmPackageDebug;

implementation

{$R *.dfm}

procedure TfrmPackageDebug.btnGetClick(Sender: TObject);
begin
  edtGet.Text := FForm.Get;
end;

procedure TfrmPackageDebug.btnShutdownClick(Sender: TObject);
begin
  FForm.Hide;
//  FForm.Free;
  FForm := Nil;

//  FObj.Free;  not needed as reference counting on the FForm := Nil has or will soon do a Destroy!
  
  UnLoadPackage(FPackage);
end;

procedure TfrmPackageDebug.btnStartupClick(Sender: TObject);
begin
  FPackage := LoadPackage('package.bpl');
  if FPackage<>0 then begin
    @FSetup := GetProcAddress(FPackage,'Setup');
    FSetup;
    @FMake := GetProcAddress(FPackage,'Make');
    FObj := FMake;
    FForm := FObj as IInPackage;
    FForm.Show;
    FForm.OnEvent := DoOnEvent;
    
//    FClass := TPersistent(FindClass('TInPackage'));
//    FForm := FCLass.Create as TPretendInPackage; this doesn't work, as you'd need to define the same class in here as well so it would be code in here not in the package.
  end else
    raise Exception.Create('Error Message');
end;

procedure TfrmPackageDebug.btnPutClick(Sender: TObject);
begin
  FForm.Put(edtPut.Text);
end;

procedure TfrmPackageDebug.DoOnEvent(ASender : TObject);
begin
  mmoLog.Lines.Add(ASender.ClassName);
end;

end.

