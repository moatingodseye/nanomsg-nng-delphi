unit Subscribe;

interface

uses
  nngdll, Dial, Packet;
  
type
  TSubscribe = class(TDial)
  strict private
    FPacket : TPacket;
  private
    FWhat : AnsiString;
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Teardown; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    property What : AnsiString read FWhat write FWhat; // what are you subscribing to!
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngType, nngConstant;
  
procedure TSubscribe.Process(AData : TObject);
var
  err : Integer;
begin
  err := Receive(FPacket); //nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
  case err of
    NNG_OK :
      begin
        Log(logInfo,'Received: '+FPacket.Pull+' size: '+IntToStr(FPacket.Used));
      end;
    NNG_EAGAIN :
      begin
      end;
  else
    Error('Error receiving: '+ nng_strerror(err))
  end;
end;

function TSubscribe.Protocol : Integer;
begin
  result := nng_sub0_open(FSocket);
end;

procedure TSubscribe.Setup;
var
  err : Integer;
  what_len : Integer;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    FPoll := True;
    FPacket := TPacket.Create(nngBuffer);
  end;
  if FStage=4 then begin
    what_len := Length(FWhat);
    err := nng_sub0_socket_subscribe(FSocket, PAnsiChar(FWhat), what_len);
    if err <> NNG_OK  then
      Error('Subscribe failed'+nng_strerror(err));
  end;
end;

procedure TSubscribe.Teardown;
var
  err : Integer;
  what_len : Integer;
begin
  if FStage=5 then begin
    what_len := Length(FWhat);
    err := nng_sub0_socket_unsubscribe(FSocket,PAnsiChar(FWhat),what_len);
    if err <> NNG_OK then
      Error('Unsubscribe failed'+nng_strerror(err));
  end;
  if FStage=4 then begin
    Dec(FStage);
    FPacket.Free;
  end;
  inherited;
end;

constructor TSubscribe.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1';
  FPort := 5557;
end;

destructor TSubscribe.Destroy;
begin
  inherited;
end;

end.

