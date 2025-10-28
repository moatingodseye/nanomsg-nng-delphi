unit Pull;

interface

uses
  nngdll, Dial;
  
type
  TPull = class(TDial)
  strict private
    FBuffer : Pointer;
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
  
procedure TPull.Process(AData : TObject);
var
  err : Integer;
  size : Integer;
  S : AnsiString;
begin
  size := 1024;
  err := nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
  case err of
    NNG_OK :
      begin
        S := PAnsiChar(FBuffer); 
        Log('Received: '+S+' size: '+IntToStr(size));
      end;
    NNG_EAGAIN :
      begin
      end;
  else
    Log('Error receiving: '+ nng_strerror(err))
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
    GetMem(FBuffer,1024);
  end;
end;

procedure TPull.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FreeMem(FBuffer, 1024);
  end;
  inherited;
end;

constructor TPull.Create;
begin
  inherited;
  FURL := 'tcp://127.0.0.1:5556';
  SetPeriod(100);
end;

destructor TPull.Destroy;
begin
  inherited;
end;

end.

