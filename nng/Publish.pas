unit Publish;

interface

uses
  nngdll, Listen, Packet;
  
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
  
procedure TPublish.Process(AData : TObject);
var
  err : Integer;
  rep : AnsiString;
begin
  // Send Publish
  rep := 'Publish:'+IntToStr(FCount);
  FPacket.Push(rep);
  err := Send(FPacket); //nng_send(FSocket, PAnsiChar(rep), rep_len, 0); 
  if err = NNG_OK then
    Log(logInfo,'Sent:'+FPacket.Pull+' size:'+IntToStr(FPacket.Used))
  else
    Error('Error sending Publish: '+ nng_strerror(err));
  Inc(FCount);
//  FEnabled := False;
end;

function TPublish.Protocol : Integer;
begin
  result := nng_pub0_open(FSocket);
end;

procedure TPublish.Setup;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    FPacket := TPacket.Create(nngBuffer);
  end;
end;

procedure TPublish.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FPacket.Free;
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

