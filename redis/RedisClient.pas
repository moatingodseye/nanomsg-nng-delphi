{$M+}
unit RedisClient;

interface

uses
  Vcl.Forms, // for application
  nngdll, nngType,
  Redis, RedisProtocol;
  
type
  TLogEvent = procedure(AMessage : String) of object;
  
  TRedisClient = class(TObject)
  private
    FRedis : TRedis;
//    FPublish : TMonitor;
    FRequest : TOutgoing;
    FHost : String;
    FPort : Integer;
    FOnLog : TLogEvent;
  protected
    procedure DoOnAction(ASender : TObject; AIncoming  : TRedis);
    procedure DoOnChange(AValue : TValue);
    procedure DoOnLog(ALevel : ELog; AMessage : String);
    procedure Log(ALevel : ELog; AMessage : String);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Add(AValue : TValue);
    procedure Stop;

    property Host : String read FHost write FHost;
    property Port : Integer read FPort write FPort;
    property OnLog : TLogEvent read FOnLog write FOnLog;
  published
  end;
  
implementation

uses
  System.SysUtils,
  Request, redisConstant;
  
procedure TRedisClient.DoOnAction(ASender : TObject; AIncoming : TRedis);
var
  lResponse,
  lKey,
  lValue : TValue;
  lTemp :TValue;
  lI,lO : TRedis;
begin
  Log(logInfo,'Action:');
  lResponse := AIncoming.Exist(keyResponse);
  lKey := AIncoming.Exist(keyKey);
  if assigned(lKey) then begin
    lValue := AIncoming.Exist(lKey.AsString);
    lTemp := TValue.Create(FRedis,lKey.AsString);
    lTemp.Assign(lValue);
    FRedis.Add(lTemp);
    SetToNil(lTemp);
  end;
end;

procedure TRedisClient.DoOnChange(AValue : TValue);
begin
  if assigned(FOnLog) then
    Log(logInfo,'Change-'+AValue.Key);
end;

procedure TRedisClient.DoOnLog(ALevel : ELog; AMessage : String);
begin
  Log(ALevel,AMessage);
end;

procedure TRedisClient.Log(ALevel : ELog; AMessage : String);
begin
  if assigned(FOnLog) then
    FOnLog(cLog[ALevel]+AMEssage);
end;

constructor TRedisClient.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1';
  FPort := 9999;

  FRedis := TRedis.Create;
  FRedis.OnChange := DoOnChange;

//  FPublish := TPublish.Create;
///  FPublish.OnLog := DoOnLog;
  FRequest := TOutgoing.Create;
  FRequest.OnAction := DoOnAction;
  FRequest.OnLog := DoOnLog;
  FRequest.Level := logInfo;
end;

destructor TRedisClient.Destroy;
begin
  FRequest.Free;
  FRequest := Nil;
//  FPublish.Free;
//  FPublish := Nil;
  FRedis.Free;
  FRedis := Nil;
  inherited;
end;

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

procedure TRedisClient.Start;
begin
//  FPublish.Host := FHost;
//  FPublish.Port := FPort+1;
  FRequest.Host := FHost;
  FRequest.Port := FPort;
//  FPublish.Start;
  FRequest.Start;
end;

procedure TRedisClient.Add(AValue : TValue);
var
  lRedis : TRedis;
begin
  lRedis := TRedis.Create;
  lRedis.Add(keyCommand,cmdAdd);
  lRedis.Add(keyKey,AValue.Key);
  lRedis.Add(AValue);
  FRequest.Request(lRedis);
  while FRequest.State<>stReceived do begin
    Sleep(100);
    Application.ProcessMessages;
  end;
  lRedis.Free;
end;

procedure TRedisClient.Stop;
begin
//  FPublish.Stop;
  FRequest.Stop;
end;

end.

