unit Dummy;

interface

uses 
  System.SysUtils, nng;

type
  TDummy = class(TNNG)
  private
  protected
    procedure Setup; override;
    procedure Process(AData : TObject); override;
    procedure Teardown; override;
  public
  published
  end;
  
implementation

procedure TDummy.Setup;
begin
  inherited;
end;

procedure TDummy.Process(AData : TObject);
begin
  inherited;
  Sleep(1000);
end;

procedure TDummy.Teardown;
begin
  inherited;
end;

end.
