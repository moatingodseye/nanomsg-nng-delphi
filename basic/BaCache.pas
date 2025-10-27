{$M+}
unit BaCache;

interface

uses
  System.Generics.Collections,
  BaUnique, BaExtended;

type
  TbaCached = class(TObject)
  private
    FHolderID,
    FMotherID,
    FUID : Integer;
    FName : String;
    FObject : TbaExtended;
  protected
  public
    constructor Create(AHolderID,AMotherID,AUID : Integer; AName : String);
    destructor  Destroy; override;

    property HolderID : Integer read FHolderID;
    property MotherID : Integer read FMotherID;
    property UID : Integer read FUID;
    property Name : String read FName write FName;
    property &Object : TbaExtended read FObject write FObject;
  published
  end;
  
  TbaCacheMethod = procedure(ASender : TObject; ACache : TbaCached) of object;
  TbaCacheProcedure = reference to procedure(ASender : TObject; ACache : TbaCached);
  
  TbaCache = class(TObject)
  private
    FGenerator : TbaUnique;
    FUID : Integer;
    FList : TObjectDictionary<String,TbaCached>;
    FID : TObjectDictionary<Integer,TbaCached>;
  protected
    function GetObject(AUID : Integer) : TbaCached;
    function GetValue(AUID : Integer) : TbaExtended;
  public                                             
    constructor Create;
    destructor  Destroy; override;

    procedure Define(AMotherID,AUID : Integer; AName : String); overload; { Null }
    procedure Define(AMotherID,AUID : Integer; AName : String; AValue : Extended); overload; { Simple }
    procedure Define(AMotherID,AUID : Integer; AName : String; AValue : TbaExtended); overload;
    procedure Reset;                                              
    procedure Clear;
    procedure Iterate(AInto : TbaCacheMethod); overload;
    procedure Iterate(AInto : TbaCacheProcedure); overload;
    
    property Generator : TbaUnique read FGenerator;
    property UID : Integer read FUID write FUID;
//    property &Object[AName : String] : TbaCached read GetObject; 
    property &Object[AUID : Integer] : TbaCached read GetObject;
    property &Value[AUID : Integer] : TbaExtended read GetValue; default;
  published
  end;
  
implementation

uses
  SysUtils;

var
  uUID : TbaUnique; { Each cache given a unique ID so you can tell the difference between them all }
    
constructor TbaCached.Create(AHolderID,AMotherID,AUID : Integer; AName : String);
begin
  inherited Create;
  FHolderID := AHolderID;
  FMotherID := AMotherID;
  FUID := AUID;
  FName := AName;
end;

destructor TbaCached.Destroy;
begin
  FObject.Free;
  inherited;
end;

function TbaCache.GetObject(AUID : Integer) : TbaCached;
var
  lEle : TbaCached;
begin
  result := Nil;
  if FID.TryGetValue(AUID,lEle) then 
    result := lEle;
end;

function TbaCache.GetValue(AUID : Integer) : TbaExtended;
var
  lEle : TbaCached;
begin
  result := Nil;           
  if FID.TryGetValue(AUID,lEle) then 
    result := lEle.&Object;
end;

constructor TbaCache.Create;
begin
  inherited;
  FGenerator := TbaUnique.Create; { Each element in cache given a unique ID, unless specified on addition }
  FList := TObjectDictionary<String,TbaCached>.Create([doOwnsValues]);
  FID := TObjectDictionary<Integer,TbaCached>.Create([]);
  FUID := uUID.NextUID;
end;

destructor  TbaCache.Destroy;
begin
  FID.Free;
  FList.Free;
  FGenerator.Free;
  inherited;
end;

procedure TbaCache.Define(AMotherID,AUID : Integer; AName : string; AValue : TbaExtended);
var
  lEle : TbaCached;
begin
  if AUID=-1 then
    AUID := FGenerator.NextUID;
  if AName='' then
    AName := IntToStr(AUID);
  if not FID.TryGetValue(AUID,lEle) then begin
    lEle := TbaCached.Create(FUID,AMotherID,AUID,AName);
    lEle.&Object := AValue;
    FID.Add(AUID,lEle);
    FList.Add(AName,lEle);
  end else
    lEle.Name := AName; { May have changed }
end;

procedure TbaCache.Define(AMotherID,AUID : Integer; AName : string; AValue : Extended);
var
  lValue : TbaExtended;
begin
  lValue := TbaExtended.Create;
  lValue.Value := AValue;
  Define(AMotherID,AUID,AName,lValue);
end;

procedure TbaCache.Define(AMotherID,AUID : Integer; AName : string);
var
  lValue : TbaExtended;
begin
  lValue := TbaExtended.Create;
  lValue.Value := 0;
  lValue.Null := True;
  Define(AMotherID,AUID,AName,lValue);
end;

procedure TbaCache.Reset;
var
  lPair : TPair<Integer,TbaCached>;
begin
  for lPair in FID do begin
    lPair.Value.&Object.Reset;
  end;
end;

procedure TbaCache.Clear;
begin
  FID.Clear;
  FList.Clear;
end;

procedure TbaCache.Iterate(AInto : TbaCacheMethod);
var
  lPair : TPair<Integer,TbaCached>;
begin
  for lPair in FID do
    AInto(Self,lPair.Value);
end;

procedure TbaCache.Iterate(AInto : TbaCacheProcedure);
var
  lPair : TPair<Integer,TbaCached>;
begin
  for lPair in FID do
    AInto(Self,lPair.Value);
end;

procedure Initialise;                            
begin
  uUID := TbaUnique.Create;
end;

procedure Finalise;
begin
  uUID.Free;
  uUID := Nil;
end;

initialization
  Initialise;

finalization
  Finalise;
  
end.
