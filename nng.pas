unit nng;

interface

uses
  Windows, SysUtils;

const
  // Update the path if necessary, or use the LoadLibrary approach
  libnng = 'nng.dll';  // If DLL is in the same directory as the executable

type
  jrb = boolean; // weird delphi 12 bug if you don't have this here you cannot put this function in!
  function nng_version : PAnsiChar; cdecl; external libnng name 'nng_version';

type
  // NNG socket types
  TNNGSocket = Pointer;

  // Declare function prototypes from libnng
//  function nng_version : PAnsiChar; cdecl; external libnng name 'nng_version';
//  function nng_pub0_open(var socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_pub0_open';
//  function nng_sub0_open(var socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_sub0_open';
  function nng_socket_setopt(socket: TNNGSocket; option: Integer; value: Pointer; optlen: Integer): Integer; cdecl; external libnng name 'nng_socket_setopt';
  function nng_socket_send(socket: TNNGSocket; buf: Pointer; len: Integer): Integer; cdecl; external libnng name 'nng_socket_send';
  function nng_socket_recv(socket: TNNGSocket; var buf: Pointer; var len: Integer): Integer; cdecl; external libnng name 'nng_socket_recv';
//  function nng_close(socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_close';

  // nng_error_t (int) -> Integer
type
  nng_error_t = Integer;
  
  // nng_socket (handle to socket) -> THandle
  nng_socket_t = THandle;

  // Callback for asynchronous operations
  nng_cb = procedure(data: Pointer); cdecl;

  // nng_msg (message structure) -> THandle
  nng_msg = THandle;

  // Function declarations from nng API
  function nng_init: nng_error_t; cdecl; external libnng name 'nng_init';
  function nng_fini: nng_error_t; cdecl; external libnng name 'nng_fini';

  // Create a PUB0 socket (Publisher)
  function nng_pub0_open(var sock: nng_socket_t): nng_error_t; cdecl; external libnng name 'nng_pub0_open';
  
  // Create a SUB0 socket (Subscriber)
  function nng_sub0_open(var sock: nng_socket_t): nng_error_t; cdecl; external libnng name 'nng_sub0_open';

  // Connect or bind a socket
  function nng_dial(sock: nng_socket_t; const url: PAnsiChar; flags: Integer): nng_error_t; cdecl; external libnng name 'nng_dial';
  function nng_listen(sock: nng_socket_t; const url: PAnsiChar; flags: Integer): nng_error_t; cdecl; external libnng name 'nng_listen';

  // Send and receive messages
  function nng_sendmsg(sock: nng_socket_t; msg: nng_msg; flags: Integer): nng_error_t; cdecl; external libnng name 'nng_sendmsg';
  function nng_recvmsg(sock: nng_socket_t; msg: nng_msg; flags: Integer): nng_error_t; cdecl; external libnng name 'nng_recvmsg';

  // Message management
  function nng_msg_alloc(var msg: nng_msg; size: Integer): nng_error_t; cdecl; external libnng name 'nng_msg_alloc';
  function nng_msg_free(msg: nng_msg): nng_error_t; cdecl; external libnng name 'nng_msg_free';

  // Close a socket
  function nng_socket_close(sock: nng_socket_t): nng_error_t; cdecl; external libnng name 'nng_socket_close';

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
