unit nngdll;

interface

uses
  Windows, SysUtils;

const
  // Update the path if necessary, or use the LoadLibrary approach
  libnng = 'nng.dll';  // If DLL is in the same directory as the executable

  // Define error constants for libnng
  NNG_OK = 0;
  NNG_EINTR        = 1;
  NNG_ENOMEM       = 2;
  NNG_EINVAL       = 3;
  NNG_EBUSY        = 4;
  NNG_ETIMEDOUT    = 5;
  NNG_ECONNREFUSED = 6;
  NNG_ECLOSED      = 7;
  NNG_EAGAIN       = 8;
  NNG_ENOTSUP      = 9;
  NNG_EADDRINUSE   = 10;
  NNG_ESTATE       = 11;
  NNG_ENOENT       = 12;
  NNG_EPROTO       = 13;
  NNG_EUNREACHABLE = 14;
  NNG_EADDRINVAL   = 15;
  NNG_EPERM        = 16;
  NNG_EMSGSIZE     = 17;
  NNG_ECONNABORTED = 18;
  NNG_ECONNRESET   = 19;
  NNG_ECANCELED    = 20;
  NNG_ENOFILES     = 21;
  NNG_ENOSPC       = 22;
  NNG_EEXIST       = 23;
  NNG_EREADONLY    = 24;
  NNG_EWRITEONLY   = 25;
  NNG_ECRYPTO      = 26;
  NNG_EPEERAUTH    = 27;
  NNG_ENOARG       = 28;
  NNG_EAMBIGUOUS   = 29;
  NNG_EBADTYPE     = 30;
  NNG_ECONNSHUT    = 31;
  NNG_EINTERNAL    = 1000;
  NNG_ESYSERR      = $10000000;
  NNG_ETRANERR     = $20000000;

  NNG_FLAG_ALLOC = 1;    // Recv to allocate receive buffer
  NNG_FLAG_NONBLOCK = 2; // Non-blocking operations

 // Options.
  NNG_OPT_SOCKNAME = 'socket-name';
  NNG_OPT_RAW = 'raw';
  NNG_OPT_PROTO = 'protocol';
  NNG_OPT_PROTONAME = 'protocol-name';
  NNG_OPT_PEER = 'peer';
  NNG_OPT_PEERNAME = 'peer-name';
  NNG_OPT_RECVBUF = 'recv-buffer';
  NNG_OPT_SENDBUF = 'send-buffer';
  NNG_OPT_RECVFD = 'recv-fd';
  NNG_OPT_SENDFD = 'send-fd';
  NNG_OPT_RECVTIMEO = 'recv-timeout';
  NNG_OPT_SENDTIMEO = 'send-timeout';
  NNG_OPT_LOCADDR = 'local-address';
  NNG_OPT_REMADDR = 'remote-address';
  NNG_OPT_URL = 'url';
  NNG_OPT_MAXTTL = 'ttl-max';
  NNG_OPT_RECVMAXSZ = 'recv-size-max';
  NNG_OPT_RECONNMINT = 'reconnect-time-min';
  NNG_OPT_RECONNMAXT = 'reconnect-time-max';
  
type
  jrb = boolean; // weird delphi 12 bug if you don't have this here you cannot put this function in!
  function nng_version : PAnsiChar; cdecl; external libnng name 'nng_version';

// nng_init_params struct declaration
type
  nng_init_param = record
    num_task_threads: SmallInt;
    max_task_threads: SmallInt;
    num_expire_threads: SmallInt;
    max_expire_threads: SmallInt;
    num_poller_threads: SmallInt;
    max_poller_threads: SmallInt;
    num_resolver_threads: SmallInt;
  end;
  pnng_init_param = ^nng_init_param;

  nng_socket = THandle;
  nng_duration = Int64;
  nng_size = UInt32;
  pnng_size = ^nng_size;
  nng_error = Integer;

// Function prototypes
function nng_init(params: pnng_init_param) : nng_error; cdecl; external libnng name 'nng_init';
function nng_fini() : nng_error; cdecl; external libnng name 'nng_fini';

function nng_pub0_open(out sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_pub0_open';
function nng_sub0_open(out sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_sub0_open';

function nng_req0_open(out sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_req0_open';
function nng_rep0_open(out sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_rep0_open';

function nng_push0_open(out sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_push0_open';
function nng_pull0_open(out sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_pull0_open';

function nng_surveyor0_open(out sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_surveyor0_open';
function nng_respondent0_open(out sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_respondent0_open';

function nng_sub0_socket_subscribe(sock : nng_socket; what : pointer; size : nng_size) : Integer; cdecl; external libnng name 'nng_sub0_socket_subscribe';
function nng_sub0_socket_unsubscribe(sock : nng_socket; what : pointer; size : nng_size) : Integer; cdecl; external libnng name 'nng_sub0_socket_unsubscribe';
//int nng_sub0_socket_subscribe(nng_socket id, const void *buf, size_t sz);
//int nng_sub0_socket_unsubscribe(nng_socket id, const void *buf, size_t sz);

function nng_listen(sock: nng_socket; url: PAnsiChar; listener: PHandle; flags: Integer) : nng_error; cdecl; external libnng name 'nng_listen';
function nng_dial(sock: nng_socket; url: PAnsiChar; dialer: PHandle; flags: Integer) : nng_error; cdecl; external libnng name 'nng_dial';

function nng_listener_close(listen: THandle) : Integer; cdecl; external libnng name 'nng_listener_close';
function nng_dialer_close(listen: THandle) : Integer; cdecl; external libnng name 'nng_dialer_close';

function nng_send(sock: nng_socket; buf: Pointer; len: nng_size; flags: Integer) : nng_error; cdecl; external libnng name 'nng_send';
function nng_recv(sock: nng_socket; buf: Pointer; len: pnng_size; flags: Integer) : nng_error; cdecl; external libnng name 'nng_recv';

function nng_socket_close(sock: nng_socket) : nng_error; cdecl; external libnng name 'nng_socket_close';

function nng_strerror(err: Integer): PAnsiChar; cdecl; external libnng name 'nng_strerror';

//procedure callback; cdecl;

const
  pipBefore = 1;
  pipAdd = 2;
  pipRemove = 3;

type
//  nng_callback = @callback; 
  nng_pipe_ev = Integer;
  nng_pipe = THandle;
  nng_argument = Pointer;
  pnng_argument = ^nng_argument;
  nng_callback = procedure(pipe : nng_pipe; which : nng_pipe_ev; out arg : nng_argument); cdecl;

function nng_pipe_notify(sock : nng_socket; which : nng_pipe_ev; callback : nng_callback; arg : nng_argument) : nng_error; cdecl; external libnng name 'nng_pipe_notify';

type
  // nng_provider (initialize provider struct)
  nng_provider = record
    dummy: Integer; // For simplicity, assuming no specific initialization parameters yet.
  end;
  pnng_provider = ^nng_provider;

  // Send and receive messages
//  function nng_sendmsg(sock: nng_socket; msg: nng_msg; flags: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_sendmsg';
//  function nng_recvmsg(sock: nng_socket; msg: nng_msg; flags: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_recvmsg';

  // Message management
//  function nng_msg_alloc(var msg: nng_msg; size: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_msg_alloc';
//  function nng_msg_free(msg: nng_msg): nng_error_t; cdecl; external LIBNNG name 'nng_msg_free';

  // Socket options
  function nng_socket_set_bool(sock: nng_socket; const option: PAnsiChar; value: Boolean): nng_error; cdecl; external LIBNNG name 'nng_socket_set_bool';
  function nng_socket_set_int(sock: nng_socket; const option: PAnsiChar; value: Integer): nng_error; cdecl; external LIBNNG name 'nng_socket_set_int';
  function nng_socket_set_ms(sock: nng_socket; const option: PAnsiChar; value: Integer): nng_error; cdecl; external LIBNNG name 'nng_socket_set_ms';
  function nng_socket_set_size(sock: nng_socket; const option: PAnsiChar; value: Integer): nng_error; cdecl; external LIBNNG name 'nng_socket_set_size';
  
  // Declare a function to load the DLL and check if it's successful
  function LoadNNGLibrary: Boolean;

implementation

var
  NNGLibHandle: THandle = 0;

function LoadNNGLibrary: Boolean;
begin
  // Explicitly load the DLL using LoadLibrary to handle errors
  NNGLibHandle := LoadLibrary(libnng);
  Result := NNGLibHandle <> 0;
  if not Result then
  begin
    RaiseLastOSError;  // This will raise an error with details about why the DLL failed to load
  end;
end;

initialization
  // Try to load the library when the unit is initialized
  if not LoadNNGLibrary then
  begin
    // If it fails, raise an exception or handle it gracefully
    raise Exception.Create('Failed to load nng.dll');
  end;

finalization
  // Clean up by freeing the DLL handle when done
  if NNGLibHandle <> 0 then
    FreeLibrary(NNGLibHandle);

end.
