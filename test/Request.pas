unit Request;

interface

uses
  Dial;
  
type
  EState = (stNull, stSent, stReceived);
  
  TRequest = class(TDial)
  strict private
    FBuffer : Pointer;
    FState : EState;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Teardown; override;
    procedure Kick; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
  end;
  
implementation

uses
  nngdll, System.SysUtils;
  
procedure TRequest.Process(AData : TObject);
var
  err : Integer;
  size : Integer;
  S : AnsiString;
  req,
  rep : AnsiString;
  req_len,
  rep_len : Integer;
begin
  case FState of
    stNull :
      begin
        { Send the request }
        req := 'Requesting Data';
        req_len := Length(req);
        err := nng_send(FSocket, PAnsiChar(req), req_len, 0);
        if err = NNG_OK then begin
          Log('Sent request');
          FState := stSent;
        end else
          Error('Error sending request: '+ nng_strerror(err))
      end;
    stSent :
      begin
        { Waiting on response }
        size := 1024;
        err := nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
        case err of
          NNG_OK :
            begin
              S := PAnsiChar(FBuffer); 
              Log('Received: '+S+' size: '+IntToStr(size));
              FState := stReceived;
            end;
          NNG_EAGAIN :
            begin
            end;
        else
          Error('Error receiving request: '+ nng_strerror(err))
        end;
//  end;
      end;
    stReceived :
      begin
        { all done }
        FEnabled := False;
      end;
  end;
end;

function TRequest.Protocol : Integer;
begin
  result := nng_req0_open(FSocket);
end;

procedure TRequest.Setup;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    GetMem(FBuffer,1024);
  end;
end;

procedure TRequest.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FreeMem(FBuffer, 1024);
  end;
  inherited;
end;

constructor TRequest.Create;
begin
  inherited;
  FState := stNull;
  FURL := 'tcp://127.0.0.1:5555';
end;

destructor TRequest.Destroy;
begin
  inherited;
end;

procedure TRequest.Kick;
begin
  inherited;
  FState := stNull;
end;

end.

