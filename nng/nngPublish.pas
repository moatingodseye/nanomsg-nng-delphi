unit nngPublish;

interface

uses
  nngType, nngListen, nngPacket;
  
type
  TnngPublish = class(TnngListen)
  strict private
    FPacket : TnngPacket;
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
  
procedure TnngPublish.Process(AData : TObject);
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

function TnngPublish.Protocol : Integer;
begin
  result := nng_pub0_open(FSocket);
end;

procedure TnngPublish.Setup;
begin
  inherited;
  if FState=statConnect then begin
    FPacket := TnngPacket.Create(nngBuffer);

    FState := Succ(FState);
  end;
end;

procedure TnngPublish.Teardown(ATo : EnngState);
begin
  if FState>ATo then
    if FState=statReady then begin
      FPacket.Free;

      FState := Pred(FState);
    end;
  inherited;
end;

constructor TnngPublish.Create;
begin
  inherited;
  FCount := 0;
  FHost := 'tcp://127.0.0.1';
  FPort := 5557;
end;

destructor TnngPublish.Destroy;
begin
  inherited;
end;

end.

