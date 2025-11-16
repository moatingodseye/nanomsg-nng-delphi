unit nngRequest;

interface

uses
  nngType, nngDial, nngPacket;
  
type
  EnngRequest = (stNull, stReady, stSent, stReceived);
  
  TnngRequest = class(TnngDial)
  strict private
    FRequest : EnngRequest;
    FIn,
    FOut : TnngPacket;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Response(AData : TObject; AIn : TnngPacket); virtual; abstract;
    procedure Teardown(ATo : EnngState); override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Kick; override;
    procedure Request(AOut : TnngPacket);

    property Stage : EnngRequest read FRequest;
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils,
  nngdll, nngConstant;
  
procedure TnngRequest.Process(AData : TObject);
var
  err : Integer;
begin
  case FRequest of
    stNull : asm nop end;
    stReady : 
      begin
        { Send the request }
        err := Send(FOut);
        if err = NNG_OK then begin
          FPoll := True;
          FRequest := stSent;
        end else
          Error('Send: '+ nng_strerror(err))
      end;
    stSent :
      begin
        { Waiting on response }
        FIn.Used := 0;
        err := Receive(FIn);
        case err of
          NNG_OK :
            begin
              FRequest := stReceived;
              FPoll := False;
              Response(AData,FIn);
            end;
          NNG_EAGAIN :
            begin
            end;
        else
          Error('Receive: '+ nng_strerror(err))
        end;
      end;
    stReceived :
      begin
        { all done }
        FEnabled := False;
      end;
  end;
end;

function TnngRequest.Protocol : Integer;
begin
  result := nng_req0_open(FSocket);
end;

procedure TnngRequest.Setup;
begin
  inherited;
  if FState=statConnect then begin
    FIn := TnngPacket.Create(nngBuffer);
    FOut := TnngPacket.Create(nngBuffer);

    FState := Succ(FState);
  end;
end;

procedure TnngRequest.Teardown(ATo : EnngState);
begin
  if FState>ATo then
    if FState=statReady then begin
      FOut.Free;
      FIn.Free;

      FState := Pred(FState);
    end;
  inherited;
end;

constructor TnngRequest.Create;
begin
  inherited;
  FRequest := stNull;
  FHost := 'tcp://127.0.0.1';
  FPort := 5555;
end;

destructor TnngRequest.Destroy;
begin
  inherited;
end;

procedure TnngRequest.Kick;
begin
  inherited;
//  FRequest := stReady;
end;

procedure TnngRequest.Request(AOut : TnngPacket);
begin
  FOut.Assign(AOut);
  FRequest := stReady;
  Kick;
end;

end.

