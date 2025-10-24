unit nng;

interface

uses
  Windows, SysUtils;

const
  // Update the path if necessary, or use the LoadLibrary approach
  libnng = 'nng.dll';  // If DLL is in the same directory as the executable

  // Define error constants for libnng
  NNG_OK = 0;
  NNG_EAGAIN = -100;  // Error code for non-blocking operation
  
type
  jrb = boolean; // weird delphi 12 bug if you don't have this here you cannot put this function in!
  function nng_version : PAnsiChar; cdecl; external libnng name 'nng_version';

// nng_init_params struct declaration
type
  nng_init_params = record
    num_task_threads: SmallInt;
    max_task_threads: SmallInt;
    num_expire_threads: SmallInt;
    max_expire_threads: SmallInt;
    num_poller_threads: SmallInt;
    max_poller_threads: SmallInt;
    num_resolver_threads: SmallInt;
  end;

  nng_socket = THandle;
  nng_duration = Int64;

// Function prototypes
function nng_init(params: Pointer): Integer; cdecl; external libnng name 'nng_init';
function nng_fini(): Integer; cdecl; external libnng name 'nng_fini';

function nng_pub0_open(out sock: nng_socket): Integer; cdecl; external libnng name 'nng_pub0_open';
function nng_sub0_open(out sock: nng_socket): Integer; cdecl; external libnng name 'nng_sub0_open';
function nng_req0_open(out sock: nng_socket): Integer; cdecl; external libnng name 'nng_req0_open';
function nng_rep0_open(out sock: nng_socket): Integer; cdecl; external libnng name 'nng_rep0_open';

function nng_listen(sock: nng_socket; url: PAnsiChar; var listener: Pointer; flags: Integer): Integer; cdecl; external libnng name 'nng_listen';
function nng_dial(sock: nng_socket; url: PAnsiChar; var dialer: Pointer; flags: Integer): Integer; cdecl; external libnng name 'nng_dial';

function nng_send(sock: nng_socket; buf: Pointer; len: UInt32; flags: Integer): Integer; cdecl; external libnng name 'nng_send';
function nng_recv(sock: nng_socket; buf: Pointer; len: UInt32; flags: Integer): Integer; cdecl; external libnng name 'nng_recv';

function nng_strerror(err: Integer): PAnsiChar; cdecl; external libnng name 'nng_strerror';

//type
  // NNG socket types
//  TNNGSocket = Pointer;

  // Declare function prototypes from libnng
//  function nng_version : PAnsiChar; cdecl; external libnng name 'nng_version';
//  function nng_pub0_open(var socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_pub0_open';
//  function nng_sub0_open(var socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_sub0_open';
//  function nng_socket_setopt(socket: TNNGSocket; option: Integer; value: Pointer; optlen: Integer): Integer; cdecl; external libnng name 'nng_socket_setopt';
//  function nng_socket_send(socket: TNNGSocket; buf: Pointer; len: Integer): Integer; cdecl; external libnng name 'nng_socket_send';
//  function nng_socket_recv(socket: TNNGSocket; var buf: Pointer; var len: Integer): Integer; cdecl; external libnng name 'nng_socket_recv';
//  function nng_close(socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_close';

  // nng_error_t (int) -> Integer
type
  // nng_error_t (int) -> Integer
  nng_error_t = Integer;

  // nng_socket_t (handle to socket) -> THandle
  nng_socket_t = THandle;

  // nng_msg (message structure) -> THandle
  nng_msg = THandle;

  // nng_provider (initialize provider struct)
  nng_provider = record
    dummy: Integer; // For simplicity, assuming no specific initialization parameters yet.
  end;
  pnng_provider = ^nng_provider;

  // Function declarations from libnng API
//  function nng_init(provider: pnng_provider): nng_error_t; cdecl; external LIBNNG name 'nng_init';
//  function nng_fini: nng_error_t; cdecl; external LIBNNG name 'nng_fini';

  // Create a PUB0 socket (Publisher)
//  function nng_pub0_open(var sock: nng_socket_t): nng_error_t; cdecl; external LIBNNG name 'nng_pub0_open';
  
  // Create a SUB0 socket (Subscriber)
//  function nng_sub0_open(var sock: nng_socket_t): nng_error_t; cdecl; external LIBNNG name 'nng_sub0_open';

  // Connect or bind a socket
//  function nng_dial(sock: nng_socket_t; const url: PAnsiChar; flags: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_dial';
//  function nng_listen(sock: nng_socket_t; const url: PAnsiChar; flags: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_listen';

  // Send and receive messages
  function nng_sendmsg(sock: nng_socket_t; msg: nng_msg; flags: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_sendmsg';
  function nng_recvmsg(sock: nng_socket_t; msg: nng_msg; flags: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_recvmsg';

  // Message management
  function nng_msg_alloc(var msg: nng_msg; size: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_msg_alloc';
  function nng_msg_free(msg: nng_msg): nng_error_t; cdecl; external LIBNNG name 'nng_msg_free';

  // Socket options
//  function nng_socket_setopt(sock: nng_socket_t; const option: PAnsiChar; const value: Pointer; len: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_socket_setopt';
// Socket options for libnng 2.0.0-dev
  function nng_socket_set_bool(sock: nng_socket_t; const option: PAnsiChar; value: Boolean): nng_error_t; cdecl; external LIBNNG name 'nng_socket_set_bool';
  function nng_socket_set_int(sock: nng_socket_t; const option: PAnsiChar; value: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_socket_set_int';
  function nng_socket_set_ms(sock: nng_socket_t; const option: PAnsiChar; value: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_socket_set_ms';
  function nng_socket_set_size(sock: nng_socket_t; const option: PAnsiChar; value: Integer): nng_error_t; cdecl; external LIBNNG name 'nng_socket_set_size';
  
  // Close a socket
  function nng_socket_close(sock: nng_socket_t): nng_error_t; cdecl; external LIBNNG name 'nng_socket_close';

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
