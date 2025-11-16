unit nngBus;

interface

uses
  nngType, nngBoth;
  
type
  TnngBus = class(TnngBoth)
  strict private
    FBuffer : Pointer;
    FCount: Integer;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Teardown(ATo : EnngState); override;
  public
    constructor Create(ABoth : EBoth); override;
    destructor Destroy; override;
  published
  end;
  
  TnngDialBus = class(TnngBus)
  public
    constructor Create; reintroduce;
  end;

  TnngListenBus = class(TnngBus)
  public
    constructor Create; reintroduce;
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngdll, nngConstant;
  
procedure TnngBus.Process(AData : TObject);
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
      Log('Sent:'+rep+' size:'+IntToStr(rep_len))
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
          Log('Receive:'+PAnsiChar(FBuffer)+' size:'+IntToStr(size));
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
          Log('Receive:'+PAnsiChar(FBuffer)+' size:'+IntToStr(size));
    
          err := nng_send(FSocket, PAnsiChar(FBuffer), size, 0); 
          if err = NNG_OK then
            Log('Sent:'+rep+' size:'+IntToStr(size))
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

function TnngBus.Protocol : Integer;
begin
  result := nng_Bus0_open(FSocket);
end;

procedure TnngBus.Setup;
begin
  inherited;
  if FState=statConnect then begin
    GetMem(FBuffer,1024);

    FState := Succ(FState);
  end;
end;

procedure TnngBus.Teardown(ATo : EnngState);
begin
  if FState>ATo then
    if FState=statReady then begin
      FreeMem(FBuffer, 1024);

      FState := Pred(FState);
    end;
  inherited;
end;

constructor TnngBus.Create;
begin
  inherited;
  FCount := 0;
  FHost := 'tcp://127.0.0.1';
  FPort := 5559;
end;

destructor TnngBus.Destroy;
begin
  inherited;
end;

constructor TnngListenBus.Create;
begin
  inherited Create(bListen);
end;

constructor TnngDialBus.Create;
begin
  inherited Create(bDial);
end;

end.

