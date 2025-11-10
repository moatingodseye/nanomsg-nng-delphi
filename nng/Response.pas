unit Response;

interface

uses
  nngdll, Protocol, Listen;
  
type
  TRequestEvent = procedure(ASender : TObject; AIn,AOut : TPacket) of object;
 
  TResponse = class(TListen)
  strict private
    FIn,
    FOut : TPacket;
    FOnRequest : TRequestEvent;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Request(AData : TObject; AIn,AOut : TPacket); virtual; abstract;
    procedure Teardown; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property OnRequest : TRequestEvent read FOnRequest write FOnRequest;
  published
  end;
  
implementation

uses
  System.SysUtils;
  
procedure TResponse.Process(AData : TObject);
var
  err : Integer;
  size : Integer;
  S : AnsiString;
//  rep : AnsiString;
//  rep_len : Integer;
begin
  size := 1024;
  err := Receive(FIn);//nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
  case err of
    NNG_OK :
      begin
//        S := PAnsiChar(FBuffer); 
//        Log('Responder received request: '+S+' size: '+IntToStr(size));

        FOut.Used := 0;
        if assigned(FOnRequest) then
          FOnRequest(Self,FIn,FOut)
        else
          // Send NULL response otherwise client will lock!
          Request(AData,FIn,FOut);
//          rep := '';
//          rep_len := Length(rep);
//          err := nng_send(FSocket, PAnsiChar(rep), rep_len, 0); 
//          if err <> NNG_OK then
//            Log('Error sending response: '+ nng_strerror(err))
        if Send(FOut)<>NNG_OK then
          Log('Error sending response: '+ nng_strerror(err))
      end;
    NNG_EAGAIN :
      begin
      end;
  else
    Log('Error receiving request: '+ nng_strerror(err))
  end;
end;

function TResponse.Protocol : Integer;
begin
  result := nng_rep0_open(FSocket);
end;

procedure TResponse.Setup;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    FIn := TPacket.Create(1024);
    FOut := TPacket.Create(1024);
  end;
end;

procedure TResponse.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FOut.Free;
    FIn.Free;
  end;
  inherited;
end;

constructor TResponse.Create;
begin
  inherited;
  FURL := 'tcp://127.0.0.1:5555';
end;

destructor TResponse.Destroy;
begin
  inherited;
end;

end.


