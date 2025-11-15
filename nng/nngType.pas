unit nngType;

interface

type
  TOnLog = procedure(AMessage : String) of object;

type
  EnngDesired = (desNull, desReady, desActive);
  EnngState = (statNull, statInitialised, statProtocol, statConnect, statReady, statActive);
  TnngStateEvent = procedure(ASender : TObject; AState : EnngState) of object;

const
  cState : Array[EnngState] of String = ('','Initialised','Protocol','Connect','Ready','Active');
  
implementation

end.
