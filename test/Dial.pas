unit Dial;

interface

uses
  nngdll, Protocol;

type
  TDial = class(TProtocol)
  private
    FDial : THandle;
  protected
    FURL : AnsiString;
    
    procedure Setup; override;
    procedure Teardown; override;
  public
  published
  end;
  
implementation

procedure TDial.Setup;
var
  err : Integer;
begin
  inherited;
  if FStage=2 then begin
    err := nng_Dial(FSocket, PAnsiChar(FUrl), @FDial, 0);
    if err = NNG_OK then 
      Inc(FStage)
     else
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
