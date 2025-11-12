unit Bus;

interface

uses
  nngdll, Both;
  
type
  TBus = class(TBoth)
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
  
  TSBus = class(TBus)
  public
    constructor Create; reintroduce;
  end;

  TCBus = class(TBus)
  public
    constructor Create; reintroduce;
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngType;
  
procedure TBus.Process(AData : TObject);
var
  err : Integer;
  rep : AnsiString;
  rep_len : Integer;
  size : Integer;
begin
  Sleep(100); // just for debugging
  if FBoth=bListen then begin
    rep := 'Bus:'+IntToStr(FCount);
    rep_len := Length(rep);
    err := nng_send(FSocket, PAnsiChar(rep), rep_len, 0); 
    if err = NNG_OK then
      Log(logInfo,'Sent:'+rep+' size:'+IntToStr(rep_len))
    else
      Error('Error sending Bus: '+ nng_strerror(err));
    Inc(FCount);
  end;
  if FBoth=bDial then begin
    size := 1024;
    err := nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
    case err of
      NNG_OK :
        begin
          Log(logInfo,'Receive:'+PAnsiChar(FBuffer)+' size:'+IntToStr(size));
        end;
      NNG_EAGAIN :
        begin
          asm nop end;
        end;
    else
      Error('Error receiving: '+ nng_strerror(err));
    end;       
  end;
  if FBoth=bBoth then begin
    size := 1024;
    err := nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
    case err of
      NNG_OK :
        begin
          Log(logInfo,'Receive:'+PAnsiChar(FBuffer)+' size:'+IntToStr(size));
    
          err := nng_send(FSocket, PAnsiChar(FBuffer), size, 0); 
          if err = NNG_OK then
            Log(logInfo,'Sent:'+rep+' size:'+IntToStr(size))
          else
            Error('Error sending Bus: '+ nng_strerror(err));
        end;
      NNG_EAGAIN :
        begin
          asm nop end;
        end;
    else
      Error('Error receiving: '+ nng_strerror(err));
    end;       
  end;
end;

function TBus.Protocol : Integer;
begin
  result := nng_Bus0_open(FSocket);
end;

procedure TBus.Setup;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    GetMem(FBuffer,1024);
  end;
end;

procedure TBus.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FreeMem(FBuffer, 1024);
  end;
  inherited;
end;

constructor TBus.Create;
begin
  inherited;
  FCount := 0;
  FHost := 'tcp://127.0.0.1';
  FPort := 5559;
//  SetPeriod(1000);
end;

destructor TBus.Destroy;
begin
  inherited;
end;

constructor TSBus.Create;
begin
  inherited Create(bListen);
end;

constructor TCBus.Create;
begin
  inherited Create(bDial);
end;

end.

