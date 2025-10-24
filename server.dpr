program server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  nng in 'nng.pas';

var
  sock: nng_socket_t;
  msg: nng_msg;
  err: nng_error_t;
  recv_data: array[0..255] of AnsiChar;
  recv_len: Integer;
begin
  try
    // Initialize nng
    err := nng_init;
    if err <> 0 then
      raise Exception.CreateFmt('Failed to initialize nng: %d', [err]);

    // Create a PUB0 socket (Publisher)
    err := nng_pub0_open(sock);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to create PUB0 socket: %d', [err]);

    // Listen on an IPC endpoint
    err := nng_listen(sock, 'ipc:///tmp/nng_test', 0);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to listen: %d', [err]);

    // Wait for a message (blocking call)
    err := nng_recvmsg(sock, msg, 0);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to receive message: %d', [err]);

    // Process the received message
    recv_len := 256; // Expected length
    Move(Pointer(msg)^, recv_data, recv_len);

    Writeln('Received message: ', recv_data);

    // Free the message
    err := nng_msg_free(msg);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to free message: %d', [err]);

    // Close the socket
    err := nng_socket_close(sock);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to close socket: %d', [err]);

    // Finalize nng
    err := nng_fini;
    if err <> 0 then
      raise Exception.CreateFmt('Failed to finalize nng: %d', [err]);

    Writeln('Server completed successfully!');
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
