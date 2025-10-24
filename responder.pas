unit responder;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
  rep_sock: nng_socket;
  msg: PAnsiChar;
  msg_len: Integer;
  err: Integer;
  init_params: nng_init_params;
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
  begin
    WriteLn('Error initializing nng: ', nng_strerror(err));
    Exit;
  end;

  // Initialize responder socket
  err := nng_rep0_open(rep_sock);
  if err <> NNG_OK then
  begin
    WriteLn('Error opening responder: ', nng_strerror(err));
    Exit;
  end;

  err := nng_listen(rep_sock, 'tcp://127.0.0.1:5555', nil, 0);
  if err <> NNG_OK then
  begin
    WriteLn('Error listening: ', nng_strerror(err));
    Exit;
  end;

  // Receive request
  err := nng_recv(rep_sock, msg, msg_len, 0);
  if err <> NNG_OK then
  begin
    WriteLn('Error receiving request: ', nng_strerror(err));
    Exit;
  end;

  WriteLn('Responder received request: ', msg);

  // Send response
  msg := PAnsiChar('Response Data');
  msg_len := Length(msg);
  err := nng_send(rep_sock, msg, msg_len, 0);
  if err <> NNG_OK then
  begin
    WriteLn('Error sending response: ', nng_strerror(err));
    Exit;
  end;

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
  begin
    WriteLn('Error finalizing nng: ', nng_strerror(err));
  end;
end;

end.

