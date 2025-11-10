unit RedisServer;

interface

uses
  nngdll,
  Redis, RedisProtocol;
  
type
  TLogEvent = procedure(AMessage : String) of object;
  
  TRedisServer = class(TObject)
  private
    FRedis : TRedis;
//    FPublish : TMonitor;
    FResponse : TIncoming;
    FHost : String;
    FPort : Integer;
    FOnLog : TLogEvent;
  protected
    procedure DoOnAction(ASender : TObject; AIncoming, AOutgoing : TRedis);
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

const
  keyCommand = 'CMD';
  keyKey = 'KEY';
  keyType = 'TYP';
  keyValue = 'VAL';
  cmdAdd = 1;
  cndExist = 2;
  cmdRemove = 3;
  
procedure TRedisServer.DoOnAction(ASender : TObject; AIncoming, AOutgoing : TRedis);
var
  lCommand,
  lKey,
  lType,
  lValue : TValue;
  lTemp :TValue;
  lI,lO : TRedis;
begin
  lCommand := AIncoming.Exist(keyCommand);
  lKey := AIncoming.Exist(keyKey);
  lType := AIncoming.Exist(keyType);
  lValue := AIncoming.Exist(keyValue);
  if assigned(lCommand) then begin
    case lCommand.AsInteger of
      cmdAdd : 
        begin
          lTemp := TValue.Create(FRedis,EValue(lType.AsInteger),lKey.AsString);
          case lTemp.&Type of
            valInteger : lTemp.AsInteger := lValue.AsInteger;
            valFloat : lTemp.AsFloat :=- lValue.AsFloat;
            valString : lTemp.AsString := lValue.AsString;
            valDate : lTemp.AsDate := lValue.AsDate;
            valObject :
              begin
                lO := lTemp.AsObject as TRedis;
                lI := lValue.AsObject as TRedis;
//                lO.Assign(lI);
              end;
          end;
          FRedis.Add(lTemp);
          lTemp := Nil;
        end;
    end;
  end;
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

//  FPublish := TPublish.Create;
///  FPublish.OnLog := DoOnLog;
  FResponse := TIncoming.Create;
  FResponse.OnAction := DoOnAction;
  FResponse.OnLog := DoOnLog;
end;

destructor TRedisServer.Destroy;
begin
  FResponse.Free;
  FResponse := Nil;
//  FPublish.Free;
//  FPublish := Nil;
  FRedis.Free;
  FRedis := Nil;
  inherited;
end;

procedure TRedisServer.Start;
begin
//  FPublish.Host := FHost;
//  FPublish.Port := FPort+1;
  FResponse.Host := FHost;
  FResponse.Port := FPort;
//  FPublish.Start;
  FResponse.Start;
end;

procedure TRedisServer.Stop;
begin
//  FPublish.Stop;
  FResponse.Stop;
end;

end.
