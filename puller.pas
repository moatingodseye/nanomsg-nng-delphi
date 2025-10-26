unit puller;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
  pull_sock: nng_socket;
  pul: Pointer;
  pul_len: Integer;
  err: Integer;
  init_params: nng_init_params;
  url : PAnsiChar;
  dial : THandle;
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
    err := nng_pull0_open(pull_sock);
    if err <> NNG_OK then
      WriteLn('Error opening requester: ', nng_strerror(err))
    else begin
      Writeln('PULL open');
      url := PAnsiChar('tcp://127.0.0.1:5555');
      err := nng_dial(pull_sock, url, @dial, 0);
      if err <> NNG_OK then 
        WriteLn('Error Dialing: ', nng_strerror(err))
      else begin
        Writeln('Dialed...');

        GetMem(pul, 128);
        ok := true;
        count := 0;
        while (count<100) and ok do begin
          pul_len :=-128;
          err := nng_recv(pull_sock, pul, @pul_len, NNG_FLAG_NONBLOCK); 
          if (err <> NNG_OK) and (err <> NNG_EAGAIN) then begin
            WriteLn('Error pulling: ', nng_strerror(err));
            ok := false;
          end else begin
            if err=NNG_OK then
              Writeln('Pulled: '+PAnsiChar(pul),' size: ', pul_len)
            else
              Writeln('Empty: ', pul_len)
          end;
          Sleep(100);
          Inc(count);
        end;
        FreeMem(pul, 128);

        err := nng_dialer_close(dial);
        if err <> NNG_OK then
          WriteLn('Error closing listener: ', nng_strerror(err));
      end;                                 
    end;
    err := nng_socket_close(pull_sock);
    if err <> NNG_OK then
      WriteLn('Error closing socket: ', nng_strerror(err));
  end;     

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
    WriteLn('Error finalizing nng: ', nng_strerror(err));
end;

end.

