unit nngType;

interface

type
  ELog = (logNone, logLow, logInfo, logWarning, logError);
  TOnLog = procedure(ALevel : ELog; AMessage : String) of object;

const
  cLog : Array[ELog] of String = ('','Tick','Info:','Warning:','Error:');
  
implementation

end.
