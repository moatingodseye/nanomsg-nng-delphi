unit Dial;

interface

uses
  nngdll, Protocol;

type
  TDial = class(TProtocol)
  private
    FDial : THandle;
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
  System.SysUtils;
  
procedure TDial.Setup;
var
  err : Integer;
begin
  inherited;
  if FStage=2 then begin
    FURL := FHost + ':' + IntToStr(FPort);
    err := nng_dial(FSocket, PAnsiChar(FUrl), @FDial, 0);
    if err = NNG_OK then begin
      Log('Dialed:'+FURL);
      Inc(FStage);
    end else
      Log('Error Dialing: '+ nng_strerror(err))
  end;
end;

procedure TDial.Teardown;
var
  err : Integer;
begin           
  if FStage=3 then begin
    Dec(FStage);
    err := nng_Dialer_close(FDial);
    if err<>NNG_OK then
      Log('Dialer close failed:'+ nng_strerror(err));
  end;

  inherited;
end;

end.
