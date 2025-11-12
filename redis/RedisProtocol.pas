unit RedisProtocol;

interface

uses
  nng, nngdll, Redis, Packet, Request, Response, Publish;
  
type
  TRequestEvent = procedure(AData : TObject; ARedis : TRedis) of object;
  TIncoming = class(TResponse)
  private
    FRedis : TRedis;
    FOnAction : TRequestEvent;
  protected
    procedure Request(AData : TObject; AIn,AOut : TPacket); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property OnAction : TRequestEvent read FOnAction write FOnAction;
  published
  end;

  TResponseEvent = procedure(AData : TObject; ARedis : TRedis) of object;
  TOutgoing = class(TRequest)
  private
    FRedis : TRedis;
    FOnAction : TResponseEvent;
  protected
    procedure Response(AData : TObject; AIn : TPacket); override;
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
  
procedure TIncoming.Request(AData : TObject; AIn,AOut : TPacket);
var
  M : TMemoryStream;
begin
  M := TMemoryStream.Create;
  M.Write(AIn.Buffer^,AIn.Used);
  M.Seek(0,soFromBeginning);
  FRedis.Load(M);
  AOut.Clear;
  FOnAction(AData,FRedis);
  if FRedis.Count>0 then begin
    M.Clear;
    M.Seek(0,soFromBeginning);
    FRedis.Save(M);
    M.Seek(0,soFromBeginning);
    M.Read(AIn.Buffer^, M.Size);
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

procedure TOutgoing.Response(AData : TObject; AIn : TPacket);
var
  M : TMemoryStream;
begin
  M := TMemoryStream.Create;
  M.Write(AIn.Buffer^,AIn.Used);
  M.Seek(0,soFromBeginning);
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
  lOut :TPacket;
begin
//  FRedis.Clear;
  lOut := TPacket.Create(nngBuffer);
  M := TMemoryStream.Create;
  ARedis.Save(M);
  M.Seek(0,soFromBeginning);
  lOut.Used := M.Size;
  M.Write(lOut.Buffer^,M.Size);
  Request(lOut);
  M.Free;
  lOut.Free;
end;

end.
