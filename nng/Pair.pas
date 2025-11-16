unit Pair;

interface

uses
  nngType, Both, Packet;
  
type
  TPair = class(TBoth)
  strict private
    FPacket : TPacket;
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
  
  TSPair = class(TPair)
  public
    constructor Create; reintroduce;
  end;

  TCPair = class(TPair)
  public
    constructor Create; reintroduce;
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils, nngdll, nngConstant;
  
procedure TPair.Process(AData : TObject);
var
  err : Integer;
  rep : AnsiString;
begin
  Sleep(100); // just for debugging
  if FBoth=bListen then begin
    rep := 'Pair:'+IntToStr(FCount);
    FPacket.Push(rep);
    err := Send(FPacket); //nng_send(FSocket, PAnsiChar(rep), rep_len, 0); 
    if err = NNG_OK then
      Log('Sent:'+FPacket.Pull)
    else
      Error('Error sending Pair: '+ nng_strerror(err));
    Inc(FCount);
  end;
  if FBoth=bDial then begin
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
  if FBoth=bBoth then begin
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

function TPair.Protocol : Integer;
begin
  result := nng_pair0_open(FSocket);
end;

procedure TPair.Setup;
begin
  inherited;
  if FState=statConnect then begin
    FPacket := TPacket.Create(nngBuffer);

    FState := Succ(FState);
  end;
end;

procedure TPair.Teardown(ATo : EnngState);
begin
  if FState>ATo then
    if FState=statReady then begin
      FPacket.Free;

      FState := Pred(FState);
    end;
  inherited;
end;

constructor TPair.Create;
begin
  inherited;
  FCount := 0;
  FHost := 'tcp://127.0.0.1';
  FPort := 5558;
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

