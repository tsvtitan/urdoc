unit SeoConfigIntf;

interface

uses SeoLogIntf;

type
  ISeoConfig=interface(IDispatch)
  ['{DCFC10E0-FE57-4EFD-AE75-7D8AB2D0DDD3}']
    procedure CreateFile(const FileName: string); stdcall;
    procedure Init(const FileName: String); stdcall;
    procedure Done; stdcall;

    function ReadString(const Section, Ident, Default: String): String; stdcall;
    function ReadInteger(const Section, Ident: String; Default: Longint): Longint; stdcall;
    function ReadBool(const Section, Ident: String; Default: Boolean): Boolean; stdcall;
    function ReadDate(const Section, Ident: String; Default: TDateTime): TDateTime; stdcall;
    function ReadDateTime(const Section, Ident: String; Default: TDateTime): TDateTime; stdcall;
    function ReadFloat(const Section, Ident: String; Default: Double): Double; stdcall;
    function ReadTime(const Section, Ident: String; Default: TDateTime): TDateTime; stdcall;
    procedure ReadSectionValues(const Section: string; out Strings: String); stdcall;
    procedure ReadSection(const Section: string; out Strings: String); stdcall;

    procedure WriteString(const Section, Ident, Value: String); stdcall;
    procedure WriteInteger(const Section, Ident: String; Value: Longint); stdcall;
    procedure WriteBool(const Section, Ident: String; Value: Boolean); stdcall;
    procedure WriteDate(const Section, Ident: String; Value: TDateTime); stdcall;
    procedure WriteDateTime(const Section, Ident: String; Value: TDateTime); stdcall;
    procedure WriteFloat(const Section, Ident: String; Value: Double); stdcall;
    procedure WriteTime(const Section, Ident: String; Value: TDateTime); stdcall;

    procedure EraseSection(const Section: String); stdcall;
    procedure UpdateFile; stdcall;

    function GetAsText: String; stdcall;
    function GetIsInit: WordBool; stdcall;

    property AsText: String read GetAsText;
    property IsInit: WordBool read GetIsInit;
  end;

implementation

end.
