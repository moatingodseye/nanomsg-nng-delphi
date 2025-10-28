unit responder;

interface

uses
  System.SysUtils, nngdll;

procedure Test;

implementation

var 
  data : Integer;
  
procedure callback(pipe : THandle; which : nng_pipe; arg : pointer); cdecl;
var
  r : Integer;
begin
  asm nop end;
  r := Integer(arg^);
  Writeln(pipe,' ',which, ' ', data, ' ', r);
end;

procedure Test;
var
  rep_sock: nng_socket;
  req: Pointer;
  req_len: UInt32;
  rep : AnsiString;
  rep_len : Integer;
  err: Integer;
  init_params: nng_init_param;
  url : PAnsiChar;
  listen : THandle;
  need : boolean;
  S : AnsiString;
begin
  // Initialize the nng_init_params structure
  need := false;
  try
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
      need := true;
      Writeln('Initialised');
      // Initialize responder socket
      err := nng_rep0_open(rep_sock);
      if err <> NNG_OK then
        WriteLn('Error opening responder: ', nng_strerror(err))
      else begin
        Writeln('REP open');
        url := PAnsiChar('tcp://127.0.0.1:5555');
        err := nng_listen(rep_sock, url, @listen, 0);
        if err <> NNG_OK then
          WriteLn('Error listening: ', nng_strerror(err))
        else begin
          Writeln('Listening...');

          err := nng_pipe_notify(rep_sock,pipBefore,@callback,@data);
          if err<>NNG_OK then
            Writeln('Pipe Error:',nng_strerror(err));
          err := nng_pipe_notify(rep_sock,pipAdd,@callback,@data);
          if err<>NNG_OK then
            Writeln('Pipe Error:',nng_strerror(err));
          err := nng_pipe_notify(rep_sock,pipRemove,@callback,@data);
          if err<>NNG_OK then
            Writeln('Pipe Error:',nng_strerror(err));

          data := Random(100);
          Writeln(data);
          
          // Receive request
          GetMem(req,128);
          req_len := 128;
          err := nng_recv(rep_sock,req, @req_len, 0); 
          if err <> NNG_OK then                              
            WriteLn('Error receiving request: ', nng_strerror(err))
          else begin
            S := PAnsiChar(req); 
            WriteLn('Responder received request: ',S,' size: ',req_len);

            // Send response
            rep := 'Response Data';
//            Move(Pointer(rep)^,req^,128);
            rep_len := Length(rep);
//            err := nng_send(rep_sock, req, rep_len, 0);
//            err := nng_send(rep_sock, @rep, rep_len, 0); // doesn't work
            err := nng_send(rep_sock, PAnsiChar(rep), rep_len, 0); // doesn't work
            if err <> NNG_OK then
              WriteLn('Error sending response: ', nng_strerror(err))
            else
              Writeln('REP sent');
          end;
          FreeMem(req,128);

          err := nng_listener_close(listen);
          if err<>NNG_OK then
            Writeln('Listener close failed:',nng_strerror(err));
        end;
        
        err := nng_socket_close(rep_sock);
        if err <> NNG_OK then
          WriteLn('Error closing socket: ', nng_strerror(err));
      end;
    end;

    // Cleanup
    err := nng_fini();
    if err <> NNG_OK then
      WriteLn('Error finalizing nng: ', nng_strerror(err));
  except
    on E : Exception do begin
      if need then begin
        err := nng_fini();
        if err <> NNG_OK then
          WriteLn('Error finalizing nng: ', nng_strerror(err));
      end;
      Writeln(E.Message);
    end;
  end;
end;

end.

