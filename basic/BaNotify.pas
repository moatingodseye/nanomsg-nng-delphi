{$M+}
unit BaNotify;

interface

uses
  System.Classes, System.Generics.Collections;
  
type
  TbaEvent = procedure(ASender,AData : TObject) of object;
  
  TBaNotify = class(TObject)
  private
    FList : TObjectDictionary<TbaEvent,TObject>;
  protected
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Add(AOnXYZ : TbaEvent);
    procedure Remove(AOnXYZ : TbaEvent);
    
    procedure Fire(ASender,AData : TObject);
  published
  end;
  
implementation

type
  TzEvent = class(TObject)
  private
    FOnXYZ : TbaEvent;
  protected
  public
    constructor Create(AOnXYZ : TbaEvent);
    destructor  Destroy; override;

    property OnXYZ : TbaEvent read FOnXYZ;
  published
  end;

constructor TzEvent.Create(AOnXYZ : TbaEvent);
begin
  inherited Create;
  FOnXYZ := AOnXYZ;
end;

destructor  TzEvent.Destroy;
begin
  inherited;
end;

constructor TbaNotify.Create;
begin
  inherited;
  FList := TObjectDictionary<TbaEvent,TObject>.Create([doOwnsValues]);
end;

destructor  TbaNotify.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TbaNotify.Add(AOnXYZ : TbaEvent);
begin
  if not FList.ContainsKey(AOnXYZ) then
    FList.Add(AOnXYZ,TzEvent.Create(AOnXYZ));
end;

procedure TbaNotify.Remove(AOnXYZ : TbaEvent);
begin
  if FList.ContainsKey(AOnXYZ) then
    FList.Remove(AOnXYZ);
end;

procedure TbaNotify.Fire(ASender,AData : TObject);
var
  lPair : TPair<TbaEvent,TObject>;
  lObj : TzEvent;
begin
  for lPair in FList do begin
    lObj := lPair.Value as TzEvent;
    lObj.OnXYZ(ASender,AData);
  end;
end;

end.
