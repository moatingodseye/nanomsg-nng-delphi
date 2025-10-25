unit nngtestsub;

interface

uses
  System.SysUtils, Windows, nng;

procedure Test;

implementation

procedure Test;
var
  sub_sock: nng_socket;
  msg: PAnsiChar;
  msg_len: Integer;
  err: Integer;
  init_params: nng_init_params;
  url : PAnsiChar;
  dial : THandle;
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
  Writeln('Before init');
  err := nng_init(@init_params);
  if err <> NNG_OK then
    WriteLn('Error initializing nng: ', nng_strerror(err));
  Writeln('After init');
                         
  // Initialize subscriber socket
  err := nng_sub0_open(sub_sock);
  if err <> NNG_OK then
    WriteLn('Error opening subscriber: ', nng_strerror(err));

  url := PAnsiChar('tcp://127.0.0.1:5555');
  dial := 0;
  err := nng_dial(sub_sock, url, @dial, 0);
  if err <> NNG_OK then
    WriteLn('Error dialing: ', nng_strerror(err));

  // Receive message
  go := true;
  count := 0;
  while go do begin
    err := nng_recv(sub_sock, msg, msg_len, 0);
    if err <> NNG_OK then begin
      WriteLn('Error receiving message: ', nng_strerror(err));
      go := false;
    end else
      WriteLn('Subscriber received message: ', msg);
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

const
  TEST_DURATION_MS = 5000;  // Run test for 5 seconds
  MAX_MESSAGES = 10;        // Maximum number of messages to receive

procedure Test;
var
  sock: nng_socket_t;
  msg: nng_msg;
  err: nng_error_t;
  recv_data: array[0..255] of AnsiChar;
  provider: nng_provider;
  timeout: Integer;
  start_time: Int64;
  message_count: Integer;
begin
  try
    // Initialize nng (with provider struct)
    err := nng_init(@provider);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to initialize nng: %d', [err]);

    // Create SUB0 socket (Subscriber)
    err := nng_sub0_open(sock);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to create SUB0 socket: %d', [err]);

    // Connect to the publisher (IPC URL)
    err := nng_dial(sock, 'ipc:///tmp/nng_test', 0);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to connect to publisher: %d', [err]);

    Writeln('Subscriber connected to ipc:///tmp/nng_test...');

    // Set socket timeout (milliseconds)
    timeout := 1000; // Set timeout to 1000ms (1 second)
    err := nng_socket_set_ms(sock, 'recv-timeout', timeout);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to set socket timeout: %d', [err]);

    // Subscribe to all messages (empty string filter means all messages)
    err := nng_socket_set_bool(sock, 'subscribe', True);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to set subscribe option: %d', [err]);

    // Get the start time for testing duration
    start_time := GetTickCount;
    message_count := 0;

    // Run the test for a fixed duration or a max number of messages
    while (GetTickCount - start_time < TEST_DURATION_MS) and (message_count < MAX_MESSAGES) do
    begin
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
        Move(Pointer(msg)^, recv_data, 256);
        Writeln('Received message: ', recv_data);

        // Free the message
        err := nng_msg_free(msg);
        if err <> 0 then
          raise Exception.CreateFmt('Failed to free message: %d', [err]);

        // Increment message count
        Inc(message_count);
      end;

      Sleep(500); // Sleep for half a second before trying to receive again
    end;

    // Close the socket
    err := nng_socket_close(sock);
    if err <> 0 then
      raise Exception.CreateFmt('Failed to close socket: %d', [err]);

    Writeln('Subscriber completed successfully. Messages received: ', message_count);
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

    // Set a receive timeout of 1000ms (1 second)
    err := nng_socket_setopt(sock, 'recv-timeout', @recv_len, SizeOf(recv_len));
    if err <> 0 then
      raise Exception.CreateFmt('Failed to set socket option: %d', [err]);

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
