{$M+}
unit Packet;

interface

type
  TPacket = class(TObject)
  private
    FBuffer : Pointer;
    FUsed,
    FSpace : Integer;
  protected
  public
    constructor Create(ASpace : Integer);
    destructor Destroy; override;

    procedure Assign(AFrom : TPacket);
    procedure Push(AString : AnsiString);
    function Pull : AnsiString;
    function Dump : String;
    procedure Clear;
    
    property Space : Integer read FSpace;
    property Used : Integer read FUsed write FUsed;
    property Buffer : Pointer read FBuffer;
  published
  end;

implementation

uses
  System.SysUtils, System.Classes;

constructor TPacket.Create(ASpace : Integer);
begin
  inherited Create;
  FSpace := ASpace;
  GetMem(FBuffer,FSpace);
end;

destructor TPacket.Destroy;
begin
  FreeMem(FBuffer,FSpace);
  inherited;
end;

procedure TPacket.Assign(AFrom : TPacket);
begin
  FUsed := AFrom.Used;
  Move(AFrom.Buffer^,FBuffer^,FUsed);
end;

procedure TPacket.Push(AString : AnsiString);
var
  T : AnsiString;
  lP : PAnsiChar;
begin
  FUsed := Length(AString);
  lP := PAnsiChar(AString);
  Move(lP^,FBuffer^,FUsed);
//  Move(lP,FBuffer^,FUsed);
//  Move(AString,FBuffer^,FUsed);
//  Move(AString,FBuffer,FUsed);
//  Move(PAnsiChar(AString)^,FBuffer^,FUsed);
//  T := PAnsiChar(FBuffer);
  SetString(T,PAnsiChar(FBuffer),FUsed);
//  T := AnsiString(FBuffer);
end;

function TPacket.Pull : AnsiString;
var
  T : AnsiString;
begin
//  T := AnsiString(FBuffer);
//  SetLength(T,FUsed);
//  Move(FBuffer^,T,FUsed);
//
//  P := 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
//  Move(FBuffer^,P^,FUsed);
  SetString(T,PAnsiChar(FBuffer),FUsed);
//  result := AnsiString(FBuffer);
  result := T;
end;

//  Move(@rep[0],FOut.Buffer,Length(rep));
//  FOut.Used := Length(rep);

function TPacket.Dump : String;
var
  S : String;
  P : PByte;
  C : Integer;
begin
  P := FBuffer;
  for C := 0 to FUsed do begin
    S := S + IntToHex(P^);
    Inc(P);
  end;
  result := S;
end;

procedure TPacket.Clear;
begin
  FUsed := 0;
end;

end.
