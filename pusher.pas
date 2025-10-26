unit pusher;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
  push_sock: nng_socket;
  pus: AnsiString;
  pus_len: Integer;
  err: Integer;
  init_params: nng_init_params;
  url : PAnsiChar;
  listen : THandle;
  ok : Boolean;
  count : Integer;
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
    WriteLn('Error initializing nng: ', nng_strerror(err))
  else begin
    Writeln('Initialised');
    // Initialize requester socket
    err := nng_push0_open(push_sock);
    if err <> NNG_OK then
      WriteLn('Error opening requester: ', nng_strerror(err))
    else begin
      Writeln('PUSH open');
      url := PAnsiChar('tcp://127.0.0.1:5555');
      err := nng_listen(push_sock, url, @listen, 0);
      if err <> NNG_OK then 
        WriteLn('Error listening: ', nng_strerror(err))
      else begin
        Writeln('Listening...');

        ok := true;
        count := 0;
        while (count<100) and ok do begin
          pus := 'Pushing '+IntToStr(count);
          pus_len := Length(pus);
          err := nng_send(push_sock, PAnsiChar(pus), pus_len, 0);
          if err <> NNG_OK then begin
            WriteLn('Error pushing: ', nng_strerror(err));
            ok := false;
          end else begin
            Writeln('Pushed: ',PAnsiChar(pus),' size: ',pus_len);
          end;
          Sleep(100);
          Inc(count);    
        end;

        err := nng_listener_close(listen);
        if err <> NNG_OK then
          WriteLn('Error closing listener: ', nng_strerror(err));
      end;                                 
    end;
    err := nng_socket_close(push_sock);
    if err <> NNG_OK then
      WriteLn('Error closing socket: ', nng_strerror(err));
  end;     

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
    WriteLn('Error finalizing nng: ', nng_strerror(err));
end;

end.

