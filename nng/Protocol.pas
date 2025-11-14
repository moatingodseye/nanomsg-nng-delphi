unit Protocol;

interface

uses
  nngdll,
  nngType, nng, Packet;

type
  TProtocol = class(TNNG)
  strict private
  private
  strict protected
    FSocket : nng_socket;
    
    function Receive(AIn : TPacket) : Integer;
    function Send(AOut :TPacket) : Integer;
    function Protocol : Integer; virtual; abstract;
  protected
    procedure Setup; override;
    procedure Teardown; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
  end;
  
implementation

uses
  System.SysUtils;

procedure Callback(pipe : THandle; which : nng_pipe; arg : pointer); cdecl;
var
  nng : TNNG;
begin
  nng := TNNG(arg);
  if assigned(nng.OnLog) then
    nng.Log(logInfo,'Pipe: '+IntToStr(pipe)+' which:'+IntToStr(which));
  nng.Pipe(which);
end;

function TProtocol.Receive(AIn : TPacket) : Integer;
var
  size : Integer;
begin
  size := AIn.Space;
  result := nng_recv(FSocket, AIn.Buffer, @size, NNG_FLAG_NONBLOCK);
  AIn.Used := size;
  if result=NNG_OK then
    Log(logInfo,'Receive:'+IntToStr(AIn.Used)+' '+AIn.Dump);
end;

function TProtocol.Send(AOut : TPacket) : Integer;
begin
  result := nng_send(FSocket, AOut.Buffer, AOut.Used, 0);
  if result=NNG_OK then
    Log(logInfo,'Send:'+InttoStr(AOut.Used)+' '+AOut.Dump);
end;

procedure TProtocol.Setup;
var
  err : Integer;
begin
  inherited;
  if FStage=1 then begin
    err := Protocol; //nng_rep0_open(FSocket);
    if err = NNG_OK then
      Inc(FStage)
    else
      Error('Protocol: '+ nng_strerror(err))
  end;
  if FStage=2 then begin
    err := nng_pipe_notify(FSocket,pipBefore,@callback,self);
    if err<>NNG_OK then
      Error('Pipe:'+nng_strerror(err));
    err := nng_pipe_notify(FSocket,pipAdd,@callback,self);
    if err<>NNG_OK then
      Error('Pipe:'+nng_strerror(err));
    err := nng_pipe_notify(FSocket,pipRemove,@callback,self);
    if err<>NNG_OK then
      Error('Pipe:'+nng_strerror(err));
  end;
end;

procedure TProtocol.Teardown;
var
  err : Integer;
begin
  inherited;
  if FStage=2 then begin
    Dec(FStage);
    err := nng_socket_close(FSocket);
    if err <> NNG_OK then
      Error('Error closing socket: '+ nng_strerror(err));
  end;
  inherited;
end;

constructor TProtocol.Create;
begin
  inherited;
  FSocket := 0;
end;

destructor TProtocol.Destroy;
begin
  inherited;
end;

end.

