unit Request;

interface

uses
  Dial, Packet;
  
type
  EState = (stNull, stReady, stSent, stReceived);
  
  TRequest = class(TDial)
  strict private
    FState : EState;
    FIn,
    FOut : TPacket;
  private
  strict protected
    function Protocol : Integer; override;
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Response(AData : TObject; AIn : TPacket); virtual; abstract;
    procedure Teardown; override;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Kick; override;
    procedure Request(AOut : TPacket);

    property State : EState read FState;
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils,
  nngdll, nngType, nngConstant;
  
procedure TRequest.Process(AData : TObject);
var
  err : Integer;
begin
  case FState of
    stNull : asm nop end;
    stReady : 
      begin
        { Send the request }
        err := Send(FOut);
        if err = NNG_OK then begin
          FPoll := True;
          FState := stSent;
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
              FState := stReceived;
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

function TRequest.Protocol : Integer;
begin
  result := nng_req0_open(FSocket);
end;

procedure TRequest.Setup;
begin
  inherited;
  if FStage=3 then begin
    Inc(FStage);
    FIn := TPacket.Create(nngBuffer);
    FOut := TPacket.Create(nngBuffer);
  end;
end;

procedure TRequest.Teardown;
begin
  if FStage=4 then begin
    Dec(FStage);
    FOut.Free;
    FIn.Free;
  end;
  inherited;
end;

constructor TRequest.Create;
begin
  inherited;
  FState := stNull;
  FHost := 'tcp://127.0.0.1';
  FPort := 5555;
end;

destructor TRequest.Destroy;
begin
  inherited;
end;

procedure TRequest.Kick;
begin
  inherited;
  FState := stReady;
end;

procedure TRequest.Request(AOut : TPacket);
begin
  FOut.Assign(AOut);
  FState := stReady;
  Kick;
end;

end.

