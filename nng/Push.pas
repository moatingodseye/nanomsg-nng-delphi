unit Push;

interface

uses
  nngdll, Listen;
  
type
  TPush = class(TListen)
  strict private
    FBuffer : Pointer;
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

uses
  System.SysUtils;
  
procedure TPush.Process(AData : TObject);
var
  err : Integer;
  rep : AnsiString;
  rep_len : Integer;
begin
  // Send Push
  rep := 'Push:'+IntToStr(FCount);
  rep_len := Length(rep);
  err := nng_send(FSocket, PAnsiChar(rep), rep_len, 0); 
  if err = NNG_OK then
    Log('Sent:'+rep+' size:'+IntToStr(rep_len))
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
    GetMem(FBuffer,1024);
  end;
end;

procedure TPush.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FreeMem(FBuffer, 1024);
  end;
  inherited;
end;

constructor TPush.Create;
begin
  inherited;
  FCount := 0;
  FURL := 'tcp://127.0.0.1:5556';
  SetPeriod(1000);
end;

destructor TPush.Destroy;
begin
  inherited;
end;

end.

