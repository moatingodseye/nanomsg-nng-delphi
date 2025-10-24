unit Subscriber;

interface

procedure Subscribe;

implementation

uses
  SysUtils,
  nng;

procedure Subscribe;
var
  host : String;
  subSocket: TNNGSocket;
  receivedMessage: Pointer;
  messageLen: Integer;
  receivedStr: string;
begin
  // Initialize SUB socket
  if nng_sub0_open(subSocket) <> 0 then
  begin
    Writeln('Failed to open SUB socket');
    Exit;
  end;

  host := 'tcp://127.0.0.1:5555';
  // Connect to the publisher
  if nng_socket_setopt(subSocket, 2, @host, Length(host)) <> 0 then
  begin
    Writeln('Failed to connect to PUB socket');
    nng_close(subSocket);
    Exit;
  end;

  // Subscribe to all messages
  if nng_socket_setopt(subSocket, 3, nil, 0) <> 0 then  // 3 represents the SUB option for subscribe
  begin
    Writeln('Failed to subscribe');
    nng_close(subSocket);
    Exit;
  end;

  // Receive messages from publisher
  while True do
  begin
    if nng_socket_recv(subSocket, receivedMessage, messageLen) = 0 then
    begin
      SetString(receivedStr, PAnsiChar(receivedMessage), messageLen);
      Writeln('Received message: ', receivedStr);
      FreeMem(receivedMessage);
    end
    else
    begin
      Writeln('Failed to receive message');
    end;
    Sleep(1000);  // Polling interval
  end;

  nng_close(subSocket);
end;

end.
