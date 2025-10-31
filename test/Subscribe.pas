unit Subscribe;

interface

uses
  nngdll, Dial;
  
type
  TSubscribe = class(TDial)
  strict private
    FBuffer : Pointer;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Teardown; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
  end;
  
implementation

uses
  System.SysUtils;
  
procedure TSubscribe.Process(AData : TObject);
var
  err : Integer;
  size : Integer;
  S : AnsiString;
begin
  size := 1024;
  err := nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
  case err of
    NNG_OK :
      begin
        S := PAnsiChar(FBuffer); 
        Log('Received: '+S+' size: '+IntToStr(size));
      end;
    NNG_EAGAIN :
      begin
      end;
  else
    Log('Error receiving: '+ nng_strerror(err))
  end;
end;

function TSubscribe.Protocol : Integer;
begin
  result := nng_sub0_open(FSocket);
end;

procedure TSubscribe.Setup;
var
  err : Integer;
  what : AnsiString;
  what_len : Integer;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    GetMem(FBuffer,1024);
  end;
  if FStage=4 then begin
    what := '';
    what_len := Length(what);
    err := nng_sub0_socket_subscribe(FSocket, PAnsiChar(what), what_len);
    if err <> NNG_OK  then
      Error('Subscribe failed'+nng_strerror(err));
  end;
end;

procedure TSubscribe.Teardown;
var
  err : Integer;
  what : AnsiString;
  what_len : Integer;
begin
  if FStage=5 then begin
    what := '';
    what_len := Length(what);
    err := nng_sub0_socket_unsubscribe(FSocket,PAnsiChar(what),what_len);
    if err <> NNG_OK then
      Error('Unsubscribe failed'+nng_strerror(err));
  end;
  if FStage=4 then begin
    Dec(FStage);
    FreeMem(FBuffer, 1024);
  end;
  inherited;
end;

constructor TSubscribe.Create;
begin
  inherited;
  FURL := 'tcp://127.0.0.1:5557';
  SetPeriod(100);
end;

destructor TSubscribe.Destroy;
begin
  inherited;
end;

end.

