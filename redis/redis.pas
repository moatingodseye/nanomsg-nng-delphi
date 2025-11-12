{$M+}
unit redis;

interface

uses
  System.Classes,
  System.Generics.Defaults, System.Generics.Collections;
  
type
  TRedis = class;
  
  EValue = (valNull, valInteger, valFloat, valString, valDate,valRedis);
  TValue = class(TObject)
  private
    FOwner : TRedis;
    FType : EValue;
    FKey : String;
    FNull : Boolean;
    FInteger : Integer;
    FFloat : Double;
    FString : String;
    FDate : TDateTime;
    FRedis : TRedis;
  protected
    procedure Change;
    procedure Load(AFrom : TStream); virtual;
    procedure Save(AInto : TStream); virtual;

    procedure SetInteger(AValue : Integer);
    procedure SetFloat(AValue : Double);
    procedure SetString(AValue : String);
    procedure SetDate(AValue : TDateTime);
    procedure SetRedis(AValue : TRedis);
  public
    constructor Create(AOwner : TRedis; AKey : String);
    destructor Destroy; override;

    function Caption : String;
    procedure Assign(AFrom : TValue);
    procedure Clear;
    
    property Key : String read FKey;
    property &Type : EValue read FType;
    property Null : Boolean read FNull;
    property AsInteger : Integer read FInteger write SetInteger;
    property AsFloat : Double read FFloat write SetFloat;
    property AsString : String read FString write SetString;
    property AsDate : TDateTime read FDate write SetDate;
    property AsRedis : TRedis read FRedis write SetRedis;
  published
  end;
  
  TOnChangeEvent = procedure(AValue : TValue) of object;
  TRedis = class(TObject)
  private
    FList : TObjectDictionary<String,TValue>;
    FOnChange : TOnChangeEvent;
  protected
    procedure DoOnChange(AValue : TValue); 
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Load(AFrom : TStream);
    procedure Save(AInto : TStream);
    procedure Assign(AFrom : TRedis);
    
    procedure Add(AValue : TValue); overload;
    procedure Add(AKey : String; AValue : Integer); overload;
    procedure Add(AKey : String; AValue : Double); overload;
    procedure Add(AKey : String; AValue : String); overload;
    procedure Add(AKey : String; AValue : TDateTime); overload;
    
    function  Exist(AKey : String) : TValue;
    procedure Remove(AKey : String);
    function Count : Integer;
    procedure Clear;

    property OnChange : TOnChangeEvent read FOnChange write FOnChange;
  published
  end;

procedure SetToNil(var AObject);
  
implementation

uses
  System.SysUtils;

procedure SetToNil(var AObject);
begin
  TObject(AObject) := nil;
end;
  
procedure TValue.Change;
begin
  if assigned(FOWner) then
    FOwner.DoOnChange(Self);
end;

procedure TValue.Load(AFrom : TStream);
var
  lSize : Integer;
begin
  AFrom.Read(FType, SizeOf(FType));
  AFrom.Read(FNull, SizeOf(FNull));
  if not FNull then
    case FType of
      valInteger : AFrom.Read(FInteger, SizeOf(FInteger));
      valFloat : AFrom.Read(FFloat, SizeOf(FFloat));
      valString : 
        begin
          AFrom.Read(lSize, SizeOf(lSize));
          SetLength(FString, lSize);
          if lSize>0 then
            AFrom.Read(FString, lSize);
        end;
      valDate : AFrom.Read(FDate, SizeOf(FDate));
      valRedis : 
        begin
          if not assigned(FRedis) then
            FRedis := TRedis.Create;
          FRedis.Load(AFrom);
        end;
    end;
end;

procedure TValue.Save(AInto : TStream);
var
  lSize : Integer;
begin
  AInto.Write(FType, SizeOf(FType));
  AInto.Write(FNull, SizeOf(FNull));
  if not Fnull then
    case FType of
      valInteger : AInto.Write(FInteger, SizeOf(FInteger));
      valFloat : AInto.Write(FFloat, SizeOf(FFloat));
      valString :
        begin
          lSize := Length(FString);
          AInto.Write(lSize, SizeOf(lSize));
          if lSize>0 then
            AInto.Write(FString, lSize);
        end;
      valDate : AInto.Write(FDate, SizeOf(FDate));
      valRedis : 
        begin
          if assigned(FRedis) then
            FRedis.Save(AInto);
        end;
    end;
end;

procedure TValue.SetInteger(AValue : Integer);
begin
  FType := valInteger;
  if FInteger<>AValue then
    Change;
  FInteger := AValue;
  FNull := False;
end;

procedure TValue.SetFloat(AValue : Double);
begin
  FType := valFloat;
  if FFloat<>AValue then
    Change;
  FFloat := AValue;
  FNull := False;
end;

procedure TValue.SetString(AValue : String);
begin
  FType := valString;
  if FString<>AValue then
    Change;
  FString := AValue;
  FNull := False;
end;         

procedure TValue.SetDate(AValue : TDateTime);
begin
  FType := valDate;
  if FDate<>AValue then
    Change;
  FDate := AValue;
  FNull := False;
end;

procedure TValue.SetRedis(AValue : TRedis);
begin
  FType := valRedis;
  if not assigned(FRedis) then
    FRedis := TRedis.Create;
  FRedis.Assign(AValue);
  Change;
  FNull := False;
end;

constructor TValue.Create(AOwner : TRedis;  AKey : String);
begin
  inherited Create;
  FOwner := AOwner;
  FType := valNull;
  FKey := AKey;
  FRedis := Nil;
end;

destructor TValue.Destroy;
begin
  if assigned(FRedis) then
    FRedis.Free;
  FRedis := Nil;
  inherited;
end;

function TValue.Caption : String;
begin
  result := 'Key:'+FKey;//+' Int:'+IntToStr(FValue);
end;

procedure TValue.Assign(AFrom : TValue);
begin
  FType := AFrom.FType;
  FNull := AFrom.FNull;
  FInteger := AFrom.FInteger;
  FFloat := AFrom.FFloat;
  FString := AFrom.FString;
  FDate := AFrom.FDate;
  FRedis := Nil;
end;

procedure TValue.Clear;
begin
  FNull := True;
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

procedure TRedis.Load(AFrom : TStream);
var
  lValue : TValue;
  lCount : Integer;
begin
  FList.Clear;
  Afrom.Read(lCount, SizeOf(lCount));
  while lCount>0 do begin
    lValue := TValue.Create(Self,'');
    lValue.Load(AFrom);
    Add(lValue);
    SetToNil(lValue);

    Dec(lCount);
  end;
end;

procedure TRedis.Save(AInto : TStream);
var
  lValue : TValue;
  lCount : Integer;
begin
  lCount := FList.Count;
  AInto.Write(lCount, SizeOf(lCount));
  for lValue in FList.Values do begin
    lValue.Save(AInto);
  end;
end;

procedure TRedis.Assign(AFrom : TRedis);
var
  lValue : TValue;
  lTemp : TValue;
begin
  FList.Clear;
  for lValue in AFrom.FList.Values do begin
    lTemp := TValue.Create(Self,lValue.Key);
    lTemp.Assign(lValue);
    FList.Add(lTemp.Key,lTemp);
    SetToNil(lTemp);
  end;
end;

procedure TRedis.Add(AValue : TValue); 
begin
  FList.Add(AValue.Key,AValue);
end;

procedure TRedis.Add(AKey : String; AValue : Integer);
var
  lValue : TValue;
begin
  lValue := TValue.Create(Self,AKey);
  lValue.AsInteger := AValue;
  FList.Add(AKey,lValue);
  SetToNil(lValue);
end;

procedure TRedis.Add(AKey : String; AValue : Double);
var
  lValue : TValue;
begin
  lValue := TValue.Create(Self,AKey);
  lValue.AsFloat := AValue;
  FList.Add(AKey,lValue);
  SetToNil(lValue);
end;

procedure TRedis.Add(AKey : String; AValue : String);
var
  lValue : TValue;
begin
  lValue := TValue.Create(Self,AKey);
  lValue.AsString := AValue;
  FList.Add(AKey,lValue);
  SetToNil(lValue);
end;

procedure TRedis.Add(AKey : String; AValue : TDateTime);
var
  lValue : TValue;
begin
  lValue := TValue.Create(Self,AKey);
  lValue.AsDate := AValue;
  FList.Add(AKey,lValue);
  SetToNil(lValue);
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

function TRedis.Count : Integer;
begin
  result := FList.Count;
end;

procedure TRedis.Clear;
begin
  FList.Clear;
end;

end.
