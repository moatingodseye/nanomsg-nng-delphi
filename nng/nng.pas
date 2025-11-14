{$M+}
unit nng;

interface

uses
  baThread, nngdll, nngType;
  
type
  TNNG = class(TObject)
  strict private
    FThread : TbaThread;

    procedure DoOnThread(ASender,AData : TObject);
    procedure DoOnIdle(ASender, AData : TObject);
  private   
    FLevel : ELog;
    FOnLog : TOnLog;
    FOnError : TOnLog;
  strict protected
    FHost : AnsiString;
    FPort : Integer;
    FStage : Integer;
    FData : TObject;
    FActive : Integer;
    FPoll : Boolean;
    
    procedure Setup; virtual; 
    procedure Process(AData : TObject); virtual; abstract;
    procedure Teardown; virtual; 
  protected
    FEnabled : Boolean;
    procedure SetPeriod(APeriod : Integer);
    procedure Error(AMessage : String);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Log(ALevel : ELog; AMessage : String);
    procedure Start;
    procedure Kick; virtual;
    procedure Stop;

    procedure Pipe(Which : Integer);
    
    property Level : ELog read FLevel write FLevel;
    property OnLog : TOnLog read FOnLog write FOnLog;
    property OnError : TOnLog read FOnError write FOnError;
    property Data : TObject read FData write FData;
    
    property Host : AnsiString read FHost write FHost;
    property Port : Integer read FPort write FPort;
  published
  end;
  
implementation

uses
  System.SysUtils, nngConstant;
  
function IIF(ACheck : Boolean; AYes,ANo : String) : String;
begin
  result := ANo;
  if ACheck then
    result := AYes;
end;

procedure TNNG.DoOnThread(ASender: TObject; AData: TObject);
begin
  Log(logLow, DateTimeToStr(Now)+' '+IntToStr(FActive)+' '+IIF(FEnabled,'Yes','No'));
  try
    if (FActive>0) and FEnabled then
      Process(AData);
//    if (FActive>0) and FEnabled then
//      FThread.Kick; this makes thread run 100%
  except
    on E : Exception do
      Error(E.Message);
  end;
end;

procedure TNNG.DoOnIdle(ASender, AData : TObject);
begin
  if (FActive>0) and FEnabled and FPoll then
    FThread.Kick;
end;

procedure TNNG.Setup;
var
  init_params : nng_init_param;
  err : Integer;
begin
  inherited;
  Log(logInfo,'Initialise:');
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
    Error('Initialise:'+ nng_strerror(err));
end;    

procedure TNNG.Teardown;
var
  err : Integer;
begin
  if FStage=1 then begin
    log(logInfo,'Finalise:');
    Dec(FStage);
    // Cleanup
    err := nng_fini();
    if err <> NNG_OK then
      Error('Finalise: '+ nng_strerror(err));
  end;
  inherited;
end;

procedure TNNG.Pipe(which : Integer);
begin
  case which of
    1 : { Before add } ;
    2 : { Add }
      begin
        Inc(FActive);
        if FActive>0 then begin
          Log(logInfo,'Active');
          FThread.Kick;
        end;
      end;
    3 : { Remove }
      begin
        Dec(FActive);
        if FActive=0 then
          Log(logInfo,'Inactive');
      end;
  end;
end;

procedure TNNG.SetPeriod(APeriod : Integer);
begin
  FThread.SetPeriod(APeriod);
end;

procedure TNNG.Log(ALevel :ELog; AMessage : String);
begin
  if assigned(FOnLog) and (ALevel>=FLevel) then
    FOnLog(ALevel,AMessage);
end;

procedure TNNG.Error(AMessage : String);
begin
  if assigned(FOnError) then
    FOnError(logError,AMessage);
end;

constructor TNNG.Create;
begin
  inherited Create;
  FLevel := logNone;
  FPoll := False;
  FEnabled := False;
  FActive := 0;
  FStage := 0;
  FThread := TbaThread.Create(nngPeriod,nngGranularity);
  FThread.OnAsThread := DoOnThread;
  FThread.OnAsIdle := DoOnIdle;
end;

destructor TNNG.Destroy;
begin
  FThread.Free;
  inherited;
end;

procedure TNNG.Start;
begin
  Setup;
  FEnabled := True;
  FThread.Kick;
end;

procedure TNNG.Kick;
begin
  FEnabled := True;
  FThread.Kick;
end;

procedure TNNG.Stop;
begin
  FThread.OnAsThread := Nil;
  Teardown;
end;

end.
