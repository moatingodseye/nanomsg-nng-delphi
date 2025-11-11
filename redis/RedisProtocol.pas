unit RedisProtocol;

interface

uses
  nng, nngdll, Redis, Packet, Request, Response, Publish;
  
type
  TRequestEvent = procedure(AData : TObject; AIn,AOut : TRedis) of object;
  TIncoming = class(TResponse)
  private
    FIn,
    FOut : TRedis;
    FOnAction : TRequestEvent;
  protected
    procedure Request(AData : TObject; AIn,AOut : TPacket); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property OnAction : TRequestEvent read FOnAction write FOnAction;
  published
  end;

  TResponseEvent = procedure(AData : TObject; AIn : TRedis) of object;
  TOutgoing = class(TRequest)
  private
    FIn,
    FOut : TRedis;
    FOnAction : TResponseEvent;
  protected
    procedure Response(AData : TObject; AIn : TPacket); override;
  public
    constructor Create; override;
    destructor Destroy;  override;

    procedure Request(AOut : TRedis); overload;
    
    property OnAction : TResponseEvent read FOnAction write FOnAction;
  published
  end;
  
implementation

uses
  System.Classes;
  
procedure TIncoming.Request(AData : TObject; AIn,AOut : TPacket);
var
  M : TMemoryStream;
begin
  M := TMemoryStream.Create;
  M.Write(AIn.Buffer^,AIn.Used);
  M.Seek(0,soFromBeginning);
  FIn.Load(M);
  AOut.Clear;
  FOnAction(AData,Fin,FOut);
  if FOut.Count>0 then begin
    M.Clear;
    M.Seek(0,soFromBeginning);
    FOut.Save(M);
    M.Seek(0,soFromBeginning);
    M.Read(AIn.Buffer^, M.Size);
  end;
  M.Free;
end;

constructor TIncoming.Create;
begin
  inherited;
  FIn := TRedis.Create;
  FOut := TRedis.Create;
end;

destructor TIncoming.Destroy;
begin
  FOut.Free;
  FIn.Free;
end;

procedure TOutgoing.Response(AData : TObject; AIn : TPacket);
var
  M : TMemoryStream;
begin
  M := TMemoryStream.Create;
  M.Write(AIn.Buffer^,AIn.Used);
  M.Seek(0,soFromBeginning);
  FIn.Load(M);
  FOnAction(AData,Fin);
  M.Free;
end;

constructor TOutgoing.Create;
begin
  inherited;
  FIn := TRedis.Create;
  FOut := TRedis.Create;
end;

destructor TOutgoing.Destroy;
begin
  FOut.Free;
  FIn.Free;
end;

procedure TOutgoing.Request(AOut : TRedis);
var
  M : TMemoryStream;
  lOut :TPacket;
begin
  lOut := TPacket.Create(1024);
  M := TMemoryStream.Create;
  AOut.Save(M);
  M.Seek(0,soFromBeginning);
  lOut.Used := M.Size;
  M.Write(lOut.Buffer^,M.Size);
  Request(lOut);
  M.Free;
  lOut.Free;
end;

end.
