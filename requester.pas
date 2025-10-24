unit requester;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
  req_sock: nng_socket;
  msg: PAnsiChar;
  msg_len: Integer;
  response: PAnsiChar;
  resp_len: Integer;
  err: Integer;
  init_params: nng_init_params;
  url ; AnsiString;
  dial : Pointer;
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

  // Initialize requester socket
  err := nng_req0_open(req_sock);
  if err <> NNG_OK then
  begin
    WriteLn('Error opening requester: ', nng_strerror(err));
    Exit;
  end;

  url := 'tcp://127.0.0.1:5555';
  err := nng_dial(req_sock, @url, dial, 0);
  if err <> NNG_OK then
  begin
    WriteLn('Error dialing: ', nng_strerror(err));
    Exit;
  end;

  // Send request
  msg := PAnsiChar('Requesting Data');
  msg_len := Length(msg);
  err := nng_send(req_sock, msg, msg_len, 0);
  if err <> NNG_OK then
  begin
    WriteLn('Error sending request: ', nng_strerror(err));
    Exit;
  end;

  // Receive response
  err := nng_recv(req_sock, response, resp_len, 0);
  if err <> NNG_OK then
  begin
    WriteLn('Error receiving response: ', nng_strerror(err));
    Exit;
  end;

  WriteLn('Requester received response: ', response);

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
  begin
    WriteLn('Error finalizing nng: ', nng_strerror(err));
  end;
end;

end.

