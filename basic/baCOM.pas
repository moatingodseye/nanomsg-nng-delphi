unit baCOM;

interface

type
  TbaCOM = class(TObject)
  private
    FInterface : IUnknown;
  public
    constructor Create(AInterface : IUnknown);
    destructor Destroy; override;
    
    property &Interface : IUnknown read FInterface;
  end;

implementation

constructor TbaCOM.Create(AInterface : IUnknown);
begin
  inherited Create;
  FInterface := AInterface;
end;

destructor TbaCOM.Destroy;
begin
  FInterface := nil;
  inherited;
end;

end.
