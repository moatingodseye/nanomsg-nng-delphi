{$M+}
unit nng;

interface

uses
  baThread, nngdll;
  
type
  TOnLog = procedure(AMessage : String) of object;
  
  TNNG = class(TObject)
  strict private
    FThread : TbaThread;

    procedure DoOnThread(ASender,AData : TObject);
  private   
    FOnLog : TOnLog;
    FOnError : TOnLog;
  strict protected
    FStage : Integer;
    FData : TObject;
    
    procedure Setup; virtual; 
    procedure Process(AData : TObject); virtual; abstract;
    procedure Teardown; virtual; 
  protected
    procedure Log(AMessage : String);
    procedure Error(AMessage : String);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Start;
    procedure Kick; virtual; abstract;
    procedure Stop;

    property OnLog : TOnLog read FOnLog write FOnLog;
    property OnError : TOnLog read FOnError write FOnError;
    property Data : TObject read FData write FData;
  published
  end;
  
implementation

procedure TNNG.DoOnThread(ASender: TObject; AData: TObject);
begin
  Process(AData);
  FThread.Kick;
end;

procedure TNNG.Setup;
var
  init_params: nng_init_params;
  err : Integer;
  url : AnsiString;
begin
  inherited;
  Log('Initialise');
  init_params.num_task_threads := 2;
  init_params.max_task_threads := 4;
  init_params.num_expire_threads := 1;
  init_params.max_expire_threads := 2;
  init_params.num_poller_threads := 1;
  init_params.max_poller_threads := 2;
  init_params.num_resolver_threads := 1;

  // Initialize the nng library
  err := nng_init(@init_params);
  if (err = NNG_OK) or (err = NNG_EBUSY) then
    Inc(FStage)
  else
    Error('Error initializing nng: '+ nng_strerror(err));
end;    

procedure TNNG.Teardown;
var
  err : Integer;
begin
  if FStage=1 then begin
    Dec(FStage);
    // Cleanup
    err := nng_fini();
    if err <> NNG_OK then
      Error('Error finalizing nng: '+ nng_strerror(err));
  end;
  inherited;
end;

procedure TNNG.Log(AMessage : String);
begin
  if assigned(FOnLog) then
    FOnLog(AMessage);
end;

procedure TNNG.Error(AMessage : String);
begin
  if assigned(FOnError) then
    FOnError(AMessage);
end;

constructor TNNG.Create;                   
begin
  inherited Create;
  FStage := 0;
  FThread := TbaThread.Create(50);
  FThread.OnAsThread := DoOnThread;
end;

destructor TNNG.Destroy;
begin
  FThread.Free;
  inherited;
end;

procedure TNNG.Start;
begin
  Setup;
  FThread.Kick;
end;

procedure TNNG.Stop;
begin
  Teardown;
end;

end.
