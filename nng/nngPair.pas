unit nngPair;

interface

uses
  nngType, nngBoth, nngPacket;
  
type
  TnngPair = class(TnngBoth)
  strict private
    FPacket : TnngPacket;
    FCount: Integer;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Teardown(ATo : EnngState); override;
  public
    constructor Create(ABoth : EnngWhat); override;
    destructor Destroy; override;
  published
  end;
  
  TnngListenPair = class(TnngPair)
  public
    constructor Create; reintroduce;
  end;

  TnngDialPair = class(TnngPair)
  public
    constructor Create; reintroduce;
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngdll, nngConstant;
  
procedure TnngPair.Process(AData : TObject);
var
  err : Integer;
  rep : AnsiString;
begin
  Sleep(100); // just for debugging
  if FBoth=whaListen then begin
    rep := 'Pair:'+IntToStr(FCount);
    FPacket.Push(rep);
    err := Send(FPacket); //nng_send(FSocket, PAnsiChar(rep), rep_len, 0); 
    if err = NNG_OK then
      Log('Sent:'+FPacket.Pull)
    else
      Error('Error sending Pair: '+ nng_strerror(err));
    Inc(FCount);
  end;
  if FBoth=whaDial then begin
    err := Receive(FPacket); //nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
    case err of
      NNG_OK :
        begin
          Log('Receive:'+FPacket.Pull+' size:'+IntToStr(FPacket.Used));
        end;
      NNG_EAGAIN :
        begin
          asm nop end;
        end;
    else
      Error('Error receiving: '+ nng_strerror(err));
    end;       
  end;
  if FBoth=whaBoth then begin
    err := Receive(FPacket); //nng_recv(FSocket, FBuffer, @size, NNG_FLAG_NONBLOCK);
    case err of
      NNG_OK :
        begin
          Log('Receive:'+FPacket.Pull+' size:'+IntToStr(FPacket.Used));
    
          err := Send(FPacket); //nng_send(FSocket, PAnsiChar(FBuffer), size, 0); 
          if err = NNG_OK then
            Log('Sent:'+FPacket.Pull+' size:'+IntToStr(FPacket.Used))
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

function TnngPair.Protocol : Integer;
begin
  result := nng_pair0_open(FSocket);
end;

procedure TnngPair.Setup;
begin
  inherited;
  if FState=statConnect then begin
    FPacket := TnngPacket.Create(nngBuffer);

    FState := Succ(FState);
  end;
end;

procedure TnngPair.Teardown(ATo : EnngState);
begin
  if FState>ATo then
    if FState=statReady then begin
      FPacket.Free;

      FState := Pred(FState);
    end;
  inherited;
end;

constructor TnngPair.Create;
begin
  inherited;
  FCount := 0;
  FHost := 'tcp://127.0.0.1';
  FPort := 5558;
end;

destructor TnngPair.Destroy;
begin
  inherited;
end;

constructor TnngListenPair.Create;
begin
  inherited Create(whaListen);
end;

constructor TnngDialPair.Create;
begin
  inherited Create(whaDial);
end;

end.

