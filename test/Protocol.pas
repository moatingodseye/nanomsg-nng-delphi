unit Protocol;

interface

uses
  nngdll, nng, Test;
  
type
  TProtocol = class(TNNG)
  strict private
//    FStage : Integer;
//    FListen : THandle;
//    FBuffer : Pointer;
  private
  strict protected
    FSocket : nng_socket;
    
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

procedure callback(pipe : THandle; which : nng_pipe; arg : pointer); cdecl;
var
  nng : Tnng;
begin
  asm nop end;
  nng := TNNG(arg);
  if assigned(nng.OnLog) then
    nng.OnLog('Pipe: '+IntToStr(pipe)+' which:'+IntToStr(which));
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
      Log('Error opening responder: '+ nng_strerror(err))
  end;
  if FStage=2 then begin
    err := nng_pipe_notify(FSocket,pipBefore,@callback,self);
    if err<>NNG_OK then
      Log('Pipe Error:'+nng_strerror(err));
    err := nng_pipe_notify(FSocket,pipAdd,@callback,self);
    if err<>NNG_OK then
      Log('Pipe Error:'+nng_strerror(err));
    err := nng_pipe_notify(FSocket,pipRemove,@callback,self);
    if err<>NNG_OK then
      Log('Pipe Error:'+nng_strerror(err));
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
      Log('Error closing socket: '+ nng_strerror(err));
  end;
  inherited;
end;

constructor TProtocol.Create;
begin
  inherited;
end;

destructor TProtocol.Destroy;
begin
  inherited;
end;

end.

