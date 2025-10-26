unit respondenter;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
  respondent_sock: nng_socket;
  sur: Pointer;
  sur_len: Integer;
  res : AnsiString;
  res_len : Integer;
  err: Integer;
  init_params: nng_init_params;
  url : PAnsiChar;
  dial : THandle;
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
    err := nng_respondent0_open(respondent_sock);
    if err <> NNG_OK then
      WriteLn('Error opening requester: ', nng_strerror(err))
    else begin
      Writeln('RESPONDENT open');
      url := PAnsiChar('tcp://127.0.0.1:5555');
      err := nng_dial(respondent_sock, url, @dial, 0);
      if err <> NNG_OK then 
        WriteLn('Error Dialing: ', nng_strerror(err))
      else begin
        Writeln('Dialed...');

        GetMem(sur, 128);
        sur_len :=-128;
        err := nng_recv(respondent_sock, sur, @sur_len, 0); //NNG_FLAG_NONBLOCK); 
        if (err <> NNG_OK) and (err <> NNG_EAGAIN) then begin
          WriteLn('Error pulling: ', nng_strerror(err));
        end else begin
          if err=NNG_OK then
            Writeln('Survey : '+PAnsiChar(sur),' size: ', sur_len)
          else
            Writeln('Empty: ', sur_len);

          res := 'I say yes';
          res_len := Length(res);
          err := nng_send(respondent_sock,PAnsiChar(res),res_len,0);
          if err<>NNG_OK then
            Writeln('Send failed: ',nng_strerror(err));
        end;
        FreeMem(sur, 128);

        Sleep(500);
        err := nng_dialer_close(dial);
        if err <> NNG_OK then
          WriteLn('Error closing listener: ', nng_strerror(err));
      end;                                 
    end;
    err := nng_socket_close(respondent_sock);
    if err <> NNG_OK then
      WriteLn('Error closing socket: ', nng_strerror(err));
  end;     

  // Cleanup
  err := nng_fini();
  if err <> NNG_OK then
    WriteLn('Error finalizing nng: ', nng_strerror(err));
end;

end.

