{$M+}
unit BaExtended;

interface

type
  TbaExtended = class(TObject)
  private
    FNeed,
    FNull : Boolean;
    FValue : Extended;
    FText : String; { Calculation text if sum is called builds up list of values }
  protected
    procedure SetNull(AValue : Boolean);
    procedure SetValue(AValue : Extended);
    function GetText0 : String;
  public
    constructor Create; virtual;
    destructor  Destroy; override;
    
    procedure Reset; virtual;

    property Need : Boolean read FNeed write FNeed;
    property Null : Boolean read FNull write SetNull;
    property Value : Extended read FValue write SetValue; 
    property Text : String read FText write FText;
    property Text0 : String read GetText0;
  published
  end;
  
implementation

uses
  System.SysUtils, System.Math;
  
function Line0(AText : String) : String;
var 
  P : Integer;
begin
  P := Min(Length(AText),Pos(#13#10,AText+#13#10));
  result := Copy(AText,1,P-1);
end;

procedure TbaExtended.SetNull(AValue : Boolean);
begin
  FNull := AValue;
  if FNull then begin
    FValue := 0.0;
    FText := '';
  end;
end;

procedure TbaExtended.SetValue(AValue : Extended);
begin
  FNeed := False;
  FNull := False;
  FValue := AValue;
end;

function TbaExtended.GetText0 : String;
begin
  result := Line0(FText);
end;

constructor TbaExtended.Create;
begin
  inherited;
  FNeed := False;
  FNull := True;
  FValue := 0.0;
  FText := '';
end;

destructor TbaExtended.Destroy;
begin
  inherited;
end;

procedure TbaExtended.Reset;
begin
  FNull := True;
  FValue := 0.0;
  FText := '';
end;

end.
