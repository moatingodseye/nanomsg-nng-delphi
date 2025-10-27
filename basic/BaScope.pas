{$M+}
unit BaScope;

interface

uses
  System.Classes, System.Contnrs, System.SysUtils, System.Generics.Collections;
  
type
  TbaScopeConstructor = function : TObject of object;

  EbaOwn = (scNothing, scOnRelease, scOnUndeclare, scCreate);
  
  TbaScope = class(TObject)
  private                        {Type,                     ID}
    FOwn,
    FDeclared,
    FTidy : TObjectDictionary<Integer,TObjectDictionary<Integer,TObject>>;
  protected
    procedure Tidy;
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Declare(AType,AID : Integer; AObject : TObject; AOwn : EbaOwn);
    function  Acquire(AType,AID : Integer) : TObject;
    procedure Release(AType,AID : Integer);
    procedure UnDeclare(AType,AID : Integer);
  published
  end;

const
  coContext = 1000; { Debugging context, username password etc }
  coLog = 1001; { General log 'everything.log' $DEFINE Logging TLogger }
  coCalculation = 1002; { Calculation logging, calculation.log £DEFINE Logging TLogger }
  coTree = 1003; { Tree related objects/classes }
  coMana = 1004; { Management classes for tree classes }
  coDebug = 1005; { General debugging }
  coLOX = 1005; { LOX settings }
  coDB = 1006;
    
var
  gScope : TbaScope;

implementation

{$IFDEF ScopeDebug}
uses
  ScopeDebugForm;
{$ENDIF}

type
  TElement = class(TObject)
  private
    FType,
    FID : Integer;
    FOwn : EbaOwn; { Do we own the object, i.e. do we free it on release/undeclare }
    FUsed : Integer; { Reference count }
    FObject : TObject; { The object iteself }
  protected
  public
    constructor Create(AType,AID : Integer;AObject : TObject; AOwn : EbaOwn);
    destructor  Destroy; override;

    property &Type : Integer read FType;
    property ID : Integer read FID;
    property Own : EbaOwn read FOwn;
    property &Object : TObject read FObject;
    property Used : Integer read FUsed write FUsed;
  published
  end;

constructor TElement.Create(AType,AID : Integer; AObject : TObject; AOwn : EbaOwn);  
begin
  inherited Create;
  FType := AType;
  FID := AID;
  FOwn := AOwn;
  FObject := AObject;
  FUsed := 0;
{$IFDEF ScopeDebug}
    frmScopeDebug.Created(FType,FID,Ord(FOwn),FUsed);
{$ENDIF}
end;                 

destructor TElement.Destroy;
begin
  case FOwn of
    scOnRelease,
    scOnUndeclare,
    scCreate :
      begin
{$IFDEF ScopeDebug}
        frmScopeDebug.Destroyed(FType,FID,FUsed);
{$ENDIF}
        FObject.Free;
      end;
  end;
  FObject := Nil;
  inherited;
end;

procedure TbaScope.Tidy;
var
  lType : TPair<Integer,TObjectDictionary<Integer,TObject>>;
  lValue : TPair<Integer,TObject>;
  lList : TObjectDictionary<Integer,TObject>;
  C : Integer;
  lEle : TElement;
  lZap : TObjectList;
begin
  lZap := TObjectList.Create(False);
  for lType in FTidy do begin
    lList := lType.Value;
    for lValue in lList do begin
      lEle := lValue.Value as TElement;
      if (lEle.Used=0) then
        lZap.Add(lEle);
    end;
  end;
  for C := 0 to lZap.Count-1 do begin
    lEle := lZap[C] as TElement;
    UnDeclare(lEle.&Type,lEle.ID);
  end;
  lZap.Free;
end;

constructor TbaScope.Create;
begin
  inherited;
  FOwn := TObjectDictionary<Integer,TObjectDictionary<Integer,TObject>>.Create([doOwnsValues]);
  FDeclared := TObjectDictionary<Integer,TObjectDictionary<Integer,TObject>>.Create([]);
  FTidy := TObjectDictionary<Integer,TObjectDictionary<Integer,TObject>>.Create([]);
end;

destructor TbaScope.Destroy;
begin
  FTidy.Free;
  FTidy := Nil;
  FDeclared.Free;
  FDeclared := Nil;
  FOwn.Free;
  FOwn := Nil;
  inherited;
end;

procedure TbaScope.Declare(AType,AID : Integer; AObject : TObject; AOwn : EbaOwn);
var
  lOwn,
  lList : TObjectDictionary<Integer,TObject>;
  lEle : TElement;
begin
{$IFDEF ScopeDebug}
  if assigned(frmScopeDebug) then
    frmScopeDebug.Declare(AType,AID);
{$ENDIF}
  Tidy;
  if not FDeclared.TryGetValue(AType,lList) then begin
    lList := TObjectDictionary<Integer,TObject>.Create([]);
    FDeclared.Add(AType,lList);
  end;
  
  if not FOwn.TryGetValue(AType,lOwn) then begin
    lOwn := TObjectDictionary<Integer,TObject>.Create([doOwnsValues]);
    FOwn.Add(AType,lOwn);
  end;  
  
  lEle := TElement.Create(AType,AID,AObject,AOwn);
  lList.AddOrSetValue(AID,lEle);
  lOwn.AddOrSetValue(AID,lEle);
end;   

function  TbaScope.Acquire(AType,AID : Integer) : TObject;
var
  lList : TObjectDictionary<Integer,TObject>;
  lObj : TObject;
  lEle : TElement;
begin
  Tidy;
  result := Nil;
  if FDeclared.TryGetValue(AType,lList) then 
    if lList.TryGetValue(AID,lObj) then begin
      lEle := lObj as TELement;
      lEle.Used := lEle.Used + 1;
      result := lEle.&Object;
{$IFDEF ScopeDebug}
      if assigned(frmScopeDebug) then
        frmScopeDebug.Acquire(lEle.&FType,lEle.ID,lEle.Used);
{$ENDIF}
    end;
end;           

procedure TbaScope.Release(AType,AID : Integer);
var
  lTemp,
  lList : TObjectDictionary<Integer,TObject>;
  lObj : TObject;           
  lEle : TElement;
begin
  if FDeclared.TryGetValue(AType,lList) then 
    if lList.TryGetValue(AID,lObj) then begin
      lEle := lObj as TELement;
      lEle.Used := lEle.Used - 1;
{$IFDEF ScopeDebug}
      frmScopeDebug.Release(lEle.&FType,lEle.ID,lEle.Used);
{$ENDIF}
      if (lEle.Used=0) and (lEle.Own in [scOnRelease,scCreate]) then
        lList.Remove(AID); { No longer available to acquire }
    end;
  if FOwn.TryGetValue(AType,lList) then
    if lList.TryGetValue(AID,lObj) then begin
      lEle := lObj as TElement;
      if (lEle.Used=0) and (lEle.Own in [scOnRelease]) then begin
        if FTidy.TryGetValue(AType,lTemp) then begin
          if lTemp.ContainsKey(AID) then
            lTemp.Remove(AID);
        end;
        lList.Remove(AID); { Free's the object, otherwise wait for undeclare call! }
      end;
    end;
  Tidy;
end;

procedure TbaScope.UnDeclare(AType,AID : Integer);
var
  lTemp,
  lList : TObjectDictionary<Integer,TObject>;
  lObj : TObject;                   
  lEle : TElement;
begin
{$IFDEF ScopeDebug}
  frmScopeDebug.UnDeclare(AType,AID);
{$ENDIF}
  if FDeclared.TryGetValue(AType,lList) then 
    if lList.TryGetValue(AID,lObj) then
      lList.Remove(AID); { No longer available to acquire } 
  if FOwn.TryGetValue(AType,lList) then
    if lList.TryGetValue(AID,lObj) then begin
      lEle := lObj as TElement;
      if (lEle.Used<>0) then begin
        { Remove from here, but don't free yet, put it to be tidied later }
        if not FTidy.TryGetValue(AType,lTemp) then begin
          lTemp := TObjectDictionary<Integer,TObject>.Create([]);
          FTidy.Add(AType,lTemp);
        end;
        lTemp.Add(AID,lEle);
      end else begin
        {Might be in tidy list alread but we are freeing so remove so don't try to free twice }
        if FTidy.TryGetValue(AType,lTemp) then begin
          if lTemp.ContainsKey(AID) then
            lTemp.Remove(AID);
        end;  
        lList.Remove(AID);
      end;
    end;
  Tidy;
end;

procedure Initialise;
begin
  gScope := TbaScope.Create;
{$IFDEF ScopeDebug}
  frmScopeDebug := TfrmScopeDebug.Create(nil);
  frmScopeDebug.Show;
{$ENDIF}  
end;

procedure Finalise;
begin
  gScope.Free;
  gScope := Nil;
{$IFDEF ScopeDebug}
  frmScopeDebug.Free;
{$ENDIF}  
end;

initialization
  Initialise;

finalization
  Finalise;

end.       
