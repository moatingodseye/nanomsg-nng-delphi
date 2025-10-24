unit testlibnng;

interface

uses
  Windows, SysUtils;

const
  // Update the path if necessary, or use the LoadLibrary approach
  libnng = 'nng.dll';  // If DLL is in the same directory as the executable

type
  // NNG socket types
  TNNGSocket = Pointer;

  // Declare function prototypes from libnng
//  function nng_pub0_open(var socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_pub0_open';
//  function nng_sub0_open(var socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_sub0_open';
//  function nng_socket_setopt(socket: TNNGSocket; option: Integer; value: Pointer; optlen: Integer): Integer; cdecl; external libnng name 'nng_socket_setopt';
//  function nng_socket_send(socket: TNNGSocket; buf: Pointer; len: Integer): Integer; cdecl; external libnng name 'nng_socket_send';
//  function nng_socket_recv(socket: TNNGSocket; var buf: Pointer; var len: Integer): Integer; cdecl; external libnng name 'nng_socket_recv';
//  function nng_close(socket: TNNGSocket): Integer; cdecl; external libnng name 'nng_close';

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
