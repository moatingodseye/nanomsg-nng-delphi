program Client;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, nng;

var
  sock: nng_socket_t;
  msg: nng_msg;
  err: nng_error_t;
  send_data: PAnsiChar;
begin
  try
    // Initialize nng
    err := nng_init;
    if err <> 0 then
      raise Exception.CreateFmt('Failed to initialize nng: %d', [err]);

    // Create a SUB0 socket (Subscriber)
    err := nng_sub0_open(sock);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to create SUB0 socket: %d', [err]);

    // Dial to the server (client-side connection)
    err := nng_dial(sock, 'ipc:///tmp/nng_test', 0);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to dial: %d', [err]);

    // Allocate a message
    err := nng_msg_alloc(msg, 256);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to allocate message: %d', [err]);

    // Prepare the message
    send_data := 'Hello from Delphi Client!';
    Move(send_data^, Pointer(msg)^, Length(send_data));

    // Send the message
    err := nng_sendmsg(sock, msg, 0);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to send message: %d', [err]);

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

    Writeln('Client completed successfully!');
  except
    on E: Exception do
    begin
      Writeln('Error: ' + E.Message);
    end;
  end;
end.

