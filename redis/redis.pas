unit redis;

interface

uses
  System.Classes,
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
    FNull : Boolean;
    FInteger : Integer;
    FFloat : Double;
    FString : String;
    FDate : TDateTime;
    FObject : TOwner;
  protected
    procedure Change;
    procedure Load(AFrom : TStream); virtual;
    procedure Save(AInto : TStream); virtual;

    procedure SetInteger(AValue : Integer);
    procedure SetFloat(AValue : Double);
    procedure SetString(AValue : String);
    procedure SetDate(AValue : TDateTime);
  public
    constructor Create(AOwner : TOwner; AType : EValue; AKey : String);
    destructor Destroy; override;

    function Caption : String;
    procedure Clear;
    
    property Key : String read FKey;
    property &Type : EValue read FType;
    property Null : Boolean read FNull;
    property AsInteger : Integer read FInteger write SetInteger;
    property AsFloat : Double read FFloat write SetFloat;
    property AsString : String read FString write SetString;
    property AsDate : TDateTime read FDate write SetDate;
    property AsObject : TOwner read FObject;
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
    procedure Load(AFrom : TStream);
    procedure Save(AInto : TStream);
    
    procedure Add(AValue : TValue); 
    function  Exist(AKey : String) : TValue;
    procedure Remove(AKey : String);
    function Count : Integer;

    property OnChange : TOnChangeEvent read FOnChange write FOnChange;
  published
  end;
  
implementation

uses
  System.SysUtils;

procedure TValue.Change;
begin
  if assigned(FOWner) then
    FOwner.DoOnChange(Self);
end;

procedure TValue.Load(AFrom : TStream);
var
  lSize : Integer;
  lRedis : TRedis;
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
      valObject : 
        begin
          lRedis := TRedis.Create;
          FObject := lRedis;
          lRedis.Load(AFrom);
        end;
    end;
end;

procedure TValue.Save(AInto : TStream);
var
  lSize : Integer;
  lRedis : TRedis;
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
      valObject : 
        begin
          if assigned(FObject) then begin
            lRedis := TRedis(FObject);
            lRedis.Save(AInto);
          end;
        end;
    end;
end;

procedure TValue.SetInteger(AValue : Integer);
begin
  if FInteger<>AValue then
    Change;
  FInteger := AValue;
  FNull := False;
end;            

procedure TValue.SetFloat(AValue : Double);
begin
  if FFloat<>AValue then
    Change;
  FFloat := AValue;
  FNull := False;
end;

procedure TValue.SetString(AValue : String);
begin
  if FString<>AValue then
    Change;
  FString := AValue;
  FNull := False;
end;         

procedure TValue.SetDate(AValue : TDateTime);
begin
  if FDate<>AValue then
    Change;
  FDate := AValue;
  FNull := False;
end;

constructor TValue.Create(AOwner : TOwner; AType : EValue; AKey : String);
begin
  inherited Create;
  FOwner := AOwner;
  FType := AType;
  FKey := AKey;
  FObject := Nil;
  if FType=valObject then
    FObject := TRedis.Create;
end;

destructor TValue.Destroy;
begin
  if assigned(FObject) then
    FObject.Free;
  FObject := Nil;
  inherited;
end;

function TValue.Caption : String;
begin
  result := 'Key:'+FKey;//+' Int:'+IntToStr(FValue);
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
    lValue := TValue.Create(Self,valNull,'');
    lValue.Load(AFrom);
    Add(lValue);
    lValue := Nil;

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

function TRedis.Count : Integer;
begin
  result := FList.Count;
end;

end.
