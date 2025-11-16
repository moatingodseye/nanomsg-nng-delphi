unit Response;

interface

uses
  nngType, Listen, Packet;
  
type
  TResponse = class(TListen)
  strict private
    FIn,
    FOut : TPacket;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Request(AData : TObject; AIn,AOut : TPacket); virtual; abstract;
    procedure Teardown(ATo : EnngState); override;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngdll, nngConstant;
  
procedure TResponse.Process(AData : TObject);
var
  err : Integer;
begin
  err := Receive(FIn);//nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
  case err of
    NNG_OK :
      begin
        FOut.Used := 0;
        Request(AData,FIn,FOut);
        if Send(FOut)<>NNG_OK then
          Error('Send: '+ nng_strerror(err))
      end;
    NNG_EAGAIN :
      begin
      end;
  else
    Error('Receive: '+ nng_strerror(err))
  end;
end;

function TResponse.Protocol : Integer;
begin
  result := nng_rep0_open(FSocket);
end;

procedure TResponse.Setup;
begin
  inherited;
  if FState=statConnect then begin
    FIn := TPacket.Create(nngBuffer);
    FOut := TPacket.Create(nngBuffer);

    FState := Succ(FState);
    FPoll := True;
  end;
end;

procedure TResponse.Teardown(ATo : EnngState);
begin
  if FState>ATo then
    if FState=statReady then begin
      FOut.Free;
      FIn.Free;

      FState := Pred(FState);
    end;
  inherited;
end;

constructor TResponse.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1';
  FPort := 5555;
end;

destructor TResponse.Destroy;
begin
  inherited;
end;

end.


