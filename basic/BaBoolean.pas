{$M+}
unit BaBoolean;

interface

type
  EbaBit = (ba00, ba01, ba02, ba03, ba04, ba05, ba06, ba07,
            ba08, ba09, ba10, ba11, ba12, ba13, ba14, ba15,  
            ba16, ba17, ba18, ba19, ba20, ba21, ba22, ba23,  
            ba24, ba25, ba26, ba27, ba28, ba29, ba30, ba31);

  TbaBit = class(TObject)
  private
    FValue : Cardinal;
    FMask : Cardinal;
  protected
    function GetMask(ABit : EbaBit) : Cardinal;
    function GetBit(ABit : EbaBit) : Boolean;
    procedure SetBit(ABit : EbaBit; AValue : Boolean);
  public
    constructor Create;
    destructor  Destroy; override;

    procedure &Set(ABit : EbaBit);
    procedure UnSet(ABit : EbaBit);
    function  IsSet(ABit : EbaBit) : Boolean;
    function  IsUnSet(ABit : EbaBit) : Boolean;
    procedure Clear; 
    
    property Value : Cardinal read FValue;
    property Mask : Cardinal read FMask;
    property _[ABit : EbaBit] : Boolean read GetBit write SetBit; default;
  published
  end;

type
  TbaBoolean = class(TbaBit)
  private
  protected
  public
    constructor Create;
    destructor  Destroy; override;

    function _OR : Boolean;
    function _AND : Boolean;
  published
  end;

implementation

function TbaBit.GetMask(ABit : EbaBit) : Cardinal;
var
  lBit : Cardinal;
begin
  lBit := 1 SHL Ord(ABit);
  result := lBit;
end;

function TbaBit.GetBit(ABit : EbaBit) : Boolean;
begin
  { Mask indicates if ever has been set! }
  result := IsSet(ABit); 
end;

procedure TbaBit.SetBit(ABit : EbaBit; AValue : Boolean);
begin
  if AValue then
    &Set(ABit)
  else
    &Unset(ABit);
end;

constructor TbaBit.Create;
//var
//  B : EbaBit;
//  V : Integer;
begin
  inherited;
  FValue := 0;
  FMask := 0;
//  V := 1;
//  for B := b00 to b31 do
//  begin
//    FMask[B] := V;
//    V := V SHL 1;
//  end;
end;

destructor  TbaBit.Destroy; 
begin
  inherited;
end;

procedure TbaBit.&Set(ABit : EbaBit);
var
  lBit : Cardinal;
begin
  lBit := GetMask(ABit);
  FValue := FValue OR lBit;
  FMask := FMask OR lBit;
end;

procedure TbaBit.UnSet(ABit : EbaBit);
var
  lBit : Cardinal;
begin
  lBit := GetMask(ABit);
  FValue := FValue AND NOT lBit;
  FMask := FMask OR lBit; { We have used this bit so we need to take not of its setting when doing boolean logic }
end;

function  TbaBit.IsSet(ABit : EbaBit) : Boolean;
begin
  result := (FValue AND FMask AND GetMask(ABit))<>0;
end;

function TbaBit.IsUnSet(ABit : EbaBit) : Boolean;
begin
  result := (FValue AND FMask OR GetMask(ABit))=0;
end;

procedure TbaBit.Clear;
begin
  FValue := 0;
  FMask := 0;
end;
  
constructor TbaBoolean.Create;
begin
  inherited;
end;

destructor TbaBoolean.Destroy;
begin
  inherited;
end;

function TbaBoolean._OR : Boolean;
begin
  result := (FValue OR FMask)<>0;
end;

function TbaBoolean._AND : Boolean;
begin
  result := (FValue AND FMask)=FMask;
end;

end.
