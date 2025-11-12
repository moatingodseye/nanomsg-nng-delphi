{$M+}
unit RedisServer;

interface

uses
  nngdll, nngType,
  Redis, RedisProtocol;
  
type
  TRedisServer = class(TObject)
  private
    FRedis : TRedis;
//    FPublish : TMonitor;
    FResponse : TIncoming;
    FHost : String;
    FPort : Integer;
    FOnLog : TOnLog;
  protected
    procedure DoOnAction(ASender : TObject; ARedis : TRedis);
    procedure DoOnChange(AValue : TValue);
    procedure DoOnLog(ALevel : ELog; AMessage : String);
    procedure Log(ALevel : ELog; AMessage : String);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    property Host : String read FHost write FHost;
    property Port : Integer read FPort write FPort;
    property OnLog : TOnLog read FOnLog write FOnLog;
  published
  end;
  
implementation

const
  keyCommand = 'CMD';
  keyKey = 'KEY';
  keyType = 'TYP';
//  keyValue = 'VAL';
  cmdAdd = 1;
  cndExist = 2;
  cmdRemove = 3;
  keyResponse = 'RES';
  repACK = 0;
  repNACK = 1;
  
procedure TRedisServer.DoOnAction(ASender : TObject; ARedis : TRedis);
var
  lCommand,
  lKey,
  lType,
  lValue : TValue;
  lTemp :TValue;
  lI,lO : TRedis;
begin
  lCommand := ARedis.Exist(keyCommand);
  lKey := ARedis.Exist(keyKey);
  lType := ARedis.Exist(keyType);
  if assigned(lCommand) then begin
    case lCommand.AsInteger of
      cmdAdd : 
        begin
          lValue := ARedis.Exist(lKey.AsString);
          lTemp := TValue.Create(FRedis,lKey.AsString);
          case EValue(lTemp.AsInteger) of
            valInteger : lTemp.AsInteger := lValue.AsInteger;
            valFloat : lTemp.AsFloat :=- lValue.AsFloat;
            valString : lTemp.AsString := lValue.AsString;
            valDate : lTemp.AsDate := lValue.AsDate;
            valRedis :
              begin
                lO := lTemp.AsRedis;
                lI := lValue.AsRedis;
                lO.Assign(lI);
              end;
          end;
          FRedis.Add(lTemp);
          SetToNil(lTemp);

          { Setup response }
          ARedis.Clear;
          ARedis.Add(keyResponse,repACK);
        end;
    else
      begin
        { Response fail }
        ARedis.Clear;
        ARedis.Add(keyResponse,repNACK);
      end;
    end;
  end;
end;

procedure TRedisServer.DoOnChange(AValue : TValue);
begin
  if assigned(FOnLog) then
    Log(logInfo,'Change-'+AValue.Caption);
end;

procedure TRedisServer.DoOnLog(ALevel : ELog; AMessage : String);
begin
  Log(ALevel,AMessage);
end;

procedure TRedisServer.Log(ALevel : ELog; AMessage : String);
begin
  if assigned(FOnLog) then
    FOnLog(ALevel,AMEssage);
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

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

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
