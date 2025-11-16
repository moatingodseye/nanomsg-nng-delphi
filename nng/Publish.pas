unit Publish;

interface

uses
  nngType, Listen, Packet;
  
type
  TPublish = class(TListen)
  strict private
    FPacket : TPacket;
    FCount: Integer;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
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
  
procedure TPublish.Process(AData : TObject);
var
  err : Integer;
begin
  if FPacket.Used>0 then begin
    err := Send(FPacket); //nng_send(FSocket, PAnsiChar(rep), rep_len, 0); 
    if err=NNG_OK then
      FPacket.Clear
    else
      Error('Sending: '+ nng_strerror(err));
  end;
end;

function TPublish.Protocol : Integer;
begin
  result := nng_pub0_open(FSocket);
end;

procedure TPublish.Setup;
begin
  inherited;
  if FState=statConnect then begin
    FPacket := TPacket.Create(nngBuffer);

    FState := Succ(FState);
  end;
end;

procedure TPublish.Teardown(ATo : EnngState);
begin
  if FState>ATo then
    if FState=statReady then begin
      FPacket.Free;

      FState := Pred(FState);
    end;
  inherited;
end;

constructor TPublish.Create;
begin
  inherited;
  FCount := 0;
  FHost := 'tcp://127.0.0.1';
  FPort := 5557;
end;

destructor TPublish.Destroy;
begin
  inherited;
end;

end.

