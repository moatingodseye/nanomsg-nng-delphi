unit redis;

interface

uses
  System.Generics.Defaults, System.Generics.Collections;
  
type
  TValue = class;
  TOwner = class(TObject)
  private
  protected
    procedure DoOnChange(AValue : TValue); virtual; abstract;
  public
  published
  end;
  
  EValue = (valNull, valInteger, valFloat, valString, valDate, valObject);
  TValue = class(TObject)
  private
    FOwner : TOwner;
    FType : EValue;
    FKey : String;
  protected
    procedure Change;
  public
    constructor Create(AOwner : TOwner; AType : EValue; AKey : String);
    destructor Destroy; override;

    function Caption : String;  virtual; abstract;
    
    property Key : String read FKey;
    property &Type : EValue read FType;
  published
  end;
  
  TIntegerValue = class(TValue)
  private
    FValue : Integer;
  protected
    procedure SetValue(AValue : Integer);
  public
    function Caption : String; override;
  
    property Value : Integer read FValue write SetValue;
  published
  end;

  TOnChangeEvent = procedure(AValue : TValue) of object;
  TRedis = class(TOwner)
  private
    FList : TObjectDictionary<String,TValue>;
    FOnChange : TOnChangeEvent;
  protected
    procedure DoOnChange(AValue : TValue); override;
  public
    constructor Create;
    destructor  Destroy; override;

//    function Make(AKey : String; AType : EValue) : TValue;
    
    procedure Add(AValue : TValue); 
    function  Exist(AKey : String) : TValue;
    procedure Remove(AKey : String);

    property OnChange : TOnChangeEvent read FOnChange write FOnChange;
  published
  end;
  
implementation

uses
  SysUtils;

procedure TValue.Change;
begin
  if assigned(FOWner) then
    FOwner.DoOnChange(Self);
end;

constructor TValue.Create(AOwner : TOwner; AType : EValue; AKey : String);
begin
  inherited Create;
  FOwner := AOwner;
  FType := AType;
  FKey := AKey;
end;

destructor TValue.Destroy;
begin
  inherited;
end;

procedure TIntegerValue.SetValue(AValue : Integer);
begin
  if FValue=AValue then
    exit;
  FValue := AValue;
  Change;
end;

function TIntegerValue.Caption : String;
begin
  result := 'Key:'+FKey+' Int:'+IntToStr(FValue);
end;

procedure TRedis.DoOnChange(AValue : TValue); 
begin
  if assigned(FOnChange) then
    FOnChange(AValue);
end;

constructor TRedis.Create;
begin
  inherited;
  FList := TObjectDictionary<String,TValue>.Create([doOwnsValues]);
end;

destructor  TRedis.Destroy; 
begin
  FList.Free;
  inherited;
end;

procedure TRedis.Add(AValue : TValue); 
begin
  FList.Add(AValue.Key,AValue);
end;

function  TRedis.Exist(AKey : String) : TValue;
var
  lValue : TValue;
begin
  result := Nil;
  if FList.TryGetValue(AKey,lValue) then
    result := lValue;
end;

procedure TRedis.Remove(AKey : String);
begin
  FList.Remove(AKey);
end;

end.
