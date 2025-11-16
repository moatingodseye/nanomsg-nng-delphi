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
    procedure DoOnLog(AMessage : String);
    procedure Log(AMessage : String);
    function GetState: EnngState;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;

    property Host : String read FHost write FHost;
    property Port : Integer read FPort write FPort;
    property OnLog : TOnLog read FOnLog write FOnLog;
    property State  : EnngState read GetState;
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
  Log('Process:'+ARedis.Dump);
  
  lCommand := ARedis.Exist(keyCommand);
  lKey := ARedis.Exist(keyKey);
  if assigned(lCommand) then begin
    case lCommand.AsInteger of
      cmdAdd : 
        begin
          Log('Add:'+lKey.AsString);
          
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
          Log('Exist:'+lKey.AsString);
        
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
          Log('Remove:'+lKey.AsString);
          
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
    Log('Change-'+AValue.Key);
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

function TRedisServer.GetState: EnngState;
begin
  result := FResponse.State;
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

procedure TRedisServer.Connect;
begin
//  FPublish.Host := FHost;
//  FPublish.Port := FPort+1;
  FResponse.Host := FHost;
  FResponse.Port := FPort;
//  FPublish.Start;
  FResponse.Connect;
end;

procedure TRedisServer.Disconnect;
begin
//  FPublish.Stop;
  FResponse.Disconnect;
end;

end.
