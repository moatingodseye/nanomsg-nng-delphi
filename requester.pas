unit requester;

interface

uses
  System.SysUtils, nng;

procedure Test;

implementation

procedure Test;
var
//  buffer : Array[0..1024] of byte;
//  p : Pointer;
  req_sock: nng_socket;
  req: AnsiString;
  req_len: Integer;
  rep: Pointer;
  rep_len: Integer;
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
    err := nng_req0_open(req_sock);
    if err <> NNG_OK then
      WriteLn('Error opening requester: ', nng_strerror(err))
    else begin
      Writeln('REQ open');
      url := PAnsiChar('tcp://127.0.0.1:5555');
      err := nng_dial(req_sock, url, @dial, 0);
      if err <> NNG_OK then 
        WriteLn('Error dialing: ', nng_strerror(err))
      else begin
        Writeln('Dialed...');
        // Send request
        req := 'Requesting Data';
        req_len := Length(req);

//        move(Pointer(req)^,buffer,128);
        
//        err := nng_send(req_sock, @buffer[0], req_len, 0); works
//        err := nng_send(req_sock, @req, req_len, 0); dpesn't work!
        err := nng_send(req_sock, PAnsiChar(req), req_len, 0); // works
        if err <> NNG_OK then                                         
          WriteLn('Error sending request: ', nng_strerror(err))
        else begin
          Writeln('REQ sent');
          // Receive response
          GetMem(rep,128);
          rep_len := 128;
          err := nng_recv(req_sock, rep, @rep_len, 0);
          
          if err <> NNG_OK then
            WriteLn('Error receiving response: ', nng_strerror(err))
          else
            WriteLn('Requester received response: ', PAnsiChar(rep),' size: ',rep_len);
          FreeMem(rep,128);
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

