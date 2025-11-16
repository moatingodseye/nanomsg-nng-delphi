unit nngPush;

interface

uses
  nngType, nngListen, nngPacket;
  
type
  TnngPush = class(TnngListen)
  strict private
    FPacket : TnngPacket;
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

    procedure Push(AFrom : TnngPacket);
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngdll, nng, nngConstant;

procedure TnngPush.Process(AData : TObject);
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

function TnngPush.Protocol : Integer;
begin
  result := nng_push0_open(FSocket);
end;

procedure TnngPush.Setup;
begin
  inherited;
  if FState=statConnect then begin
    FPacket := TnngPacket.Create(nngBuffer);
    FState := Succ(FState);
  end;
end;

procedure TnngPush.Teardown(ATo : Enngstate);
begin
  if FState>ATo then
    if FState=statReady then begin
      FPacket.Free;
      FState := Pred(FState);
    end;
  inherited;
end;

constructor TnngPush.Create;
begin
  inherited;
  FHost := 'tcp://127.0.0.1';
  FPort := 5556;
end;

destructor TnngPush.Destroy;
begin
  inherited;
end;

procedure TnngPush.Push(AFrom : TnngPacket);
begin
  FPacket.Assign(AFrom);
  KIck;
end;


end.

