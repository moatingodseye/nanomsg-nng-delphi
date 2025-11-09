unit Pair;

interface

uses
  nngdll, Both;
  
type
  TPair = class(TBoth)
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
    constructor Create(ABoth : EBoth); override;
    destructor Destroy; override;
  published
  end;
  
  TSPair = class(TPair)
  public
    constructor Create; reintroduce;
  end;

  TCPair = class(TPair)
  public
    constructor Create; reintroduce;
  end;
  
implementation

uses
  System.SysUtils;
  
procedure TPair.Process(AData : TObject);
var
  err : Integer;
  rep : AnsiString;
  rep_len : Integer;
  size : Integer;
begin
  Sleep(100); // just for debugging
  if FBoth=bListen then begin
    rep := 'Pair:'+IntToStr(FCount);
    rep_len := Length(rep);
    err := nng_send(FSocket, PAnsiChar(rep), rep_len, 0); 
    if err = NNG_OK then
      Log('Sent:'+rep+' size:'+IntToStr(rep_len))
    else
      Log('Error sending Pair: '+ nng_strerror(err));
    Inc(FCount);
  end;
  if FBoth=bDial then begin
    size := 1024;
    err := nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
    case err of
      NNG_OK :
        begin
          Log('Receive:'+PAnsiChar(FBuffer)+' size:'+IntToStr(size));
        end;
      NNG_EAGAIN :
        begin
          asm nop end;
        end;
    else
      Log('Error receiving: '+ nng_strerror(err));
    end;       
  end;
  if FBoth=bBoth then begin
    size := 1024;
    err := nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
    case err of
      NNG_OK :
        begin
          Log('Receive:'+PAnsiChar(FBuffer)+' size:'+IntToStr(size));
    
          err := nng_send(FSocket, PAnsiChar(FBuffer), size, 0); 
          if err = NNG_OK then
            Log('Sent:'+rep+' size:'+IntToStr(size))
          else
            Log('Error sending Bus: '+ nng_strerror(err));
        end;
      NNG_EAGAIN :
        begin
          asm nop end;
        end;
    else
      Log('Error receiving: '+ nng_strerror(err));
    end;       
  end;
end;

function TPair.Protocol : Integer;
begin
  result := nng_pair0_open(FSocket);
end;

procedure TPair.Setup;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    GetMem(FBuffer,1024);
  end;
end;

procedure TPair.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FreeMem(FBuffer, 1024);
  end;
  inherited;
end;

constructor TPair.Create;
begin
  inherited;
  FCount := 0;
  FURL := 'tcp://127.0.0.1:5558';
//  SetPeriod(1000);
end;

destructor TPair.Destroy;
begin
  inherited;
end;

constructor TSPair.Create;
begin
  inherited Create(bListen);
end;

constructor TCPair.Create;
begin
  inherited Create(bDial);
end;

end.

