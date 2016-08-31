unit SeoLogIntf;

interface

type
  TSeoLogType=(ltInformation,ltWarning,ltError);
  TSeoLogOutput= set of (loScreen,loFile);

  ISeoLogWriter=interface(IDispatch)
  ['{A2B89F2C-844F-4EC8-852C-ED2918E71C26}']
    procedure Write(const Message: String; LogType: TSeoLogType); stdcall;
  end;
  
  ISeoLog=interface(IDispatch)
  ['{18C338D4-108E-4755-AFC3-365E267E4E3B}']
    procedure Init(const FileName: String); stdcall;
    procedure Done; stdcall;

    function Write(const Message: String; LogType: TSeoLogType; LogOutput: TSeoLogOutput): WordBool; stdcall;
    function WriteInfo(const Message: String; LogOutput: TSeoLogOutput): WordBool; stdcall;
    function WriteError(const Message: String; LogOutput: TSeoLogOutput): WordBool; stdcall;
    function WriteWarn(const Message: String; LogOutput: TSeoLogOutput): WordBool; stdcall;
    function WriteToFile(const Message: String; LogType: TSeoLogType): WordBool; stdcall;
    function WriteToScreen(const Message: String; LogType: TSeoLogType): WordBool; stdcall;
    function WriteToBoth(const Message: String; LogType: TSeoLogType): WordBool; stdcall;

    procedure Clear; stdcall;

    function GetScreenWriter: ISeoLogWriter; stdcall;
    function GetIsInit: WordBool; stdcall;
    function GetClearOnInit: WordBool; stdcall;
    function GetFileName: String; stdcall;

    property ScreenWriter: ISeoLogWriter read GetScreenWriter;
    property IsInit: WordBool read GetIsInit;
    property ClearOnInit: WordBool read GetClearOnInit;
    property FileName: String read GetFileName;

  end;  


implementation

end.
