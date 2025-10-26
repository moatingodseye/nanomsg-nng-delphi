unit surveyor;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
  survey_sock: nng_socket;
  sur: AnsiString;
  sur_len: Integer;
  res : Pointer;
  res_len : Integer;
  err: Integer;
  init_params: nng_init_params;
  url: PAnsiChar;
  listen: THandle;
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
    err := nng_surveyor0_open(survey_sock);
    if err <> NNG_OK then
      WriteLn('Error opening publisher: ', nng_strerror(err))
    else begin
      Writeln('SURVERYOR open');
      // Set the URL for binding
      url := PAnsiChar('tcp://127.0.0.1:5555');

      // Listen on the URL
      listen := 0;
      err := nng_listen(survey_sock, url, @listen, 0);
      if err <> NNG_OK then
        WriteLn('Error listening: ', nng_strerror(err))
      else begin
        Writeln('Listening...');
        Sleep(5000); // give things chance to connect as need people in order to see results

        // Send message
        sur := 'Vote now';
        sur_len := Length(sur);
        err := nng_send(survey_sock, PAnsiChar(sur), sur_len, 0);
        if err <> NNG_OK then begin
          WriteLn('Error sending message: ', nng_strerror(err));
        end else begin
          WriteLn('Survey sent message: ', sur, ' size: ', sur_len);
          GetMem(res, 128);
          count := 0;
          while (count<100) do begin
            // wait for votes
            res_len := 128;
            err := nng_recv(survey_sock, res, @res_len, NNG_FLAG_NONBLOCK);
            if (err<>NNG_OK) and (err<>NNG_EAGAIN) then
              Writeln('Error reading: ', nng_strerror(err))
            else begin
              if err=NNG_OK then
                writeln('Response: ',PAnsiChar(res), ' size: ', res_len)
              else
                writeln('Error : ', nng_strerror(err), ' size: ', sur_len);
            end;
            
            Sleep(100);
            inc(count);
          end;
        end;

        err := nng_listener_close(listen);
        if err<>NNG_OK then
          Writeln('Listener close failed: ',nng_strerror(err));
      end;
      err := nng_socket_close(survey_sock);
      if err <> NNG_OK then
        WriteLn('Error closing socket: ', nng_strerror(err));
    end;
  end;

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
    WriteLn('Error finalizing nng: ', nng_strerror(err));
end;

end.

