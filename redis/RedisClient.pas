{$M+}
unit RedisClient;

interface

uses
  Vcl.Forms, // for application
  System.Contnrs, System.SyncObjs,
  baThread,
  nngdll, nngType,
  Redis, RedisProtocol;
  
type
  TResponseEvent = procedure(ASender : TObject; ACommand : Integer; AKey : String; AValue : TValue; AResponse : Integer) of object;
  TLogEvent = procedure(AMessage : String) of object;
  
  TRedisClient = class(TObject)
  private
    FThread : TbaThread;
    FLock : TCriticalSection;
    FQueue : TObjectQueue;
//    FPublish : TMonitor;
    FRequest : TOutgoing;
    FHost : String;
    FPort : Integer;
    FOnLog : TLogEvent;
    FOnResponse : TResponseEvent;
  protected
    procedure DoOnResponse(ASender,AData : TObject);
    procedure DoOnAction(ASender : TObject; AIncoming  : TRedis);
    procedure DoOnChange(AValue : TValue);
    procedure Log(AMessage : String);
    function GetState : EnngState;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect;
    procedure Add(AValue : TValue);
    procedure Exist(AKey : String);
    procedure Remove(AKey : String);
    procedure Disconnect;

    property State : EnngState read GetState;
    property Host : String read FHost write FHost;
    property Port : Integer read FPort write FPort;
    property OnLog : TLogEvent read FOnLog write FOnLog;
    property OnResponse : TResponseEvent read FOnResponse write FOnResponse;
  published
  end;
  
implementation

uses
  System.SysUtils,
  Request, redisConstant;
  
type
  TInternal = class(TObject)
  private
  public
    FCommand : Integer;
    FKey : String;
    FResponse : Integer;
    FValue : TValue;
  end;
  
procedure TRedisClient.DoOnResponse(ASender,AData : TObject);
var
  lObj : TInternal;
begin
  // syncrhonised
  lObj := Nil;
  FLock.Acquire;
  try
    lObj := FQueue.Pop as TInternal;
  finally
    FLock.Release;
  end;
  if assigned(FOnResponse) and assigned(lObj) then
    FOnResponse(Self,lObj.FCommand,lObj.FKey,lObj.FValue,lObj.FResponse);
end;
  
procedure TRedisClient.DoOnAction(ASender : TObject; AIncoming : TRedis);
var
  lCommand,
  lResponse,
  lKey,
  lValue : TValue;
  lTemp :TValue;
  lObj : TInternal;
begin
  // Threaded!
  Log('Action:');
  lCommand := AIncoming.Exist(keyCommand);
  lResponse := AIncoming.Exist(keyResponse);
  lKey := AIncoming.Exist(keyKey);

  lObj := TInternal.Create;
  lObj.FCommand := lCommand.AsInteger;
  if assigned(lKey) then
    lObj.FKey := lKey.AsString;
  lObj.FResponse := lResponse.AsInteger;
  lValue := Nil;
  if assigned(lKey) then begin
    lValue := AIncoming.Exist(lKey.AsString);
    if assigned(lValue) then
      lObj.FValue := TValue.Clone(Nil,lValue);
  end;
  
  FLock.Acquire;  
  try
    FQueue.Push(lObj);
  finally
    FLock.Release;
  end;
  FThread.Kick;
end;

procedure TRedisClient.DoOnChange(AValue : TValue);
begin
  if assigned(FOnLog) then
    Log('Change-'+AValue.Key);
end;

procedure TRedisClient.Log(AMessage : String);
begin
  if assigned(FOnLog) then
    FOnLog(AMEssage);
end;

function TRedisClient.GetState : EnngState;
begin
  result := FRequest.State;
end;

constructor TRedisClient.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1';
  FPort := 9999;

  FQueue := TObjectQueue.Create;
  
  FThread := TbaThread.Create(100,100);
  FThread.OnSyThread := DoOnResponse;

  FLock := TCriticalSection.Create;
  
//  FPublish := TPublish.Create;
///  FPublish.OnLog := DoOnLog;
  FRequest := TOutgoing.Create;
  FRequest.OnAction := DoOnAction;
  FRequest.OnLog := Log;
end;

destructor TRedisClient.Destroy;
begin
  FThread.Free;
  FThread := Nil;
  
  FLock.Free;
  FLock := Nil;

  FQueue.Free;
  FQueue := Nil;
  
  FRequest.Free;
  FRequest := Nil;
//  FPublish.Free;
//  FPublish := Nil;
  inherited;
end;

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

procedure TRedisClient.Connect;
begin
//  FPublish.Host := FHost;
//  FPublish.Port := FPort+1;
  FRequest.Host := FHost;
  FRequest.Port := FPort;
//  FPublish.Start;
  FRequest.Connect;
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
  lRedis.Free;
end;

procedure TRedisClient.Exist(AKey : String);
var
  lRedis : TRedis;
begin
  lRedis := TRedis.Create;
  lRedis.Add(keyCommand,cmdExist);
  lredis.Add(keyKey,AKey);
  FRequest.Request(lRedis);
  lRedis.Free;
end;

procedure TRedisClient.Remove(AKey : String);
var
  lRedis : TRedis;
begin
  lRedis := TRedis.Create;
  lRedis.Add(keyCommand,cmdRemove);
  lredis.Add(keyKey,AKey);
  FRequest.Request(lRedis);
  lRedis.Free;
end;

procedure TRedisClient.Disconnect;
begin
//  FPublish.Stop;
  FRequest.Disconnect;
  while FRequest.State<>statNull do begin
    Sleep(250);
    Application.ProcessMessages;
  end;
end;

end.
       
