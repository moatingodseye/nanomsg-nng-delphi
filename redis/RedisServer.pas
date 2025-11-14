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

uses
  System.SysUtils, redisConstant;
  
procedure TRedisServer.DoOnAction(ASender : TObject; ARedis : TRedis);
var
  lCommand,
  lKey,
  lValue : TValue;
  lTemp :TValue;
  lI,lO : TRedis;
begin
  Log(logInfo,'Process:'+ARedis.Dump);
  
  lCommand := ARedis.Exist(keyCommand);
  lKey := ARedis.Exist(keyKey);
  if assigned(lCommand) then begin
    case lCommand.AsInteger of
      cmdAdd : 
        begin
          Log(logInfo,'Add:'+lKey.AsString);
          
          lValue := ARedis.Exist(lKey.AsString);
          lTemp := TValue.Create(FRedis,lKey.AsString);
          lTemp.Assign(lValue);
          FRedis.Add(lTemp);
          SetToNil(lTemp);

          { Setup response }
          ARedis.Remove(lKey.AsString);
//          ARedis.Add(keyCommand,cmdAdd);
//          ARedis.Add(keyKey,lKey.AsString);
          ARedis.Add(keyResponse,repACK);  
        end;
      cmdExist : 
        begin
          Log(logInfo,'Exist:'+lKey.AsString);
        
          lTemp := FRedis.Exist(lKey.AsString);

          if assigned(lTemp) then begin
//            ARedis.Clear;
//            ARedis.Add(keyCommand,cmdExist);
            ARedis.Add(keyResponse,repACK);
//            ARedis.Add(keyKey,lKey.AsString);
            AREdis.Add(TValue.Clone(Nil,lTemp));
          end else begin
//            ARedis.Clear;
//            ARedis.Add(keyCommand,cmdExist);
            ARedis.Add(keyResponse,repNACK);
//            ARedis.Add(keyKey,lKey.AsString);
          end;
        end;
      cmdRemove :
        begin
          Log(logInfo,'Remove:'+lKey.AsString);
          
          FRedis.Remove(lKey.AsString);
          
//          ARedis.Clear;
//          ARedis.Add(keyCommand,cmdRemove);
//          ARedis.Add(keyKey,lKey.AsString);
          ARedis.Add(keyResponse,repACK);  
        end;
    else
      begin
        { Response fail }
//        ARedis.Clear;
        ARedis.Add(keyResponse,repNACK);
      end;
    end;
  end;
end;

procedure TRedisServer.DoOnChange(AValue : TValue);
begin
  if assigned(FOnLog) then
    Log(logInfo,'Change-'+AValue.Key);
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
  FResponse.Level := logInfo;
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
