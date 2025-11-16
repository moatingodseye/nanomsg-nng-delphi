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
    FOnLog : TOnLog;
  strict protected
    FHost : String;
    FPort : Integer;
    FDesired : EnngDesired;
    FState : EnngState;
    FData : TObject;
    FActive : Integer;
    FPoll : Boolean;
    
    procedure Setup; virtual; 
    procedure Process(AData : TObject); virtual; abstract;
    procedure Teardown(ATo : Enngstate); virtual; 
  protected
    FEnabled : Boolean;
    
    procedure Error(AMessage : String);
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure Log(AMessage : String);
    procedure Connect;
    procedure Kick; virtual;
    procedure Disconnect;

    procedure Pipe(AWhich : Integer); // callback from nng dll - only reason its public don't call yourself!

    property State : EnngState read FState;
    
    property OnLog : TOnLog read FOnLog write FOnLog;
    property Data : TObject read FData write FData;
    
    property Host : String read FHost write FHost;
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
  try
    if (FActive>0) and FEnabled then
      Process(AData);
  except
    on E : Exception do
      Error(E.Message);
  end;
end;

procedure TNNG.DoOnIdle(ASender, AData : TObject);
begin
  case FDesired of
    desNull :
      case FState of
        statProtocol,
        statReady,
        statActive,
        statConnect :
          begin
            Teardown(statNUll);
          end;
      end;
    desReady : 
      case FState of
        statNull,
        statProtocol :
          begin
            Sleep(250);
            Setup;
            if (FState=statReady) or (FState=statActive) then
              FEnabled := True
            else
              Teardown(statProtocol);
          end;
        statReady : ;
        statActive : FState := statReady;
      end;
    desActive :
      case FState of
        statReady : FState := statActive;
        statActive : 
          if (FActive>0) and FEnabled and FPoll then
            FThread.Kick;
      end;
  end;
end;

procedure TNNG.Setup;
var
  init_params : nng_init_param;
  err : Integer;
begin
  inherited;
  if FState=statNull then begin
    Log('Initialise:');
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
      FState := Succ(FState)
    else
      Error('Initialise:'+ nng_strerror(err));
  end;
end;    

procedure TNNG.Teardown(ATo : Enngstate);
var
  err : Integer;
begin
  if FState>ATo then
    if FState=statInitialised then begin
      log('Finalise:');
      FState := Pred(FState);
      // Cleanup
      err := nng_fini();
      if err <> NNG_OK then
        Error('Finalise: '+ nng_strerror(err));
    end;
  inherited;
end;

procedure TNNG.Pipe(AWhich : Integer);
begin
  case AWhich of
    1 : { Before add } ;
    2 : { Add }
      begin
        Inc(FActive);
        if FActive>0 then begin
          Log('Active');
          FDesired := desActive;
          FThread.Kick;
        end;
      end;
    3 : { Remove }
      begin
        Dec(FActive);
        if FActive=0 then begin
          FDesired := desReady;
          Log('Inactive');
        end;
      end;
  end;
end;

procedure TNNG.Log(AMessage : String);
begin
  if assigned(FOnLog) then
    FOnLog(ClassName+':'+AMessage);
end;

procedure TNNG.Error(AMessage : String);
begin
  Log('Error:'+AMessage);
end;

constructor TNNG.Create;
begin
  inherited Create;
  FPoll := False;
  FEnabled := False;
  FActive := 0;
  FDesired := desNull;
  FState := statNull;
  FThread := TbaThread.Create(nngPeriod,nngGranularity);
  FThread.OnAsThread := DoOnThread;
  FThread.OnAsIdle := DoOnIdle;
end;

destructor TNNG.Destroy;
begin
  FThread.Free;
  inherited;
end;

procedure TNNG.Connect;
begin
  FDesired := desReady;
  FThread.Kick;
end;

procedure TNNG.Kick;
begin
//  FEnabled := True;
  FThread.Kick;
end;

procedure TNNG.Disconnect;
begin
  FDesired := desNull;
//  FThread.OnAsThread := Nil;
//  Teardown;
end;

end.
