unit SeoDbIntf;

interface

uses SeoConfigIntf, SeoLogIntf, Db;

type

  ISeoDb=interface(IDispatch)
  ['{4DB055D4-40E9-4A2C-8968-A0CF24EC3889}']
    function GetConfig: ISeoConfig; stdcall;
    function GetDisplayName: String; stdcall;
    function GetLog: ISeoLog; stdcall;
    function GetFileName: String; stdcall;
    function GetActive: Boolean; stdcall;
    function GetDataSet: TDataSet; stdcall;

    procedure Init(const FileName: string); stdcall;
    procedure Done; stdcall;


    procedure ReCreate(const FileName: String); stdcall;
    procedure LoadFromFile(const FileName: String); stdcall;
    procedure SaveToFile(const FileName: String); stdcall;

    function ReadParam(const AName: String; var AValue: String): WordBool; stdcall;
    procedure WriteParam(const AName, AValue: String; IsNew: WordBool); stdcall;
    function DeleteParam(const AName: String): WordBool; stdcall;
    function ExistsParam(const AName: String): WordBool; stdcall;
    procedure UpdateFile(IgnoreChanges: Boolean=false); stdcall;

    function HashValue(Field: TBlobField): String; stdcall;

    property Config: ISeoConfig read GetConfig;
    property DisplayName: String read GetDisplayName;
    property Log: ISeoLog read GetLog;
    property FileName: String read GetFileName;
    property Active: Boolean read GetActive;
    property DataSet: TDataSet read GetDataSet;
  end;


implementation

end.
