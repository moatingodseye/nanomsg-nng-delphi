unit RedisProtocol;

interface

uses
  nng, nngdll, Redis, nngPacket, nngRequest, nngResponse, nngPublish;
  
type
  TRequestEvent = procedure(AData : TObject; ARedis : TRedis) of object;
  TIncoming = class(TnngResponse)
  private
    FRedis : TRedis;
    FOnAction : TRequestEvent;
  protected
    procedure Request(AData : TObject; AIn,AOut : TnngPacket); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property OnAction : TRequestEvent read FOnAction write FOnAction;
  published
  end;

  TResponseEvent = procedure(AData : TObject; ARedis : TRedis) of object;
  TOutgoing = class(TnngRequest)
  private
    FRedis : TRedis;
    FOnAction : TResponseEvent;
  protected
    procedure Response(AData : TObject; AIn : TnngPacket); override;
  public
    constructor Create; override;
    destructor Destroy;  override;

    procedure Request(ARedis : TRedis); overload;
    
    property OnAction : TResponseEvent read FOnAction write FOnAction;
  published
  end;
  
implementation

uses
  System.Classes, nngConstant;
  
procedure TIncoming.Request(AData : TObject; AIn,AOut : TnngPacket);
var
  M : TMemoryStream;
begin
  M := TMemoryStream.Create;
  M.Write(AIn.Buffer^,AIn.Used);
  M.Seek(0,soFromBeginning);
  FRedis.Load(M);
  FOnAction(AData,FRedis);
  if FRedis.Count>0 then begin
    AOut.Clear;
    M.Clear;
    M.Seek(0,soFromBeginning);
    FRedis.Save(M);
    M.Seek(0,soFromBeginning);
    AOut.Used := M.Size;
    M.Read(AOut.Buffer^, M.Size);
  end;
  M.Free;
end;

constructor TIncoming.Create;
begin
  inherited;
  FRedis := TRedis.Create;
end;

destructor TIncoming.Destroy;
begin
  FRedis.Free;
  inherited;
end;

procedure TOutgoing.Response(AData : TObject; AIn : TnngPacket);
var
  M : TMemoryStream;
begin
  M := TMemoryStream.Create;
  M.Write(AIn.Buffer^,AIn.Used);
  M.Seek(0,soFromBeginning);
  FRedis.Clear;
  FRedis.Load(M);
  FOnAction(AData,FRedis);
  M.Free;
end;

constructor TOutgoing.Create;
begin
  inherited;
  FRedis := TRedis.Create;
end;

destructor TOutgoing.Destroy;
begin
  FRedis.Free;
  inherited;
end;

procedure TOutgoing.Request(ARedis : TRedis);
var
  M : TMemoryStream;
  lOut :TnngPacket;
begin
//  FRedis.Clear;
  lOut := TnngPacket.Create(nngBuffer);
  M := TMemoryStream.Create;
  ARedis.Save(M);
  M.Seek(0,soFromBeginning);
  lOut.Used := M.Size;
  M.Read(lOut.Buffer^,M.Size);
  Request(lOut);
  M.Free;
  lOut.Free;
end;

end.
