unit Listen;

interface

uses
  nngdll, Protocol;

type
  TListen = class(TProtocol)
  private
    FListen : THandle;
  protected
    FURL : AnsiString;
    
    procedure Setup; override;
    procedure Teardown; override;
  public
  published
  end;
  
implementation

procedure TListen.Setup;
var
  err : Integer;
begin
  inherited;
  if FStage=2 then begin
    err := nng_listen(FSocket, PAnsiChar(FUrl), @FListen, 0);
    if err = NNG_OK then 
      Inc(FStage)
     else
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
