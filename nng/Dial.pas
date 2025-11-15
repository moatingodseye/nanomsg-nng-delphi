unit Dial;

interface

uses
  nngType, Protocol;

type
  TDial = class(TProtocol)
  private
    FDial : THandle;
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
  System.SysUtils, nngdll, nng;
  
procedure TDial.Setup;
var
  err : Integer;
begin
  inherited;
  if FState=statProtocol then begin
    FURL := FHost + ':' + IntToStr(FPort);
    Log('Dial:'+FURL);
    err := nng_dial(FSocket, PAnsiChar(FUrl), @FDial, 0);
    if err = NNG_OK then begin
      FState := Succ(FState)
    end else
      Error('Dial: '+ nng_strerror(err))
  end;
end;

procedure TDial.Teardown(ATo : Enngstate);
var
  err : Integer;
begin           
  if FState>ATo then
    if FState=statConnect then begin
      Log('Undial:'+FURL);
      err := nng_Dialer_close(FDial);
      if err=NNG_OK then
        FState := Pred(FState)
      else
        Error('Undial:'+ nng_strerror(err));
    end;

  inherited;
end;

end.
