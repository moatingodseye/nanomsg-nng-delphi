unit packageContent;

interface

uses
  System.Classes, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  InPackageForm, packageInterface;
  
type
  TInPackage = class(TInterfacedObject, IInPackage) // for RegisterClass
  private
    FForm : TfrmInPackage;
  protected
    function GetOnEvent : TNotifyEvent;
    procedure SetOnEvent(AEvent : TNotifyEvent);
    
    procedure Show;
    procedure Hide;

    procedure Put(AValue : String);
    function Get : String;
    
//    property OnEvent : TNotifyEvent read GetOnEvent write SetOnEvent;
  public
    constructor Create;
    destructor Destroy; override;
  published
  end;

  procedure Setup; exports Setup;
  function Make : TInterfacedObject; exports Make;
  
implementation

constructor TInPackage.Create;
begin
  inherited;
end;

destructor TInPackage.Destroy;
begin
  inherited;
end;

function TInPackage.GetOnEvent : TNotifyEvent;
begin
  result := FForm.OnEvent;
end;

procedure TInPackage.SetOnEvent(AEvent : TNotifyEvent);
begin
  FForm.OnEvent := AEvent;
end;

procedure TInPackage.Show;
begin
  FForm := TfrmInPackage.Create(Nil);
  FForm.Show;
end;

procedure TInPackage.Hide;
begin
  FForm.Hide;
  FForm.Free;
  FForm := Nil;
end;

procedure TInPackage.Put(AValue : String);
begin
  FForm.Put(AValue);
end;

function TInPackage.Get : String;
begin
  result := FForm.Get;
end;

procedure Setup;
begin
//  RegisterClass(TInPackage);  -- can't use this as can't have anything other than standard classes/forms anything new you'd have to define completely in the exe and hence the code would be compiled into the exe, it wound't really by in the bpl/dll
end;

function Make : TInterfacedObject;
begin
  result := TInPackage.Create;
end;

initialization 
//  RegisterClass(TInPackage);
  
end.
