unit Both;

interface

uses
  nngdll, Protocol;

type
  EBoth = (bListen, bDial, bBoth);
  TBoth = class(TProtocol)
  private
    FListen,
    FDial : THandle;
  protected
    FBoth : EBoth;
    FHost : AnsiString;
    FPort : Integer;
    FURL : AnsiString;
    
    procedure Setup; override;
    procedure Teardown; override;
  public
    constructor Create(ABoth : EBoth); reintroduce; virtual; 
    destructor Destroy; override;
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  System.SysUtils;
  
procedure TBoth.Setup;
  function Listen : Integer;
  var
    err : Integer;
  begin
    FURL := FHost+':'+IntToStr(FPort);
    err := nng_Listen(FSocket, PAnsiChar(FUrl), @FListen, 0);
    if err = NNG_OK then
    else
      Error('Error Bothing: '+ nng_strerror(err));
    result := err;
  end;
  function Dial : Integer;
  var
    err : Integer;
  begin
    FURL := FHost+':'+IntToStr(FPort);
    err := nng_Dial(FSocket, PAnsiChar(FUrl), @FDial, 0);
    if err = NNG_OK then 
    else
      Error('Error Dialing: '+ nng_strerror(err));
    result := err;
  end;
begin
  inherited;
  if FStage=2 then begin
    case FBoth of
      bListen : 
        if Listen=NNG_OK then
          Inc(FStage);
      bDial : 
        if Dial=NNG_OK then
          Inc(FStage);
      bBoth :
        begin
          if Listen=NNG_OK then
            if Dial=NNG_OK then
              Inc(FStage);
        end;
    end;
  end;
end;

procedure TBoth.Teardown;
var
  err : Integer;
begin           
  if FStage=3 then begin
    Dec(FStage);
    if FListen<>0 then begin
      err := nng_Listener_close(FListen);
      if err<>NNG_OK then
        Error('Listen close failed:'+ nng_strerror(err));
    end;
    if FDial<>0 then begin
      err := nng_Dialer_close(FDial);
      if err<>NNG_OK then
        Error('Dialer close failed:'+ nng_strerror(err));
    end;
  end;

  inherited;
end;

constructor TBoth.Create(ABoth : EBoth);
begin
  inherited Create;
  FListen := 0;
  FDial := 0;
  FBoth := ABoth;
end;

destructor TBoth.Destroy;
begin
  inherited;
end;

end.
