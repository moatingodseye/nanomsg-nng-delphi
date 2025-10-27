unit BaValue;

interface

uses
  System.Contnrs, System.Classes,
  BaExtended;
  
type
  EbaEquation = (baCount, baSum, baMean, baSD, baSumSq);
  
  TbaValue = class(TObject)
  private
    FList : TObjectList;
  protected
    function GetOutput(AIndex : EbaEquation) : Extended;
    function GetEquation(AIndex : EbaEquation) : TbaExtended;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Setup(AEqn : EbaEquation);
    procedure Add(AValue : Extended);
    procedure Reset;

//    property Output[AIndex : EbaEquation] : TbaExtended read GetOutput; default;
    property Equation[AIndex : EbaEquation] : TbaExtended read GetEquation; default;
  end;

implementation

uses
  System.SysUtils;

type
  TbaEquation = class(TbaExtended)
  private
    FEquation : EbaEquation;
    FList : TObjectList;
  protected
    procedure Calculate; virtual;
  public
    constructor Create; override;
    destructor  Destroy; override;

    procedure Add(AValue : Extended);
    procedure Reset; override;
  end;

  TbaCount = class(TbaEquation)
  private
  protected
    procedure Calculate; override;
  public
    constructor Create; override;
  end;

  TbaSum = class(TbaEquation)
  private
  protected
    procedure Calculate; override;
  public
    constructor Create; override;
  end;

  TbaMean = class(TbaEquation)
  private
  protected
    procedure Calculate; override;
  public
    constructor Create; override;
  end;

  TbaSumSq = class(TbaEquation)
  private
  protected
    procedure Calculate; override;
  public
    constructor Create; override;
  end;

  TbaSD = class(TbaEquation)
  private
  protected
    procedure Calculate; override;
  public
    constructor Create; override;
  end;

  TInternal = class(TObject)
  private
    FValue : Extended;
  protected
  public
    constructor Create(AValue : Extended);

    property Value : Extended read FValue write FValue;
  end;

constructor TInternal.Create(AValue : Extended);
begin
  inherited Create;
  FValue := AValue;
end;

procedure TbaEquation.Calculate;
begin
  Null := True;
end;

constructor TbaEquation.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor  TbaEquation.Destroy; 
begin
  FList.Free;
  inherited;
end;

procedure TbaEquation.Add(AValue : Extended);
begin
  FList.Add(TInternal.Create(AValue));
end;

procedure TbaEquation.Reset;
begin
  inherited;
  FList.Clear;
end;

procedure TbaCount.Calculate;
begin
  inherited;
  Value := FList.Count;
  Text := IntToStr(FList.Count);
end;

constructor TbaCount.Create; 
begin
  inherited;
  FEquation := baCount;
end;

function IIF(ACheck : Boolean; ATrue,AFalse : String) : String;
begin
  result := AFalse;
  if ACheck then
    result := ATrue;
end;

procedure TbaSum.Calculate;
var
  C : Integer;
  lInt : TInternal;
  lVal : Extended;
begin
  inherited;
  if FList.Count>0 then begin
    lVal := 0.0;
    for C := 0 to FList.Count-1 do begin
      lInt := FList[C] as TInternal;
      lVal := lVal + lInt.Value;
      Text := Text + IIF(C=0,'',' + ') + FloatToStr(lInt.Value);
    end;
    Value := lVal;
    Text := Text + #13#10;
    Text := Text + FloatToStr(lVal);
  end;
end;

constructor TbaSum.Create;
begin
  inherited;
  FEquation := baSum;
end;

procedure TbaMean.Calculate;
var
  C : Integer;
  lInt : TInternal;
  lVal : Extended;
begin
  inherited;
  if FList.Count>0 then begin
    lVal := 0.0;
    Text := '(';
    for C := 0 to FList.Count-1 do begin
      lInt := FList[C] as TInternal;
      lVal := lVal + lInt.Value;
      Text := Text + IIF(C=0,'',' + ') + FloatToStr(lInt.Value);
    end;
    Text := Text+') / '+IntToStr(FList.Count);
    Value := lVal / FList.Count;
    Text := Text + #13#10;
    Text := Text + FloatToStr(Value);
  end;
end;

constructor TbaMean.Create;
begin
  inherited;
  FEquation := baMean;
end;

procedure TbaSumSq.Calculate;
var
  C : Integer;
  lInt : TInternal;
  lVal : Extended;
begin
  inherited;
  if FList.Count>0 then begin
    lVal := 0.0;
    Text := '(';
    for C := 0 to FList.Count-1 do begin
      lInt := FList[C] as TInternal;
      lVal := lVal + (lInt.Value * lInt.Value);
      Text := Text + IIF(C=0,'',' + (') + FloatToStr(lInt.Value)+' x ' + FLoatToStr(lInt.Value)+')';
    end;
    Value := lVal;
    Text := Text + #13#10;
    Text := Text + FloatToStr(Value);
  end;
end;

constructor TbaSumSq.Create;
begin
  inherited;
  FEquation := baSumSq;
end;

procedure TbaSD.Calculate;   
var
  C : Integer;
  lInt : TInternal;
  lCount,
  lSum,
  lSumSQ : Extended;
  lA,
  lB,
  lC : String;
begin
  inherited;
  if FList.Count>2 then begin
    lSum := 0.0;
    lSumSq := 0.0;
    lA := 'A = ';
    lB := 'B = ';
    for C := 0 to FList.Count-1 do begin
      lInt := FList[C] as TInternal;
      lSum := lSum + lInt.Value;
      lA := lA + IIF(C=0,'',' + ') + FloatToStr(lInt.Value);
      lSumSq := lSumSq + (lInt.Value * lInt.Value);
      lB := lB + IIF(C=9,'(',' + (') + FloatToStr(lInt.Value) + ' x ' + FloatToStr(lInt.Value)+')';
    end;
    lCount := FList.Count;
    lC := 'C = ' + IntToStr(FList.Count);
    if (lCount*lSumSq)>(lSum*lSum) then
      Value := Sqrt(((lCount * lSumSq) - (lSum * lSum)) / (lCount * (lCount - 1)))
    else
      Value := 0.0; { Sqrt of negative! }
    Text := lA+#13#10 + lB+#13#10 + lC+#13#10;
    Text := 'Sqrt(((C x B) - (A * A)) / (C x (C-1)))';
    Text := Text + #13#10;
    Text := Text + FloatToStr(Value);
  end;
end;

constructor TbaSD.Create;
begin
  inherited;
  FEquation := baSD;
end;

function TbaValue.GetOutput(AIndex : EbaEquation) : Extended;
var
  C : Integer;
  lEqn : TbaEquation;
begin
  result := 0.0;
  for C := 0 to FList.Count-1 do begin
    lEqn := FList[C] as TbaEquation;
    if lEqn.FEquation=AIndex then begin
      result := lEqn.Value;
      break;
    end;
  end;
end;

function TbaValue.GetEquation(AIndex : EbaEquation) : TbaExtended;
var
  C : Integer;
  lEqn : TbaEquation;
begin
  result := Nil;
  for C := 0 to FList.Count-1 do begin
    lEqn := FList[C] as TbaEquation;
    if lEqn.FEquation=AIndex then begin
      result := lEqn;
      break;
    end;
  end;
end;

constructor TbaValue.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor TbaValue.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TbaValue.Setup(AEqn : EbaEquation);
begin
  case AEqn of
    baCount : FList.Add(TbaCount.Create);
    baSum : FList.Add(TbaSum.Create);
    baMean : FList.Add(TbaMean.Create);
    baSD : FList.Add(TbaSD.Create);
    baSumSq : FList.Add(TbaSumSq.Create);
  end;
end;

procedure TbaValue.Add(AValue : Extended);
var
  C : Integer;
  lEqn : TbaEquation;
begin
  for C := 0 to FList.Count-1 do begin
    lEqn := FList[C] as TbaEquation;
    lEqn.Add(AValue);
    lEqn.Calculate;
  end;
end;

procedure TbaValue.Reset;
var
  C : Integer;
  lEqn : TbaEquation;
begin
  inherited;
  for C := 0 to FList.Count-1 do begin
    lEqn := FList[C] as TbaEquation;
    lEqn.Reset;
  end;
end;

end.
