unit Listen;

interface

uses
  nngdll, Protocol;

type
  TListen = class(TProtocol)
  private
    FListen : THandle;
  protected
    FHost : AnsiString;
    FPort : Integer;
    FURL : AnsiString;
    
    procedure Setup; override;
    procedure Teardown; override;
  public

    property Host : AnsiString read FHost write FHost;
    property Port : Integer read FPort write FPort;
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  SysUtils;
  
procedure TListen.Setup;
var
  err : Integer;
begin
  inherited;
  if FStage=2 then begin
    FURL := FHost + ':' + IntToStr(FPort);
    err := nng_listen(FSocket, PAnsiChar(FUrl), @FListen, 0);
    if err = NNG_OK then begin
      Log('Listening:'+FURL);
      Inc(FStage);
    end else
      Log('Error listening: '+ nng_strerror(err))
  end;
end;

procedure TListen.Teardown;
var
  err : Integer;
begin           
  if FStage=3 then begin
    Dec(FStage);
    err := nng_listener_close(FListen);
    if err<>NNG_OK then
      Log('Listener close failed:'+ nng_strerror(err));
  end;

  inherited;
end;

end.
