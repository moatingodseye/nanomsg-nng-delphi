unit nngProtocol;

interface

uses
  nngdll,
  nngType, nng, nngPacket;

type
  TnngProtocol = class(TNNG)
  strict private
  private
  strict protected
    FSocket : nng_socket;
    
    function Receive(AIn : TnngPacket) : Integer;
    function Send(AOut :TnngPacket) : Integer;
    function Protocol : Integer; virtual; abstract;
  protected
    procedure Setup; override;
    procedure Teardown(ATo : Enngstate); override;
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
    nng.Log('Pipe: '+IntToStr(pipe)+' which:'+IntToStr(which));
  nng.Pipe(which);
end;

function TnngProtocol.Receive(AIn : TnngPacket) : Integer;
var
  size : Integer;
begin
  size := AIn.Space;
  result := nng_recv(FSocket, AIn.Buffer, @size, NNG_FLAG_NONBLOCK);
  AIn.Used := size;
  if result=NNG_OK then
    Log('Receive:'+IntToStr(AIn.Used)+' '+AIn.Dump);
end;

function TnngProtocol.Send(AOut : TnngPacket) : Integer;
begin
  result := nng_send(FSocket, AOut.Buffer, AOut.Used, 0);
  if result=NNG_OK then
    Log('Send:'+InttoStr(AOut.Used)+' '+AOut.Dump);
end;

procedure TnngProtocol.Setup;
var
  err : Integer;
begin
  inherited;
  if FState=statInitialised then begin
    err := Protocol; //nng_rep0_open(FSocket);
    if err= NNG_OK then begin
      err := nng_pipe_notify(FSocket,pipBefore,@callback,self);
      if err<>NNG_OK then
        Error('Pipe:'+nng_strerror(err));
      err := nng_pipe_notify(FSocket,pipAdd,@callback,self);
      if err<>NNG_OK then
        Error('Pipe:'+nng_strerror(err));
      err := nng_pipe_notify(FSocket,pipRemove,@callback,self);
      if err<>NNG_OK then
        Error('Pipe:'+nng_strerror(err));
      FState := Succ(FState);
    end else
      Error('Protocol: '+ nng_strerror(err))
  end;
end;

procedure TnngProtocol.Teardown(ATo : Enngstate);
var
  err : Integer;
begin
  inherited;
  if FState>ATo then
    if FState=statProtocol then begin
      err := nng_socket_close(FSocket);
      if err <> NNG_OK then
        Error('Protocol: '+ nng_strerror(err));
      FState := Pred(FState);
    end;
  inherited;
end;

constructor TnngProtocol.Create;
begin
  inherited;
  FSocket := 0;
end;

destructor TnngProtocol.Destroy;
begin
  inherited;
end;

end.

