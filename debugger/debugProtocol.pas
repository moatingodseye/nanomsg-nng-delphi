unit debugProtocol;

interface

uses
  System.Classes, System.Contnrs, System.SyncObjs,
  baThread,
  nngType,
  Pull, Push, Packet;
  
type
  TCommand = class(TObject)
  private
    FMemory : TMemoryStream;
    FID : Integer;
    FCommand : Integer;
  protected
    procedure Put(AValue : String);
    function  Get : String;
    procedure ToStream; virtual;
    procedure StreamTo; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Load(AFrom : TPacket);
    procedure Save(AInto : TPacket);
  published
  end;
  TPullEvent = procedure(ACommand : TCommand) of object;

  TPrepare = class(TCommand)
  private
    FUsername,
    FPassword,
    FHost : String;
  protected
    procedure ToStream; override;
    procedure StreamTo; override;
  public
    constructor Create(AUsername,APassword,AHost : String); reintroduce;
    destructor Destroy; override;
  published                       
  end;
  
  TServer = class(TObject)
  private
    type
      TIncoming = class(TPull)
      private
        FServer : TServer;
      protected
        procedure Pull(AData : TObject; AIn : TPacket); override;
      public
        constructor Create(AServer : TServer); reintroduce;
      published
      end;

    type
      TTodo = class(TObject)
      private
        FServer : TServer;
        FThread : TbaThread;
        FQueue : TObjectQueue;
        FLock : TCriticalSection;
//        FOnPull : TPullEvent;
      protected
        procedure DoPull(ASender : TObject; AData : TObject);
      public
        constructor Create(AServer : TServer);
        destructor Destroy; override;

        procedure Pull(ACommand : TCommand);

//        property OnPull : TPullEvent read FOnPull write FOnPull;
      published
      end;
      
    var
      FID : Integer;
      FPull : TIncoming;
      FPush : TPush;
      FOnPull : TPullEvent;
      FOnLog : TOnLog;
  protected
    FTodo : TTodo;
    function GetState : EnngState;
    procedure DoOnPull(ACommand : TCommand);
  public
    constructor Create(AHost : String; APull,APush : Integer);
    destructor  Destroy; override;

    procedure Connect;
    procedure Push(ACommand : TCommand); overload;
    procedure Disconnect;

    property State :EnngState read GetState;
    property OnPull : TPullEvent read FOnPull write FOnPull;
    property OnLog : TOnLog read FOnLog write FOnLog;
  published
  end;
  
implementation

uses 
  nngConstant;
  
procedure TCommand.Put(AValue : String);
var
  lSize : Integer;
begin
  lSize := Length(AValue) * SizeOf(Char); // aaargh UTF
  FMemory.Write(lSize, SizeOf(lSize));
  FMemory.WriteBuffer(Pointer(AValue)^, lSize);
end;

function TCommand.Get;
var
  lSize : Integer;
  lString : String;
begin
  FMemory.Read(lSize, SizeOf(lSize));
  SetLength(lString, lSize);
  FMemory.ReadBuffer(Pointer(lString)^, lSize);
  result := lString;
end;

procedure TCommand.ToStream;
begin
  FMemory.Write(FID, SizeOf(FID));
  FMemory.Write(FCommand,SizeOf(FCommand));
end;

procedure TCommand.StreamTo;
begin
  FMemory.Read(FID, SizeOf(FID));
  FMemory.Read(FCommand, SizeOf(FCommand));
end;

constructor TCommand.Create;
begin
  inherited;
  FMemory := TMemoryStream.Create;
end;

destructor TCommand.Destroy;
begin
  FMemory.Free;
  FMemory := Nil;
  inherited;
end;

procedure TCommand.Load(AFrom : TPacket);
begin
  FMemory.Clear;
  FMemory.Write(AFrom.Buffer^,AFrom.Used);
  FMemory.Seek(0,soFromBeginning);
  
  StreamTo;
end;

procedure TCommand.Save(AInto : TPacket);
begin
  FMemory.Clear;
  ToStream;
  
  FMemory.Seek(0,soFromBeginning);
  AInto.Used := FMemory.Size;
  FMemory.Read(AInto.Buffer^,AInto.Used);
end;

procedure TPrepare.ToStream;
begin
  inherited;
  Put(FUsername);
  Put(FPassword);
  Put(FHost);
end;

procedure TPrepare.StreamTo;
begin
  inherited;
  FUsername := Get;
  FPassword := Get;
  FHost := Get;
end;

constructor TPrepare.Create(AUsername,APassword,AHost: string);
begin
  inherited Create;
  FUsername := AUsername;
  FPassword := APassword;
  FHost := AHost;
end;

destructor TPrepare.Destroy;
begin
  inherited;
end;

procedure TServer.TIncoming.Pull(AData : TObject; AIn : TPacket); 
var
  lCommand : TCommand;
begin
  lCommand := TCommand.Create;
  lCommand.Load(AIn);
  FServer.FTodo.Pull(lCommand);
end;

constructor TServer.TIncoming.Create(AServer : TServer);
begin
  inherited Create;
  FServer := AServer;
end;

procedure TServer.TTodo.DoPull(ASender : TObject; AData : TObject);
var
  lCommand : TCommand;
begin
  { Threaded }
  FLock.Acquire;
  try
    lCommand := FQueue.Pop as TCommand;
  finally
    FLock.Release;
  end;
  FServer.DoOnPull(lCommand);
  lCommand.Free;
end;

constructor TServer.TTodo.Create(AServer : TServer);
begin
  inherited Create;
  FServer := AServer;
  FThread := TbaThread.Create(100,100);
  FThread.OnSyThread := DoPull;
  FLock := TCriticalSection.Create;
  FQueue := TObjectQueue.Create;
end;

destructor TServer.TTodo.Destroy;
begin
  FQueue.Free;
  FLock.Free;
  FThread.Free;
  inherited;
end;

procedure TServer.TTodo.Pull(ACommand : TCommand);
begin
  FLock.Acquire;
  try
    FQueue.Push(ACommand);
  finally
    FLock.Release;
  end;
  FThread.Kick;
end;

function TServer.GetState : EnngState;
var
  lState : EnngState;
begin
  lState := FPull.State;
  if lState<FPush.State then
    lState := FPush.State;
  result := lState;
end;

procedure TServer.DoOnPull(ACommand : TCommand);
begin
  { Synchronised! }
  if assigned(FOnPUll) then
    FOnPull(ACommand);
end;

constructor TServer.Create(AHost : String; APull,APush : Integer);
begin
  inherited Create;
  FTodo := TTodo.Create(Self);
  
  FPull := TIncoming.Create(Self);
  FPull.Host := AHost;
  FPull.Port := APull;
  FPush := TPush.Create;
  FPush.Host := AHost;
  FPush.Port := APush;
end;

destructor TServer.Destroy;
begin
  FPush.Free;
  FPush := Nil;
  FPull.Free;
  FPull := Nil;

  FTodo.Free;
  inherited;
end;

procedure TServer.Connect;
begin
  FPush.OnLog := FOnLog;
  FPull.OnLog := FOnLog;
  
  FPush.Connect;
  FPull.Connect;
end;

procedure TServer.Push(ACommand : TCommand);
var
  lPacket :  TPacket;
begin
  lPacket := TPacket.Create(nngBuffer);
  ACommand.Save(lPacket);
  FPush.Push(lPacket);
  lPacket.Free;
end;

procedure TServer.Disconnect;
begin
  FPull.Disconnect;
  FPush.Disconnect;
end;

end.
