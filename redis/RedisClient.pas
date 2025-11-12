{$M+}
unit RedisClient;

interface

uses
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
  Request;
  
const
  keyCommand = 'CMD';
  keyKey = 'KEY';
  keyType = 'TYP';
  keyValue = 'VAL';
  cmdAdd = 1;
  cndExist = 2;
  cmdRemove = 3;
  
procedure TRedisClient.DoOnAction(ASender : TObject; AIncoming : TRedis);
var
  lKey,
  lType,
  lValue : TValue;
  lTemp :TValue;
  lI,lO : TRedis;
begin
  Log(logInfo,'Action:');
  lKey := AIncoming.Exist(keyKey);
  lType := AIncoming.Exist(keyType);
  lValue := AIncoming.Exist(keyValue);
//    case lCommand.AsInteger of
//      cmdAdd : 
        begin
          lTemp := TValue.Create(FRedis,lKey.AsString);
          case EValue(lType.AsInteger) of
            valInteger : lTemp.AsInteger := lValue.AsInteger;
            valFloat : lTemp.AsFloat :=- lValue.AsFloat;
            valString : lTemp.AsString := lValue.AsString;
            valDate : lTemp.AsDate := lValue.AsDate;
            valRedis :
              begin
                lO := lTemp.AsRedis as TRedis;
                lI := lValue.AsRedis as TRedis;
                lO.Assign(lI);
              end;
          end;
          FRedis.Add(lTemp);
          SetToNil(lTemp);
        end;
//    end;
//  end;
end;

procedure TRedisClient.DoOnChange(AValue : TValue);
begin
  if assigned(FOnLog) then
    Log(logInfo,'Change-'+AValue.Caption);
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
  lRedis.Add(keyType,Ord(AValue.&Type));
  lRedis.Add(keyKey,AValue.Key);
  lRedis.Add(AValue);
  FRequest.Request(lRedis);
  while FRequest.State<>stReceived do
    Sleep(100);
  lRedis.Free;
end;

procedure TRedisClient.Stop;
begin
//  FPublish.Stop;
  FRequest.Stop;
end;

end.

