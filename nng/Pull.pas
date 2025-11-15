unit Pull;

interface

uses
  nngdll, nngType, Packet, Dial;
  
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
    procedure Pull(AData : TObject; AIn : TPacket); virtual; abstract;
    procedure Teardown(ATo : Enngstate); override;
  public
    constructor Create; override;
    destructor Destroy; override;
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nng, nngConstant;
  
procedure TPull.Process(AData : TObject);
var
  err : Integer;
begin
  err := Receive(FPacket);
  case err of
    NNG_OK :
      begin
        Pull(AData,FPacket);
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
  if FState=statConnect then begin
    FPacket := TPacket.Create(nngBuffer);
    FState := Succ(FState);
    FPoll := True;
  end;
end;

procedure TPull.Teardown(ATo : Enngstate);
begin
  if FState>ATo then
    if FState=statReady then begin
      FPoll := False;
      FPacket.Free;
      FState := Pred(FState);
    end;
  inherited;
end;

constructor TPull.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1';
  FPort := 5556;
end;

destructor TPull.Destroy;
begin
  inherited;
end;

end.

