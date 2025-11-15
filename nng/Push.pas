unit Push;

interface

uses
  nngType, Listen, Packet;
  
type
  TPush = class(TListen)
  strict private
    FPacket : TPacket;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Teardown(ATo : Enngstate); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Push(AFrom : TPacket);
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngdll, nng, nngConstant;

procedure TPush.Process(AData : TObject);
var
  err : Integer;
begin
  // Send Push
  if FPacket.Used>0 then begin
    err := Send(FPacket); 
    if err=NNG_OK then
      FPacket.Clear
    else
      Error('Send: '+ nng_strerror(err));
  end;
end;

function TPush.Protocol : Integer;
begin
  result := nng_push0_open(FSocket);
end;

procedure TPush.Setup;
begin
  inherited;
  if FState=statConnect then begin
    FPacket := TPacket.Create(nngBuffer);
    FState := Succ(FState);
  end;
end;

procedure TPush.Teardown(ATo : Enngstate);
begin
  if FState>ATo then
    if FState=statReady then begin
      FPacket.Free;
      FState := Pred(FState);
    end;
  inherited;
end;

constructor TPush.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1';
  FPort := 5556;
end;

destructor TPush.Destroy;
begin
  inherited;
end;

procedure TPush.Push(AFrom : TPacket);
begin
  FPacket.Assign(AFrom);
  KIck;
end;


end.

