{$M+}
unit BaUnique;

interface

type
  TbaUnique = class(TObject)
  private
    FUID : Integer;
  protected
  public
    constructor Create; 
    destructor  Destroy; override;

    function NextUID : Integer;
  published
  end;
  
implementation

constructor TbaUnique.Create;
begin
  inherited;
  FUID := 1000;
end;

destructor TbaUnique.Destroy;
begin
  inherited;
end;

function TbaUnique.NextUID : Integer;
begin
  result := FUID;
  Inc(FUID);
end;

end.
