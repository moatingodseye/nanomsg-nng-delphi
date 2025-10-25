unit nngtestpub;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
  pub_sock: nng_socket;
  msg: PAnsiChar;
  msg_len: Integer;
  err: Integer;
  init_params: nng_init_params;
  url: PAnsiChar;
  listen: THandle;
  go : boolean;
  count : integer;
begin
  // Initialize the nng_init_params structure
  init_params.num_task_threads := 2;
  init_params.max_task_threads := 4;
  init_params.num_expire_threads := 1;
  init_params.max_expire_threads := 2;
  init_params.num_poller_threads := 1;
  init_params.max_poller_threads := 2;
  init_params.num_resolver_threads := 1;

  // Initialize the nng library
  err := nng_init(@init_params);
  if err <> NNG_OK then
    WriteLn('Error initializing nng: ', nng_strerror(err));

  // Initialize publisher socket
  err := nng_pub0_open(pub_sock);
  if err <> NNG_OK then
    WriteLn('Error opening publisher: ', nng_strerror(err));

  // Set the URL for binding
  url := PAnsiChar('tcp://127.0.0.1:5555');

  // Listen on the URL
  listen := 0;
  err := nng_listen(pub_sock, url, @listen, 0);
  if err <> NNG_OK then
    WriteLn('Error listening: ', nng_strerror(err));

  // Send message
  msg := PAnsiChar('Hello, Subscriber!');
  msg_len := Length(msg);
  go := true;
  while go do begin
    err := nng_send(pub_sock, msg, msg_len, 0);
    if err <> NNG_OK then begin
      WriteLn('Error sending message: ', nng_strerror(err));
      go := false;
    end else
      WriteLn('Publisher sent message: ', msg);
    Sleep(100);
    inc(count);
    if count>100 then
      go := false;
  end;

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
    WriteLn('Error finalizing nng: ', nng_strerror(err));
end;

end.

procedure Test;
var
  pub_sock: nng_socket;
  msg: PAnsiChar;
  msg_len: Integer;
  err: Integer;
  init_params: nng_init_params;
  url : AnsiString;
  listen : Pointer;
begin
  // Initialize the nng_init_params structure
  init_params.num_task_threads := 2;
  init_params.max_task_threads := 4;
  init_params.num_expire_threads := 1;
  init_params.max_expire_threads := 2;
  init_params.num_poller_threads := 1;
  init_params.max_poller_threads := 2;
  init_params.num_resolver_threads := 1;

  // Initialize the nng library
  Writeln('Before init');
  err := nng_init(@init_params);
  if err <> NNG_OK then
  begin
    WriteLn('Error initializing nng: ', nng_strerror(err));
    Exit;
  end;
  Writeln('After init');
                         
  // Initialize publisher socket
  err := nng_pub0_open(pub_sock);
  if err <> NNG_OK then
  begin
    WriteLn('Error opening publisher: ', nng_strerror(err));
    Exit;
  end;

  url := 'tcp://127.0.0.1:5555';
  listen := nil;
  err := nng_listen(pub_sock, @url, listen, 0);
  if err <> NNG_OK then
  begin
    WriteLn('Error listening: ', nng_strerror(err));
    Exit;
  end;

  // Send message
  msg := PAnsiChar('Hello, Subscriber!');
  msg_len := Length(msg);
  err := nng_send(pub_sock, msg, msg_len, 0);
  if err <> NNG_OK then
  begin
    WriteLn('Error sending message: ', nng_strerror(err));
    Exit;
  end;

  WriteLn('Publisher sent message: ', msg);

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
  begin
    WriteLn('Error finalizing nng: ', nng_strerror(err));
  end;
end;

end.


const
  MAX_MESSAGES = 1000;  // Send a maximum of 1000 messages

procedure Test;
var
  sock: nng_socket_t;
  msg: nng_msg;
  err: nng_error_t;
  provider: nng_provider;
  message_count: Integer;
begin
  try
    // Initialize nng (with provider struct)
    err := nng_init(@provider);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to initialize nng: %d', [err]);

    // Create PUB0 socket (Publisher)
    err := nng_pub0_open(sock);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to create PUB0 socket: %d', [err]);

    // Listen on an IPC endpoint
    err := nng_listen(sock, 'ipc:///tmp/nng_test', 0);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to listen: %d', [err]);

    Writeln('Publisher is broadcasting on ipc:///tmp/nng_test...');

    // Send a limited number of messages (e.g., 1000 messages)
    message_count := 0;
    while message_count < MAX_MESSAGES do
    begin
      err := nng_msg_alloc(msg, 256);
      if err <> 0 then
        raise Exception.CreateFmt('Failed to allocate message: %d', [err]);

      // Fill message with test data
      FillChar(Pointer(msg)^, 256, 0);
      StrPCopy(PAnsiChar(Pointer(msg)^), 'Hello from Publisher!');

      // Send the message
      err := nng_sendmsg(sock, msg, 0);
      if err <> 0 then
        raise Exception.CreateFmt('Failed to send message: %d', [err]);

      Writeln('Publisher sent message #', message_count + 1);

      // Increment the message counter
      Inc(message_count);

      // Wait before sending the next message
      Sleep(1000); // Delay 1 second between messages
    end;

    // Close the socket
    err := nng_socket_close(sock);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to close socket: %d', [err]);

    Writeln('Publisher sent ', message_count, ' messages and completed successfully!');
  except
    on E: Exception do
    begin
      Writeln('Error: ' + E.Message);
    end;
  end;
end;

end.

procedure Test;
var
  sock: nng_socket_t;
  msg: nng_msg;
  err: nng_error_t;
  recv_data: array[0..255] of AnsiChar;
  recv_len: Integer;
  provider: nng_provider;
  timeout : Integer;
begin
  try
    // Initialize nng (now with provider struct)
    err := nng_init(@provider);
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

    Writeln('Server is listening on ipc:///tmp/nng_test...');

    // Set socket timeout (milliseconds) for receiving messages
    timeout := 1000; // Set timeout to 1000ms (1 second)
    err := nng_socket_set_ms(sock, 'recv-timeout', timeout);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to set socket timeout: %d', [err]);

    // Wait for a message (this should be non-blocking or have a timeout)
    err := nng_recvmsg(sock, msg, 0);
    if err <> 0 then
    begin
      if err = NNG_EAGAIN then
        Writeln('Timeout reached, no message received.')
      else
        raise Exception.CreateFmt('Failed to receive message: %d', [err]);
    end
    else
    begin
      // Process the received message
      recv_len := 256; // Expected length
      Move(Pointer(msg)^, recv_data, recv_len);

      Writeln('Received message: ', recv_data);

      // Free the message
      err := nng_msg_free(msg);
      if err <> 0 then
        raise Exception.CreateFmt('Failed to free message: %d', [err]);
    end;

    // Close the socket
    err := nng_socket_close(sock);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to close socket: %d', [err]);

    Writeln('Server completed successfully!');
  except
    on E: Exception do
    begin
      Writeln('Error: ' + E.Message);
    end;
  end;
end;

end.

