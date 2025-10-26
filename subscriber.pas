unit subscriber;

interface

uses
  System.SysUtils, Windows, nng;

procedure Test;

implementation

procedure Test;
var
  sub_sock: nng_socket;
  what : AnsiString;
  what_len : Integer;
  buffer : Pointer;
  sub: AnsiString;
  sub_len: Integer;
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
  err := nng_init(@init_params);
  if err <> NNG_OK then
    WriteLn('Error initializing nng: ', nng_strerror(err))
  else begin
    Writeln('Initialised');

    // Initialize subscriber socket
    err := nng_sub0_open(sub_sock);
    if err <> NNG_OK then
      WriteLn('Error opening subscriber: ', nng_strerror(err))
    else begin
      Writeln('SUB open');

      // subsribe to the messages
      what := '';
      what_len := Length(what);
      err := nng_sub0_socket_subscribe(sub_sock, PAnsiChar(what), what_len);
      if err <> NNG_OK  then
        Writeln('Failed to subscribe: ', nng_strerror(err))
      else begin
        url := PAnsiChar('tcp://127.0.0.1:5555');
        dial := 0;
        err := nng_dial(sub_sock, url, @dial, 0);
        if err <> NNG_OK then
          WriteLn('Error dialing: ', nng_strerror(err))
        else begin
          Writeln('Dialed');
          GetMem(buffer, 128);
          sub_len := 128;
          
          // Receive message
          go := true;
          count := 0;
          while go do begin
            sub_len := 128;
            err := nng_recv(sub_sock, buffer, @sub_len, 0);
            if err <> NNG_OK then begin
              WriteLn('Error receiving message: ', nng_strerror(err));
              go := false;
            end else begin
              sub := PAnsiChar(buffer);
              WriteLn('Subscriber received message: ', sub, ' size: ', sub_len);
            end;
            Sleep(100);
            inc(count);
            if count>100 then
              go := false;
          end;
          FreeMem(buffer, 128);
        end;
      end;
      err := nng_sub0_socket_unsubscribe(sub_sock, PAnsiChar(what), what_len);
      if err <> NNG_OK then
        Writeln('Failed to unsubscribe: ', nng_strerror(err))
    end;
  end;

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
    WriteLn('Error finalizing nng: ', nng_strerror(err));
end;

end.

