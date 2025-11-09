unit RedisServer;

interface

uses
  nngdll,
  Publish, Response, Redis;
  
type
  TLogEvent = procedure(AMessage : String) of object;
  
  TRedisServer = class(TObject)
  private
    FRedis : TRedis;
    FPublish : TPublish;
    FResponse : TResponse;
    FHost : String;
    FPort : Integer;
    FOnLog : TLogEvent;
  protected
    procedure DoOnRequest(ASender : TObject; ARequest : Pointer; ASize : Integer; ASocket : nng_socket);
    procedure DoOnChange(AValue : TValue);
    procedure DoOnLog(AMessage : String);
    procedure Log(AMessage : String);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    property Host : String read FHost write FHost;
    property Port : Integer read FPort write FPort;
    property OnLog : TLogEvent read FOnLog write FOnLog;
  published
  end;
  
implementation

procedure TRedisServer.DoOnRequest(ASender : TObject; ARequest : Pointer; ASize : Integer; ASocket : nng_socket);
begin

end;

procedure TRedisServer.DoOnChange(AValue : TValue);
begin
  if assigned(FOnLog) then
    Log('Change-'+AValue.Caption);
end;

procedure TRedisServer.DoOnLog(AMessage : String);
begin
  Log(AMessage);
end;

procedure TRedisServer.Log(AMessage : String);
begin
  if assigned(FOnLog) then
    FOnLog(AMEssage);
end;

constructor TRedisServer.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1:8888';

  FRedis := TRedis.Create;
  FRedis.OnChange := DoOnChange;

  FPublish := TPublish.Create;
  FPublish.OnLog := DoOnLog;
  FResponse := TResponse.Create;
  FResponse.OnRequest := DoOnRequest;
  FResponse.OnLog := DoOnLog;
end;

destructor TRedisServer.Destroy;
begin
  FResponse.Free;
  FResponse := Nil;
  FPublish.Free;
  FPublish := Nil;
  FRedis.Free;
  FRedis := Nil;
  inherited;
end;

procedure TRedisServer.Start;
begin
  FPublish.Host := FHost;
  FPublish.Port := FPort+1;
  FResponse.Host := FHost;
  FResponse.Port := FPort;
  FPublish.Start;
  FResponse.Start;
end;

procedure TRedisServer.Stop;
begin
  FPublish.Stop;
  FResponse.Stop;
end;

end.
