unit packageInterface;

interface

uses
  System.Classes;
  
type
  IInPackage = Interface
    ['{4C662C92-7581-4216-935E-3348C3DB3A53}']
    procedure Show;
    procedure Hide;

    procedure Put(AValue : String);
    function Get : String;

    function GetOnEvent : TNotifyEvent;
    procedure SetOnEvent(AEvent : TNotifyEvent);
    
    property OnEvent : TNotifyEvent read GetOnEvent write SetOnEvent;
  end;

implementation

end.
