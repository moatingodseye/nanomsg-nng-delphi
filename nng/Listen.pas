unit Listen;

interface

uses
  nngdll, nng, Protocol;

type
  TListen = class(TProtocol)
  private
    FListen : THandle;
    FURL : AnsiString;
  protected
    procedure Setup; override;
    procedure Teardown; override;
  public
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  SysUtils, nngType;
  
procedure TListen.Setup;
var
  err : Integer;
begin
  inherited;
  if FStage=2 then begin
    FURL := FHost + ':' + IntToStr(FPort);
    err := nng_listen(FSocket, PAnsiChar(FUrl), @FListen, 0);
    if err = NNG_OK then begin
      Log(logInfo,'Listen:'+FURL);
      FPoll := True;
      Inc(FStage);
    end else
      Error('Listen: '+ nng_strerror(err))
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
      Error('unlisten:'+ nng_strerror(err));
  end;

  inherited;
end;

end.
