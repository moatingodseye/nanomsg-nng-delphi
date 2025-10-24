unit nng;

interface

uses
  Windows, SysUtils;

const
  // The location of the compiled nng.dll
  libnng = 'libnng.dll';  // Change this if necessary

type
  // NNG socket types
  TNNGSocket = Pointer;
  
  // Declare function prototypes from libnng
  function nng_pub0_open(var socket: TNNGSocket): Integer; cdecl; external libnng;
  function nng_sub0_open(var socket: TNNGSocket): Integer; cdecl; external libnng;
  function nng_socket_setopt(socket: TNNGSocket; option: Integer; value: Pointer; optlen: Integer): Integer; cdecl; external libnng;
  function nng_socket_send(socket: TNNGSocket; buf: Pointer; len: Integer): Integer; cdecl; external libnng;
  function nng_socket_recv(socket: TNNGSocket; var buf: Pointer; var len: Integer): Integer; cdecl; external libnng;
  function nng_close(socket: TNNGSocket): Integer; cdecl; external libnng;

implementation

end.
