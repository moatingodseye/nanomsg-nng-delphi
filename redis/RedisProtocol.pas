unit RedisProtocol;

interface

uses
  nng, nngdll, Redis, Protocol, Response, Publish;
  
type
  TActionEvent = procedure(AData : TObject; AIn,AOut : TRedis) of object;
  TIncoming = class(TResponse)
  private
    FIn,
    FOut : TRedis;
    FOnAction : TActionEvent;
  protected
    procedure Request(AData : TObject; AIn,AOut : TPacket); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property OnAction : TActionEvent read FOnAction write FOnAction;
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
  FOUt := TRedis.Create;
end;

destructor TIncoming.Destroy;
begin
  FOut.Free;
  FIn.Free;
end;

end.
