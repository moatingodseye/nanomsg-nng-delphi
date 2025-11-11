unit Push;

interface

uses
  nngdll, Listen, Packet;
  
type
  TPush = class(TListen)
  strict private
    FOut : TPacket;
    FCount: Integer;
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
  System.SysUtils;

procedure TPush.Process(AData : TObject);
var
  err : Integer;
  rep : AnsiString;
begin
  // Send Push
  rep := 'Push:'+IntToStr(FCount);
  FOut.Push(rep);
  err := Send(FOut); 
  if err = NNG_OK then
    Log('Sent:'+FOut.Pull)
  else
    Log('Error sending Push: '+ nng_strerror(err));
  Inc(FCount);
//  FEnabled := False;
end;

function TPush.Protocol : Integer;
begin
  result := nng_push0_open(FSocket);
end;

procedure TPush.Setup;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    FOut := TPacket.Create(128);
  end;
end;

procedure TPush.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FOut.Free;
  end;
  inherited;
end;

constructor TPush.Create;
begin
  inherited;
  FCount := 0;
  FHost := 'tcp://127.0.0.1';
  FPort := 5556;
  SetPeriod(1000);
end;

destructor TPush.Destroy;
begin
  inherited;
end;

end.

