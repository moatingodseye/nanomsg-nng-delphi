unit Listen;

interface

uses
  nngType, Protocol;

type
  TListen = class(TProtocol)
  private
    FListen : THandle;
    FURL : AnsiString;
  protected
    procedure Setup; override;
    procedure Teardown(ATo : Enngstate); override;
  public
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

uses
  SysUtils, nngdll;
  
procedure TListen.Setup;
var
  err : Integer;
begin
  inherited;
  if FState=statProtocol then begin
    FURL := FHost + ':' + IntToStr(FPort);
    Log('Listen:'+FURL);
    err := nng_listen(FSocket, PAnsiChar(FUrl), @FListen, 0);
    if err = NNG_OK then begin
      FPoll := True;
      FState := Succ(FState);
    end else
      Error('Listen: '+ nng_strerror(err))
  end;
end;

procedure TListen.Teardown(ATo : Enngstate);
var
  err : Integer;
begin
  if FState>ATo then
    if FState=statConnect then begin
      Log('Unlisten:'+FURL);
      err := nng_listener_close(FListen);
      if err<>NNG_OK then
        Error('unlisten:'+ nng_strerror(err));
      FState := Pred(FState);
    end;

  inherited;
end;

end.
