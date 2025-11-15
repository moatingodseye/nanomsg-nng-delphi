{DebugClient : Connect to the debug server
               Send commands/requests to the debug server for tasks for it to perform
               debug Server can send commands/requests back}
unit debugClient;

interface

uses
  debugProtocol;
  
type
  TdebugClient = class(TServer)
  private
  protected
  public
    constructor Create(AHost : String; APort: Integer); reintroduce;
    destructor Destroy; override;
  published
  end;
  
implementation

constructor TdebugClient.Create(AHost : String; APort : Integer);
begin
  inherited Create(AHost,APort+1,APort);
end;

destructor TdebugClient.Destroy;
begin
  inherited;
end;

end.
