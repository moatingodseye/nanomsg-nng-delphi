unit Pull;

interface

uses
  nngdll, Packet, Dial;
  
type
  TPull = class(TDial)
  strict private
    FPacket : TPacket;
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

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngType, nngConstant;
  
procedure TPull.Process(AData : TObject);
var
  err : Integer;
begin
  err := Receive(FPacket);
  case err of
    NNG_OK :
      begin
        Log(logInfo,'Received: '+FPacket.Pull);
      end;
    NNG_EAGAIN :
      begin
      end;
  else
    Error('Error receiving: '+ nng_strerror(err))
  end;
end;

function TPull.Protocol : Integer;
begin
  result := nng_pull0_open(FSocket);
end;

procedure TPull.Setup;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    FPoll := True;
    FPacket := TPacket.Create(nngBuffer);
  end;
end;

procedure TPull.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FPacket.Free;
  end;
  inherited;
end;

constructor TPull.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1';
  FPort := 5556;
  SetPeriod(100);
end;

destructor TPull.Destroy;
begin
  inherited;
end;

end.

