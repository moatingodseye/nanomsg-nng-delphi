unit nngType;

interface

type
  ELog = (logNone, logInfo, logWarning, logError);
  TOnLog = procedure(ALevel : ELog; AMessage : String) of object;

const
  cLog : Array[ELog] of String = ('','Info:','Warning:','Error:');
  
implementation

end.
