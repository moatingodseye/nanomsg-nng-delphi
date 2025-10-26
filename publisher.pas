unit publisher;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
  pub_sock: nng_socket;
  pub: AnsiString;
  pub_len: Integer;
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
    WriteLn('Error initializing nng: ', nng_strerror(err))
  else begin
    Writeln('Initialised');
    // Initialize publisher socket
    err := nng_pub0_open(pub_sock);
    if err <> NNG_OK then
      WriteLn('Error opening publisher: ', nng_strerror(err))
    else begin
      Writeln('PUB open');
      // Set the URL for binding
      url := PAnsiChar('tcp://127.0.0.1:5555');

      // Listen on the URL
      listen := 0;
      err := nng_listen(pub_sock, url, @listen, 0);
      if err <> NNG_OK then
        WriteLn('Error listening: ', nng_strerror(err))
      else begin
        Writeln('Listening...');

        // Send message
        pub := 'Hello, Subscriber!';
        pub_len := Length(pub);
        go := true;
        while go do begin
          err := nng_send(pub_sock, PAnsiChar(pub), pub_len, 0);
          if err <> NNG_OK then begin
            WriteLn('Error sending message: ', nng_strerror(err));
            go := false;
          end else
            WriteLn('Publisher sent message: ', pub, ' size: ', pub_len);
          Sleep(Random(100)+50);
          inc(count);
          if count>100 then
            go := false;
        end;
      end;
    end;
  end;

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
    WriteLn('Error finalizing nng: ', nng_strerror(err));
end;

end.

