{$M+}
unit debugServer;
{DebugClient : Connect to the debug server
               Send commands/requests to the debug server for tasks for it to perform
               debug Server can send commands/requests back}

interface

uses
  debugProtocol;
  
type
  TdebugServer = class(TServer)
  private
  protected
  public
    constructor Create(AHost : String; APort : Integer); reintroduce;
    destructor Destroy; override;
  published
  end;
  
implementation

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF} 

constructor TdebugServer.Create(AHost : String; APort : Integer);
begin
  inherited Create(AHost,APort,APort+1);
end;

destructor TdebugServer.Destroy;
begin
  inherited;
end;

end.

