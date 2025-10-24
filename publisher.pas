unit Publisher;

interface

procedure Publish;

implementation

uses
  SysUtils,
  nng;

procedure Publish;
var
  pubSocket: TNNGSocket;
  message: string;
  msgLen: Integer;
begin
  // Initialize PUB socket
  if nng_pub0_open(pubSocket) <> 0 then
  begin
    Writeln('Failed to open PUB socket');
    Exit;
  end;

  // Bind to a local endpoint
  message := 'tcp://127.0.0.1:5555';  // You can change the address as needed
  msgLen := Length(message);
  if nng_socket_setopt(pubSocket, 1, @message[1], msgLen) <> 0 then  // 1 is the NNG option for binding
  begin
    Writeln('Failed to bind PUB socket');
    nng_close(pubSocket);
    Exit;
  end;

  // Send messages to subscribers
  while True do
  begin
    message := 'Hello from PUB: ' + DateTimeToStr(Now);
    if nng_socket_send(pubSocket, @message[1], Length(message)) <> 0 then
      Writeln('Failed to send message');
    Writeln('Published message: ', message);
    Sleep(1000);  // Send every second
  end;

  nng_close(pubSocket);
end;

end.
