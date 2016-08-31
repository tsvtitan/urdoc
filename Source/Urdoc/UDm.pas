unit UDm;

interface

{$I def.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, IBDatabase, Db, ImgList,
  dbtables, ComObj, ActiveX, ComCtrls,
  stdctrls,buttons,mask, menus, bde, iniFiles, FileCtrl,
  IBQuery, IBTable, Tabnotbk, UUnited, TypInfo,
  IBServices, shellapi, dbgrids, IB, rxToolEdit, RxCalc, IBSQL, Variants,
  UNewDbGrids, SeoDb, SeoCrypter, SeoCrypterIntf, SeoDbConsts, SeoKeys, SeoUtils,
  DateUtils;

type
  TSetOfChar=set of char;
  
type
  TInfoHelperItem=class(TObject)
  private
    FNotId: Integer;
    FisHelper: Integer;
  public
    property NotId: Integer read FNotId write FNotId;
    property isHelper: Integer read FisHelper write FisHelper;
  end;

  TTypeTranslateText=(tttUpper,tttLower,tttRussian,tttEnglish);

  TTypeEnterPeriod=(tepQuarter,tepMonth,tepDay,tepInterval,tepYear);

  PInfoEnterPeriod=^TInfoEnterPeriod;
  TInfoEnterPeriod=packed record
    DateBegin: TDate;
    DateEnd: TDate;
    LoadAndSave: Boolean;
    TypePeriod: TTypeEnterPeriod;
  end;


   PInfoNotarius=^TInfoNotarius;
   TInfoNotarius=packed record
    not_id: Integer;

    FIO: string;
    FIODatel: string;
    FIORodit: string;
    FIOVinit: string;
    FIOTvorit: string;
    FIOPredl: string;
    FIOSmall: string;

    FIO_h: string;
    FIODatel_h: string;
    FIORodit_h: string;
    FIOVinit_h: string;
    FIOTvorit_h: string;
    FIOPredl_h: string;
    FIOSmall_h: string;

    UrAdres: string;
    Phone: String;
    INN: string;

    TownFull_Normal: string;
    TownFull_Where: string;
    TownFull_What: string;

    TownSmall_Normal: string;
    TownSmall_Where: string;
    TownSmall_What: string;

    NameFull_Normal: string;
    NameFull_Where: string;
    NameFull_What: string;

    NameSmall_Normal: string;
    NameSmall_Where: string;
    NameSmall_What: string;

    isHelper: Integer;

    UseAutoFormat: Boolean;
    Style: String;
   end;
   
   PCheckPoint=^TCheckPoint;
   TCheckPoint=packed record
     dwOemId: DWord;
     wProcessorArchitecture: Word;
     dwPageSize: DWord;
     dwActiveProcessorMask: DWord;
     dwNumberOfProcessors: DWord;
     dwProcessorType: DWord;
     dwAllocationGranularity: DWord;
     wProcessorLevel: Word;
     wProcessorRevision: Word;
     dwWin32Platform: DWord;
     dwWin32MajorVersion: DWord;
     dwWin32MinorVersion: DWord;
     dwWin32BuildNumber: DWord;
     Win32CSDVersion: array[0..127] of AnsiChar;
     dwVolumeSerialNumber: DWord;
     CPUSpeed: Extended;
   end;

  PInfoReestr=^TInfoReestr;
  TInfoReestr=packed record
    ID: Integer;
    IDList: Integer;
    IDNode: Integer;
    Name: string;
    Hint: string;
    NodeText: string;
    IDUser: Integer;
  end;


  PInfoMenu=^TInfoMenu;
  TInfoMenu=packed record
    mi: TMenuItem;
    fm: TForm;
  end;

  PInfoClass=^TInfoClass;
  TInfoClass=packed record
    Caption: String;
    TypeClass: TClass;
    ImageIndex: Integer;
  end;


  TViewType=(vtView,vtEdit);

  TWordFormType=(wtFieldQuote,wtFieldNone);

  PFieldQuote=^TFieldQuote;
  TFieldQuote=packed record
    Code: String;
    Result: String;
    FieldName: string;
    ID: Integer;
    AutoFormat: Boolean;
    Style: String;
  end;

  PFieldNone=^TFieldNone;
  TFieldNone=packed record
    Text: String;
    ID: Integer;
  end;

  PInfoWordType=^TInfoWordType;
  TInfoWordType=packed record
    WordType: TWordFormType;
    PField: Pointer;
    NameControl: String;
  end;

  TViewNode=procedure (nd: TTreeNode; Only: Boolean);

type
  TDm = class(TDataModule)
    ilMain: TImageList;
    IBTransaction: TIBTransaction;
    tmRestore: TTimer;
    IBDbase: TIBDatabase;
    procedure DataModuleCreate(Sender: TObject);
    procedure tmRestoreTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LocalDb: TSeoDb;
  Crypter: ISeoCrypter;
  ctTemp: TWinControl;
  TempStr: string;
  Dm: TDm;
  DataBaseName: string;

  MutexHan: THandle;
  MessageID: UINT;


  ChangeFlag: Boolean=False;

  LastNodeID,LastParentNodeID: Integer;
  LastListID: Integer;


  ListReestrForms: TList;
  ListClasses: TList;
  ListClassesForWord: TList;
  ListDefaultConst: TStringList;
  ListFieldNoCreate: TStringList;
  ListDefaultStyles: TStringList;
  TempDocFilePath: string;
  LastActive: TForm;
  ListMenuItems: TList;
  UserId: Integer;
  UserName: string;
  UserIsAdmin: Boolean=false;
  isBackUpFirst: Boolean=false;
  isBackUpLast: Boolean=false;
  isBackUpTime: Boolean=false;
  isClearTempDir: Boolean=false;
  isViewDateInListView: Boolean=false;
  isViewCheckSumInListView: Boolean=false;
  isViewPath: Boolean=false;
  isRefreshFormOnDocumentLoad: Boolean=false;
  isSaveDocumentOnView: Boolean=false;
  isDeleteQuiteInReestr: Boolean=false;
  isViewDeleteQuiteInReestr: Boolean=false;
  BackUpTime: Byte=10;
  BackUpFreeze: Byte=10;
  RestoreSleep: Integer=10;

  FormGridSize: Integer;

  LastSaveArch: string;
  LastLoadArch: string;
  LastDocAddDir: string;
  BackUpDir: string;
  FileHelp: string;

  BreakAnyProgress: Boolean;

  isViewObjectIns: Boolean;

  isCheckFieldsFill: Boolean=false;
  WorkYear: Integer;
  WorkDate: TDate;
  KeepDoc: Boolean=true;
  lastFileDoc: string;
  WordFileName: string;
  isCloseWord: Boolean;
  LastHelperIndex: Integer;
//  QuestionOnAddToReestr: Boolean=true;


  NewForm: TForm;
  LastID: Integer;
  LastNotarialActionId: Integer;

  DefaultBackUpDir: String;

  isExitCode: Boolean=false;
  isExit: Boolean=false;
  DayDoverOffset: Integer;
  isDisableDefaultOnForm: Boolean=true;
  UpdateInfoFile: string;
  isViewUpdateInfo: Boolean=true;
  isViewHintOnFocus: Boolean=false;
  isViewReminder: Boolean=true;
  isAutoBuildWords: Boolean=true;
  isViewWhoCert: Boolean=false;
  isDocumentLock: Boolean=true;
  isNotViewHereditaryDeal: Boolean=false;
  isExpandConst: Boolean=false;
  isQuestionBackup: Boolean=true;
  isSelectDatabase: Boolean=false;
  isCheckEmptySumm: Boolean=false;

  FSqlFileName: string;
  FConfigFileName: string='';
  FAdminPresent: Boolean=false;

const
  SCompany='%s 2010';
  SCompanyName=SCompany+'. ��� ����� ��������.';

  WordOle='Word.Application';

  FieldsNameConst='������ ����';
  MesOperationInaccessible='�������� ����������';
  MesCallingWasDeclined='����� ��� ��������';

  SMainCaption='%s';
  SForm='Form';

  DataBaseUserName='user_name=%s';
  DataBaseUserPass='password=%s';
  DataBaseCodePage='lc_ctype=WIN1251';

  DefaultTransactionParamsTwo='read_committed'+#13+
                              'rec_version'+#13+
                              'nowait';

  UrDocMutex='UrDoc4Mutex';

  ViewCountText='����� �������: ';
  ViewCountTextSearch='����� �������: ';

  ChangeHintCaption='�������� ��������';
  DataFolderConst='Data';
  DocTreeCaption='������ ��������';
  DocTreeCarringCaption='������� ��������';
  StatusEdit='��������������';
  StatusView='��������';
  StatusLoad='��������';
  StatusSave='����������';
  DefaultNodeText='��� �������';
  DefSelectDocument='�������� ������';
  DefSelectNode='�������� ��� �������';
  DefNoncorrectValue='�������� ��������';
  DefSearchReestr='��� ��������� ������� � ������';

  TableDoc='DOC';
  TableReestr='REESTR';
  TableDocLock='DOCLOCK';
  TableUsers='USERREESTR';
  TableTypeReestr='TYPEREESTR';
  TableOperation='OPERATION';
  TableMask='MASK';
  TableCase='"CASE"';
  TableTypeDoc='TYPEDOC';
  TableMarkCar='MARKCAR';
  TableColor='COLOR';
  TableLicense='LICENSE';
  TableNotarius='NOTARIUS';
  TableSearchInReestr='SEARCHINREESTR';
  TableConst='CONST';
  TableNotarialAction='NOTARIALACTION';
  TableCancelAction='CANCELACTION';
  TableHereditaryDeal='HEREDITARYDEAL';
  TableHereditaryDocum='HEREDITARYDOCUM';
  TableSubs='SUBS';
  TableSubsValue='SUBSVALUE';
  TableReFillQuote='REFILLQUOTE';
  TablePeople='PEOPLE';
  TableRuleForElement='RULEFORELEMENT';
  TableReminder='REMINDER';
  TableRenovation='RENOVATION';
  TableGraphVisit='GRAPHVISIT';
  TableChamber='CHAMBER';
  TableNotary='NOTARY';
  TableBlanks='BLANKS';

  DefTempDocDir='Temp';

  ExtDoc='*.doc';
  FilterDoc='����� �������� (*.doc)|*.doc';
  FilterForm='����� ���� (*.frm)|*.frm';
  FilterAll='��� ����� (*.*)|*.*';

  LoadEditor='SuperVisor';
  LoadEditorPass='admin';
  isEdit: Boolean=false;

  captionAdd='��������';
  captionChange='��������';
  CaptionFilter='������';
  CaptionView='��������';

  valuePresent='��� ����������.';

  fmtCaptionStatus='%s - %d ��.';
  fmtFileDate='dd.mm.yyyy';
  fmtFileTime='hh.mm.ss';
  fmtDate='dd.mm.yyyy';
  fmtDateTime='dd.mm.yyyy hh.mm.ss';
  fmtDateLong='dd mmmm yyyy';
  fmtReportPlus='dd.mm.yyyy �.';
  fmtReport='dd.mm.yyyy';
  fmtViewDocSave='�������� ������� <%s> ��� ������� � ������ ���������, ��������� ���������?';
  fmtUpdateForm='�������� ����� ������� <%s>?';
  fmtAboutVer='������ %s';
  fmtAboutVerSplash='%s (%s)';
  fmtAboutVerNew='������ %s (%s)';
  fmtUpdateInfo='�������� ��������� �������� � %s �� %s �.';
  fmtRenovationId=' �%d';
  fmtRenovationLogSuccess='[Command: %s Success]';
  fmtRenovationLogFail='[Command: %s Fail]';
  fmtRefreshField='%s';

  fmtDateShort='dd.mm.yy';
  fmtDateShortEx='dd.mm.yyyy';
  ConstFindCount=20;

  ConstBackUpDir='BackUp';
  ConstBackUpExt='.uda';

  SwitchRunParamSqlFile='sqlfile';
  SwitchRunParamConfig='config';
  SwitchRunParamUser='user';
  SwitchRunParamKey='key';
  SwitchRunParamAdmin='admin';

  //////////////////////////////////
  TSVLIBDLL='tsvlib.dll';

  //////////////////////////////////
  RndTimeConst=1000*60*3;
  PatchResName='CHECKPOINT';

  ////////////////////////////////////////
  WordFieldNumInReestr='����� � �������';
  WordFieldSumm='�����';
  WordFieldNumLicense='����� ��������';

  WordFieldTownFull_Normal='�� ������������(��.�.)'; // �����
  WordFieldTownFull_Where='�� ������������(����.�.)'; // ������
  WordFieldTownFull_What='�� ������������(���.�.)';  // ������

  WordFieldTownSmall_Normal='�� ������������(��.�.)����.'; // �.
  WordFieldTownSmall_Where='�� ������������(����.�.)����.'; // �.
  WordFieldTownSmall_What='�� ������������(���.�.)����.'; // �.

  // old -----------------
  WordFieldTownFull_Normal2='�/� � ������������(��.�.)'; // �����
  WordFieldTownFull_Where2='�/� � ������������(����.�.)'; // ������
  WordFieldTownFull_What2='�/� � ������������(���.�.)';  // ������

  WordFieldTownSmall_Normal2='�/� �������������(��.�.)'; // �����
  WordFieldTownSmall_Where2='�/� �������������(����.�.)'; // �.
  WordFieldTownSmall_What2='�/� �������������(���.�.)'; // �.

  WordFieldUrAdres2='����� ������������ �������';
  // old --------------------

  WordFieldFIO_Imenit='��� ���������(��.�.)';
  WordFieldFIO_Rodit='��� ���������(���.�.)';
  WordFieldFIO_Datel='��� ���������(���.�.)';
  WordFieldFIO_Vinit='��� ���������(���.�.)';
  WordFieldFIO_Tvorit='��� ���������(��.�.)';
  WordFieldFIO_Predl='��� ���������(����.�.)';
  WordFieldFIO_Imenit_sm='��� ���������(��.�.)����.';
                                                                                                         
  WordFieldFIO_Imenit_h='��� ���������(��.�.)';
  WordFieldFIO_Rodit_h='��� ���������(���.�.)';
  WordFieldFIO_Datel_h='��� ���������(���.�.)';
  WordFieldFIO_Vinit_h='��� ���������(���.�.)';
  WordFieldFIO_Tvorit_h='��� ���������(��.�.)';
  WordFieldFIO_Predl_h='��� ���������(����.�.)';
  WordFieldFIO_Imenit_sm_h='��� ���������(��.�.)����.';

  WordFieldUrAdres='����� ���������';
  WordFieldPhone='������� ���������';
  WordFieldINN='��� ���������';

  WordFieldToday='����������� ����';
  WordFieldToday2='���.����';

  WordFieldBlankSeries='����� ������';
  WordFieldBlankNum='����� ������';

  // not used in list
  WordFieldDateEndDeistviyDover='���� ��������� ����� �������� ������������';
  WordFieldTownDefault='����� �� ���������';

  ///////////////////////


  ConstAddDoc='������: ';
  CaptionCreateReport='������������ ������ ...';

  ConstWordFailed='���������� ���������� Microsoft Word.';
  ConstFieldNoLinkInDocument='������� ����� �� �������� �������� � ���� ���������,'+#13+
                             '���� ���������� �� ��������� ���������.';

  ConstWarning='��������������';
  ConstWorkYear='������� ���: %d �.';
  ConstWorkDate='������� ����: %s';

  ConstRenovationBase='���������� ���� ������';
  ConstExtRenovationLog='.log';
  ConstRenovationCommandB='<';
  ConstRenovationCommandE='>';
  fmtRenovationCommandBegin=ConstRenovationCommandB+'%s'+ConstRenovationCommandE;
  fmtRenovationCommandEnd=ConstRenovationCommandB+'/%s'+ConstRenovationCommandE;
  ConstRenovationCommandSql='sql';
  ConstRenovationCommandSetBlobFile='setblobfile';

  ConstRefreshForm='���������� �����';
  ConstReadFields='������ ����� �� ���������';
  ConstRemoveDocumentsLooksSuccess='������ ���������� ������� �� ������� ������.';

  ConstPropSubs='Subs';
  ConstPropDocFieldName='DocFieldName';
  ConstPropTypeCase='TypeCase';
  ConstPropBlocking='Blocking';

  ConstLeftBreak='<%';
  ConstRightBreak='%>';
  ConstPageControlMain='PageMain';
  ConstPageControlMainOld='pgMain';
  ConstTabSheetMain='TabSheetMain';
  ConstTabSheetMainOld='tsMain';
  ConstTabSheetCaption='��������';
  ConstScrollBox='ScrollBox';
  ConstScrollBoxOld='scrlbx';

  ConstFontNameUpdateInfo='Times New Roman';
  ConstFontHeightUpdateInfo=13;
  SConstHeaderUpdateInfo1='%s';

  SConstFooterUpdateInfo1='%s';

const
  WM_PropChange=WM_USER+1;
  WM_BoundsChange=WM_USER+2;


var
  // Hot Keys
  hkTranslateToUpperCase: TShortCut;
  hkTranslateToLowerCase: TShortCut;
  hkTranslateToRussian: TShortCut;
  hkTranslateToEnglish: TShortCut;

const
  ConstHotKeyUpperCase=100;
  ConstHotKeyLowerCase=101;
  ConstHotKeyToRussian=102;
  ConstHotKeyToEnglish=103;

  LayoutRussian='00000419';
  LayoutEnglish='00000409';
  ConstNoneVisibleNode='$$$';
  CopyID=14;
  ColorCount=64;
  StartUpdateHeight=5000;  // Max 32767 
  IncUpdateHeight=10;

  NConstVersion=1;
  NRuleVersion=1;

  MaxBlankNumLength=7;

  GridRowColor=clBlack;



function IsServer: Boolean;
procedure InitAll;
procedure DoneAll;
function GetLastNodeID: Integer;
procedure ShowError(Handle: THandle; Mess: String);
procedure ShowInfo(Mess: String);
function GetListTextObjectFromWord(Form: TForm; FileDoc: String; List: TList; ViewProgress: Boolean=false): Boolean;
function isBadString(S: string): Boolean;
procedure ClearWordObjectList(List: TList);
function AddToWordObjectList(List: TList; PField: Pointer;
                             WordType: TWordFormType; NameControl: string): Integer;
function GetNodeSortID(ParentID: Integer): Integer;
procedure SetNodeSortID(ID,SortID,ParentID: Integer);
procedure GetNodelistFromLevel(TV: TTreeView; Level: Integer; NdParent: TTreeNode; List: TList);
procedure GetSelectedInListView(LV: TListView; List: TList);
procedure UpdateListsParentID(ID,NodeID: Integer);
procedure SaveNewFormToStream(List: TList; MsOut: TmemoryStream; ViewProgress: Boolean=false);
function CreateNewFormFromStream(MsIn: TMemoryStream;
                                 ViewType: TViewType; LiParent: TListItem;
                                 NewName: String=''): TForm;
procedure RemoveLinksForm_ListItem(fm: TForm);
procedure SaveNewForm(fm: TForm);
procedure SaveControlToStream(ct: TControl; msOut: TMemoryStream);
procedure LoadControlFromStream(ct: TControl; msOut: TMemoryStream; var Error: Boolean);
procedure CompressAndCrypt(MsOut: TMemoryStream);
procedure InitClasses;
procedure DestroyClasses;
procedure InitClassesForWord;
function GetImageIndexFromClassesForWord(TypeClass: TClass): Integer;
function GetIndexByClass(cls: TClass): Integer;

procedure DestroyClassesForWord;
function ExtractFormOrDocFile(LV: TListView; Form: Boolean; FileDoc: String): Boolean;
procedure ExtractObjectFromStream(msIn: TMemoryStream);
procedure FindOnListView(LV: TListView);
procedure FindOnTreeView(TV: TTreeView; fm: TForm);
procedure ClearReestrForms;

procedure ClearListMenuItems;
function isLinkOnReestr(IDList,IDNode: Integer; forList: Boolean): Boolean;
function isLinkOnReestrNew: Boolean;
procedure FreeAllComponents(ct: TWinControl);
procedure GetWordsByDocument(D: Variant; Words: TStringList; ViewProgress: Boolean=true);
procedure GetTextByDocument(D: Variant; Text: TStringList);
function SetFieldsToWord(List: TList; Active,OnlyView: Boolean; AutoFormat: Boolean=true): Boolean;
function GetNodeText(IDNode: Integer): String;
function isNewControl(ct: TControl): Boolean;
function ExtractDocFile(IDList: Integer; FIO: String): Boolean;
function ExtractDocFileFromReestr(ReestrId: Integer; FIO: String): Boolean;
function GetUniqueFileName(DocFile: String; Incr: Integer): string;
procedure PackTables(FmHandle: THandle; ViewMess: Boolean);
function isEmptyControl(ct: TControl): Boolean;
procedure DragDropFromDocTree(LVSource: TListView);
function isLoginToProgramm: Boolean;
function CheckStream(ms: TStream; InPass: String): Boolean;
function TranslateStream(ms: TStream;Crypt: Boolean): String;
function GetIniFileName: String;
procedure SaveToIni;
procedure LoadFromIni;
procedure LoadFromIniSearchParams;
procedure LoadFromIniReestrParams;
procedure LoadFromIniDocTreeParams;
procedure CreateBackUpOld;
procedure CreateBackUp(DefFileName: String);
procedure RestoreBackUp(DefFileName: String);

procedure DeleteBackUp;
function FormatDateTimeTSV(const Format: string; DateTime: TDateTime): string;
procedure RemoveDir(FName: String);
procedure GetDirs(FName: String; str: TStringList);
procedure GetDirFiles(FName: String; str: TStringList; Mask: string);
function ServerFound: Boolean;
function ConnectServer(dbName: String): Boolean;
procedure CheckPermissions;
function GetMaxIDFromTableDoc(TypeDocId: Integer; DocName: String): Integer;

{procedure _QuantityText(Value: Extended; var Translate: array of char;
                      Size: Integer; TypeTranslate: TTypeTranslate);
            stdcall;external TSVLIBDLL name 'QuantityText';}
function QuantityText(Value: Extended; TypeTrans: TTypeTranslate): string;
procedure SaveToCaseTable;
function GetRecordCount(qr: TIBQuery): Integer;
function isOtherControlConsistProp(WT: TWinControl; TypeCase: TTypeCase): Boolean;

{function _GetPadegFromStr(pFIO: ShortString; cSex: Char; TypeCase: TTypeCase):
           ShortString; stdcall; external TSVLIBDLL name 'GetPadegFromStr';}
function GetPadegStr(FIO: ShortString; TypeCase: TTypeCase): String;
function ExtractWord(InFio: string;  var cLastName,cFirstName,cMiddleName: String;
                     Delims: Char): string;
procedure ActiveWord;
procedure ClearTempDir;
procedure SetStatusHint(Hint: String);
procedure GetProtocolAndServerName(DataBaseStr: String; var Protocol: TProtocol;
                                   var ServerName: String);
procedure RefreshAll;
function GetRndTime: Integer;
procedure CheckPatch;
procedure UnCryptCheckPoint(Addr: DWord; Size: DWord);
function GetCPUSpeed: Extended;
function RunAnyFile(FileStr: String): Boolean;
procedure LoadDocFromDir(Caption: String; Dir: string; WithForm: Boolean=false);
procedure SaveDocToDir(Caption: String; Dir: string);
function GetTypeDocID(Name: String): Integer;
function GetMaxTypeDocID: Integer;
function AppendToDoc(TypeDoc_id: Integer; strFiles: TStringList; strName: string; WithForm: Boolean): Boolean;
procedure CompressAndCryptFile(FileName: String; MsOut: TMemoryStream);
function InsertToTypeDoc(NameStr,HintStr: String; ParentID: Integer): Integer;
procedure SetPositonAndText(Pos: Integer; Text,ConstStr: String; fm: TForm=nil; MaxProgress: Integer=100);
function GetSmallNameEX(Canvas: TCanvas; Text, ConstStr: string; Wid: Integer): String;
function GetCheckedString(Instr: String): String;
function isControlConsistPropPadegAndEqual(ct: TControl; TypeCase: TTypeCase): Boolean;
function GetUserDopField(tmpUserId: Integer; var UristFio,UrAdress,Town: string): Boolean;
function GetUserLicense(tmpLicenceID: Integer; var retNum: string;
                        var retUserId: Integer; var retDateLice: TDate;
                        var retKem: string): Boolean;
function GetNotariusList(OnlyNotary: Boolean=false): String;
function GetDocName(Doc_id: Integer): string;
function GetOperName(Oper_id: Integer): string;
function ChangeDecimalSeparator(InString: String; Ch: Char): String;
procedure GetInfoNotarius(TypeReestr_id: Integer; P: PInfoNotarius; RenovationId: Integer);
procedure GetInfoNotariusEx(not_id: Integer; P: PInfoNotarius; RenovationId: Integer;
                            OnlyFio, OnlyFioHelper, OnlyAddress: Boolean);
procedure ReadAndSettlbMainParams;
function GetTransformationResult(Text: String; ct: TControl): String;
function SearchInForm(ms: TmemoryStream; FindString: String;
                      reestr_id: Integer; InString: Boolean): Boolean;
function ControlConsistString(wt: TWinControl; str: String; InString: Boolean): Boolean;
function GetTextFromControl(ct: TControl): String;
function GetWinDir: string;
procedure EnterWorkYear(check: Boolean);
procedure EnterWorkDate(check: Boolean);
function ActiveWordKeepDoc(var KeepFileName: String; isCloseWord: Boolean): Boolean;
procedure SetWordFileName(Path: String);
procedure SaveDocumentToStream(FileName: string; msIn: TMemoryStream);
function CloseWord: Boolean;
function GetTypeReestrCount: Integer;
function GetReestrCount: Integer;

/// New Function
procedure ClearFields(wt: TWinControl);
function ViewEnterPeriod(P: PInfoEnterPeriod): Boolean;
procedure LoadGridProp(ClsName: string; fi: TIniFile; Grd: TDBGrid);
procedure SaveGridProp(ClsName: string; fi: TIniFile; Grd: TDBGrid);
function GetSmallFIO(InString: String): String;
function GetSmallFIONew(InString: String): String;
function GetTreeRootFromTypeDoc(TypeDocId: Integer): string;
function GetDateTimeFromServer: TDateTime;
procedure UnRegisterAllHotKeys;
procedure RegisterAllHotKeys;
procedure TranslateText(ttt: TTypeTranslateText);
function isFloat(Value: string): Boolean;
function isInteger(Value: string): Boolean;
function isDateTime(Value: String): Boolean;
function isDate(Value: String): Boolean;
function isTime(Value: String): Boolean;
function GetStrFromCondition(isNotEmpty: Boolean; STrue,SFalse: string): string;
function ChangeChar(Value: string; chOld, chNew: char): string;
function GetNotarialActionId(IdSort: Integer; var ActionName: string): Integer;
function isValidKey(Key: Char): Boolean;
function TranslateIBError(Message: string): string;
procedure SelectAllInListView(LV: TListView);
procedure SetCurrentDateTimeToDoc(Doc_id: Integer; var CurrentDateTime: TDateTime);
function CalculateCheckSumByDocId(Doc_id: Integer): LongWord;
function CalculateCheckSumByReestrId(Reestr_id: Integer): LongWord;
function GetTownDefault(isHelper: Boolean; RenovationId: Integer): String;
function CheckFileClosed(FileName: string): Boolean;
procedure LoadDocumentFromFile(FileName: string; doc_id: Integer; LV: TListView; msBack: TStream=nil);
function GetConstValueByName(Name: string; isHelper: Boolean; RenovationID: Integer): String;

function ListCompareTop(Item1, Item2: Pointer): Integer;
function GetNewName(ct: TComponent): String;
procedure ReAlignControls(wt: TWinControl; UseTabOrder: Boolean=false; UseDialog: Boolean=false; UseCheckBlocking: Boolean=false);
procedure UpdateFormFromStream(ListFields: TList; msOutForm: TMemoryStream; isFirstLoad: Boolean=false; ViewProgress: Boolean=false);
function GetFirstWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
procedure InitDefaultConst;
procedure InitFieldNoCreate;
procedure GetControlByPropValue(wtParent: TWInControl; PropName: string; PropValue: Variant;
                                ListControls: TList; UsePropValue: Boolean=true; OnlyThisParent: Boolean=false);
procedure SortListByTabOrder(List: TList);
procedure PrepearListFields(ListFields: TList);
procedure ExtractFormToFile(Stream: TStream; FileName: string);
procedure FreeAllControls(wt: TWinControl);
procedure AddDefaultStyles;
function GetNotarialActionIdByDocId(DocId: Integer): Integer;
function GetRenovationIdByDocId(DocId: Integer): Integer;
procedure SetNotarialActionIdByDocId(NotarialActionId,DocId: Integer; NotarialName: string);
procedure SetRenovationIdByDocId(RenovationId,DocId: Integer);
function IsValidPointer(P: Pointer; Size: Integer=0): Boolean;
function ViewFieldsInDocument(FieldName: string): Boolean;
function GetDocumentRefByFileName(FileName: string): Variant;
function Iff(isTrue: Boolean; TrueValue, FalseValue: Variant): Variant;
function GetGenIdEx(DB: TIBDatabase; TableName: string; Increment: Word): Longword;
function GetGenId(TableName: string; Increment: Word): Longword;
function toTrimSpaceForOne(const s: string): string;
function ChangeString(Value: string; strOld, strNew: string): string;
procedure SwitchParams;
procedure RunParamSqlFile(SqlFile: string);
function GetSubsId(SubsName: string): Integer;
procedure OpenSubs(Control: TControl; isLocate: Boolean; LocateSubs,LocateSubsValue: Variant; isFirst: Boolean=true);
procedure SetTextToControl(ct: TControl; const Value: Variant);
procedure FillSubsToStrings(Subs: string; Items: TStrings);
procedure ViewUpdateInfo;
function GetRenovationIdByWorkDate(): Integer;
function GetRenovationNameById(Id: Integer): string;
function GetRenovationIdByDate(Date: TDate): Integer;
function GetRenovationVersion(Version: string): string;
procedure GetStringsByString(const S: string; const Delim: string; Strings: TStringList);
procedure UpdateWordsInReestr(DateForm,DateTo: TDateTime);
procedure UpdateWordsInReestrByToday;
function TrimCharForOne(ch: Char; const s: string): string;
procedure CreateWordTableByGrid(AGrid: TNewdbGrid; const ACaption: string='');
function GetMaxNumReestr(LastTypeReestrID: Integer; NewUserId: Integer): Integer;
function isNumReestrAlready(NumReestr,LastTypeReestrID: Integer): Boolean;
procedure DocumentLock(NumReestr,LastTypeReestrID: Integer);
procedure DocumentUnLock(NumReestr,LastTypeReestrID: Integer);
function RemoveDocumentsLocks: Boolean;
function RemoveNotFileNameChar(FileName: string): string;

procedure SetDocSortNum(DocId: Integer; SortNum: Integer);
procedure SetDocSumm(DocId: Integer; Summ: Double);

procedure AddDopField(List: TList; var Plus: Integer;
                      Value,FieldName,ControlName: string; AutoFormat: Boolean=false;
                      Style: string='');
procedure AddDopFieldFromConst(List: TList; var Plus: Integer; isHelper: Boolean; RenovationId: Integer);

function CharIsNumber(const C: AnsiChar): Boolean;
function CharIsDigit(const C: AnsiChar): Boolean;
function CharIsControl(const C: AnsiChar): Boolean;
function CharIsPrintable(const C: AnsiChar): Boolean;
function SelectDatabaseEx(var ADataBase: String; CheckCurrent: Boolean): Boolean;
function SelectDatabase(CheckCurrent: Boolean): Boolean;

function VarToIntDef(const V: Variant; const ADefault: Integer): Integer;
function VarToExtendedDef(const V: Variant; const ADefault: Extended): Extended;
function VarToDateDef(const V: Variant; const ADefault: TDateTime): TDateTime;

procedure InvalidKey(S: String);
procedure AddPageHeaders(Document: Variant);
function GetVersion: String;
function CheckDemo: Boolean;
procedure ClearStrings(Strings: TStrings);


implementation

uses UNewControls, UNewForm, UMain, UDocTree, Mcompres, UFind, ULogin,
  UDocReestr, UServerConnect, URBUsers, URBTypeReestr, URBOperation,
  URBMask, URBCase, UProgress, URBMarkCar, USearchReestr, UWorkYear,
  UEnterPeriod, UWorkDate, URBColor, URBConst, URBLicense,
  URBNotarialAction, URBNotarius, USearchDoc, UViewRunService,
  URBHereditaryDeal, URBSubs, URBSubsValue,
  UCheckSum, DsnFunc, URBRuleForElement, URBPeople, URenameTabSheet, DsnUnit,
  UUpdateInfo, UtsvLib, FIOPadeg, WordConst, IBCustomDataSet,
  URBGraphVisit, URBReminder, URBRenovation, SeoClientDataSet, DBClient,
  URBChamber, URBNotary, URBBlanks,
  USelectDatabase;

var
  AnsiCharTypes: array [AnsiChar] of Word;
const
  AnsiSigns          = ['-', '+'];

const
  // CharType return values
  C1_UPPER  = $0001; // Uppercase
  C1_LOWER  = $0002; // Lowercase
  C1_DIGIT  = $0004; // Decimal digits
  C1_SPACE  = $0008; // Space characters
  C1_PUNCT  = $0010; // Punctuation
  C1_CNTRL  = $0020; // Control characters
  C1_BLANK  = $0040; // Blank characters
  C1_XDIGIT = $0080; // Hexadecimal digits
  C1_ALPHA  = $0100; // Any linguistic character: alphabetic, syllabary, or ideographic

{$R *.DFM}

procedure InitAll;
var
  Year,Month,Day: Word;
  DS: TSeoClientDataSet;
  S: string;
  Flag: Boolean;
  FileName: String;
begin
  DecodeDate(Now,Year,Month,Day);
  WorkYear:=Year;
  WorkDate:=Date;
  DayDoverOffset:=-1;

  hkTranslateToUpperCase:=ShortCut(Word('U'),[ssCtrl,ssAlt]);
  hkTranslateToLowerCase:=ShortCut(Word('L'),[ssCtrl,ssAlt]);
  hkTranslateToRussian:=ShortCut(Word('R'),[ssCtrl,ssAlt]);
  hkTranslateToEnglish:=ShortCut(Word('E'),[ssCtrl,ssAlt]);

  FileName:=ChangeFileExt(Application.ExeName,'.db');

  if FileExists(FileName) then begin
    try
      Crypter:=_GetCrypter;
      LocalDb:=TSeoDb.Create(nil);
      LocalDb.Crypter:=Crypter;
      LocalDb.Crypter.Active:=true;
      LocalDb.CipherKey:=SKey;
      LocalDb.Init(FileName);
      DS:=TSeoClientDataSet.Create(nil);
      try
        S:='';
        if LocalDb.ReadParam(SDb_ParamLicense,S) then begin
          DS.XMLData:=S;
          Flag:=false;
          if Ds.Active and not Ds.IsEmpty then begin
            DS.First;
            while not DS.Eof do begin
              if CheckUniqueIdByAdapter(DS.FieldByName('KEY').AsString) then begin
                Flag:=true;
                break;
              end;
              DS.Next;
            end;
          end;
          if not Flag then
            Halt;
        end;
        S:='';
        if LocalDb.ReadParam(SDb_ParamProgramm,S) then begin
          Application.Title:=S;
        end;
      finally
        DS.Free;
      end;
    except
      Halt;
    end;
  end else
    Halt;
end;

procedure DoneAll;
begin
  LocalDb.Done;
  LocalDb.Free;
  Crypter:=nil;
end;

function GetLastNodeID: Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=0;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select Max(typedoc_id) as ID from '+TableTypeDoc;
   qr.Sql.Add(sqls);
   qr.Active:=true;
   Result:=qr.FieldByName('ID').AsInteger;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function GetNodeText(IDNode: Integer): String;
{var
  qr: TQuery;
  sqls: string;}
begin
{  Screen.Cursor:=crHourGlass;
  qr:=TQuery.Create(nil);
  try
   qr.DatabaseName:=DataFolder;
   sqls:='Select name from '+TableNodes+' where id='+inttostr(IDNode);
   qr.Sql.Add(sqls);
   qr.Active:=true;
   Result:=qr.FieldByName('name').AsString;
  finally
   qr.Free;
   Screen.Cursor:=crDefault;
  end;}
end;

procedure ShowError(Handle: THandle; Mess: String);
begin
  MessageDlg(Mess,mtError,[mbYes],-1);

//  MessageBox(Handle,Pchar(Mess),'������',MB_ICONERROR);
end;

procedure ShowInfo(Mess: String);
begin
  MessageDlg(Mess,mtInformation,[mbYes],-1);
end;

function GetListTextObjectFromWord(Form: TForm; FileDoc: String; List: TList; ViewProgress: Boolean=false): Boolean;
var
  W: Variant;

  function GetObjectList: Boolean;
  var
    I: Integer;
    Count: Integer;
    D: Variant;
    F: Variant;
    P1: PFieldQuote;
    fmP: TfmProgress;
    s: string;
  begin
   Screen.Cursor:=crHourGlass;
   try
    SetWordFileName(W.Path);
    Result:=false;
    D:=W.Documents.Open(FileDoc,false,false,false,'','',false,'','',wdOpenFormatAuto);
    Count:=D.Fields.Count;
    fmP:=TfmProgress.Create(nil);
    fmP.Caption:=ConstReadFields;
    fmP.lbProgress.Caption:='';
    fmP.bibBreak.Visible:=false;
    fmP.gag.Position:=0;
    fmP.Visible:=(Count>0) and ViewProgress;
    fmP.Update;
    fmP.FormStyle:=fsStayOnTop;
    try
      for i:=1 to Count do begin
        F:=D.Fields.Item(I);
        s:=F.Result.Text;
        SetPositonAndText(i,Format(fmtRefreshField,[s]),'����:',fmP,Count);
        if F.Type=wdFieldQuote then begin
         new(P1);
         P1.Code:=F.Code.Text;
         P1.Result:=F.Result.Text;
         P1.FieldName:=s;
         P1.ID:=I;
         if (Trim(P1.FieldName)='') then begin
           Dispose(P1);
         end else begin
           AddToWordObjectList(List,P1,wtFieldQuote,'');
         end;
        end;
      end;
    finally
      fmP.Free;
    end;  
    D.Close(wdDoNotSaveChanges,wdOriginalDocumentFormat,false);
    Result:=true;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

  function CreateAndPrepairWord: Boolean;
  begin
   result:=false;
   Screen.Cursor:=crHourGlass;
   try
    try
     VarClear(W);
     W:=CreateOleObject(WordOle);
     Application.MainForm.Update;
     result:=true;
    except
     on E: Exception do begin
        ShowError(Application.Handle,ConstWordFailed);
 //      Application.ShowException(E);
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

  function PrepairWord: Boolean;
  begin
   Screen.Cursor:=crHourGlass;
   try
    try
     CoInitialize(nil);
     W:=GetActiveOleObject(WordOle);
     Application.MainForm.Update;
     result:=true;
    except
     on E: Exception do begin
       if E.Message=MesOperationInaccessible then
        result:=CreateAndPrepairWord
       else if E.Message=MesCallingWasDeclined then
        result:=CreateAndPrepairWord
       else begin
         Result:=False;
         ShowError(Application.Handle,ConstWordFailed);
//         Application.ShowException(E);
       end;
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

begin
  Result:=false;
  if PrepairWord then begin
    result:=GetObjectList;
  end;
end;

function isBadString(S: string): Boolean;
var
  i: Integer;
  ch: char;
const
  badchar='"'; 
begin
  for i:=1 to Length(s) do begin
    ch:=S[i];
    if Pos(ch,badchar)<>0 then begin
     Result:=true;
     exit;
    end;
  end;
  Result:=false;
end;

procedure ClearWordObjectList(List: TList);
var
  I: INteger;
  P: PInfoWordType;
begin
  for i:=0 to List.Count-1 do begin
    P:=List.Items[i];
    case P.WordType of
      wtFieldQuote: begin
        dispose(PFieldQuote(P.PField));
      end;
      wtFieldNone: begin
        dispose(PFieldNone(P.PField));
      end;
    end;
    dispose(P);
  end;
  List.Clear;
end;

function AddToWordObjectList(List: TList; PField: Pointer;
                             WordType: TWordFormType; NameControl: string): Integer;
var
  P: PInfoWordType;
begin
  new(P);
  P.WordType:=WordType;
  P.PField:=PField;
  P.NameControl:=NameControl;
  Result:=List.Add(P); 
end;

function GetNodeSortID(ParentID: Integer): Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=0;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select Max(sort_id) as sort_id from '+TableTypeDoc+
         ' where parent_id='+inttostr(ParentID);
   qr.Sql.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount<>0 then
    Result:=qr.FieldByName('sort_id').AsInteger;
   Result:=Result+1;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure SetNodeSortID(ID,SortID,ParentID: Integer);
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Update '+TableTypeDoc+
         ' set sort_id='+inttostr(SortID)+
         ', parent_id='+inttostr(ParentID)
         +' where typedoc_id='+inttostr(ID);
   qr.Transaction.Active:=true;
   qr.SQL.Add(sqls);
   qr.ExecSQL;
   qr.Transaction.Commit;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure GetNodelistFromLevel(TV: TTreeView; Level: Integer; NdParent: TTreeNode; List: TList);
var
     i: Integer;
     nd: TTreeNode;
begin
     for i:=0 to TV.Items.Count-1 do begin
       nd:=TV.Items.Item[i];
       if (nd.Level=Level)and (nd.Parent=NdParent) then begin
         List.Add(nd);
       end;
     end;
end;

procedure GetSelectedInListView(LV: TListView; List: TList);
var
  I: Integer;
  li: TListItem;
begin
  for i:=0 to LV.Items.Count-1 do begin
    li:=LV.Items.Item[i];
    if Li.Selected then begin
      List.Add(li);
    end;
  end;
end;

procedure UpdateListsParentID(ID,NodeID: Integer);
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Update '+TableDoc+
         ' set typedoc_id='+inttostr(NodeID)
         +' where doc_id='+inttostr(ID);
   qr.SQL.Add(sqls);
   qr.ExecSQL;
   qr.Transaction.Commit;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure FreeAllControlsInControl(ct: TWinControl);
var
  i: Integer;
  ctnew: TControl;
begin
  for i:=ct.ControlCount-1 downto 0 do begin
   ctnew:=ct.Controls[i];
   ctnew.Free;
  end;
end;

procedure FreeAllComponents(ct: TWinControl);
var
  i: Integer;
  ctnew: TComponent;
begin
  for i:=ct.ComponentCount-1 downto 0 do begin
   ctnew:=ct.Components[i];
   ctnew.Free;
  end;
end;

type
  TNewControl=class(TControl)
   published
    property OnMouseDown;
  end;

procedure SetPropAllControls(ct: TNewControl);
var
  i: Integer;
  ctnew: TControl;
begin
   for i:=0 to TWincontrol(ct).ControlCount-1 do begin
    ctnew:=TWincontrol(ct).Controls[i];
    TNewControl(ctnew).OnMouseDown:=TNewControl(ct).OnMouseDown;
    if ctnew is TWincontrol then begin
     SetPropAllControls(TNewControl(ctnew));
    end
   end;
end;

function CreateNewFormFromStream(MsIn: TMemoryStream;
                                 ViewType: TViewType; LiParent: TListItem;
                                 NewName: String=''): TForm;
var
  fm: TfmNewForm;
  Error: Boolean;
begin
  Screen.Cursor:=crHourGlass;
  fm:=TfmNewForm.Create(nil);
  try
   Result:=nil;
   fm.Visible:=false;
//   FreeAllControlsInControl(fm);
   FreeAllComponents(fm);
   Error:=false;
   LoadControlFromStream(fm,msIn,Error);
   if not Error then begin
     fm.DestroyHeaderAndCreateNew;

    // fm.pnDesign.LoadFromStream(MsIn);

     fm.OnKeyDown:=fmMain.OnKeyDown;
     fm.OnKeyPress:=fmMain.OnKeyPress;
     fm.OnKeyUp:=fmMain.OnKeyUp;

     fm.ViewType:=ViewType;

     fm.InitAll;
     if Trim(NewName)<>'' then fm.Caption:=Trim(NewName);
     fm.Position:=poScreenCenter;
     fm.WindowState:=wsMaximized;
     fm.show;
     fm.ChangeFlagNewForm:=false;
     Result:=fm;
   end else
     fm.Free;

  finally
   Screen.Cursor:=crDefault;
  end;
end;

procedure RemoveLinksForm_ListItem(fm: TForm);
begin
  if not Assigned(fmDocTree) then exit;
  NewForm:=nil;
  LastActive:=nil;
end;

procedure SaveNewForm(fm: TForm);
var
  tb: TIBTable;
  msOut: TmemoryStream;
  Plist: PInfoDoc;
  li: TListItem;
  tr: TIBTransaction;
  cdt: TDateTime;
begin
  if not Assigned(fm) then exit;
  li:=fmDocTree.LV.Selected;
  if li=nil then exit;
  Plist:=li.data;
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  tb:=TIBTable.Create(nil);
  msOut:=TmemoryStream.Create;
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   tb.Database:=dm.IBDbase;
   tb.Transaction:=tr;
   tb.Transaction.Active:=true;
   tb.TableName:=TableDoc;
   tb.Active:=true;
   if tb.RecordCount<>0 then begin
     fm.Visible:=false;
     SaveControlToStream(fm,msOut);
//     ExtractFormToFile(msOut,'c:\1.txt');
     msOut.Position:=0;
     CompressAndCrypt(msOut);
     msOut.Position:=0;
     tb.Locate('doc_id',Plist.ID,[loCaseInsensitive]);
     tb.Edit;
     TBlobField(tb.FieldByName('DataForm')).LoadFromStream(msOut);
     tb.Post;
     tb.Transaction.Commit;
     SetCurrentDateTimeToDoc(Plist.ID,cdt);
     li.SubItems[3]:=DateTimeToStr(cdt);
   end;
  finally
   msOut.Free;
   tb.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;

end;

type
   TSampleWriter=class(TObject)
     private
      procedure WriterOnFindAncestor(Writer: TWriter; Component: TComponent;
                                     const Name: string; var Ancestor, RootAncestor: TComponent);
   end;

procedure TSampleWriter.WriterOnFindAncestor(Writer: TWriter; Component: TComponent;
            const Name: string; var Ancestor, RootAncestor: TComponent);
begin
  if Component is TBoundLabel then  begin
    Ancestor:=Component;
  end;
end;

procedure SaveControlToStream(ct: TControl; msOut: TMemoryStream);
var
 wr: TWriter;
 s: TSampleWriter;
begin
 s:=TSampleWriter.Create;
 wr:=TWriter.create(msOut,4096);
 try
   wr.OnFindAncestor:=s.WriterOnFindAncestor;
   wr.WriteRootComponent(ct);
 finally
  wr.Free;
  s.free;
 end;
end;

procedure LoadControlFromStream(ct: TControl; msOut: TMemoryStream; var Error: Boolean);
var
 rd: TReader;
begin
  try
   rd:=TReader.create(msOut,4096);
   try
    rd.ReadRootComponent(ct);
   finally
    rd.Free;
   end;
  except
    on E: Exception do begin
      Error:=true;
      InvalidKey(E.Message);
    end;
  end;
end;

procedure CompressAndCrypt(MsOut: TMemoryStream);
var
  cm: TMCompress;
  ms: TmemoryStream;
  S: string;
  OldVersion: Boolean;
begin
  OldVersion:=false;
  Screen.Cursor:=crHourGlass;
  cm:=TMCompress.Create(nil);
  ms:=TmemoryStream.Create;
  try
   MsOut.Position:=0;
   ms.CopyFrom(MsOut,MsOut.Size);
   ms.Position:=0;
   MsOut.Clear;
   MsOut.Position:=0;
   if OldVersion then begin
     cm.Compress(msOut,ms,coLZH5);
   end else begin
     S:='';
     if LocalDb.ReadParam(SDb_ParamKey,S) then begin
       msOut.CopyFrom(ms,ms.Size);
       msOut.Position:=0;
       Crypter.EncodeStream(S,msOut,DefaultCipherAlgorithm,DefaultCipherMode);
     end;
   end;
  finally
   ms.Free;
   cm.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure DestroyClasses;
var
  i: Integer;
  P: PInfoClass;
begin
  for i:=0 to ListClasses.Count-1 do begin
    P:=ListClasses.Items[i];
    dispose(P);
  end;
  ListClasses.Clear;
end;


function ExtractFormOrDocFile(LV: TListView; Form: Boolean; FileDoc: String): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  li: TListItem;
  PList: PInfoDoc;
  msIn: TmemoryStream;
  tr: TIBTransaction;
begin
  Result:=false;
  li:=LV.Selected;
  if li=nil then exit;
  PList:=li.data;

  if IsBadCodePtr(PList) then exit;
  if Form then begin
   if (NewForm<>nil)and(LastID<>PList.ID) then begin
     NewForm.Close;
     NewForm:=nil;
   end;
   if NewForm=nil then begin
    LastID:=PList.ID;
    Screen.Cursor:=crHourGlass;
    msIn:=TmemoryStream.Create;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select * from '+TableDoc+' where doc_id='+inttostr(PList.ID);
     qr.SQL.Add(sqls);
     qr.Active:=true;
     TBlobField(qr.fieldByName('DataForm')).SaveToStream(msIn);
     msIn.Position:=0;
     ExtractObjectFromStream(msIn);
     msIn.Position:=0;
     NewForm:=CreateNewFormFromStream(msIn,fmMain.ViewType,li,qr.fieldByName('name').AsString);
     if NewForm is TfmNewForm then begin
       TfmNewForm(NewForm).LastDocId:=PList.ID;
       TfmNewForm(NewForm).RenovationId:=PList.RenovationID;
     end;
     Result:=true;
    finally
     qr.Free;
     tr.Free;
     msIn.Free;
     Screen.Cursor:=crdefault;
    end;
   end else begin
     if Assigned(NewForm)and(NewForm<>nil) then begin
      NewForm.WindowState:=wsNormal;
      NewForm.BringToFront;
     end;
   end;
  end else begin
    Screen.Cursor:=crHourGlass;
    msIn:=TmemoryStream.Create;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select * from '+TableDoc+' where doc_id='+inttostr(PList.ID);
     qr.SQL.Add(sqls);
     qr.Active:=true;
     TBlobField(qr.fieldByName('DataDoc')).SaveToStream(msIn);
     msIn.Position:=0;
     ExtractObjectFromStream(msIn);
     msIn.Position:=0;
     msIn.SaveToFile(FileDoc);
     Result:=true;
    finally
     qr.Free;
     tr.Free;
     msIn.Free;
     Screen.Cursor:=crdefault;
    end;
  end;
end;

procedure ExtractObjectFromStream(msIn: TMemoryStream);
var
  cm: TMCompress;
  ms: TmemoryStream;
  OldVersion: Boolean;
  S: string;
const
  OldHead='FORM';
begin
  Screen.Cursor:=crHourGlass;
  cm:=TMCompress.Create(nil);
  ms:=TmemoryStream.Create;
  try
   MsIn.Position:=0;
   ms.CopyFrom(MsIn,MsIn.Size);
   if ms.Size>0 then begin
     SetLength(S,4);
     ms.Position:=0;
     ms.Read(Pointer(S)^,4);
     OldVersion:=AnsiSameText(OldHead,S);
     ms.Position:=0;
     MsIn.Clear;
     MsIn.Position:=0;
     if OldVersion then
       cm.Expand(MsIn,ms)
     else begin
       S:='';
       if LocalDb.ReadParam(SDb_ParamKey,S) then begin
         MsIn.CopyFrom(ms,ms.Size);
         MsIn.Position:=0;
         Crypter.DecodeStream(S,MsIn,DefaultCipherAlgorithm,DefaultCipherMode);
       end;  
     end;  
   end;
  finally
   ms.Free;
   cm.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure FindOnListView(LV: TListView);
begin
  fmFind.isInListView:=true;
  fmFind.lv:=LV;
  fmFind.OldLVMultiSelect:=LV.MultiSelect;
  fmFind.show;
end;

procedure FindOnTreeView(TV: TTreeView; fm: TForm);
begin
  fmFind.isInListView:=false;
  fmFind.TV:=TV;
  fmFind.fmTV:=fm;
  fmFind.show;
end;

procedure ClearReestrForms;
var
  i: Integer;
  fm: TForm;
begin
  for i:=ListReestrForms.Count-1 downto 0 do begin
   fm:=ListReestrForms.Items[i];
   fm.Free;
  end;
end;

procedure ClearListMenuItems;
var
  i: Integer;
  P: PInfoMenu;
begin
  for i:=0 to ListMenuItems.Count-1 do begin
    P:=ListMenuItems.Items[i];
    dispose(P);
  end;
  ListMenuItems.Clear;
end;

function isLinkOnReestr(IDList,IDNode: Integer; forList: Boolean): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=false;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   if forList then
    sqls:='Select count(*)as num from '+TableReestr+' tr join '+
          TableDoc+' td on tr.doc_id=td.doc_id  where tr.doc_id='+inttostr(IDList)
   else
    sqls:='Select count(*)as num from '+TableReestr+' tr join '+
          TableDoc+' td on tr.doc_id=td.doc_id join '+
          TableTypeDoc+' ttd on td.typedoc_id=ttd.typedoc_id '+
         ' where td.typedoc_id='+inttostr(IDNode);
   qr.sql.Add(sqls);
   qr.Active:=true;
   if qr.FieldByname('num').AsInteger<>0 then
    Result:=true;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function isLinkOnReestrNew: Boolean;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=false;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select typedoc_id from '+TableTypeDoc;
   qr.sql.Add(sqls);
   qr.Active:=true;
   qr.First;
   while not qr.Eof do begin
    if isLinkOnReestr(0,qr.FieldByName('typedoc_id').AsInteger,false) then begin
      result:=true;
      exit;
    end;
    qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function isNewControl(ct: TControl): Boolean;
var
  i: Integer;
  P: PInfoClass;
begin
  Result:=false;
  for I:=0 to ListClassesForWord.Count-1 do begin
    P:=ListClassesForWord.Items[i];
    if P.TypeClass=ct.ClassType then begin
      Result:=true;
      exit;
    end;
  end;
end;

function GetStringInQuote(Value: string): String;
var
  pos1,pos2: Integer;
  tmps: string;
const
  instr='"';
begin
  Result:=value;
  tmps:=value;
  pos1:=Pos(instr,tmps);
  if pos1=0 then exit;
  tmps:=Copy(tmps,pos1+1,Length(tmps)-pos1);
  pos2:=Pos(instr,tmps);
  if pos2=0 then exit;
  Result:=Copy(tmps,1,pos2-1);
end;

procedure GetWordsByDocument(D: Variant; Words: TStringList; ViewProgress: Boolean=true);
var
  WdCount: Integer;
  Str: TStringList;
  S: string;
  i,t: Integer;
begin
  WdCount:=D.Words.Count;
  Screen.Cursor:=crHourGlass;
  t:=fmProgress.bibBreak.Top;
  if ViewProgress then begin
    fmProgress.gag.Position:=0;
    fmProgress.Caption:='���������� ������ ����...';
    fmProgress.lbProgress.Caption:='�����: ';
    fmProgress.Visible:=ViewProgress;
    fmProgress.Update;
    fmProgress.bibBreak.Top:=1000;
    fmProgress.bibBreak.Enabled:=false;
    fmProgress.gag.Max:=WdCount;
  end;
  Str:=TStringList.Create;
  try
    for i:=1 to WdCount do begin
      S:=D.Words.Item(i).Text;
      S:=Trim(S);
      if S<>'' then
        if Str.IndexOf(S)=-1 then
          Str.Add(S);
      if ViewProgress then
        SetPositonAndText(i,S,'�����: ',nil,WdCount);
    end;
    Words.Assign(Str);
  finally
    Str.Free;
    if ViewProgress then begin
      fmProgress.bibBreak.Top:=t;
      fmProgress.bibBreak.Enabled:=true;
      fmProgress.Visible:=false;
    end;
    Screen.Cursor:=crDefault;
  end;
end;

procedure GetTextByDocument(D: Variant; Text: TStringList);
var
  FileTxt: string;
  DocName: string;
  Str: TStringList;
begin
  DocName:=D.FullName;
  FileTxt:=DocName+'.txt';
  D.SaveAs(FileName:=FileTxt,FileFormat:=wdFormatText);
  D.Close(SaveChanges:=false);
  Str:=TStringList.Create;
  try
    Str.LoadFromFile(FileTxt);
    Text.Assign(Str);
    DeleteFile(FileTxt);
  finally
    Str.Free;
  end;
end;

function SetFieldsToWord(List: TList; Active,OnlyView: Boolean; AutoFormat: Boolean=true): Boolean;
var
  W: Variant;

  function GetInfoWordType(WFT: TWordFormType; Value: String): PInfoWordType;
  var
    i: Integer;
    P: PInfoWordType;
  begin
    Result:=nil;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      if P.WordType=WFT then begin
       case P.WordType of
         wtFieldQuote: begin
           if AnsiUpperCase(PFieldQuote(P.PField).FieldName)=AnsiUpperCase(GetStringInQuote(Value)) then begin
             Result:=P;
             exit;
           end;
         end;
       end;
      end;
    end;
  end;

  function SetObjectList: Boolean;
  var
    I: Integer;
    Count: Integer;
    D: Variant;
    F: Variant;
    P: PInfoWordType;
    filename: string;
    tmps: WideString;
    laststr: string;
    p1,p2: Integer;
    Range,Style: Variant;
    t: Integer;
  begin
    Screen.Cursor:=crHourGlass;
    t:=0;
    try
     SetWordFileName(W.Path);
     Result:=false;
     Filename:=lastFileDoc;
     t:=fmProgress.bibBreak.Top;
     D:=W.Documents.Open(Filename,false,false,false,'','',false,'','',wdOpenFormatAuto);

     if not OnlyView then begin
      fmProgress.gag.Position:=0;
      fmProgress.Caption:='������������...';
      fmProgress.lbProgress.Caption:='����: ';
      fmProgress.Visible:=true;
      fmProgress.Update;
      fmProgress.bibBreak.Top:=1000;
      fmProgress.bibBreak.Enabled:=false;
      
      D.Fields.Update;
      Count:=D.Fields.Count;
      fmProgress.gag.Max:=Count;
      for i:=1 to Count do begin
       try
        F:=D.Fields.Item(I);
        if F.Type=wdFieldQuote then begin
         P:=GetInfoWordType(wtFieldQuote,F.Code);
         if P<>nil then begin

           tmps:=PFieldQuote(P.PField).Result;
           if i=1 then begin
            if Length(tmps)<>0 then
             tmps[1]:=WideUpperCase(tmps[1])[1];
           end;
          
           F.Result.Text:=tmps;
           if Trim(tmps)<>'' then begin
             if PFieldQuote(P.PField).AutoFormat then begin
               p1:=F.Result.Start;
               p2:=F.Result.End;
               Range:=D.Range(p1,p2);
               Range.AutoFormat;
             end;
             if Trim(PFieldQuote(P.PField).Style)<>'' then begin
              try
                F.Result.Select;
                Style:=D.Styles.Item(Trim(PFieldQuote(P.PField).Style));
                W.Selection.Style:=Style;
              except
              end;
             end;
           end;
           laststr:=tmps;

//           Application.ProcessMessages;  Exception ??????????
           if BreakAnyProgress then break;
           SetPositonAndText(i,PFieldQuote(P.PField).FieldName,'����: ',nil,Count);

         end;
        end;
       except
         ShowError(Application.Handle,'��������� ������������ ��������������� ��������� (���� � '+inttostr(i)+').');
       end;
      end;


      AddPageHeaders(D);

      W.Selection.Start:=0;
      W.Selection.End:=0;
      D.ActiveWindow.ActivePane.VerticalPercentScrolled:=0;
      W.Documents.Save(true);
     end;
     Result:=true;
    finally
     fmProgress.bibBreak.Top:=t;
     fmProgress.bibBreak.Enabled:=true;
     fmProgress.Visible:=false;
     Screen.Cursor:=crDefault;
    end;

  end;

  function CreateAndPrepairWord: Boolean;
  begin
   result:=false;
   Screen.Cursor:=crHourGlass;
   try
    try
     VarClear(W);
     W:=CreateOleObject(WordOle);
     Application.Mainform.Update;
   //  W.PrintPreview:=true;
{     if Active then begin
      W.Visible:=true;
      W.Activate;
      W.WindowState:=wdWindowStateMaximize;
     end;}
     result:=true;
    except
     on E: Exception do begin
         ShowError(Application.Handle,ConstWordFailed);
//       Application.ShowException(E);
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

  function PrepairWord: Boolean;
  begin
   Screen.Cursor:=crHourGlass;
   try
    try
     CoInitialize(nil);

     W:=GetActiveOleObject(WordOle);
     Application.Mainform.Update;
     //W.PrintPreview:=true;
{     if Active then begin
      W.Visible:=true;
      W.Activate;
      W.WindowState:=wdWindowStateMaximize;
     end;}
     result:=true;
    except
     on E: Exception do begin
       if E.Message=MesOperationInaccessible then
        result:=CreateAndPrepairWord
       else if E.Message=MesCallingWasDeclined then
        result:=CreateAndPrepairWord
       else begin
         Result:=False;
         ShowError(Application.Handle,ConstWordFailed);
//         Application.ShowException(E);
       end;
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

  function SaveNewFile: Boolean;
  begin
    result:=false;
  end;
  
begin
  Result:=false;
  if PrepairWord then begin
    result:=SetObjectList;
    if Active then begin
      W.Visible:=true;
      W.Activate;
      W.Visible:=true;
      W.WindowState:=wdWindowStateMaximize;
    end;
  end;
end;

function ExtractDocFile(IDList: Integer; FIO: String): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  msIn: TmemoryStream;
  tmps: string;
  fiostr,datestr,timestr: string;
  tr: TIBTransaction;
begin
    Screen.Cursor:=crHourGlass;
    msIn:=TmemoryStream.Create;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     result:=false;
     if not DirectoryExists(TempDocFilePath) then
      CreateDir(TempDocFilePath);
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select DataDoc,name from '+TableDoc+' where doc_id='+inttostr(IDList);
     qr.SQL.Add(sqls);
     qr.Active:=true;
     TBlobField(qr.fieldByName('DataDoc')).SaveToStream(msIn);
     msIn.Position:=0;
     ExtractObjectFromStream(msIn);
     msIn.Position:=0;
     fiostr:=FIO;
     timestr:=FormatDateTime(fmtFileTime,WorkDate);
     datestr:=FormatDateTimeTSV(fmtDateLong,WorkDate);
     tmps:=qr.FieldByname('name').AsString+' '+
            fiostr+' ('+timestr+', ' +datestr+').doc';
     lastFileDoc:=GetUniqueFileName(TempDocFilePath+'\'+tmps,0);
     msIn.SaveToFile(lastFileDoc);
     Result:=true;
    finally
     qr.Free;
     tr.Free;
     msIn.Free;
     Screen.Cursor:=crdefault;
    end;
end;

function ExtractDocFileFromReestr(ReestrId: Integer; FIO: String): Boolean;
var
  qr: TIBQuery;
  sqls: string;
  msIn: TmemoryStream;
  tmps: string;
  fiostr,datestr,timestr: string;
  tr: TIBTransaction;
begin
    Screen.Cursor:=crHourGlass;
    msIn:=TmemoryStream.Create;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     result:=false;
     if not DirectoryExists(TempDocFilePath) then
      CreateDir(TempDocFilePath);
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select tmpname,datadoc from '+TableReestr+' where reestr_id='+inttostr(ReestrID);
     qr.SQL.Add(sqls);
     qr.Active:=true;
     TBlobField(qr.fieldByName('DataDoc')).SaveToStream(msIn);
     msIn.Position:=0;
     ExtractObjectFromStream(msIn);
     msIn.Position:=0;
     fiostr:=FIO;
     timestr:=FormatDateTime(fmtFileTime,WorkDate);
     datestr:=FormatDateTimeTSV(fmtDateLong,WorkDate);
     tmps:=qr.FieldByname('tmpname').AsString+' '+
            fiostr+' ('+timestr+', ' +datestr+').doc';
     lastFileDoc:=GetUniqueFileName(TempDocFilePath+'\'+tmps,0);
     msIn.SaveToFile(lastFileDoc);
     Result:=true;
    finally
     qr.Free;
     tr.Free;
     msIn.Free;
     Screen.Cursor:=crdefault;
    end;
end;

function RemoveNotFileNameChar(FileName: string): string;
var
  i: Integer;
const
  Fuck: set of char = ['/','\','"','?','*','<','>',':','|'];
begin
  Result:='';
  for i:=1 to Length(FileName) do begin
    if not (FileName[i] in Fuck) then begin
      Result:=Result+FileName[i];
    end;
  end;
end;

function GetUniqueFileName(DocFile: String; Incr: Integer): string;
var
  str: string;
  ext: string;
  hFile: THandle;
begin
 DocFile:=ExtractFilePath(DocFile)+RemoveNotFileNameChar(ExtractFileName(DocFile));
 result:=DocFile;
 if FileExists(DocFile) then begin
  hFile:=0;
  try
    hFile := FileOpen(DocFile, fmOpenReadWrite);
    if hFile = INVALID_HANDLE_VALUE then begin
     Result:=Copy(DocFile,1,Length(DocFile)-4);
     ext:=Copy(DocFile,Length(DocFile)-3,Length(DocFile));
     inc(Incr);
     str:=inttostr(Incr);
     Result:=GetUniqueFileName(Result+str+ext,Incr);
    end; 
  finally
   CloseHandle(HFile);
  end;
 end;
end;

procedure PackTables(FmHandle: THandle; ViewMess: Boolean);

 procedure PackTable(Table: TTable);
 var
  Props: CURProps;
  hDb: hDBIDb;
  TableDesc: CRTblDesc;
 begin
  if not Table.Exclusive then exit;
  Check(DbiGetCursorProps(Table.Handle, Props));
  if Props.szTableType = szPARADOX then begin
    FillChar(TableDesc, sizeof(TableDesc), 0);
    Check(DbiGetObjFromObj(hDBIObj(Table.Handle), objDATABASE, hDBIObj(hDb)));
    StrPCopy(TableDesc.szTblName, Table.TableName);
    StrPCopy(TableDesc.szTblType, Props.szTableType);
    TableDesc.bPack := True;
    Table.Close;
    Check(DbiDoRestructure(hDb, 1, @TableDesc, nil, nil, nil, False));
  end else begin
    if (Props.szTableType = szDBASE) then
      Check(DbiPackTable(Table.DBHandle, Table.Handle, nil, szDBASE, True));
  end;    
 end;
 
{var
 tb: TTable;}
begin
{ tb:=TTable.Create(nil);
 Screen.Cursor:=crHourGlass;
 try
  tb.DatabaseName:=DataFolder;
  tb.Exclusive:=true;
  tb.Active:=false;
  tb.TableName:=TableNodes;
  tb.Active:=true;
  PackTable(tb);

  tb.Active:=false;
  tb.TableName:=TableLists;
  tb.Active:=true;
  PackTable(tb);

  tb.Active:=false;
  tb.TableName:=TableReestr;
  tb.Active:=true;
  PackTable(tb);

  tb.Active:=false;
  tb.TableName:=TableMasks;
  tb.Active:=true;
  PackTable(tb);

  tb.Active:=false;
  tb.TableName:=TableUsers;
  tb.Active:=true;
  PackTable(tb);

  if ViewMess then
   MessageBox(FmHandle,Pchar('������� ���������.'),'����������',MB_ICONINFORMATION);
 finally
  tb.Free;
  Screen.Cursor:=crDefault;
 end;}
end;

function isEmptyControl(ct: TControl): Boolean;
begin
   result:=true;
   if ct is TNewLabel then
    result:=Trim(TNewLabel(ct).Caption)='';
   if ct is TNewEdit then
    result:=Trim(TNewEdit(ct).Text)='';
   if ct is TNewComboBox then
    result:=Trim(TNewComboBox(ct).Text)='';
   if ct is TNewMemo then
    result:=Trim(TNewMemo(ct).Lines.Text)='';
   if ct is TNewCheckBox then
    result:=Trim(TNewCheckBox(ct).Caption)='';
   if ct is TNewListBox then begin
      if TNewListBox(ct).ItemIndex<>-1 then
         Result:=Trim(TNewListBox(ct).Items.Strings[TNewListBox(ct).ItemIndex])='';
   end;
   if ct is TNewRadioGroup then begin
      if TNewRadioGroup(ct).ItemIndex<>-1 then
          Result:=Trim(TNewRadioGroup(ct).Items.Strings[TNewRadioGroup(ct).ItemIndex])='';
   end;
   if ct is TNewMaskEdit then begin
      Result:=Trim(TNewMaskEdit(ct).Text)='';
   end;
   if ct is TNewRichEdit then begin
      Result:=Trim(TNewRichEdit(ct).Lines.Text)='';
   end;
   if ct is TNewDateTimePicker then begin
     result:=false;
   end;
   if ct is TNewRXCalcEdit then begin
     result:=false;
   end;
   if ct is TNewRXDateEdit then begin
     result:=Trim(TNewRXDateEdit(ct).Text)='';
   end;
   if ct is TNewComboBoxMarkCar then
     result:=Trim(TNewComboBoxMarkCar(ct).Text)='';
   if ct is TNewComboBoxColor then
     result:=Trim(TNewComboBoxColor(ct).Text)='';

end;

procedure DragDropFromDocTree(LVSource: TListView);
var
  msOutForm: TMemoryStream;
  fmNew: TfmNewForm;
  PList: PInfoDoc;
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  ListControls: TList;
  i: Integer;
  dt: TDateTime;
  Error: Boolean;
//  PReestr: PInfoReestr;
//  tb: TTable;
begin
     PlIst:=LVSource.Selected.Data;
     if Plist=nil then exit;
     fmNew:=TfmNewForm.Create(nil);
     msOutForm:=TMemoryStream.Create;
     tr:=TIBTransaction.Create(nil);
     qr:=TIBQuery.Create(nil);
     try
      Screen.Cursor:=crHourGlass;
      try
       tr.AddDatabase(dm.IBDbase);
       dm.IBDbase.AddTransaction(tr);
       tr.Params.Text:=DefaultTransactionParamsTwo;
       qr.Database:=dm.IBDbase;
       qr.Transaction:=tr;
       qr.Transaction.Active:=true;
       sqls:='Select * from '+TableDoc+' where doc_id='+inttostr(PList.ID);
       qr.SQL.Add(sqls);
       qr.Active:=true;
       TBlobField(qr.fieldByName('DataForm')).SaveToStream(msOutForm);
       msOutForm.Position:=0;
       ExtractObjectFromStream(msOutForm);
       msOutForm.Position:=0;

       FreeAllComponents(fmNew);
       Error:=false;
       LoadControlFromStream(fmNew,msOutForm,Error);

       if not Error then begin

         fmNew.DestroyHeaderAndCreateNew;

         fmNew.RenovationID:=PList.RenovationID;
         fmNew.InitAll;
         fmNew.Caption:=captionAdd+' �������� <'+LVSource.Selected.Caption+'>';
         fmNew.SummEdit.Value:=iff(VarIsNull(qr.fieldByName('summ').Value),0.0,qr.fieldByName('summ').Value);
         fmNew.OnKeyDown:=fmMain.OnKeyDown;
         fmNew.OnKeyPress:=fmMain.OnKeyPress;
         fmNew.OnKeyUp:=fmMain.OnKeyUp;
         fmNew.ViewType:=vtEdit;
         fmNew.ViewType:=vtView;
         fmNew.bibOk.OnClick:=fmNew.bibOkClickAppend;
         fmNew.bibCancel.OnClick:=fmNew.bibCancelClickAppend;
         fmNew.bibOtlogen.OnClick:=fmNew.bibOtlogenClickAppend;
         fmNew.edDocname.Text:=Trim(LVSource.Selected.Caption);
         dt:=SysUtils.StrToDate(DateToStr(WorkDate))+SysUtils.Time;
         fmNew.dtpCertificateDate.DateTime:=dt;
         fmNew.isCreateReestr:=true;
         fmNew.DefLastTypeReestrID:=fmDocReestr.LastTypeReestrID;
         fmNew.LastTypeReestrID:=fmDocReestr.LastTypeReestrID;
         fmNew.LastDocId:=PList.ID;
         fmNew.isInsert:=false;
         fmNew.isKeepDoc:=KeepDoc;

         fmNew.FillAllNeedFieldForAppend;
         fmNew.FillReminders;
         fmNew.PrepeareControlsAfterLoad(fmNew.pnDesign);

         ListControls:=TList.Create;
         GetControlByPropValue(fmNew,'Checked',false,ListControls);
         try

           fmNew.FormStyle:=fsMDIChild;
  //         fmNew.PrepeareControlsAfterLoad(fmNew.pnDesign);
           fmNew.WindowState:=wsMaximized;
           fmNew.LocateFirstFocusedControl;

         finally
           for i:=0 to ListControls.Count-1 do begin
             if TControl(ListControls.Items[i]) is TDateTimePicker then begin
               TDateTimePicker(ListControls.Items[i]).Checked:=false;
             end;
           end;
           ListControls.Free;
         end;
       end else
         fmNew.Free;


      finally
       Screen.Cursor:=crDefault;
      end;
    finally

     msOutForm.Free;
     qr.Free;
     tr.Free;
    end;
end;

function TranslateStream(ms: TStream; Crypt: Boolean): String;
var
  i: Integer;
  b: byte;
  tmps: string;
begin
  for i:=0 to ms.Size-1 do begin
    if Crypt then begin
      ms.Read(b,1);
      ms.Position:=ms.Position-1;
      if Odd(i) then begin
        b:=b+20;
      end else begin
        b:=b-20;
      end;
      ms.Write(b,1);
    end else begin
      ms.Read(b,1);
      if Odd(i) then begin
        b:=b-20;
      end else begin
        b:=b+20;
      end;            
    end;
    tmps:=tmps+char(b);
  end;
  result:=tmps;
end;

function CheckStream(ms: TStream; InPass: String): Boolean;
begin
  result:=inPass=TranslateStream(ms,false);
end;

function TranslatePass(InPass: string; Crypt: Boolean): String;
var
  i: Integer;
  b: byte;
  tmps: string;
begin
  result:=InPass;
  for i:=1 to Length(Inpass) do begin
    b:=byte(inPass[i]);
    if Crypt then begin
      if Odd(i) then begin
        b:=b+20;
      end else begin
        b:=b-20;
      end;
    end else begin
      if Odd(i) then begin
        b:=b-20;
      end else begin
        b:=b+20;
      end;
    end;
    tmps:=tmps+char(b);
  end;
  result:=tmps;
end;

function GetIniFileName: String;
var
  s: string;
begin
  if not FileExists(FConfigFileName) then begin
    s:=GetWinDir+'\'+ExtractFileName(AppliCation.ExeName);
    Delete(s,Length(s)-3,4);
    s:=s+'.ini';
    result:=s;
  end else begin
    Result:=FConfigFileName;
  end;
end;

procedure SaveToIni;
var
  fi: TIniFile;
  i: Integer;
  tmps: string;

   procedure SaveHotKey;
   begin
     fi.WriteInteger('HotKeys','hkUpperCase',hkTranslateToUpperCase);
     fi.WriteInteger('HotKeys','hkLowerCase',hkTranslateToLowerCase);
     fi.WriteInteger('HotKeys','hkToRussian',hkTranslateToRussian);
     fi.WriteInteger('HotKeys','hkToEnglish',hkTranslateToEnglish);
   end;

begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.WriteString('Main','UserName',UserName);
    fi.WriteString('Main','DataBaseName',DataBaseName);
    fi.WriteBool('Main','isClearTempDir',isClearTempDir);
    fi.WriteBool('Main','isBackUpFirst',isBackUpFirst);
    fi.WriteBool('Main','isBackUpLast',isBackUpLast);
    fi.WriteBool('Main','isBackUpTime',isBackUpTime);
    fi.WriteInteger('Main','BackUpTime',BackUpTime);
    fi.WriteInteger('Main','BackUpFreeze',BackUpFreeze);
    fi.WriteInteger('Main','RestoreSleep',RestoreSleep);

    fi.WriteString('Main','FileHelp',FileHelp);
//    fi.WriteInteger('Main','WorkYear',WorkYear);
//    fi.WriteDate('Main','WorkDate',WorkDate);
    fi.WriteBool('Main','KeepDoc',KeepDoc);
    fi.WriteBool('Main','isCloseWord',isCloseWord);
    fi.WriteInteger('Main','LastHelperIndex',LastHelperIndex);
//    fi.WriteBool('Main','QuestionOnAddToReestr',QuestionOnAddToReestr);
    fi.WriteInteger('Main','LastNotarialActionId',LastNotarialActionId);


    if fmMain.WindowState<>wsMaximized then begin
      fi.WriteInteger('Main','Width',fmMain.Width);
      fi.WriteInteger('Main','Height',fmMain.Height);
      fi.WriteInteger('Main','Left',fmMain.Left);
      fi.WriteInteger('Main','Top',fmMain.Top);
    end;


    fi.WriteInteger('Main','tlbMainWidth',fmMain.tlbMain.Width);
    fi.WriteInteger('Main','tlbMainHeight',fmMain.tlbMain.Height);
    fi.WriteInteger('Main','tlbMainLeft',fmMain.tlbMain.Left);
    fi.WriteInteger('Main','tlbMainTop',fmMain.tlbMain.Top);
    fi.WriteBool('Main','tlbMainFloat',fmMain.tlbMain.Floating);
    fi.WriteBool('Main','tlbMainVisible',fmMain.tlbMain.Visible);

    fi.WriteString('Main','DefaultBackUpDir',DefaultBackUpDir);



    if Assigned(fmFind) then begin
      for i:=0 to fmFind.cbFindStr.Items.Count-1 do begin
        tmps:='Params'+inttostr(I+1);
        fi.WriteString('Search',tmps,fmFind.cbFindStr.Items.Strings[i]);
      end;
    end;

    if Assigned(fmDocReestr) then begin
      fi.WriteInteger('DocReestr','LastIndexTypeReestr',fmDocReestr.LastIndex);
      fi.WriteInteger('DocReestr','LastIndexPageReestr',fmDocReestr.pgReestr.ActivePageIndex);
    end;

    if Assigned(fmDocTree) then begin
      fi.WriteInteger('DocTree','View',fmDocTree.GetCheckedView);
      fi.WriteInteger('DocTree','Document',fmDocTree.GetCheckedDocument);
    end;

    fi.WriteBool('Main','isViewDateInListView',isViewDateInListView);
    fi.WriteBool('Main','isViewCheckSumInListView',isViewCheckSumInListView);
    fi.WriteBool('Main','isViewPath',isViewPath);
    fi.WriteBool('Main','isSaveDocumentOnView',isSaveDocumentOnView);
    fi.WriteBool('Main','isRefreshFormOnDocumentLoad',isRefreshFormOnDocumentLoad);
    fi.WriteBool('Main','isDeleteQuiteInReestr',isDeleteQuiteInReestr);
    fi.WriteBool('Main','isViewDeleteQuiteInReestr',isViewDeleteQuiteInReestr);
    fi.WriteInteger('Main','DayDoverOffset',DayDoverOffset);
    fi.WriteBool('Main','isDisableDefaultOnForm',isDisableDefaultOnForm);
    fi.WriteBool('Main','isViewUpdateInfo',isViewUpdateInfo);
    fi.WriteString('Main','UpdateInfoFile',UpdateInfoFile);
    fi.WriteBool('Main','isViewHintOnFocus',isViewHintOnFocus);
    fi.WriteBool('Main','isViewReminder',isViewReminder);
    fi.WriteBool('Main','isAutoBuildWords',isAutoBuildWords);
    fi.WriteBool('Main','isViewWhoCert',isViewWhoCert);
    fi.WriteBool('Main','isDocumentLock',isDocumentLock);
    fi.WriteBool('Main','isNotViewHereditaryDeal',isNotViewHereditaryDeal);
    fi.WriteBool('Main','isExpandConst',isExpandConst);
    fi.WriteBool('Main','isQuestionBackup',isQuestionBackup);
    fi.WriteBool('Main','isSelectDatabase',isSelectDatabase);
    fi.WriteBool('Main','isCheckEmptySumm',isCheckEmptySumm);




    SaveHotKey;
  finally
   fi.free;
  end;
 except
 end;
end;

procedure LoadFromIni;
var
  fi: TIniFile;

  procedure LoadHotKey;
  begin
     hkTranslateToUpperCase:=fi.ReadInteger('HotKeys','hkUpperCase',hkTranslateToUpperCase);
     hkTranslateToLowerCase:=fi.ReadInteger('HotKeys','hkLowerCase',hkTranslateToLowerCase);
     hkTranslateToRussian:=fi.ReadInteger('HotKeys','hkToRussian',hkTranslateToRussian);
     hkTranslateToEnglish:=fi.ReadInteger('HotKeys','hkToEnglish',hkTranslateToEnglish);
     RegisterAllHotKeys;
  end;

begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
    UserName:=fi.ReadString('Main','UserName',UserName);
    DataBaseName:=fi.ReadString('Main','DataBaseName',DataBaseName);
    isClearTempDir:=fi.ReadBool('Main','isClearTempDir',isClearTempDir);

    isBackUpFirst:=fi.ReadBool('Main','isBackUpFirst',isBackUpFirst);
    isBackUpLast:=fi.ReadBool('Main','isBackUpLast',isBackUpLast);
    isBackUpTime:=fi.ReadBool('Main','isBackUpTime',isBackUpTime);
    BackUpTime:=fi.ReadInteger('Main','BackUpTime',BackUpTime);
    BackUpFreeze:=fi.ReadInteger('Main','BackUpFreeze',BackUpFreeze);
    RestoreSleep:=fi.ReadInteger('Main','RestoreSleep',RestoreSleep);

    FileHelp:=fi.ReadString('Main','FileHelp',FileHelp);

//    WorkYear:=fi.ReadInteger('Main','WorkYear',WorkYear);
//    WorkDate:=fi.ReadDate('Main','WorkDate',WorkDate);
    KeepDoc:=fi.ReadBool('Main','KeepDoc',KeepDoc);
    isCloseWord:=fi.ReadBool('Main','isCloseWord',isCloseWord);
    LastHelperIndex:=fi.ReadInteger('Main','LastHelperIndex',LastHelperIndex);
//    QuestionOnAddToReestr:=fi.ReadBool('Main','QuestionOnAddToReestr',QuestionOnAddToReestr);
    LastNotarialActionId:=fi.ReadInteger('Main','LastNotarialActionId',LastNotarialActionId);

    DefaultBackUpDir:=fi.ReadString('Main','DefaultBackUpDir',DefaultBackUpDir);

    isViewDateInListView:=fi.ReadBool('Main','isViewDateInListView',isViewDateInListView);
    isViewCheckSumInListView:=fi.ReadBool('Main','isViewCheckSumInListView',isViewCheckSumInListView);

    isViewPath:=fi.ReadBool('Main','isViewPath',isViewPath);
    isRefreshFormOnDocumentLoad:=fi.ReadBool('Main','isRefreshFormOnDocumentLoad',isRefreshFormOnDocumentLoad);
    isSaveDocumentOnView:=fi.ReadBool('Main','isSaveDocumentOnView',isSaveDocumentOnView);

    isDeleteQuiteInReestr:=fi.ReadBool('Main','isDeleteQuiteInReestr',isDeleteQuiteInReestr);
    isViewDeleteQuiteInReestr:=fi.ReadBool('Main','isViewDeleteQuiteInReestr',isViewDeleteQuiteInReestr);
    DayDoverOffset:=fi.ReadInteger('Main','DayDoverOffset',DayDoverOffset);
    isDisableDefaultOnForm:=fi.ReadBool('Main','isDisableDefaultOnForm',isDisableDefaultOnForm);
    isViewUpdateInfo:=fi.ReadBool('Main','isViewUpdateInfo',isViewUpdateInfo);
    UpdateInfoFile:=fi.ReadString('Main','UpdateInfoFile',UpdateInfoFile);
    isViewHintOnFocus:=fi.ReadBool('Main','isViewHintOnFocus',isViewHintOnFocus);
    isViewReminder:=fi.ReadBool('Main','isViewReminder',isViewReminder);

    isAutoBuildWords:=fi.ReadBool('Main','isAutoBuildWords',isAutoBuildWords);
    isViewWhoCert:=fi.ReadBool('Main','isViewWhoCert',isViewWhoCert);
    isDocumentLock:=fi.ReadBool('Main','isDocumentLock',isDocumentLock);
    isNotViewHereditaryDeal:=fi.ReadBool('Main','isNotViewHereditaryDeal',isNotViewHereditaryDeal);
    isExpandConst:=fi.ReadBool('Main','isExpandConst',isExpandConst);
    isQuestionBackup:=fi.ReadBool('Main','isQuestionBackup',isQuestionBackup);
    isSelectDatabase:=fi.ReadBool('Main','isSelectDatabase',isSelectDatabase);
    isCheckEmptySumm:=fi.ReadBool('Main','isCheckEmptySumm',isCheckEmptySumm);


    LoadHotKey;

  finally
   fi.free;
  end;
 except
 end; 
end;

procedure LoadFromIniSearchParams;
var
  fi: TIniFile;
  str: TStringList;
  i: Integer;
  tmps: string;
  APos: Integer;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  str:=TStringList.Create;
  try
   if Assigned(fmFind) then begin
    fi.ReadSectionValues('search',str);
    for i:=0 to str.Count-1 do begin
      APos:=Pos('=',str.Strings[i]);
      if Apos<>0 then begin
       tmps:=Copy(str.Strings[i],Apos+1,Length(str.Strings[i])-(Apos));
       fmFind.cbFindStr.Items.Add(tmps);
      end;
    end;
   end;
  finally
   str.Free;
   fi.free;
  end;
 except

 end; 
end;

procedure LoadFromIniReestrParams;
var
  fi: TIniFile;
  str: TStringList;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  str:=TStringList.Create;
  try
   if Assigned(fmDocReestr) then begin
     fmDocReestr.LastIndex:=fi.ReadInteger('DocReestr','LastIndexTypeReestr',fmDocReestr.LastIndex);
     fmDocReestr.pgReestr.ActivePageIndex:=
       fi.readInteger('DocReestr','LastIndexPageReestr',fmDocReestr.pgReestr.ActivePageIndex);

   end;
  finally
   str.Free;
   fi.free;
  end;
 except
 end; 
end;

procedure LoadFromIniDocTreeParams;
var
  fi: TIniFile;
  str: TStringList;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  str:=TStringList.Create;
  try
   if Assigned(fmDocTree) then begin
     fmDocTree.SetCheckedView(fi.ReadInteger('DocTree','View',fmDocTree.GetCheckedView));
     fmDocTree.SetCheckedDocument(fi.ReadInteger('DocTree','Document',fmDocTree.GetCheckedDocument));
   end;
  finally
   str.Free;
   fi.free;
  end;
 except
 end; 
end;

procedure CreateBackUpOld;
var
  FileName: String;
  BackUpDirCur: String;
  strTime: string;
  strDate: string;
const
  fmtDate='ddmmyyyy';
  fmtTime='hhnnss';
begin
  SetStatusHint('�������� ������');
  exit;
  Screen.Cursor:=crHourGlass;
  try

   strDate:=FormatDateTime(fmtDate,WorkDate);
   BackUpDir:=ExtractFileDir(Application.ExeName)+'\'+ConstBackUpDir;
   if not DirectoryExists(BackUpDir) then
    CreateDir(BackUpDir);
   BackUpDirCur:=BackUpDir+'\'+strDate;
   if not DirectoryExists(BackUpDirCur) then
    CreateDir(BackUpDirCur);
   strTime:=FormatDateTime(fmtTime,WorkDate);
   FileName:=BackUpDirCur+'\'+strTime+ConstBackUpExt;
   CompressDir(ExtractFileDir(DataBaseName),FileName);
  finally
    SetStatusHint('');
    Screen.Cursor:=crDefault;
  end;
end;

procedure DateTimeToStringTSV(var Result: string; const Format: string;
  DateTime: TDateTime);
var
  BufPos, AppendLevel: Integer;
  Buffer: array[0..255] of Char;

  procedure AppendChars(P: PChar; Count: Integer);
  var
    N: Integer;
  begin
    N := SizeOf(Buffer) - BufPos;
    if N > Count then N := Count;
    if N <> 0 then Move(P[0], Buffer[BufPos], N);
    Inc(BufPos, N);
  end;

  procedure AppendString(const S: string);
  begin
    AppendChars(Pointer(S), Length(S));
  end;

  procedure AppendNumber(Number, Digits: Integer);
  const
    Format: array[0..3] of Char = '%.*d';
  var
    NumBuf: array[0..15] of Char;
  begin
    AppendChars(NumBuf, FormatBuf(NumBuf, SizeOf(NumBuf), Format,
      SizeOf(Format), [Digits, Number]));
  end;

  procedure AppendFormat(Format: PChar);
  var
    Starter, Token, LastToken: Char;
    DateDecoded, TimeDecoded, Use12HourClock,
    BetweenQuotes: Boolean;
    P: PChar;
    Count: Integer;
    Year, Month, Day, Hour, Min, Sec, MSec, H: Word;

    procedure GetCount;
    var
      P: PChar;
    begin
      P := Format;
      while Format^ = Starter do Inc(Format);
      Count := Format - P + 1;
    end;

    procedure GetDate;
    begin
      if not DateDecoded then
      begin
        DecodeDate(DateTime, Year, Month, Day);
        DateDecoded := True;
      end;
    end;

    procedure GetTime;
    begin
      if not TimeDecoded then
      begin
        DecodeTime(DateTime, Hour, Min, Sec, MSec);
        TimeDecoded := True;
      end;
    end;

    function ConvertEraString(const Count: Integer) : string;
    var
      FormatStr: string;
      SystemTime: TSystemTime;
      Buffer: array[Byte] of Char;
      P: PChar;
    begin
      Result := '';
      with SystemTime do
      begin
        wYear  := Year;
        wMonth := Month;
        wDay   := Day;
      end;

      FormatStr := 'gg';
      if GetDateFormat(GetThreadLocale, DATE_USE_ALT_CALENDAR, @SystemTime,
        PChar(FormatStr), Buffer, SizeOf(Buffer)) <> 0 then
      begin
        Result := Buffer;
        if Count = 1 then
        begin
          case SysLocale.PriLangID of
            LANG_JAPANESE:
              Result := Copy(Result, 1, CharToBytelen(Result, 1));
            LANG_CHINESE:
              if (SysLocale.SubLangID = SUBLANG_CHINESE_TRADITIONAL)
                and (ByteToCharLen(Result, Length(Result)) = 4) then
              begin
                P := Buffer + CharToByteIndex(Result, 3) - 1;
                SetString(Result, P, CharToByteLen(P, 2));
              end;
          end;
        end;
      end;
    end;

    function ConvertYearString(const Count: Integer): string;
    var
      FormatStr: string;
      SystemTime: TSystemTime;
      Buffer: array[Byte] of Char;
    begin
      Result := '';
      with SystemTime do
      begin
        wYear  := Year;
        wMonth := Month;
        wDay   := Day;
      end;

      if Count <= 2 then
        FormatStr := 'yy' // avoid Win95 bug.
      else
        FormatStr := 'yyyy';

      if GetDateFormat(GetThreadLocale, DATE_USE_ALT_CALENDAR, @SystemTime,
        PChar(FormatStr), Buffer, SizeOf(Buffer)) <> 0 then
      begin
        Result := Buffer;
        if (Count = 1) and (Result[1] = '0') then
          Result := Copy(Result, 2, Length(Result)-1);
      end;
    end;

    function GetNewMonthName(IndexMN: integer): String;
    var
      mname: string;
    begin
      mname:=LongMonthNames[IndexMN];
      case IndexMN of
        1,2,4,5,6,7,9,10,11,12: begin
          Delete(mname,Length(mname),1);
          mname:=mname+'�';
        end;
        3,8: begin
          mname:=mname+'�';
        end;
      end;
      result:=mname;
    end;

  var
    tmps: string;
  begin
    if (Format <> nil) and (AppendLevel < 2) then
    begin
      Inc(AppendLevel);
      LastToken := ' ';
      DateDecoded := False;
      TimeDecoded := False;
      Use12HourClock := False;
      while Format^ <> #0 do
      begin
        Starter := Format^;
        Inc(Format);
        if Starter in LeadBytes then
        begin
          if Format^ = #0 then Break;
          Inc(Format);
          LastToken := ' ';
          Continue;
        end;
        Token := Starter;
        if Token in ['a'..'z'] then Dec(Token, 32);
        if Token in ['A'..'Z'] then
        begin
          if (Token = 'M') and (LastToken = 'H') then Token := 'N';
          LastToken := Token;
        end;
        case Token of
          'Y':
            begin
              GetCount;
              GetDate;
              if Count <= 2 then
                AppendNumber(Year mod 100, 2) else
                AppendNumber(Year, 4);
            end;
          'G':
            begin
              GetCount;
              GetDate;
              AppendString(ConvertEraString(Count));
            end;
          'E':
            begin
              GetCount;
              GetDate;
              AppendString(ConvertYearString(Count));
            end;
          'M':
            begin
              GetCount;
              GetDate;
              case Count of
                1, 2: AppendNumber(Month, Count);
                3: AppendString(ShortMonthNames[Month]);
               else begin
                 tmps:=GetNewMonthName(Month);
                 AppendString(tmps);
//                 AppendString(LongMonthNames[Month]);
               end;
              end;
            end;
          'D':
            begin
              GetCount;
              case Count of
                1, 2:
                  begin
                    GetDate;
                    AppendNumber(Day, Count);
                  end;
                3: AppendString(ShortDayNames[DayOfWeek(DateTime)]);
                4: AppendString(LongDayNames[DayOfWeek(DateTime)]);
                5: AppendFormat(Pointer(ShortDateFormat));
              else
                AppendFormat(Pointer(LongDateFormat));
              end;
            end;
          'H':
            begin
              GetCount;
              GetTime;
              BetweenQuotes := False;
              P := Format;
              while P^ <> #0 do
              begin
                if P^ in LeadBytes then
                begin
                  Inc(P);
                  if P^ = #0 then Break;
                  Inc(P);
                  Continue;
                end;
                case P^ of
                  'A', 'a':
                    if not BetweenQuotes then
                    begin
                      if ( (StrLIComp(P, 'AM/PM', 5) = 0)
                        or (StrLIComp(P, 'A/P',   3) = 0)
                        or (StrLIComp(P, 'AMPM',  4) = 0) ) then
                        Use12HourClock := True;
                      Break;
                    end;
                  'H', 'h':
                    Break;
                  '''', '"': BetweenQuotes := not BetweenQuotes;
                end;
                Inc(P);
              end;
              H := Hour;
              if Use12HourClock then
                if H = 0 then H := 12 else if H > 12 then Dec(H, 12);
              if Count > 2 then Count := 2;
              AppendNumber(H, Count);
            end;
          'N':
            begin
              GetCount;
              GetTime;
              if Count > 2 then Count := 2;
              AppendNumber(Min, Count);
            end;
          'S':
            begin
              GetCount;
              GetTime;
              if Count > 2 then Count := 2;
              AppendNumber(Sec, Count);
            end;
          'T':
            begin
              GetCount;
              if Count = 1 then
                AppendFormat(Pointer(ShortTimeFormat)) else
                AppendFormat(Pointer(LongTimeFormat));
            end;
          'Z':
            begin
              GetCount;
              GetTime;
              if Count > 3 then Count := 3;
              AppendNumber(MSec, Count);
            end;
          'A':
            begin
              GetTime;
              P := Format - 1;
              if StrLIComp(P, 'AM/PM', 5) = 0 then
              begin
                if Hour >= 12 then Inc(P, 3);
                AppendChars(P, 2);
                Inc(Format, 4);
                Use12HourClock := TRUE;
              end else
              if StrLIComp(P, 'A/P', 3) = 0 then
              begin
                if Hour >= 12 then Inc(P, 2);
                AppendChars(P, 1);
                Inc(Format, 2);
                Use12HourClock := TRUE;
              end else
              if StrLIComp(P, 'AMPM', 4) = 0 then
              begin
                if Hour < 12 then
                  AppendString(TimeAMString) else
                  AppendString(TimePMString);
                Inc(Format, 3);
                Use12HourClock := TRUE;
              end else
              if StrLIComp(P, 'AAAA', 4) = 0 then
              begin
                GetDate;
                AppendString(LongDayNames[DayOfWeek(DateTime)]);
                Inc(Format, 3);
              end else
              if StrLIComp(P, 'AAA', 3) = 0 then
              begin
                GetDate;
                AppendString(ShortDayNames[DayOfWeek(DateTime)]);
                Inc(Format, 2);
              end else
              AppendChars(@Starter, 1);
            end;
          'C':
            begin
              GetCount;
              AppendFormat(Pointer(ShortDateFormat));
              GetTime;
              if (Hour <> 0) or (Min <> 0) or (Sec <> 0) then
              begin
                AppendChars(' ', 1);
                AppendFormat(Pointer(LongTimeFormat));
              end;
            end;
          '/':
            AppendChars(@DateSeparator, 1);
          ':':
            AppendChars(@TimeSeparator, 1);
          '''', '"':
            begin
              P := Format;
              while (Format^ <> #0) and (Format^ <> Starter) do
              begin
                if Format^ in LeadBytes then
                begin
                  Inc(Format);
                  if Format^ = #0 then Break;
                end;
                Inc(Format);
              end;
              AppendChars(P, Format - P);
              if Format^ <> #0 then Inc(Format);
            end;
        else
          AppendChars(@Starter, 1);
        end;
      end;
      Dec(AppendLevel);
    end;
  end;

begin
  BufPos := 0;
  AppendLevel := 0;
  if Format <> '' then AppendFormat(Pointer(Format)) else AppendFormat('C');
  SetString(Result, Buffer, BufPos);
end;

function FormatDateTimeTSV(const Format: string; DateTime: TDateTime): string;
begin
  DateTimeToStringTSV(Result, Format, DateTime);
end;

procedure DeleteBackUp;
var
  Dend,dnew: TDateTime;
  str: TStringList;
  i: Integer;
  dirnew: string;
  day,month,year: String;
  dirnewnext: string;
begin
  SetStatusHint('�������� �������');
  Screen.Cursor:=crHourGlass;
  if Trim(DefaultBackUpDir)='' then
   BackUpDir:=ExtractFileDir(Application.ExeName)+'\'+ConstBackUpDir
  else BackUpDir:=DefaultBackUpDir;
  DEnd:=Now-BackUpFreeze;
  str:=TStringList.Create;
  try
   GetDirs(BackUpDir,str);
   for i:=0 to str.Count-1 do begin
     try
      dirnew:=str.Strings[i];
      dirnewnext:=ExtractFileName(dirnew);
      day:=Copy(dirnewnext,1,2);
      month:=Copy(dirnewnext,3,2);
      year:=Copy(dirnewnext,5,4);
      dnew:=StrToDate(day+'.'+month+'.'+year);
      if dnew<=dend then
        RemoveDir(dirnew);
     except
     end;
   end;
  finally
   SetStatusHint('');
   str.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure GetDirs(FName: String; str: TStringList);
var
  AttrWord: Word;
  FMask: string;
  MaskPtr: PChar;
  Ptr: PChar;
  FileInfo: TSearchRec;
  lastdir: String;
begin
  lastdir:=Fname;
  if Trim(Fname)<>'' then begin
    if Fname[Length(Fname)]='\' then
     delete(Fname,Length(Fname),1);
  end;
  if not DirectoryExists(FName) then exit;
  AttrWord := faAnyFile+SysUtils.faReadOnly+faHidden+faSysFile+faVolumeID+faDirectory+faArchive;
  if not SetCurrentDir(lastdir) then exit;
    FMask:='*.*';
    try
      MaskPtr := PChar(FMask);
      while MaskPtr <> nil do
      begin
        Ptr := StrScan (MaskPtr, ';');
        if Ptr <> nil then
          Ptr^ := #0;
        if FindFirst(MaskPtr, AttrWord, FileInfo) = 0 then
        begin
          repeat
              if FileInfo.Attr and faDirectory <> 0 then begin
                if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') then begin
                     str.Add(fname+'\'+FileInfo.Name);
                end;
              end else begin
              end;
          until FindNext(FileInfo) <> 0;
          FindClose(FileInfo);
        end;
        if Ptr <> nil then
        begin
          Ptr^ := ';';
          Inc (Ptr);
        end;
        MaskPtr := Ptr;
      end;
    finally

    end;
end;

procedure RemoveDir(FName: String);
var
  AttrWord: Word;
  FMask: string;
  MaskPtr: PChar;
  Ptr: PChar;
  FileInfo: TSearchRec;
  FileExt: string;
  dir: string;
begin
  if not DirectoryExists(FName) then exit;
  AttrWord := faAnyFile+SysUtils.faReadOnly+faHidden+faSysFile+faVolumeID+faDirectory+faArchive;
  if not SetCurrentDir(Fname) then exit;
    FMask:='*.*';
    try
      MaskPtr := PChar(FMask);
      while MaskPtr <> nil do
      begin
        Ptr := StrScan (MaskPtr, ';');
        if Ptr <> nil then
          Ptr^ := #0;
        if FindFirst(MaskPtr, AttrWord, FileInfo) = 0 then
        begin
          repeat            
              if FileInfo.Attr and faDirectory <> 0 then begin
                if DirectoryExists(fname+'\'+FileInfo.Name) then begin
                  if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') then begin
                   setCurrentDir('c:\');
                   RemoveDir(fname+'\'+FileInfo.Name);
                   SetCurrentDir(Fname);
                  end;
                end;
              end else begin
                 FileExt := AnsiLowerCase(ExtractFileExt(FileInfo.Name));
                 FileSetAttr(fname+'\'+FileInfo.Name,DDL_READWRITE);
                 DeleteFile(fname+'\'+FileInfo.Name);
              end;
          until FindNext(FileInfo) <> 0;
          FindClose(FileInfo);
        end;
        if Ptr <> nil then
        begin
          Ptr^ := ';';
          Inc (Ptr);
        end;
        MaskPtr := Ptr;
      end;
    finally
     dir:=AnsiUppercase(Fname);
     setCurrentDir('c:\');
     FileSetAttr(dir,0);
     SysUtils.RemoveDir(dir);
    end;
end;


procedure TDm.DataModuleCreate(Sender: TObject);
var
  Buffer: String;
begin
 Screen.Cursor:=crHourGlass;
 try
  IBDbase.Connected:=false;
  IBDbase.LoginPrompt:=false;
  IBDbase.DatabaseName:=DataBaseName;
  IBDbase.Params.Clear;

  Buffer:='';
  if LocalDb.ReadParam(SDb_ParamUserName,Buffer) then
    IBDbase.Params.Add(Format(DataBaseUserName,[Buffer]));

  Buffer:='';
  if LocalDb.ReadParam(SDb_ParamPassword,Buffer) then
    IBDbase.Params.Add(Format(DataBaseUserPass,[Buffer]));
    
  IBDbase.Params.Add(DataBaseCodePage);
  IBDbase.Connected:=true;
  IBTransaction.Active:=IBDbase.Connected;
 finally
  Screen.Cursor:=crDefault;
 end; 
end;

function ConnectServer(dbName: String): Boolean;
var
  ibbasetest: TIBDataBase;
  Buffer: String;
begin
  Result:=false;
  ibbasetest:=TIBDataBase.create(nil);
  Screen.Cursor:=crHourGlass;
  try
   ibbasetest.DatabaseName:=dbname;
   ibbasetest.LoginPrompt:=false;

   Buffer:='';
   if LocalDb.ReadParam(SDb_ParamUserName,Buffer) then
     ibbasetest.Params.Add(Format(DataBaseUserName,[Buffer]));

   Buffer:='';
   if LocalDb.ReadParam(SDb_ParamPassword,Buffer) then
     ibbasetest.Params.Add(Format(DataBaseUserPass,[Buffer]));

   ibbasetest.Params.Add(DataBaseCodePage);

   try
    ibbasetest.Connected:=true;
    result:=ibbasetest.Connected;
   except
   end; 
  finally
   ibbasetest.free;
   Screen.Cursor:=crDefault;
  end;
end;

function ServerFound: Boolean;
var
  fm: TfmServerConnect;
begin
  Result:=ConnectServer(DataBaseName);
  if Result then exit;
  fm:=TfmServerConnect.Create(nil);
  try
   if fm.ShowModal=mrOk then begin
     Result:=ConnectServer(fm.ConnectString);
     if Result then
       DataBaseName:=fm.ConnectString;
   end;
  finally
   fm.Free;
  end;
end;

function isLoginToProgramm: Boolean;
var
  fm: TfmLogin;
begin
  Result:=false;
  fm:=TfmLogin.Create(nil);
  try
{   if Trim(UserName)='' then begin
    if ParamCount<2 then begin
     fm.ActiveQuery;
     fm.cbUsers.Text:=ParamStr(1);
     if Trim(fm.cbUsers.Text)<>'' then
       fm.isFocusPass:=true;
     if fm.ShowModal=mrOk then begin
       UserID:=fm.UserID;
       UserName:=fm.UserName;
       Result:=true;
     end;
    end else begin
     fm.ActiveQuery;
     fm.cbUsers.Text:=ParamStr(1);
     fm.edPass.Text:=ParamStr(2);
     result:=fm.Connect;
     if Result then begin
      UserID:=fm.UserID;
      UserName:=fm.UserName;
     end;
    end;
   end else begin}
     fm.ActiveQuery;
     fm.cbUsers.Text:=UserName;
     if Trim(fm.cbUsers.Text)<>'' then
       fm.isFocusPass:=true;
     if fm.ShowModal=mrOk then begin
       UserID:=fm.UserID;
       UserName:=fm.UserName;
       Result:=true;
     end;
//   end;
  finally
    fm.Free;
  end;
end;

function GetMaxIDFromTableDoc(TypeDocId: Integer; DocName: String): Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=0;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select Max(doc_id) as doc_id from '+TableDoc+
         ' where typedoc_id='+inttostr(TypeDocID)+
         ' and name='''+Docname+'''';
   qr.Sql. Add(sqls);
   qr.Active:=true;
   if qr.RecordCount<>0 then
    Result:=qr.FieldByName('doc_id').AsInteger;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure InitClasses;

  procedure AddToListClasses(Caption: String; TypeClass: TClass; ImageIndex: Integer);
  var
    P: PInfoClass;
  begin
    new(P);
    P.Caption:=Caption;
    P.TypeClass:=TypeClass;
    P.ImageIndex:=ImageIndex;
    ListClasses.Add(P);
  end;

begin
  AddToListClasses('�������',TLabel,-1);
  AddToListClasses('���� �����',TEdit,-1);
  AddToListClasses('���������� ������',TComboBox,-1);
  AddToListClasses('������������� ���� �����',TMemo,-1);
  AddToListClasses('������',TCheckBox,-1);
  AddToListClasses('�������������',TRadioButton,-1);
  AddToListClasses('������',TListBox,-1);
  AddToListClasses('������',TGroupBox,-1);
  AddToListClasses('������ ��������������',TRadioGroup,-1);
  AddToListClasses('������',TPanel,-1);
  AddToListClasses('���������� ������',TSpeedButton,-1);
  AddToListClasses('���� ����� � ������',TMaskEdit,-1);
  AddToListClasses('��������',TImage,-1);
  AddToListClasses('������',TShape,-1);
  AddToListClasses('����������',TBevel,-1);
  AddToListClasses('�������������� ����',TScrollBox,-1);
  AddToListClasses('��������',TSplitter,-1);
  AddToListClasses('����������� ������������� ���� �����',TRichEdit,-1);
  AddToListClasses('����',TTrackBar,-1);
  AddToListClasses('��������',TAnimate,-1);
  AddToListClasses('���� ����� ����',TDateTimePicker,-1);
  AddToListClasses('��������',TPageControl,-1);
  AddToListClasses('���� ����� �����',TRxCalcEdit,-1);
  AddToListClasses('���� ����� ���� (�����)',TDateEdit,-1);

end;

procedure DestroyClassesForWord;
var
  i: Integer;
  P: PInfoClass;
begin
  for i:=0 to ListClassesForWord.Count-1 do begin
    P:=ListClassesForWord.Items[i];
    dispose(P);
  end;
  ListClassesForWord.Clear;
end;

function GetImageIndexFromClassesForWord(TypeClass: TClass): Integer;
var
    i: Integer;
    P: PInfoClass;
begin
    Result:=-1;
    if not Assigned(ListClasses) then exit;
    for i:=0 to ListClasses.Count-1 do begin
      P:=ListClasses.Items[i];
      if TypeClass.ClassParent=P.TypeClass then begin
       Result:=i;
       exit;
      end;
    end;
end;

function GetIndexByClass(cls: TClass): Integer;
var
    i: Integer;
    P: PInfoClass;
begin
   Result:=-1;
   if not Assigned(ListClassesForWord) then exit;
   for i:=0 to ListClassesForWord.Count-1 do begin
     P:=ListClassesForWord.Items[i];
     if cls=P.TypeClass then begin
       Result:=i;
       exit;
     end;
   end;
end;

procedure InitClassesForWord;


  procedure AddToListClasses(Caption: String; TypeClass: TClass; ImageIndex: Integer);
  var
    P: PInfoClass;
  begin
    new(P);
    P.Caption:=Caption;
    P.TypeClass:=TypeClass;
    if ImageIndex=-1 then
     ImageIndex:=GetImageIndexFromClassesForWord(TypeClass);
    P.ImageIndex:=ImageIndex;
    ListClassesForWord.Add(P);
  end;

begin
  AddToListClasses('�������',TNewLabel,-1);
  AddToListClasses('���� �����',TNewEdit,-1);
  AddToListClasses('���������� ������',TNewComboBox,-1);
  AddToListClasses('������������� ���� �����',TNewMemo,-1);
  AddToListClasses('������',TNewCheckBox,-1);
  AddToListClasses('�������������',TNewRadioButton,-1);
  AddToListClasses('������',TNewListBox,-1);
  AddToListClasses('������ ��������������',TNewRadioGroup,-1);
  AddToListClasses('���� ����� � ������',TNewMaskEdit,-1);
  AddToListClasses('����������� ������������� ���� �����',TNewRichEdit,-1);
  AddToListClasses('���� ����� ����',TNewDateTimePicker,-1);
  AddToListClasses('���� ����� �����',TNewRxCalcEdit,-1);
  AddToListClasses('���������� ������ ����� �����',TNewComboBoxMarkCar,2);
  AddToListClasses('���������� ������ ������',TNewComboBoxColor,2);
  AddToListClasses('���� ����� ���� (�����)',TNewRxDateEdit,-1);
end;

function QuantityText(Value: Extended; TypeTrans: TTypeTranslate): string;
{var
 P: array[0..400] of char;}
begin
{ _QuantityText(Value,P,SizeOf(P),TypeTrans);
 result:=P;}
 Result:=QuantityTextFromExtended(Value,TypeTrans);
end;

procedure SaveToCaseTable;
begin

end;

function GetRecordCount(qr: TIBQuery): Integer;
var
// i: Integer;
 sqls: string;
 Apos: Integer;
 APos1: Integer;
 newsqls: string;
 qrnew: TIBQuery;
 tr: TIBTransaction;
const
 from='from';
 order='order by';
begin
  Result:=0;
  if not qr.Active then exit;
  sqls:=qr.SQL.Text;
  if Trim(sqls)='' then exit;
  Apos:=Pos(AnsiUpperCase(from),AnsiUpperCase(sqls));
  if Apos=0 then exit;
  APos1:=Pos(AnsiUpperCase(order),AnsiUpperCase(sqls));
  if APos1=0 then
    newsqls:='Select count(*) as ctn from '+ Copy(sqls,Apos+Length(from),Length(sqls))
  else
    newsqls:='Select count(*) as ctn from '+ Copy(sqls,Apos+Length(from),(Apos1-Apos)-Length(from));
    
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qrnew:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(qr.Database);
   qr.Database.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qrnew.Database:=qr.Database;
   qrnew.Transaction:=tr;
   qrnew.Transaction.Active:=true;
   qrnew.SQL.Add(newsqls);
   qrnew.Active:=true;
   if qrnew.RecordCount=1 then begin
     Result:=qrnew.FieldByName('ctn').AsInteger;
   end;
  finally
   qrnew.free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;

end;

function isOtherControlConsistProp(WT: TWinControl; TypeCase: TTypeCase): Boolean;
var
  i: Integer;
  ct: TControl;
  propName: String;
  EnumProp: Integer;
  TC: TTypeCase;
begin
  Result:=false;
  if wt=nil then exit;
  propName:='TypeCase';
  for i:=0 to WT.ControlCount-1 do begin
    ct:=WT.Controls[i];
    if IsPublishedProp(ct,propName)then begin
     EnumProp:=GetOrdProp(ct,PropName);
     TC:=TTypeCase(EnumProp);
     if TC=TypeCase then begin
       Result:=true;
       exit;
     end;
    end;
  end;
end;

function GetPadegStr(FIO: ShortString; TypeCase: TTypeCase): String;
begin
//  Result:=_GetPadegFromStr(FIO,#0,TypeCase);
  Result:=GetFIOFromStr(FIO, '', TypeCase);
end;

function ExtractWord(InFio: string;
                     var cLastName,cFirstName,cMiddleName: String; Delims: Char): string;
var
  Apos: Integer;
  Last: Integer;
  tmps: string;
begin
  Result:=InFio;
  tmps:=InFio;
  Apos:=Pos(Delims,tmps);
  if APos<>0 then begin
   cLastName:=Copy(InFio,1,APos-1);
   tmps:=Copy(InFio,APos+1,Length(InFio)-Length(cLastName));
  end else begin
   cLastName:=InFio;
   exit;
  end; 
  last:=APos;
  APos:=Pos(Delims,tmps);
  if APos<>0 then begin
   cFirstName:=Copy(tmps,1,APos-1);
   tmps:=Copy(InFio,APos+last+1,Length(InFio)-Length(cFirstName));
  end else begin
   cFirstName:=tmps;
   exit;
  end;
  
  cMiddleName:=Copy(tmps,1,Length(tmps));

end;

procedure SetStatusHint(Hint: String);
begin
 if Assigned(fmMain) then begin
  fmMain.stbStatus.Panels.Items[3].Text:=Hint;
  fmMain.Update;
 end; 
end;

procedure GetDirFiles(FName: String; str: TStringList; Mask: string);
var
  AttrWord: Word;
  FMask: string;
  MaskPtr: PChar;
  Ptr: PChar;
  FileInfo: TSearchRec;
  lastdir: string;
begin
  lastdir:=Fname;
  if Trim(Fname)<>'' then begin
    if Fname[Length(Fname)]='\' then
     delete(Fname,Length(Fname),1);
  end;
  if not DirectoryExists(FName) then exit;
  AttrWord := faAnyFile+SysUtils.faReadOnly+faHidden+faSysFile+faVolumeID+faArchive;
  if not SetCurrentDir(lastdir) then exit;
    FMask:=Mask;
    try
      MaskPtr := PChar(FMask);
      while MaskPtr <> nil do
      begin
        Ptr := StrScan (MaskPtr, ';');
        if Ptr <> nil then
          Ptr^ := #0;
        if FindFirst(MaskPtr, AttrWord, FileInfo) = 0 then
        begin
          repeat
             if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') then begin
               str.Add(FName+'\'+FileInfo.Name);
             end;
          until FindNext(FileInfo) <> 0;
          FindClose(FileInfo);
        end;
        if Ptr <> nil then
        begin
          Ptr^ := ';';
          Inc (Ptr);
        end;
        MaskPtr := Ptr;
      end;
    finally

    end;
end;

procedure ClearTempDir;
var
 str: TStringList;
 i: Integer;
begin
 if not DirectoryExists(TempDocFilePath) then exit;
 SetStatusHint('�������� ��������� ������');
 Screen.Cursor:=crHourGlass;
 str:=TStringList.Create;
 try
   GetDirs(TempDocFilePath,str);
   for i:=0 to str.Count-1 do begin
    RemoveDir(str.Strings[i]);
   end;
   str.Clear;
   GetDirFiles(TempDocFilePath,str,'*.*');
   for i:=0 to str.Count-1 do begin
    FileSetAttr(str.Strings[i],DDL_READWRITE);
    DeleteFile(str.Strings[i]);
   end;
 finally
  SetStatusHint('');
  str.Free;
  Screen.Cursor:=crDefault;
 end;
end;

procedure GetProtocolAndServerName(DataBaseStr: String; var Protocol: TProtocol;
                                   var ServerName: String);
var
  APos: Integer;
begin
  if FileExists(DataBaseStr) then begin
    Protocol:=Local;
    ServerName:='';
    exit;
  end;
  APos:=Pos(':',DataBaseStr);
  if APos<>0 then begin
    Protocol:=TCP;
    ServerName:=Copy(DataBaseStr,1,Apos-1);
    exit;
  end;
  APos:=Pos('@',DataBaseStr);
  if APos<>0 then begin
    Protocol:=SPX;
    ServerName:=Copy(DataBaseStr,1,Apos-1);
    exit;
  end;
  APos:=Pos('\\',DataBaseStr);
  if APos<>0 then begin
    Protocol:=NamedPipe;
    ServerName:=Copy(DataBaseStr,1,Apos-1);
    exit;
  end;

end;

procedure CreateBackUp(DefFileName: String);
var
  FileName: String;
  BackUpDirCur: String;
  strTime: string;
  strDate: string;
  IBBackUp: TIBBackupService;
  srvname: string;
  protcol: TProtocol;
  fmView: TfmViewRunService;
  Buffer: String;
const
  fmtDate='ddmmyyyy';
  fmtTime='hhnnss';
  ConstCreateBackUp='�������� ������ ...';
begin
 try
  SetStatusHint(ConstCreateBackUp);
  Screen.Cursor:=crHourGlass;
  IBBackUp:=TIBBackupService.Create(nil);
  try
    IBBackUp.BufferSize:=128000;
    strDate:=FormatDateTime(fmtDate,Now);
    if Trim(DefaultBackUpDir)='' then
     BackUpDir:=ExtractFileDir(Application.ExeName)+'\'+ConstBackUpDir
    else BackUpDir:=DefaultBackUpDir;
    if not DirectoryExists(BackUpDir) then
     CreateDir(BackUpDir);
    BackUpDirCur:=BackUpDir+'\'+strDate;
    if not DirectoryExists(BackUpDirCur) then
     CreateDir(BackUpDirCur);
    strTime:=FormatDateTime(fmtTime,Now);
    if Trim(DefFileName)='' then
     FileName:=BackUpDirCur+'\'+strTime+ConstBackUpExt
    else FileName:=DefFileName;
   IBBackUp.BackupFile.Add(FileName);
   IBBackUp.DatabaseName:=DataBaseName;
   IBBackUp.Options:=IBBackUp.Options;

   IBBackUp.LoginPrompt:=false;

   Buffer:='';
   if LocalDb.ReadParam(SDb_ParamUserName,Buffer) then
     IBBackUp.Params.Add(Format(DataBaseUserName,[Buffer]));

   Buffer:='';
   if LocalDb.ReadParam(SDb_ParamPassword,Buffer) then
     IBBackUp.Params.Add(Format(DataBaseUserPass,[Buffer]));

   GetProtocolAndServerName(DataBaseName,protcol,srvname);
   IBBackUp.Protocol:=protcol;
   IBBackUp.ServerName:=srvname;
   IBBackUp.Attach;
   fmView:=nil;
   try
    IBBackUp.ServiceStart;
    fmView:=TfmViewRunService.Create(nil);
    fmView.Service:=IBBackUp;
    fmView.lb.Caption:=ConstCreateBackUp;
    fmView.tm.Enabled:=true;
    fmView.ShowModal;
   finally
    fmView.Free;
   end; 
  finally
    SetStatusHint('');
    IBBackUp.Free;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: Exception do begin
    ShowError(Application.Handle,E.Message);
  end;
 end;
end;

procedure RestoreBackUp(DefFileName: String);
var
  IBRest: TIBRestoreService;
  srvname: string;
  protcol: TProtocol;
  fmView: TfmViewRunService;
  Buffer: String;
//  SI: TSystemInfo;
const
  ConstRestoreBackUp='�������������� �� ������ ...';
begin
 try
  SetStatusHint(ConstRestoreBackUp);
  Screen.Cursor:=crHourGlass;
  IBRest:=TIBRestoreService.Create(nil);
  dm.IBTransaction.Active:=false;
  dm.IBDbase.connected:=false;
  try
//   GetSystemInfo(SI);
   IBRest.BackupFile.Add(DefFileName);
   IBRest.DatabaseName.Add(DataBaseName);
   IBRest.LoginPrompt:=false;

   Buffer:='';
   if LocalDb.ReadParam(SDb_ParamUserName,Buffer) then
     IBRest.Params.Add(Format(DataBaseUserName,[Buffer]));

   Buffer:='';
   if LocalDb.ReadParam(SDb_ParamPassword,Buffer) then
     IBRest.Params.Add(Format(DataBaseUserPass,[Buffer]));

   GetProtocolAndServerName(DataBaseName,protcol,srvname);
   IBRest.Protocol:=protcol;
   IBRest.ServerName:=srvname;
   IBRest.Options:=IBRest.Options+[Replace]-[CreateNewDB];
   IBRest.PageSize:=1024;
   IBRest.Attach;
   fmView:=nil;
   try
    IBRest.ServiceStart;
    fmView:=TfmViewRunService.Create(nil);
    fmView.Service:=IBRest;
    fmView.lb.Caption:=ConstRestoreBackUp;
    fmView.tm.Enabled:=true;
    fmView.ShowModal;
   finally
    fmView.Free;
   end; 
  finally
    Sleep(RestoreSleep*1000);
    SetStatusHint('');
    IBRest.Free;
    RefreshAll;
    Screen.Cursor:=crDefault;
  end;
 except
  on E: Exception do begin
    ShowError(Application.Handle,E.Message);
  end;
 end; 
end;

procedure RefreshAll;
begin

 try
  dm.IBTransaction.Active:=false;
  dm.IBDbase.Connected:=false;
  dm.IBDbase.DatabaseName:=DataBaseName;
  dm.IBDbase.Connected:=true;
  dm.IBTransaction.Active:=true;

  fmMain.RefreshNeeded;

  if Newform<>nil then begin
    Newform.Close;
    Newform:=nil;
  end;

  fmDocTree.ActiveQuery;
  fmDocReestr.LoadFilter;
  fmDocReestr.ActiveQuery;

  if fmUsers<>nil then begin
   fmUsers.Close;
   fmUsers:=nil;
  end;

  if fmTypeReestr<>nil then begin
   fmTypeReestr.Close;
   fmTypeReestr:=nil;
  end;

  if fmOperation<>nil then begin
   fmOperation.Close;
   fmOperation:=nil;
  end;

  if fmMask<>nil then begin
   fmMask.Close;
   fmMask:=nil;
  end;

  if fmCase<>nil then begin
   fmCase.Close;
   fmCase:=nil;
  end;

  if fmMarkCar<>nil then begin
   fmMarkCar.Close;
   fmMarkCar:=nil;
  end;

  if fmColor<>nil then begin
   fmColor.Close;
   fmColor:=nil;
  end;

  if fmConst<>nil then begin
   fmConst.Close;
   fmConst:=nil;
  end;

  if fmLicense<>nil then begin
   fmLicense.Close;
   fmLicense:=nil;
  end;

  if fmRBNotarialAction<>nil then begin
   fmRBNotarialAction.Close;
   fmRBNotarialAction:=nil;
  end;

  if fmNotarius<>nil then begin
   fmNotarius.Close;
   fmNotarius:=nil;
  end;

  if fmSearchReestr<>nil then begin
   fmSearchReestr.Close;
   fmSearchReestr:=nil;
  end;

  if fmSearchDoc<>nil then begin
   fmSearchDoc.Close;
   fmSearchDoc:=nil;
  end;

  if fmHereditaryDeal<>nil then begin
    fmHereditaryDeal.Close;
    fmHereditaryDeal:=nil;
  end;

  if fmSubs<>nil then begin
    fmSubs.Close;
    fmSubs:=nil;
  end;

  if fmSubsValue<>nil then begin
    fmSubsValue.Close;
    fmSubsValue:=nil;
  end;

  if fmRBPeople<>nil then begin
    fmRBPeople.Close;
    fmRBPeople:=nil;
  end;

  if fmRBRuleForElement<>nil then begin
    fmRBRuleForElement.Close;
    fmRBRuleForElement:=nil;
  end;

  if fmRbReminder<>nil then begin
    fmRbReminder.Close;
    fmRbReminder:=nil;
  end;

  if fmRenovation<>nil then begin
    fmRenovation.Close;
    fmRenovation:=nil;
  end;
  
  if fmGraphVisit<>nil then begin
    fmGraphVisit.Close;
    fmGraphVisit:=nil;
  end;

  if fmChamber<>nil then begin
    fmChamber.Close;
    fmChamber:=nil;
  end;

  if fmNotary<>nil then begin
    fmNotary.Close;
    fmNotary:=nil;
  end;

  if fmBlanks<>nil then begin
    fmBlanks.Close;
    fmBlanks:=nil;
  end;

 except
  on E: Exception do
   ShowError(Application.Handle,E.Message);
 end;
end;

procedure TDm.tmRestoreTimer(Sender: TObject);
begin
  tmRestore.Enabled:=false;
  if dm.IBDbase.TestConnected then begin
    RefreshAll;
  end else begin
    tmRestore.Enabled:=true;
  end;
end;

procedure ActiveWord;
var
 W: Variant;
begin
   Screen.Cursor:=crHourGlass;
   try
    try
     CoInitialize(nil);
     W:=GetActiveOleObject(WordOle);
     Application.Mainform.Update;
     W.Visible:=true;
     W.Activate;
     W.Visible:=true;
     W.WindowState:=wdWindowStateMaximize;
     ShowWindow(Application.Handle,SW_MINIMIZE);
    except
    
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
end;

function GetRndTime: Integer;
begin
  Result:=RndTimeConst+Random(Round(RndTimeConst/2))-Random(Round(RndTimeConst/2));
end;

function GetCPUSpeed: Extended;
const
 DelayTime = 100;
var
 TimerHi, TimerLo: DWORD;
 PriorityClass, Priority: Integer;
begin
 PriorityClass := GetPriorityClass(GetCurrentProcess);
 Priority := GetThreadPriority(GetCurrentThread);
 SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
 SetThreadPriority(GetCurrentThread,
 THREAD_PRIORITY_TIME_CRITICAL);
 Sleep(10);
 asm
  dw 310Fh // rdtsc
  mov TimerLo, eax
  mov TimerHi, edx
 end;
 Sleep(DelayTime);
 asm
  dw 310Fh // rdtsc
  sub eax, TimerLo
  sbb edx, TimerHi
  mov TimerLo, eax
  mov TimerHi, edx
 end;
 SetThreadPriority(GetCurrentThread, Priority);
 SetPriorityClass(GetCurrentProcess, PriorityClass);
 Result := TimerLo / (1000.0 * DelayTime);
end;

procedure CheckPatch;

  procedure ExitApp(Num: Integer);
  begin
//    showmessage(inttostr(Num));
//    Application.Terminate;
    TerminateProcess(GetCurrentProcess,0);
  end;

  function GetVolumeSerialNumber: DWord;
  var
   lpRootPathName: PChar;
   lpVolumeNameBuffer: array [0..MAX_PATH] of Char;
   nVolumeNameSize: DWORD;
   lpVolumeSerialNumber: PDWORD;
   lpMaximumComponentLength: DWORD;
   lpFileSystemFlags: DWORD;
  begin
   Result:=0;
   lpRootPathName:=Pchar(ExtractFiledrive(Application.ExeName)+'\');
   nVolumeNameSize:=DWord(Sizeof(lpVolumeNameBuffer));
   FillChar(lpVolumeNameBuffer,nVolumeNameSize,0);
   lpVolumeNameBuffer[0] := #$00;
   new(lpVolumeSerialNumber);
   try
    if GetVolumeInformation(lpRootPathName,lpVolumeNameBuffer,nVolumeNameSize,
                              lpVolumeSerialNumber,lpMaximumComponentLength,
                              lpFileSystemFlags, nil,0) then
    Result:=DWord(lpVolumeSerialNumber^);
   finally
     dispose(lpVolumeSerialNumber);
   end;
  end;

  function EqualCPUSpeed(Value: Extended): Boolean;
  var
   Def: Extended;
   delta: Extended;
  begin
   Result:=false;
   Def:=GetCPUSpeed;
   delta:=0.1*def;
   if (Value>=Def-delta)and(Value<=Def+delta) then begin
    Result:=true;
   end;
  end;
  
var
  res: TResourceStream;
  Check: PCheckPoint;
  SI: TSystemInfo;
  tmps: string;
  Mem: Pointer;
begin
  {$IFDEF NOSECURITY}
   exit;
  {$ENDIF}

  Mem:=nil;
  
  Screen.Cursor:=crHourGlass;
  GetMem(Check,SizeOf(TCheckPoint));
  try
   try
    res:=nil; 
    try
     res:=TResourceStream.Create(HINSTANCE,PatchResName,RT_BITMAP);
     Mem:=res.MeMory;
    finally
     res.Free;
    end;
   except
   end;

    CopyMemory(Check,Mem,sizeof(TCheckPoint));
//    Move(res.MeMory^,Check^,sizeof(TCheckPoint));
    UnCryptCheckPoint(DWord(Check),sizeof(TCheckPoint));
    GetSystemInfo(SI);
    if Check.dwOemId<>SI.dwOemId Then ExitApp(1);
    if Check.wProcessorArchitecture<>SI.wProcessorArchitecture Then ExitApp(2);
    if Check.dwPageSize<>SI.dwPageSize Then ExitApp(3);
    if Check.dwActiveProcessorMask<>SI.dwActiveProcessorMask Then ExitApp(4);
    if Check.dwNumberOfProcessors<>SI.dwNumberOfProcessors Then ExitApp(5);
    if Check.dwProcessorType<>SI.dwProcessorType Then ExitApp(6);
    if Check.dwAllocationGranularity<>SI.dwAllocationGranularity Then ExitApp(7);
//    if Check.wProcessorLevel<>SI.wProcessorLevel Then ExitApp(8);
//    if Check.wProcessorRevision<>SI.wProcessorRevision Then ExitApp(9);
    if LongInt(Check.dwWin32Platform)<>LongInt(Win32Platform) Then ExitApp(10);
    if LongInt(Check.dwWin32MajorVersion)<>LongInt(Win32MajorVersion) Then ExitApp(11);
    if LongInt(Check.dwWin32MinorVersion)<>LongInt(Win32MinorVersion) Then ExitApp(12);
    if LongInt(Check.dwWin32BuildNumber)<>LongInt(Win32BuildNumber) Then ExitApp(13);
    tmps:=Check.Win32CSDVersion;
    if tmps<>Win32CSDVersion Then ExitApp(14);
    if Check.dwVolumeSerialNumber<>GetVolumeSerialNumber Then ExitApp(15);
//    if not EqualCPUSpeed(Check.CPUSpeed) Then ExitApp(16);

  finally
   FreeMem(Check,SizeOf(TCheckPoint));
   Screen.Cursor:=crDefault;
  end;
end;

procedure UnCryptCheckPoint(Addr: DWord; Size: DWord);
var
  i: DWord;
  b: Byte;
  j: Integer;
begin
  j:=0;
  for i:=Addr to Addr+Size-1 do begin
   move(Pointer(i)^,b,1);
   if Odd(j) then  begin
     b:=b-j*3;
   end else begin
     b:=b+j*4;
   end;
   move(b,Pointer(i)^,1);
   inc(j);
  end;
end;

function RunAnyFile(FileStr: String): Boolean;
var
  ret: DWord;
begin
   if not FileExists(FileStr) then begin
    Result:=false;
    exit;
   end;

   ret:=ShellExecute(Application.Handle,'open',Pchar(FileStr),nil,nil,SW_SHOWMAXIMIZED);
   case ret of
     0,ERROR_FILE_NOT_FOUND,ERROR_PATH_NOT_FOUND,
     ERROR_BAD_FORMAT,SE_ERR_ACCESSDENIED,SE_ERR_ASSOCINCOMPLETE,
     SE_ERR_DDEBUSY,SE_ERR_DDEFAIL,SE_ERR_DDETIMEOUT,SE_ERR_DLLNOTFOUND,
     SE_ERR_NOASSOC,SE_ERR_OOM,SE_ERR_SHARE: result:=false;
    else begin
      Result:=true;
    end;
   end;
end;

function GetTypeDocID(Name: String): Integer;
var
    qr: TIBQuery;
    sqls: string;
    tr: TIBTransaction;
begin
    Screen.Cursor:=crHourGlass;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     Result:=0;
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select typedoc_id from '+TableTypeDoc+' where name='''+Trim(name)+'''';
     qr.SQL.Add(sqls);
     qr.Active:=true;
     if qr.RecordCount>0 then
       Result:=qr.FieldByName('typedoc_id').ASInteger;
    finally
     qr.Free;
     tr.Free;
     Screen.Cursor:=crDefault;
    end;
end;

function GetMaxTypeDocID: Integer;
var
    qr: TIBQuery;
    sqls: string;
    tr: TIBTransaction;
begin
    Screen.Cursor:=crHourGlass;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     Result:=0;
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
//     sqls:='Select Max(typedoc_id) as typedoc_id from '+TableTypeDoc;
     sqls:='select gen_id(SetTypeDoc_id, 0) as typedoc_id from '+TableTypeDoc;
     qr.SQL.Add(sqls);
     qr.Active:=true;
     Result:=qr.FieldByName('typedoc_id').ASInteger;
    finally
     qr.Free;
     tr.Free;
     Screen.Cursor:=crDefault;
    end;
end;

procedure CompressAndCryptFile(FileName: String; MsOut: TMemoryStream);
var
  cm: TMCompress;
  fs: TFileStream;
  S: string;
  OldVersion: Boolean;
begin
  Screen.Cursor:=crHourGlass;
  cm:=TMCompress.Create(nil);
  fs:=TFileStream.Create(FileName,fmOpenRead);
  try
   OldVersion:=false;
   fs.Position:=0;
   if OldVersion then begin
     cm.Compress(msOut,fs,coLZH5);
   end else begin
     S:='';
     if LocalDb.ReadParam(SDb_ParamKey,S) then begin
       msOut.CopyFrom(fs,fs.Size);
       msOut.Position:=0;
       Crypter.EncodeStream(S,msOut,DefaultCipherAlgorithm,DefaultCipherMode);
     end;  
   end;  
  finally
   fs.Free;
   cm.Free;
   Screen.Cursor:=crDefault;
  end;
end;


procedure LoadDocFromDir(Caption: String; Dir: string; WithForm: Boolean=false);

   procedure AppendTypeDocDir(Cur: string; strFiles: TStringList; var ParentId: Integer);
   var
    TypeDoc_id: Integer;
    Name: string;
   begin
     Name:=ExtractFileName(Cur);
     strFiles.Clear;
     GetDirFiles(Cur,strFiles,ExtDoc);
    { TypeDoc_id:=GetTypeDocID(Name);
     if TypeDoc_id<>0 then begin
       AppendToDoc(TypeDoc_id,strFiles,ConstAddDoc);
       ParentId:=TypeDoc_id;
     end else begin}
       TypeDoc_id:=InsertToTypeDoc(Name,Name,ParentID);
       ParentId:=TypeDoc_id;
       if TypeDoc_id<>0 then begin
         AppendToDoc(TypeDoc_id,strFiles,ConstAddDoc,WithForm);
       end;
//     end;

   end;

   procedure AppendAll(DirNew: string; ParentId: Integer);
   var
    str: TStringList;
    i: Integer;
    strFiles: TStringList;
   begin
    str:=TStringList.Create;
    strFiles:=TStringList.Create;
    try
     application.ProcessMessages;
     if BreakAnyProgress then exit; 
     AppendTypeDocDir(GetCheckedString(DirNew),strFiles,ParentId);
     GetDirs(DirNew,str);
     for i:=0 to str.Count-1 do begin
      AppendAll(GetCheckedString(str.Strings[i]),ParentId);
     end;
    finally
     strFiles.Free;
     str.Free;
    end;
   end;

var
  ParentId: Integer;
  nd: TTreeNode;
begin
  Screen.Cursor:=CrHourGlass;
  BreakAnyProgress:=false;
  fmProgress.Caption:=Caption;
  fmProgress.lbProgress.Caption:=ConstAddDoc;
  fmProgress.gag.Position:=0;
  fmProgress.Visible:=true;
  fmProgress.Update;
  try
    nd:=fmDocTree.TV.Selected;
    if nd=nil then
     ParentId:=0
    else
     ParentId:=PInfoNode(nd.data).ID;
     
    AppendAll(dir,ParentId);
  finally
   fmProgress.Visible:=false;
   if Assigned(fmDocTree) then begin
    fmDocTree.notSort:=true;
    fmDocTree.ActiveQuery;
    fmDocTree.notSort:=false;
   end;
   Screen.Cursor:=CrDefault;
  end;
end;

procedure SaveDocToDir(Caption: String; Dir: string);

  procedure SaveDocs(CurDir: String; ParentId: Integer);
  var
    msIn: TmemoryStream;
    tr: TIBTransaction;
    qr: TIBQuery;
    sqls: string;
    Aname: String;
    FileDoc: String;
    FileForm: String;
    Counter: Integer;
  begin
    msIn:=TmemoryStream.Create;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select name, datadoc, dataform from '+TableDoc+' where typedoc_id='+inttostr(ParentId);
     qr.SQL.Add(sqls);
     qr.Active:=true;
     qr.fetchAll;


     fmProgress.gag.Max:=qr.RecordCount;
     fmProgress.gag.Position:=0;
     try
       Counter:=0;
       qr.First;
       while not qr.Eof do begin
         Aname:=qr.fieldByName('name').AsString;
         FileDoc:=CurDir+'\'+AName+'.doc';
         FileForm:=ChangeFileExt(FileDoc,'.frm');

         try
           msIn.Clear;
           TBlobField(qr.fieldByName('DataDoc')).SaveToStream(msIn);
           msIn.Position:=0;
           ExtractObjectFromStream(msIn);
           msIn.Position:=0;
           msIn.SaveToFile(FileDoc);

           msIn.Clear;
           TBlobField(qr.fieldByName('Dataform')).SaveToStream(msIn);
           msIn.Position:=0;
           ExtractObjectFromStream(msIn);
           msIn.Position:=0;
           msIn.SaveToFile(FileForm);
         except
           on E: Exception do
             ShowError(Application.Handle,E.Message);
         end;

         inc(Counter);
         SetPositonAndText(Counter,AName,ConstAddDoc,nil,qr.RecordCount);
         
         qr.Next;
       end;
     finally
       fmProgress.gag.Max:=0;
       fmProgress.gag.Position:=0;
     end;
    finally
     qr.Free;
     tr.Free;
     msIn.Free;
    end;
  end;

  procedure SaveAll(CurDir: String; ParentId: Integer);
  var
    msIn: TmemoryStream;
    tr: TIBTransaction;
    qr: TIBQuery;
    sqls: string;
    NewDir: String;
    Id: Integer;
  begin
    msIn:=TmemoryStream.Create;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select * from '+TableTypeDoc+' where parent_id='+inttostr(ParentId)+
           ' order by sort_id ';
     qr.SQL.Add(sqls);
     qr.Active:=true;
     qr.First;
     while not qr.Eof do begin
       NewDir:=CurDir+'\'+qr.FieldByName('name').AsString;
       Id:=qr.FieldByName('typedoc_id').AsInteger;
       CreateDir(NewDir);
       SaveDocs(NewDir,Id);
       SaveAll(NewDir,Id);
       qr.Next;
     end;
    finally
     qr.Free;
     tr.Free;
     msIn.Free;
    end;
  end;

  procedure SaveParent(CurDir: String; ParentId: Integer);
  var
    msIn: TmemoryStream;
    tr: TIBTransaction;
    qr: TIBQuery;
    sqls: string;
    NewDir: String;
  begin
    msIn:=TmemoryStream.Create;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select * from '+TableTypeDoc+' where typedoc_id='+inttostr(ParentId);
     qr.SQL.Add(sqls);
     qr.Active:=true;
     qr.First;
     while not qr.Eof do begin
       NewDir:=CurDir+'\'+qr.FieldByName('name').AsString;
       CreateDir(NewDir);
       SaveDocs(NewDir,ParentId);
       SaveAll(NewDir,ParentId);
       qr.Next;
     end;
    finally
     qr.Free;
     tr.Free;
     msIn.Free;
    end;
  end;

var
  nd: TTreeNode;
  ParentId: Integer;
begin
  Screen.Cursor:=CrHourGlass;
  BreakAnyProgress:=false;
  fmProgress.Caption:=Caption;
  fmProgress.lbProgress.Caption:=ConstAddDoc;
  fmProgress.gag.Position:=0;
  fmProgress.Visible:=true;
  fmProgress.Update;
  try
    nd:=fmDocTree.TV.Selected;
    if nd=nil then begin
      ParentId:=0;
    end else begin
      ParentId:=PInfoNode(nd.data).ID;
    end;

    SaveParent(Dir,ParentId);
  finally
   fmProgress.Visible:=false;
   Screen.Cursor:=CrDefault;
  end;
end;

function InsertToTypeDoc(NameStr,HintStr: String; ParentID: Integer): Integer;
var
    qr: TIBQuery;
    sqls: string;
    PName: string;
    PHint: string;
    PParentID: string;
    PSortID: Integer;
    tr: TIBTransaction;
begin
    Screen.Cursor:=crHourGlass;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     Result:=0;
     PName:=Trim(NameStr);
     PHint:=Trim(HintStr);
     PParentID:=inttostr(ParentID);
     PSortID:=GetNodeSortID(strtoint(PParentID));
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Insert into '+TableTypeDoc+' (name,hint,parent_id,sort_id)'+
        ' values ('''+PName+''','''+PHint+''','+PParentID+','+inttostr(PSortID)+')';
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     tr.Commit;
     Result:=GetMaxTypeDocID;
    finally
     qr.Free;
     tr.Free;
     Screen.Cursor:=crDefault;
    end;
end;

function AppendToDoc(TypeDoc_id: Integer; strFiles: TStringList; strName: string; WithForm: Boolean): Boolean;

  function AppendToDocOne(FileName: string; RenId: Integer): Boolean;
  var
   List: TList;
   msOutDoc,msOutForm: TMemoryStream;
   tb: TIBTable;
   PlistName,PListHint: string;
   PListNodeId: Integer;
   tr: TIBTransaction;
   ext: string;
   FileForm: String;
  begin
   msOutDoc:=TMemoryStream.Create;
   msOutForm:=TMemoryStream.Create;
   List:=TList.Create;
   try
    Result:=false;
    FileForm:=ChangeFileExt(FileName,'.frm');
    if not WithForm or not FileExists(FileForm) then begin
      if not GetListTextObjectFromWord(Application.MainForm,FileName,List,true) then exit;
      SaveNewFormToStream(List,msOutForm,true);
      CompressAndCryptFile(FileName,msOutDoc);
      CompressAndCrypt(msOutForm);
    end else begin
      CompressAndCryptFile(FileName,msOutDoc);
      CompressAndCryptFile(FileForm,msOutForm);
    end;
    PListName:=ExtractFileName(FileName);
    ext:=ExtractFileExt(FileName);
    if trim(ext)<>'' then
     PListName:=Copy(PListName,1,AnsiPos(AnsiUpperCase(ext),AnsiUpperCase(PListName))-1);
    PlistHint:=PListName;
    PListNodeId:=TypeDoc_id;
    tr:=TIBTransaction.Create(nil);
    tb:=TIBTable.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     tb.Database:=dm.IBDbase;
     tb.Transaction:=tr;
     tb.Transaction.Active:=true;
     tb.TableName:=TableDoc;
     tb.Filter:=' name='''+PListName+'''';
     tb.Filtered:=true;
     tb.Active:=true;

     tb.Append;
     tb.FieldByName('doc_id').Required:=false;
     tb.FieldByName('lastdate').Required:=false;
     tb.FieldByName('typedoc_id').AsInteger:=PListNodeId;
     tb.FieldByName('name').AsString:=PListName;
     tb.FieldByName('hint').AsString:=PListHint;
     tb.FieldByName('renovation_id').Value:=iff(RenId=0,Null,RenId);
     msOutDoc.Position:=0;
     TBlobField(tb.FieldByName('datadoc')).LoadFromStream(msOutDoc);
     msOutForm.Position:=0;
     TBlobField(tb.FieldByName('dataform')).LoadFromStream(msOutForm);
     tb.Post;
     tb.Transaction.Commit;
     Result:=true;
    finally
     tb.Free;
     tr.Free;
    end;

   finally
    ClearWordObjectList(List);
    List.Free;
    msOutDoc.free;
    msOutForm.free;
   end;
  end;

var
  i: Integer;
  isSucc: Boolean;
  RenId: Integer;
begin
 isSucc:=true;
 BreakAnyProgress:=false;
 Screen.Cursor:=crAppStart;
 try
  if strFiles.Count>0 then begin
   fmProgress.gag.Max:=strFiles.Count;
   fmProgress.gag.Position:=0;
   RenId:=GetRenovationIdByWorkDate;
   for i:=0 to strFiles.Count-1 do begin
    Application.ProcessMessages;
    if BreakAnyProgress then break;
    if not AppendToDocOne(GetCheckedString(strFiles.Strings[i]),RenId) then
      isSucc:=false
    else begin
      SetPositonAndText(i+1,strFiles.Strings[i],ConstAddDoc,nil,strFiles.Count);
    end;
   end;
  end;
  Result:=isSucc;
 finally
  Screen.Cursor:=crDefault;
 end;
end;

function GetSmallNameEX(Canvas: TCanvas; Text, ConstStr: string; Wid: Integer): String;
var
  wd: Integer;
  i: Integer;
  tmps: string;
  isBig: Boolean;
  len: Integer;
begin
 result:=ConstStr+Text;
 wd:=Canvas.TextWidth(Result);
 if wd>Wid then begin
  tmps:='';
  isBig:=false;
  len:=Length(result);
  for i:=1 to len do begin
    tmps:=tmps+result[i];
    if Canvas.TextWidth(tmps)>=wid-Canvas.TextWidth(ConstStr) then begin
      isBig:=true;
      break;
    end;
  end;
  if isBig then begin
    Result:=Copy(result,1,i+Length(ConstStr)-4)+'...';
  end;
 end;
end;

procedure SetPositonAndText(Pos: Integer; Text,ConstStr: String; fm: TForm=nil; MaxProgress: Integer=100);
var
  fmP: TfmProgress;
begin
 if fm<>nil then begin
   fmP:=TfmProgress(fm);
 end else begin
   if not Assigned(fmProgress) then exit;
   fmP:=fmProgress;
 end;
 if fmP.Visible then begin
   fmP.lbProgress.Caption:=GetSmallNameEX(fmP.Canvas,Text,ConstStr,fmP.lbProgress.width);
   fmP.gag.Position:=Pos;
   fmP.gag.Max:=MaxProgress;
   fmP.Update;
 end;
end;

function GetCheckedString(Instr: String): String;
var
  i: integer;
  ch: char;
begin
  Result:='';
  for i:=1 to Length(InStr) do begin
    ch:=Instr[i];
    if ch='''' then ch:=' ';
    Result:=Result+ch;
  end;
end;


function isControlConsistPropPadegAndEqual(ct: TControl; TypeCase: TTypeCase): Boolean;
var
  propname: string;
  EnumProp: Integer;
begin
  Result:=false;
  if ct=nil then exit;
  propName:='TypeCase';
  if IsPublishedProp(ct,propName)then begin
   EnumProp:=GetOrdProp(ct,PropName);
   if TTypeCase(EnumProp)=TypeCase then begin
     Result:=true;
     exit;
   end;
 end;
end;

function GetUserDopField(tmpUserId: Integer; var UristFio,UrAdress,Town: string): Boolean;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=false;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableUsers+
         ' where user_id='+inttostr(tmpUserId);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then begin
    UristFio:=Trim(qr.FieldByName('uristfio').AsString);
    UrAdress:=Trim(qr.FieldByName('uradres').AsString);
    Town:=Trim(qr.FieldByName('town').AsString);
    Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function GetUserLicense(tmpLicenceID: Integer; var retNum: string;
                        var retUserId: Integer; var retDateLice: TDate;
                        var retKem: string): Boolean;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=false;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableLicense+
         ' where license_id='+inttostr(tmpLicenceID);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then begin
    retNum:=Trim(qr.FieldByName('num').AsString);
    retUserId:=qr.FieldByName('user_id').AsInteger;
    retDateLice:=qr.FieldByName('datelic').AsDateTime;
    retKem:=Trim(qr.FieldByName('kem').AsString);
    Result:=true;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function GetNotariusList(OnlyNotary: Boolean=false): String;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:='������������������ ���������:';
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   if OnlyNotary then
     sqls:='Select fio from '+TableNotarius+' where ishelper=0 order by fio'
   else
     sqls:='Select fio from '+TableNotarius+' order by fio';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   qr.First;
   while not qr.Eof do begin
     Result:=Result+#13+qr.FieldByName('fio').AsString;
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function GetDocName(Doc_id: Integer): string;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:='';
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select name from '+TableDoc+
         ' where doc_id='+inttostr(Doc_id) ;
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then
    Result:=qr.FieldByname('name').AsString;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function GetOperName(Oper_id: Integer): string;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:='';
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select name from '+TableOperation+
         ' where oper_id='+inttostr(Oper_id) ;
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then
    Result:=qr.FieldByname('name').AsString;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function ChangeDecimalSeparator(InString: String; Ch: Char): String;
var
  i: Integer;
  ch1: Char;
begin
  ch1:=DecimalSeparator;
  for i:=0 to Length(InString)-1 do begin
    if Instring[i+1]=ch1 then begin
      Instring[i+1]:=ch;
    end;
  end;
  result:=InString;
end;

procedure GetInfoNotarius(TypeReestr_id: Integer; P: PInfoNotarius; RenovationId: Integer);
var
  qrConst: TIBQuery;

  function GetConstValueByNameLocal(Name: string; isHelper: Boolean; RenovationID: Integer): String;
  var
    S: String;
  begin
    Result:='';
    if qrConst.Active then begin
      if not isHelper then
        S:='val'
      else S:='valplus';
      if qrConst.Locate('name',Name,[loCaseInsensitive]) then begin
        Result:=Trim(qrConst.FieldByName(S).AsString);
      end;
    end;
  end;

var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
  trConst: TIBTransaction;
  Helper: Boolean;
  renovation_id: Integer;
begin
  if P=nil then exit;
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  trConst:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  qrConst:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select tn.* from '+TableTypeReestr+' ttr join '+
         TableNotarius+' tn on ttr.not_id=tn.not_id '+
         ' where ttr.typereestr_id='+inttostr(TypeReestr_id) ;
   qr.SQL.Add(sqls);
   qr.Active:=true;

   trConst.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(trConst);
   trConst.Params.Text:=DefaultTransactionParamsTwo;
   qrConst.Database:=dm.IBDbase;
   qrConst.Transaction:=trConst;
   qrConst.Transaction.Active:=true;
   qrConst.ParamCheck:=false;

   if RenovationID=0 then
     renovation_id:=GetRenovationIdByWorkDate()
   else renovation_id:=RenovationID;

   sqls:='Select * from '+TableConst+iff(renovation_id<>0,' where renovation_id='+inttostr(renovation_id),'');
   qrConst.SQL.Add(sqls);
   qrConst.Active:=true;

   if qr.RecordCount>0 then begin
     P.not_id:=qr.FieldByName('not_id').AsInteger;
     P.isHelper:=qr.FieldByName('ishelper').AsInteger;
     Helper:=Boolean(P.isHelper);

     P.FIO:=GetConstValueByNameLocal(WordFieldFIO_Imenit,Helper,RenovationId);
     if Trim(P.FIO)='' then P.FIO:=qr.FieldByName('fio').AsString;

     P.FIODatel:=GetConstValueByNameLocal(WordFieldFIO_Datel,Helper,RenovationId);
     if Trim(P.FIODatel)='' then P.FIODatel:=GetPadegStr(P.FIO,tcDatel);

     P.FIORodit:=GetConstValueByNameLocal(WordFieldFIO_Rodit,Helper,RenovationId);
     if Trim(P.FIORodit)='' then P.FIORodit:=GetPadegStr(P.FIO,tcRodit);

     P.FIOVinit:=GetConstValueByNameLocal(WordFieldFIO_Vinit,Helper,RenovationId);
     if Trim(P.FIOVinit)='' then P.FIOVinit:=GetPadegStr(P.FIO,tcVinit);

     P.FIOTvorit:=GetConstValueByNameLocal(WordFieldFIO_Tvorit,Helper,RenovationId);
     if Trim(P.FIOTvorit)='' then P.FIOTvorit:=GetPadegStr(P.FIO,tcTvorit);

     P.FIOPredl:=GetConstValueByNameLocal(WordFieldFIO_Predl,Helper,RenovationId);
     if Trim(P.FIOPredl)='' then P.FIOPredl:=GetPadegStr(P.FIO,tcPredl);

     P.FIOSmall:=GetConstValueByNameLocal(WordFieldFIO_Imenit_sm,Helper,RenovationId);
     if Trim(P.FIOSmall)='' then P.FIOSmall:=GetSmallFIONew(P.FIO);

     P.FIO_h:=GetConstValueByNameLocal(WordFieldFIO_Imenit_h,Helper,RenovationId);
     if Trim(P.FIO_h)='' then P.FIO_h:=qr.FieldByName('fio').AsString;

     P.FIODatel_h:=GetConstValueByNameLocal(WordFieldFIO_Datel_h,Helper,RenovationId);
     if Trim(P.FIODatel_h)='' then P.FIODatel_h:=GetPadegStr(P.FIO_h,tcDatel);

     P.FIORodit_h:=GetConstValueByNameLocal(WordFieldFIO_Rodit_h,Helper,RenovationId);
     if Trim(P.FIORodit_h)='' then P.FIORodit_h:=GetPadegStr(P.FIO_h,tcRodit);

     P.FIOVinit_h:=GetConstValueByNameLocal(WordFieldFIO_Vinit_h,Helper,RenovationId);
     if Trim(P.FIOVinit_h)='' then P.FIOVinit_h:=GetPadegStr(P.FIO_h,tcVinit);

     P.FIOTvorit_h:=GetConstValueByNameLocal(WordFieldFIO_Tvorit_h,Helper,RenovationId);
     if Trim(P.FIOTvorit_h)='' then P.FIOTvorit_h:=GetPadegStr(P.FIO_h,tcTvorit);

     P.FIOPredl_h:=GetConstValueByNameLocal(WordFieldFIO_Predl_h,Helper,RenovationId);
     if Trim(P.FIOPredl_h)='' then P.FIOPredl_h:=GetPadegStr(P.FIO_h,tcPredl);

     P.FIOSmall_h:=GetConstValueByNameLocal(WordFieldFIO_Imenit_sm_h,Helper,RenovationId);
     if Trim(P.FIOSmall_h)='' then P.FIOSmall_h:=GetSmallFIONew(P.FIO_h);

     P.UrAdres:=GetConstValueByNameLocal(WordFieldUrAdres,Helper,RenovationId);
     if Trim(P.UrAdres)='' then begin
       P.UrAdres:=GetConstValueByNameLocal(WordFieldUrAdres2,Helper,RenovationId);
       if Trim(P.UrAdres)='' then begin
         P.UrAdres:=qr.FieldByName('uradres').AsString;
       end;
     end;

     P.Phone:=GetConstValueByNameLocal(WordFieldPhone,Helper,RenovationId);
     if Trim(P.Phone)='' then P.Phone:=qr.FieldByName('phone').AsString;

     P.INN:=GetConstValueByNameLocal(WordFieldINN,Helper,RenovationId);
     if Trim(P.INN)='' then P.INN:=qr.FieldByName('inn').AsString;

     P.TownFull_Normal:=GetConstValueByNameLocal(WordFieldTownFull_Normal,Helper,RenovationId);
     if Trim(P.TownFull_Normal)='' then begin
       P.TownFull_Normal:=GetConstValueByNameLocal(WordFieldTownFull_Normal2,Helper,RenovationId);
       if Trim(P.TownFull_Normal)='' then begin
         P.TownFull_Normal:=qr.FieldByName('townfullnormal').AsString;
         P.NameFull_Normal:=qr.FieldByName('nametownnormal').AsString;
       end;
     end;

     P.TownFull_Where:=GetConstValueByNameLocal(WordFieldTownFull_Where,Helper,RenovationId);
     if Trim(P.TownFull_Where)='' then begin
       P.TownFull_Where:=GetConstValueByNameLocal(WordFieldTownFull_Where2,Helper,RenovationId);
       if Trim(P.TownFull_Where)='' then begin
         P.TownFull_Where:=qr.FieldByName('townfullwhere').AsString;
         P.NameFull_Where:=qr.FieldByName('nametownwhere').AsString;
       end;
     end;

     P.TownFull_What:=GetConstValueByNameLocal(WordFieldTownFull_What,Helper,RenovationId);
     if Trim(P.TownFull_What)='' then begin
       P.TownFull_What:=GetConstValueByNameLocal(WordFieldTownFull_What2,Helper,RenovationId);
       if Trim(P.TownFull_What)='' then begin
         P.TownFull_What:=qr.FieldByName('townfullwhat').AsString;
         P.NameFull_What:=qr.FieldByName('nametownwhat').AsString;
       end;
     end;

     P.TownSmall_Normal:=GetConstValueByNameLocal(WordFieldTownSmall_Normal,Helper,RenovationId);
     if Trim(P.TownSmall_Normal)='' then begin
       P.TownSmall_Normal:=GetConstValueByNameLocal(WordFieldTownSmall_Normal2,Helper,RenovationId);
       if Trim(P.TownSmall_Normal)='' then begin
         P.TownSmall_Normal:=qr.FieldByName('townsmallnormal').AsString;
         P.NameSmall_Normal:=qr.FieldByName('nametownnormal').AsString;
       end;
     end;

     P.TownSmall_Where:=GetConstValueByNameLocal(WordFieldTownSmall_Where,Helper,RenovationId);
     if Trim(P.TownSmall_Where)='' then begin
       P.TownSmall_Where:=GetConstValueByNameLocal(WordFieldTownSmall_Where2,Helper,RenovationId);
       if Trim(P.TownSmall_Where)='' then begin
         P.TownSmall_Where:=qr.FieldByName('townsmallwhere').AsString;
         P.NameSmall_Where:=qr.FieldByName('nametownwhere').AsString;
       end;
     end;

     P.TownSmall_What:=GetConstValueByNameLocal(WordFieldTownSmall_What,Helper,RenovationId);
     if Trim(P.TownSmall_What)='' then begin
       P.TownSmall_What:=GetConstValueByNameLocal(WordFieldTownSmall_What2,Helper,RenovationId);
       if Trim(P.TownSmall_What)='' then begin
         P.TownSmall_What:=qr.FieldByName('townsmallwhat').AsString;
         P.NameSmall_What:=qr.FieldByName('nametownwhat').AsString;
       end;
     end;

   end;
  finally
   qrConst.Free;
   qr.Free;
   trConst.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure GetInfoNotariusEx(not_id: Integer; P: PInfoNotarius; RenovationId: Integer;
                            OnlyFio, OnlyFioHelper, OnlyAddress: Boolean);
var
  qrConst: TIBQuery;

  function GetConstValueByNameLocal(Name: string; isHelper: Boolean; RenovationID: Integer): String;
  var
    S: String;
  begin
    Result:='';
    if qrConst.Active then begin
      if not isHelper then
        S:='val'
      else S:='valplus';
      if qrConst.Locate('name',Name,[loCaseInsensitive]) then begin
        Result:=Trim(qrConst.FieldByName(S).AsString);
      end;
    end;
  end;

var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
  trConst: TIBTransaction;
  Helper: Boolean;
  renovation_id: Integer;
begin
  if P=nil then exit;
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  trConst:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  qrConst:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableNotarius+
         ' where not_id='+inttostr(not_id);
   qr.SQL.Add(sqls);
   qr.Active:=true;

   trConst.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(trConst);
   trConst.Params.Text:=DefaultTransactionParamsTwo;
   qrConst.Database:=dm.IBDbase;
   qrConst.Transaction:=trConst;
   qrConst.Transaction.Active:=true;
   qrConst.ParamCheck:=false;

   if RenovationID=0 then
     renovation_id:=GetRenovationIdByWorkDate()
   else renovation_id:=RenovationID;

   sqls:='Select * from '+TableConst+iff(renovation_id<>0,' where renovation_id='+inttostr(renovation_id),'');
   qrConst.SQL.Add(sqls);
   qrConst.Active:=true;
   
   if qr.RecordCount>0 then begin
     P.not_id:=qr.FieldByName('not_id').AsInteger;
     P.isHelper:=qr.FieldByName('ishelper').AsInteger;
     Helper:=Boolean(P.isHelper);

     if OnlyFioHelper then begin
       P.FIO_h:=GetConstValueByName(WordFieldFIO_Imenit_h,Helper,RenovationId);
       if Trim(P.FIO_h)='' then P.FIO_h:=qr.FieldByName('fio').AsString;

       P.FIODatel_h:=GetConstValueByName(WordFieldFIO_Datel_h,Helper,RenovationId);
       if Trim(P.FIODatel_h)='' then P.FIODatel_h:=GetPadegStr(P.FIO_h,tcDatel);

       P.FIORodit_h:=GetConstValueByName(WordFieldFIO_Rodit_h,Helper,RenovationId);
       if Trim(P.FIORodit_h)='' then P.FIORodit_h:=GetPadegStr(P.FIO_h,tcRodit);

       P.FIOVinit_h:=GetConstValueByName(WordFieldFIO_Vinit_h,Helper,RenovationId);
       if Trim(P.FIOVinit_h)='' then P.FIOVinit_h:=GetPadegStr(P.FIO_h,tcVinit);

       P.FIOTvorit_h:=GetConstValueByName(WordFieldFIO_Tvorit_h,Helper,RenovationId);
       if Trim(P.FIOTvorit_h)='' then P.FIOTvorit_h:=GetPadegStr(P.FIO_h,tcTvorit);

       P.FIOPredl_h:=GetConstValueByName(WordFieldFIO_Predl_h,Helper,RenovationId);
       if Trim(P.FIOPredl_h)='' then P.FIOPredl_h:=GetPadegStr(P.FIO_h,tcPredl);

       P.FIOSmall_h:=GetConstValueByName(WordFieldFIO_Imenit_sm_h,Helper,RenovationId);
       if Trim(P.FIOSmall_h)='' then P.FIOSmall_h:=GetSmallFIONew(P.FIO_h);
     end;

     if OnlyFio then begin
       P.FIO:=GetConstValueByName(WordFieldFIO_Imenit,Helper,RenovationId);
       if Trim(P.FIO)='' then P.FIO:=qr.FieldByName('fio').AsString;

       P.FIODatel:=GetConstValueByName(WordFieldFIO_Datel,Helper,RenovationId);
       if Trim(P.FIODatel)='' then P.FIODatel:=GetPadegStr(P.FIO,tcDatel);

       P.FIORodit:=GetConstValueByName(WordFieldFIO_Rodit,Helper,RenovationId);
       if Trim(P.FIORodit)='' then P.FIORodit:=GetPadegStr(P.FIO,tcRodit);

       P.FIOVinit:=GetConstValueByName(WordFieldFIO_Vinit,Helper,RenovationId);
       if Trim(P.FIOVinit)='' then P.FIOVinit:=GetPadegStr(P.FIO,tcVinit);

       P.FIOTvorit:=GetConstValueByName(WordFieldFIO_Tvorit,Helper,RenovationId);
       if Trim(P.FIOTvorit)='' then P.FIOTvorit:=GetPadegStr(P.FIO,tcTvorit);

       P.FIOPredl:=GetConstValueByName(WordFieldFIO_Predl,Helper,RenovationId);
       if Trim(P.FIOPredl)='' then P.FIOPredl:=GetPadegStr(P.FIO,tcPredl);

       P.FIOSmall:=GetConstValueByName(WordFieldFIO_Imenit_sm,Helper,RenovationId);
       if Trim(P.FIOSmall)='' then P.FIOSmall:=GetSmallFIONew(P.FIO);
     end;

     if OnlyAddress then begin
     
       P.UrAdres:=GetConstValueByName(WordFieldUrAdres,Helper,RenovationId);
       if Trim(P.UrAdres)='' then begin
         P.UrAdres:=GetConstValueByName(WordFieldUrAdres2,Helper,RenovationId);
         if Trim(P.UrAdres)='' then begin
           P.UrAdres:=qr.FieldByName('uradres').AsString;
         end;
       end;

       P.Phone:=GetConstValueByName(WordFieldPhone,Helper,RenovationId);
       if Trim(P.Phone)='' then P.Phone:=qr.FieldByName('phone').AsString;

       P.INN:=GetConstValueByName(WordFieldINN,Helper,RenovationId);
       if Trim(P.INN)='' then P.INN:=qr.FieldByName('inn').AsString;

       P.TownFull_Normal:=GetConstValueByName(WordFieldTownFull_Normal,Helper,RenovationId);
       if Trim(P.TownFull_Normal)='' then begin
         P.TownFull_Normal:=GetConstValueByName(WordFieldTownFull_Normal2,Helper,RenovationId);
         if Trim(P.TownFull_Normal)='' then begin
           P.TownFull_Normal:=qr.FieldByName('townfullnormal').AsString;
           P.NameFull_Normal:=qr.FieldByName('nametownnormal').AsString;
         end;
       end;

       P.TownFull_Where:=GetConstValueByName(WordFieldTownFull_Where,Helper,RenovationId);
       if Trim(P.TownFull_Where)='' then begin
         P.TownFull_Where:=GetConstValueByName(WordFieldTownFull_Where2,Helper,RenovationId);
         if Trim(P.TownFull_Where)='' then begin
           P.TownFull_Where:=qr.FieldByName('townfullwhere').AsString;
           P.NameFull_Where:=qr.FieldByName('nametownwhere').AsString;
         end;
       end;

       P.TownFull_What:=GetConstValueByName(WordFieldTownFull_What,Helper,RenovationId);
       if Trim(P.TownFull_What)='' then begin
         P.TownFull_What:=GetConstValueByName(WordFieldTownFull_What2,Helper,RenovationId);
         if Trim(P.TownFull_What)='' then begin
           P.TownFull_What:=qr.FieldByName('townfullwhat').AsString;
           P.NameFull_What:=qr.FieldByName('nametownwhat').AsString;
         end;
       end;

       P.TownSmall_Normal:=GetConstValueByName(WordFieldTownSmall_Normal,Helper,RenovationId);
       if Trim(P.TownSmall_Normal)='' then begin
         P.TownSmall_Normal:=GetConstValueByName(WordFieldTownSmall_Normal2,Helper,RenovationId);
         if Trim(P.TownSmall_Normal)='' then begin
           P.TownSmall_Normal:=qr.FieldByName('townsmallnormal').AsString;
           P.NameSmall_Normal:=qr.FieldByName('nametownnormal').AsString;
         end;
       end;

       P.TownSmall_Where:=GetConstValueByName(WordFieldTownSmall_Where,Helper,RenovationId);
       if Trim(P.TownSmall_Where)='' then begin
         P.TownSmall_Where:=GetConstValueByName(WordFieldTownSmall_Where2,Helper,RenovationId);
         if Trim(P.TownSmall_Where)='' then begin
           P.TownSmall_Where:=qr.FieldByName('townsmallwhere').AsString;
           P.NameSmall_Where:=qr.FieldByName('nametownwhere').AsString;
         end;
       end;

       P.TownSmall_What:=GetConstValueByName(WordFieldTownSmall_What,Helper,RenovationId);
       if Trim(P.TownSmall_What)='' then begin
         P.TownSmall_What:=GetConstValueByName(WordFieldTownSmall_What2,Helper,RenovationId);
         if Trim(P.TownSmall_What)='' then begin
           P.TownSmall_What:=qr.FieldByName('townsmallwhat').AsString;
           P.NameSmall_What:=qr.FieldByName('nametownwhat').AsString;
         end;
       end;
     end;
   end;
  finally
   qrConst.Free;
   qr.Free;
   trConst.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function CalculateRealyWidth(tb: TToolBar): Integer;
var
  i,w: Integer;
begin
  w:=0;
  for i:=0 to tb.ButtonCount-1 do begin
    if tb.Buttons[i].Visible then
      w:=w+tb.Buttons[i].Width;
  end;
  Result:=w;
end;

procedure CheckPermissions;
begin
  if isEdit then begin
    fmmain.ViewType:=vtEdit;
    fmmain.miViewEditNew.Click;

    fmMain.miRBUsers.Visible:=true;
    fmMain.miRBTypeReestr.Visible:=true;
    fmMain.miRBOperation.Visible:=true;
    fmMain.miRBMask.Visible:=true;
    fmMain.miRBCase.Visible:=true;
    fmMain.miRBMarkCar.Visible:=true;
    fmMain.miRBColor.Visible:=true;
    fmMain.miRBLicense.Visible:=true;
    fmMain.miRBNotarius.Visible:=true;
    fmMain.miRB.Visible:=true;

    fmmain.miViewViewNew.Visible:=true;
    fmmain.miViewEditNew.Visible:=true;
    fmMain.miViewNew.Visible:=true;

    fmmain.miService.Visible:=true;

    fmmain.tlbOptions.Visible:=true;


  end else begin
    fmmain.ViewType:=vtView;
    fmmain.miViewViewNew.Click;

    fmmain.miViewViewNew.Visible:=false;
    fmmain.miViewEditNew.Visible:=false;
    fmMain.miViewNew.Visible:=false;
    fmmain.miService.Visible:=false;
    fmmain.tlbOptions.Visible:=false;
//    fmMain.tlbCurrentForm.Visible:=false;

    if UserIsAdmin then begin
     fmMain.miRBUsers.Visible:=false;
     fmMain.miRBTypeReestr.Visible:=false;
     fmMain.miRBOperation.Visible:=true;
     fmMain.miRBMask.Visible:=false;
     fmMain.miRBCase.Visible:=true;
     fmMain.miRBMarkCar.Visible:=true;
     fmMain.miRBColor.Visible:=true;
     fmMain.miRBLicense.Visible:=true;
     fmMain.miRBNotarius.Visible:=false;
     fmMain.miRB.Visible:=true;


    end else begin
     fmMain.miRBUsers.Visible:=false;
     fmMain.miRBTypeReestr.Visible:=false;
     fmMain.miRBOperation.Visible:=false;
     fmMain.miRBMask.Visible:=false;
     fmMain.miRBCase.Visible:=false;
     fmMain.miRBMarkCar.Visible:=false;
     fmMain.miRBColor.Visible:=false;
     fmMain.miRBLicense.Visible:=false;
     fmMain.miRBNotarius.Visible:=false;
     fmMain.miRB.Visible:=false;

    end;
  end;


  if not isEdit then begin
    fmMain.miRBNotarius.Visible:=false;
    fmMain.miCarringDoc.Visible:=false;
    fmMain.miOperationPatchUtil.Visible:=false;
    fmMain.miOperationUpdateWords.Visible:=false;
  end else
    fmMain.miCarringDoc.Visible:=false;

  if isNotViewHereditaryDeal then
    fmMain.tlbbutHereditaryDeal.Visible:=false
  else
    fmMain.tlbbutHereditaryDeal.Visible:=true;

  fmmain.tlbMain.Width:=CalculateRealyWidth(fmmain.tlbMain);
  fmmain.tlbMain.AutoSize:=false;
  fmmain.tlbMain.AutoSize:=true;
end;


procedure ReadAndSettlbMainParams;
var
  fi: TIniFile;
  FloatPos: Boolean;
begin
  if not Assigned(fmMain) then exit;
  exit;
 try
  fi:=TIniFile.Create(GetIniFileName);
  try
   with fmMain do begin
    tlbMain.Width:=fi.ReadInteger('Main','tlbMainWidth',tlbMain.Width);
    tlbMain.Height:=fi.ReadInteger('Main','tlbMainHeight',tlbMain.Height);
    tlbMain.Left:=fi.ReadInteger('Main','tlbMainLeft',tlbMain.Left);
    tlbMain.Top:=fi.ReadInteger('Main','tlbMainTop',tlbMain.Top);
    FloatPos:=fi.ReadBool('Main','tlbMainFloat',tlbMain.Floating);
    if FloatPos then tlbMain.parent:=ctrlBarTop;
    tlbMain.Visible:=fi.ReadBool('Main','tlbMainVisible',tlbMain.Visible);

    tlbMain.DockOrientation:=doHorizontal;
   end; 
  finally
   fi.free;
  end;
 except
 end; 
end;

function GetTransformationResult(Text: String; ct: TControl): String;

  function GetFirstUpperText: String;
  var
    tmps: string;
  begin
    Result:=Text;
    if Length(Text)=0 then exit;
    tmps:=Text[1];
    tmps:=AnsiUpperCase(tmps);
    Text[1]:=tmps[1];
    Result:=Text;
  end;
  
var
  EnumProp: Integer;
const
  PropName='TypeUpperLower';
begin
  Result:=Text;
  if not IsPublishedProp(ct,PropName) then exit;
  EnumProp:=GetOrdProp(ct,PropName);
  case TTypeUpperLower(EnumProp) of
    tulNone: Result:=Text;
    tulFirstUpper: Result:=GetFirstUpperText;

  end;
end;

function SearchInForm(ms: TmemoryStream; FindString: String;
                      Reestr_id: Integer; InString: Boolean): Boolean;
var
  fmNew: TfmNewForm;
  msOutForm: TMemoryStream;
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  Error: Boolean;
begin
  Screen.Cursor:=crHourGlass;
  fmNew:=TfmNewForm.Create(nil);
  msOutForm:=TMemoryStream.Create;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    Result:=false;
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select dataform from '+TableReestr+' where reestr_id='+inttostr(reestr_id);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    TBlobField(qr.fieldByName('dataform')).SaveToStream(msOutForm);
    msOutForm.Position:=0;
    ExtractObjectFromStream(msOutForm);
    msOutForm.Position:=0;
    FreeAllComponents(fmNew);
//    PropNoneRead_FormStyle:='FormStyle';
//    PropNoneRead_Visible:='Visible';
    Error:=false;
    LoadControlFromStream(fmNew,msOutForm,Error);
    if not Error then begin

      fmNew.DestroyHeaderAndCreateNew;
  //    PropNoneRead_FormStyle:='';
  //    PropNoneRead_Visible:='';

      ExtractObjectFromStream(ms);
      ms.Position:=0;
      fmNew.InitAll;

      result:=ControlConsistString(fmNew.pnDesign,FindString,InString);
    end;
  finally
    msOutForm.Free;
    qr.Free;
    tr.Free;
    fmNew.free;
    Screen.Cursor:=crDefault;
  end;
end;

function GetTextFromControl(ct: TControl): String;
begin
    Result:='';
    if ct is TLabel then Result:=TNewLabel(ct).Caption;
    if ct is TEdit then Result:=TNewEdit(ct).Text;
    if ct is TComboBox then Result:=TNewComboBox(ct).Text;
    if ct is TMemo then Result:=TNewMemo(ct).Lines.Text;
    if ct is TCheckBox then Result:=TNewCheckBox(ct).Caption;
    if ct is TRadioButton then Result:=TNewRadioButton(ct).Caption;
    if ct is TListBox then begin
     if (TListBox(ct).Items.Count>0) and (TListBox(ct).ItemIndex<>-1) then
      Result:=TListBox(ct).Items.Strings[TListBox(ct).itemindex];
    end;
    if ct is TRadioGroup then begin
     if (TRadioGroup(ct).Items.Count>0) and (TRadioGroup(ct).ItemIndex<>-1) then
      Result:=TRadioGroup(ct).Items.Strings[TRadioGroup(ct).ItemIndex];
    end; 
    if ct is TMaskEdit then Result:=TMaskEdit(ct).Text;
    if ct is TRichEdit then Result:=TRichEdit(ct).Lines.Text;
    if ct is TDateTimePicker then begin
     case TDateTimePicker(ct).Kind of
       dtkDate: Result:=DateToStr(TDateTimePicker(ct).DateTime);
       dtkTime: Result:=TimeToStr(TDateTimePicker(ct).DateTime);
     end;
    end;
    if ct is TRxCalcEdit then Result:=FloatToStr(TRxCalcEdit(ct).Value);
    if ct is TDateEdit then begin
      if TDateEdit(ct).Date<>0 then
        Result:=DateToStr(TDateEdit(ct).Date);
    end;  
    if ct is TfmNewForm then Result:='�����';
    if ct is TPageControl then Result:='��������';
    if ct is TTabSheet then Result:=TTabSheet(ct).Caption;
    if ct is TScrollBox then Result:='�������������� ����';
end;

function ControlConsistString(wt: TWinControl; str: String; InString: Boolean): Boolean;

  function CtrlConsistsString(ct: TControl): Boolean;
  var
    tmps: string;
    APos: Integer;
  begin
    Result:=false;
    tmps:=GetTextFromControl(ct);
    if Instring then begin
      APos:=Pos(AnsiUpperCase(str),AnsiUpperCase(tmps));
      if Apos<>0 then
        Result:=true;
    end else begin
      if AnsiUpperCase(tmps)=AnsiUpperCase(str) then begin
         Result:=true;
      end;
    end;
  end;

var
  i: Integer;
  ct: TControl;
begin
  Result:=false;
  for i:=0 to wt.ControlCount-1 do begin
    ct:=wt.Controls[i];
    Result:=CtrlConsistsString(ct);
    if Result then exit;
    if ct is TWinControl then begin
      result:=ControlConsistString(TWinControl(ct),str,InString);
      if Result then exit;
    end;
  end;
end;

procedure SaveNewFormToStream(List: TList; MsOut: TmemoryStream; ViewProgress: Boolean=false);

  procedure CreateBottomControls(fm: TFmNewForm);
  begin
  end;

  function GetSizeLabel(lb: TNewLabel): Integer;
  begin
    with lb.Canvas do begin
      result:=TextWidth(lb.Caption);
    end;
  end;

  function GetTabIndex(FieldName: string): Integer;
  var
    ch: char;
    tmps: string;
    i: integer;
  begin
    Result:=-1;
    tmps:='';
    for i:=1 to Length(FieldName) do begin
      ch:=FieldName[i];
      if ch in ['1'..'9'] then begin
        tmps:=tmps+ch;
      end;
    end;
    if Trim(tmps)<>'' then
      Result:=StrToInt(tmps);
  end;

  function GetRealParent(Owner,Ctrl: TWinControl; FieldName: string): TWinControl;
  var
   ct: TComponent;
   Val: Integer;
   tmps: string;
  begin
   result:=Ctrl;
   ct:=Owner.FindComponent(ConstPageControlMain);
   if ct=nil then begin
     ct:=Owner.FindComponent(ConstPageControlMainOld);
     if ct=nil then exit;
   end;
{   if TPageControl(ct).PageCount>0 then begin
    Result:=TPageControl(ct).ActivePage;}
   val:=GetTabIndex(FieldName);
   if val=-1 then begin
    Val:=0;
   end;
   tmps:=ConstScrollBox+ConstTabSheetMain+inttostr(Val);
   ct:=Owner.FindComponent(tmps);
   if ct=nil then begin
     tmps:=ConstScrollBox+ConstTabSheetMainOld+inttostr(Val);
     ct:=Owner.FindComponent(tmps);
   end;
   Result:=TWinControl(ct);
  end;

  procedure CreateQuoteControls(Owner,Ctrl: TWinControl; P: PFieldQuote;
                                y,x: Integer; StrPlus: String);
  var
    lb: TNewLabel;
  //  SizeLb: Integer;
    ed: TNewEdit;
    dtp: TNewDateTimePicker;
    rxcalc: TNewRxCalcEdit;
  const
    dx=15;
    NewSize=100;
  begin
    lb:=TNewLabel.Create(Owner);
    lb.Parent:=GetRealParent(Owner,Ctrl,P.FieldName);
    lb.Top:=y;
    lb.Left:=x;
    lb.Caption:=P.FieldName+':';
    lb.DocFieldName:='';
    lb.Name:=DsnCheckNameNew(Owner,lb,'NewLabel');
//    SizeLb:=GetSizeLabel(lb);

    if Pos(AnsiUpperCase('����'),AnsiUpperCASE(P.FieldName))<>0 then begin
     dtp:=TNewDateTimePicker.Create(Owner);
     dtp.Parent:=lb.Parent;
     dtp.Top:=y-3;
     dtp.Left:=lb.Left+lb.Width+dx;
     dtp.DocFieldName:=P.FieldName;
     dtp.Name:=DsnCheckNameNew(Owner,dtp,'NewDateTimePicker');
     dtp.Width:=NewSize;
     exit;
    end;

    if Pos(AnsiUpperCase('�����'),AnsiUpperCASE(P.FieldName))<>0 then begin
     rxcalc:=TNewRxCalcEdit.Create(Owner);
     rxcalc.Parent:=lb.Parent;
     rxcalc.Top:=y-3;
     rxcalc.Left:=lb.Left+lb.Width+dx;
     rxcalc.DocFieldName:=P.FieldName;
     rxcalc.Name:=DsnCheckNameNew(Owner,rxcalc,'NewRxCalcEdit');
     rxcalc.Width:=NewSize;
     exit;
    end;

    ed:=TNewEdit.Create(Owner);
    ed.Parent:=lb.Parent;
    ed.Top:=y-3;
    ed.Left:=lb.Left+lb.Width+dx;
    ed.DocFieldName:=P.FieldName;
    ed.Text:=P.FieldName;
    ed.Name:=DsnCheckNameNew(Owner,ed,'NewEdit');
    ed.Width:=NewSize;


  end;

  procedure PagesNeeded(Owner,Ctrl: TWinControl; lstParent: TList);
  var
    AlreadyCreated: Boolean;

    function FieldNameConsistNumbers(FieldName: string): Boolean;
    var
      pg: TPageControl;
      ts: TTabSheet;
      sb: TScrollBox;
      Val: Integer;
      ct: TComponent;
      tmps: string;
    begin
      Result:=false;
      Val:=GetTabIndex(FieldName);
      tmps:=ConstPageControlMain;
      if Val<>-1 then begin
        if not AlreadyCreated then begin
         pg:=TPageControl.Create(Owner);
         pg.parent:=Ctrl;
         pg.Name:=tmps;
         pg.Align:=alClient;
         AlreadyCreated:=true;
        end else begin
         pg:=TPageControl(Owner.FindComponent(tmps));
         if pg=nil then exit;
        end;
        tmps:=ConstTabSheetMain+inttostr(Val);
        ct:=Owner.FindComponent(tmps);
        if ct<>nil then begin
          ct:=Owner.FindComponent(ConstTabSheetMainOld+inttostr(Val));
          if ct<>nil then exit;
        end;
        ts:=TTabSheet.Create(Owner);
        ts.PageControl:=pg;
        ts.parent:=pg;
        ts.Name:=tmps;
        sb:=TScrollBox.Create(Owner);
        sb.Parent:=ts;
        sb.Name:=ConstScrollBox+ts.Name;
        sb.Align:=alClient;
        sb.BorderStyle:=bsNone;
        lstParent.Add(sb);
      end else begin
        if not AlreadyCreated then begin
         pg:=TPageControl.Create(Owner);
         pg.parent:=Ctrl;
         pg.Name:=tmps;
         pg.Align:=alClient;
         AlreadyCreated:=true;
        end else begin
         pg:=TPageControl(Owner.FindComponent(tmps));
         if pg=nil then exit;
        end;
        tmps:=ConstTabSheetMain+inttostr(0);
        ct:=Owner.FindComponent(tmps);
        if ct<>nil then begin
          ct:=Owner.FindComponent(ConstTabSheetMainOld+inttostr(0));
          if ct<>nil then exit;
        end;
        ts:=TTabSheet.Create(Owner);
        ts.PageControl:=pg;
        ts.parent:=pg;
        ts.Name:=tmps;
        sb:=TScrollBox.Create(Owner);
        sb.Parent:=ts;
        sb.Name:=ConstScrollBox+ts.Name;
        sb.Align:=alClient;
        sb.BorderStyle:=bsNone;
        lstParent.Add(sb);
      end;
    end;

  var
    i: Integer;
    P: PInfoWordType;
  begin
    AlreadyCreated:=false;
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      case P.WordType of
        wtFieldQuote: begin
          FieldNameConsistNumbers(PFieldQuote(P.PField).FieldName);
        end;
      end;
    end;
  end;

  procedure CreateControls(Owner,Ctrl: TWinControl; var W,H: Integer);

    procedure GetFieldsFromParent(lstFields: TList; wt: TWinControl);
    var
      i: Integer;
      P: PInfoWordType;
      prn: TWinControl;
    begin
      for i:=0 to List.Count-1 do begin
       P:=List.Items[i];
       case P.WordType of
         wtFieldQuote: begin
           prn:=GetRealParent(Owner,Ctrl,PFieldQuote(P.PField).FieldName);
           if prn=wt then
             lstFields.Add(P);
         end;
       end;
      end;
    end;
    
  var
    i,j: Integer;
    P: PInfoWordType;
    y,x: Integer;
    Ymax: Integer;
    lstParent,lstFields: TList;
    wt: TWinControl;
    tmps: string;
    isYChange: Boolean;
  const
    HPlus=200;
    XPlus=150;
  begin
    y:=15;
    x:=15;
    i:=0;
    Ymax:=280;
    isYChange:=false;
    lstParent:=TList.Create;
    lstFields:=TList.Create;
    try
     PagesNeeded(Owner,Ctrl,lstParent);
     if lstParent.Count>0 then begin
      for i:=0 to lstParent.Count-1 do begin
        wt:=lstParent.Items[i];
        lstFields.Clear;
        GetFieldsFromParent(lstFields,wt);
        y:=15;
        x:=15;
        for j:=0 to lstFields.Count-1 do begin
          P:=lstFields.Items[j];
          case P.WordType of
            wtFieldQuote: begin
              tmps:=inttostr(i+1)+inttostr(j+1);
              CreateQuoteControls(Owner,Ctrl,P.PField,y,x,tmps);
            end;
          end;
          y:=y+25;
          if y>=Ymax then begin
           x:=x+XPlus;
           y:=15;
           isYChange:=true;
          end;
        end; // j
      end; // i
     end else begin
        for j:=0 to List.Count-1 do begin
          P:=List.Items[j];
          case P.WordType of
            wtFieldQuote: begin
              tmps:=inttostr(i+1)+inttostr(j+1);
              CreateQuoteControls(Owner,Ctrl,P.PField,y,x,tmps);
            end;
          end;
          y:=y+25;
          if y>=Ymax then begin
           x:=x+XPlus;
           y:=15;
           isYChange:=true;
          end;
        end; // j
     end;

     W:=x+300;
     if isYChange then
      H:=Ymax+HPlus
     else
      H:=Y+HPlus;

    finally
      lstFields.Free;
      lstParent.Free;
    end;

  end;

{var
  fm: TfmNewForm;
  w,h: Integer;}
begin
  UpdateFormFromStream(List,MsOut,true,ViewProgress);
{  fm:=TfmNewForm.Create(fmMain);
  try
   CreateBottomControls(fm);
   CreateControls(fm,fm.pnDesign,w,h);
   fm.ClientWidth:=w;
   fm.ClientHeight:=h;
   fm.Left:=Screen.Width div 2 - fm.Width div 2;
   fm.Top:=Screen.Height div 2 - fm.Height div 2;

   fm.Visible:=false;
   ReAlignControls(fm.pnDesign,true);
   SaveControlToStream(fm,MsOut);
  finally
   fm.free;
  end;}
end;

function GetWinDir: string;
var
  wd: PChar;
  WinDir:String;
begin
  Result:='';
  GetMem(wd,256);
  GetWindowsDirectory(wd,256);
  WinDir:=StrPas(wd);
  FreeMem(wd,256);
  result:=WinDir;
end;

procedure EnterWorkYear(check: Boolean);
var
  fm: TfmWorkYear;
  Year,Month,Day: Word;
begin
  if check then exit;
  fm:=TfmWorkYear.Create(nil);
  try
    fm.udWorkYear.Position:=WorkYear;
    if fm.ShowModal=mrOk then begin
      WorkYear:=fm.udWorkYear.Position;
    end else begin
      DecodeDate(Now,Year,Month,Day);
      WorkYear:=Year;
    end;
    if fmDocReestr<>nil then
      fmDocReestr.ActiveQuery;
  finally
    fm.Free;
  end;
end;

function GetWorkYear(wd: TDate): Integer;
var
  Year,Month,Day: Word;
begin
  DecodeDate(wd,Year,Month,Day);
  Result:=Year;
end;

procedure EnterWorkDate(check: Boolean);
var
  fm: TfmWorkDate;
begin
  if check then begin
   WorkDate:=GetDateTimeFromServer;
   WorkYear:=GetWorkYear(WorkDate);
   exit;
  end ;
  fm:=TfmWorkDate.Create(nil);
  try
    fm.dtpWorkdate.DateTime:=Workdate;
    if fm.ShowModal=mrOk then begin
      Workdate:=fm.dtpWorkdate.DateTime;
      WorkYear:=GetWorkYear(WorkDate);
    end;
    if fmDocReestr<>nil then
      fmDocReestr.ActiveQuery;
  finally
    fm.Free;
  end;
end;

function ActiveWordKeepDoc(var KeepFileName: String; isCloseWord: Boolean): Boolean;
var
  lpStartupInfo: STARTUPINFO;
  lpProcessInformation: TProcessInformation;
  lpProcessAttributes: PSecurityAttributes;
  tmps: string;
  newWordFile: string;
begin
  Result:=false;
  if isCloseWord then
   if not CloseWord then exit;
  new(lpProcessAttributes);
  try
   FillChar(lpStartupInfo,sizeof(STARTUPINFO),0);
   lpStartupInfo.cb:=SizeOf(STARTUPINFO);
   lpStartupInfo.wShowWindow:=SW_SHOWDEFAULT;
   lpStartupInfo.dwFlags:=STARTF_USESHOWWINDOW;
   FillChar(lpProcessInformation,sizeof(TProcessInformation),0);
   newWordFile:=GetUniqueFileName(lastFileDoc,99);
   if AnsiUpperCase(lastFileDoc)<>AnsiUpperCase(newWordFile) then
    if not CopyFile(Pchar(lastFileDoc),Pchar(newWordFile),false) then exit;
   tmps:=WordFileName+' "'+newWordFile+'"';
   ZeroMemory(lpProcessAttributes,sizeof(TSecurityAttributes));
   lpProcessAttributes.nLength:=sizeof(TSecurityAttributes);
   lpProcessAttributes.lpSecurityDescriptor:=nil;
   lpProcessAttributes.bInheritHandle:=true;
   if not CreateProcess(nil,Pchar(tmps),lpProcessAttributes,nil,
                        false,CREATE_DEFAULT_ERROR_MODE,nil,nil,
                        lpStartupInfo,lpProcessInformation) then begin
    ShowError(Application.Handle,SysErrorMessage(GetLastError));
    exit;
   end;
//  Application.Minimize;
   WaitForSingleObject(lpProcessInformation.hProcess, INFINITE);
   CloseHandle(lpProcessInformation.hProcess);
 {  Application.RestoreTopMosts;
  PostMessage(HWND_BROADCAST, MessageId,0,0);}
//  SendMessage(Application.Handle,MessageId,0,0);
   KeepFileName:=newWordFile;
   Result:=true;
  finally
   dispose(lpProcessAttributes);
  end;
end;

procedure SetWordFileName(Path: String);
begin
  WordFileName:='"'+Path+'\winword.exe"';
end;

procedure SaveDocumentToStream(FileName: string; msIn: TMemoryStream);
var
  newWordFile: String;
  Stream : TFileStream;
begin
  Screen.Cursor:=crHourGlass;
  newWordFile:=GetUniqueFileName(FileName,9999);
  try
   if not FileExists(newWordFile) then
     if not CopyFile(Pchar(FileName),Pchar(newWordFile),false) then exit;
   Stream := TFileStream.Create(newWordFile, fmOpenRead);
   try
    Stream.Position:=0;
    msin.LoadFromStream(Stream);
   finally
    Stream.Free;
   end;
   DeleteFile(newWordFile);
  finally
   Screen.Cursor:=crDefault;
  end;
end;

function CloseWord: Boolean;
var
  W: Variant;

  function PrepairWord: Boolean;
  begin
   Screen.Cursor:=crHourGlass;
   try
    try
     CoInitialize(nil);
     W:=GetActiveOleObject(WordOle);
     Application.MainForm.Update;
     W.Quit(wdDoNotSaveChanges,wdOriginalDocumentFormat,false);
     result:=true;
    except
     on E: Exception do begin
       if E.Message=MesOperationInaccessible then
        result:=false
       else if E.Message=MesCallingWasDeclined then
        result:=false
       else begin
         Result:=False;
         ShowError(Application.Handle,ConstWordFailed);
//         Application.ShowException(E);
       end;
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

begin
  Result:=PrepairWord;
end;

function GetTypeReestrCount: Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;  
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    Result:=0;
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select count(*) as trcount from '+TableTypeReestr;
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if qr.RecordCount>0 then
      result:=qr.FieldByname('trcount').AsInteger;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

function GetReestrCount: Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    Result:=0;
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select count(*) as trcount from '+TableReestr;
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if qr.RecordCount>0 then
      result:=qr.FieldByname('trcount').AsInteger;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;


/// New Function

procedure ClearFields(wt: TWinControl);
var
  i: Integer;
  ct: TControl;
begin
  if wt=nil then exit;
  for i:=0 to wt.ControlCount-1 do begin
    ct:=wt.Controls[i];
    if ct is TWinControl then begin
      ClearFields(TWinControl(ct));
    end;
    if ct is TEdit then begin
      TEdit(ct).Text:='';
    end;
    if ct is TComboBox then begin
      TComboBox(ct).ItemIndex:=-1;
      TComboBox(ct).Text:='';
    end;
    if ct is TMemo then begin
      TMemo(ct).Clear;
    end;
    if ct is TDateTimePicker then begin
      TDateTimePicker(ct).Checked:=false;
    end;

  end;
end;

function ViewEnterPeriod(P: PInfoEnterPeriod): Boolean; 
var
  fm: TfmEnterPeriod;
begin
  fm:=nil;
  try
    Result:=false;
    fm:=TfmEnterPeriod.Create(nil);
    if P<>nil then begin
     if P.LoadAndSave then
      fm.LoadPeriod(P);
     fm.SetPeriod(P); 
    end;
    if fm.ShowModal=mrOk then begin
     if P<>nil then begin
      if P.LoadAndSave then
       fm.SavePeriod;
      fm.GetPeriod(P); 
     end;
     Result:=true;
    end;
  finally
    FreeAndNil(fm);
  end;
end;

procedure LoadGridProp(ClsName: string; fi: TIniFile; Grd: TDBGrid);
var
  i: Integer;
  cl: TColumn;
  id: Integer;
begin
  if Grd=nil then exit;
  for i:=0 to Grd.Columns.Count-1 do begin
    id:=fi.ReadInteger(ClsName,'clmnID'+Grd.Name+inttostr(i),i);
    cl:=TColumn(Grd.Columns.FindItemID(id));
    if cl<>nil then begin
     cl.Index:=fi.ReadInteger(ClsName,'clmnIndex'+Grd.Name+inttostr(i),cl.Index);
     cl.Width:=fi.ReadInteger(ClsName,'clmnWidth'+Grd.Name+inttostr(i),cl.Width);
     cl.Visible:=fi.ReadBool(ClsName,'clmnVisible'+Grd.Name+inttostr(i),cl.Visible);
    end;
  end;
end;

procedure SaveGridProp(ClsName: string; fi: TIniFile; Grd: TDBGrid);
var
  i: Integer;
  cl: TColumn;
begin
  if Grd=nil then exit;
  for i:=0 to Grd.Columns.Count-1 do begin
    cl:=Grd.Columns.Items[i];
    fi.WriteInteger(ClsName,'clmnID'+Grd.Name+inttostr(i),cl.ID);
    fi.WriteInteger(ClsName,'clmnIndex'+Grd.Name+inttostr(i),cl.Index);
    fi.WriteInteger(ClsName,'clmnWidth'+Grd.Name+inttostr(i),cl.Width);
    fi.WriteBool(ClsName,'clmnVisible'+Grd.Name+inttostr(i),cl.Visible);
  end;
end;

function GetSmallFIONew(InString: String): String;
var
  APos: Integer;
  tmps,s1,s2,s3: string;
begin
  InString:=toTrimSpaceForOne(InString);
  tmps:=trim(InString);
  result:='';
  APos:=Pos(' ',tmps);
  if APos<>0 then begin
    s1:=Copy(InString,1,APos-1);
    tmps:=Copy(InString,APos+1,Length(InString)-APos);
    s2:=tmps[1];
    APos:=Pos(' ',tmps);
    if APos<>0 then begin
      s3:=tmps[APos+1];
      result:=s2+'. '+s3+'. '+s1;
    end else begin
      result:=s2+'. '+s1;
      exit;
    end;

  end else begin
    result:=InString;
    exit;
  end;

end;

function GetSmallFIO(InString: String): String;
var
  APos: Integer;
  tmps: string;
begin
  tmps:=trim(InString);
  result:='';
  APos:=Pos(' ',tmps);
  if APos<>0 then begin
    Result:=Copy(InString,1,APos-1)+' '+tmps[APos+1]+'.';
    tmps:=Copy(InString,APos+1,Length(InString)-APos);
  end else begin
   result:=tmps;
   exit;
  end; 
   
  APos:=Pos(' ',tmps);
  if APos<>0 then begin
    Result:=Result+tmps[APos+1]+'.';
  end;
end;

function GetTreeRootFromTypeDoc(TypeDocId: Integer): string;
var
  Tv: TTReeView;

  function GetNodeTypeDoc: TTreeNode;
  var
    i: Integer;
    nd: TTreeNode;
    P: PInfoNode;
  begin
   Result:=nil;
   for i:=0 to Tv.Items.Count-1 do begin
     nd:=Tv.Items[i];
     P:=nd.data;
     if p<>nil then begin
       if P.ID=TypeDocId then begin
         result:=nd;
         exit;
       end;
     end;
   end;
  end;

  function GetPath(nd: TTreeNode): string;
  begin
    Result:=nd.Text;
    while nd.Parent<>nil do begin
      nd:=nd.Parent;
      Result:=nd.text+'-->'+Result;
    end;
  end;
  
var
  nd: TTreeNode;
begin
  Result:='';
  if fmDocTree=nil then exit;
  Tv:=fmDocTree.Tv;
  nd:=GetNodeTypeDoc;
  if nd=nil then exit;
  Result:=GetPath(nd);
end;

function GetDateTimeFromServer: TDateTime;
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 Result:=Now;
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qrnew.Database:=dm.IBDbase;
   tran.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Select current_timestamp as dt from '+TableUsers;
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     Result:=qrnew.FieldByName('dt').AsDateTime;
   end;
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
 end;
end;


procedure UnRegisterAllHotKeys;
begin
  UnregisterHotKey(Application.Handle,ConstHotKeyUpperCase);
  UnregisterHotKey(Application.Handle,ConstHotKeyLowerCase);
  UnregisterHotKey(Application.Handle,ConstHotKeyToRussian);
  UnregisterHotKey(Application.Handle,ConstHotKeyToEnglish);
end;

procedure RegisterAllHotKeys;

  function GetMod(Shift: TShiftState): Word;
  begin
    Result:=0;
    if ssCtrl in Shift then inc(Result,MOD_CONTROL);
    if ssAlt in Shift then inc(Result,MOD_ALT);
    if ssShift in Shift then inc(Result,MOD_SHIFT);
  end;

var
  Key: Word;
  Shift: TShiftState;
begin
  UnRegisterAllHotKeys;
  ShortCutToKey(hkTranslateToUpperCase,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyUpperCase,GetMod(Shift),Key);
  ShortCutToKey(hkTranslateToLowerCase,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyLowerCase,GetMod(Shift),Key);
  ShortCutToKey(hkTranslateToRussian,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyToRussian,GetMod(Shift),Key);
  ShortCutToKey(hkTranslateToEnglish,Key,Shift);
  RegisterHotKey(Application.Handle,ConstHotKeyToEnglish,GetMod(Shift),Key);
end;

procedure TranslateText(ttt: TTypeTranslateText);
const
  ENG_up: array[0..39] of char=('Q','W','E','R','T','Y','U','I','O','P',
                                'A','S','D','F','G','H','J','K','L','Z',
                                'X','C','V','B','N','M','`','~','[','{',
                                ']','}',';',':','''','"',',','<','.','>');
  RUS_up: array[0..39] of char=('�','�','�','�','�','�','�','�','�','�',
                                '�','�','�','�','�','�','�','�','�','�',
                                '�','�','�','�','�','�','�','�','�','�',
                                '�','�','�','�','�','�','�','�','�','�');
  ENG_lo: array[0..39] of char=('q','w','e','r','t','y','u','i','o','p',
                                'a','s','d','f','g','h','j','k','l','z',
                                'x','c','v','b','n','m','`','`','{','[',
                                '}',']',';',':','''','"',',','<','.','>');
  RUS_lo: array[0..39] of char=('�','�','�','�','�','�','�','�','�','�',
                                '�','�','�','�','�','�','�','�','�','�',
                                '�','�','�','�','�','�','�','�','�','�',
                                '�','�','�','�','�','�','�','�','�','�');

  function GetCharFromArray(arr1,arr2: array of char; ch: char): char;
  var
    cur: char;
    i: Integer;
  begin
    Result:=ch;
    for i:=0 to sizeof(arr1)-1 do begin
     cur:=arr1[i];
     if cur=ch then begin
       Result:=arr2[i];
       exit;
     end;
    end;
  end;

  function toRussian(s: string): String;
  var
    i: Integer;
    ch: char;
    tmps: string;
  begin
    Result:=s;
    for i:=1 to Length(s) do begin
      ch:=s[i];
      if IsCharLower(ch) then
       ch:=GetCharFromArray(ENG_lo,RUS_lo,ch)
      else
       ch:=GetCharFromArray(ENG_up,RUS_up,ch);
      tmps:=tmps+ch; 
    end;
    Result:=tmps;
  end;

  function toEnglish(s: string): String;
  var
    i: Integer;
    ch: char;
    tmps: string;
  begin
    Result:=s;
    for i:=1 to Length(s) do begin
      ch:=s[i];
      if IsCharLower(ch) then
       ch:=GetCharFromArray(RUS_lo,ENG_lo,ch)
      else
       ch:=GetCharFromArray(RUS_up,ENG_up,ch);
      tmps:=tmps+ch;
    end;
    Result:=tmps;
  end;

  function MAKELANGID(p:Word; s: Word): Word;// ((((WORD) (s)) << 10) | (WORD) (p))  
  begin
    Result:=(s shl 10) or p; 
  end;

var
  wnd: HWND;
  P: Pointer;
  s: String;
  l: Integer;
begin
  try
   wnd:=GetFocus;
   if wnd=0 then exit;
   l:=GetWindowTextLength(wnd);
   if l=0 then exit;
   l:=l+1;
   GetMem(P,l);
   try
    GetWindowText(wnd,P,l);
    SetLength(s,l);
    Move(P^,Pointer(s)^,l);
    case ttt of
     tttUpper: s:=AnsiUpperCase(s);
     tttLower: s:=AnsiLowerCase(s);
     tttRussian: begin
      s:=toRussian(s);
      LoadKeyboardLayout(LayoutRussian,KLF_ACTIVATE);
     end;
     tttEnglish: begin
      s:=toEnglish(s);
      LoadKeyboardLayout(LayoutEnglish,KLF_ACTIVATE);
     end; 
    end;
    SetWindowText(wnd,Pchar(s));
   finally
     FreeMem(P,l);
   end;
  except
  end;
end;

function isFloat(Value: string): Boolean;
begin
 try
   strtofloat(value);
   Result:=true;
 except
   Result:=false;
 end;
end;

{$HINTS OFF}
function isInteger(Value: string): Boolean;
var
  E: Integer;
  ret: Integer;
begin
  Val(Value, ret, E);
  Result:=E=0;
end;
{$HINTS ON}

function isDateTime(Value: String): Boolean;
begin
  Result:=false;
  try
    StrToDateTime(Value);
    Result:=True;
  except
  end;
end;

function isDate(Value: String): Boolean;
begin
  Result:=false;
  try
    StrToDate(Value);
    Result:=True;
  except
  end;
end;

function isTime(Value: String): Boolean;
begin
  Result:=false;
  try
    StrToTime(Value);
    Result:=True;
  except
  end;
end;

function GetStrFromCondition(isNotEmpty: Boolean; STrue,SFalse: string): string;
begin
 if isNotEmpty then
  Result:=STrue
 else Result:=SFalse;
end;

function ChangeChar(Value: string; chOld, chNew: char): string;
var
  i: Integer;
  tmps: string;
begin
  for i:=1 to Length(Value) do begin
    if Value[i]=chOld then
     Value[i]:=chNew;
    tmps:=tmps+Value[i];
  end;
  Result:=tmps;
end;

function GetNotarialActionId(IdSort: Integer; var ActionName: string): Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    Result:=0;
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select notarialaction_id as id,name from '+TableNotarialAction+
          ' where fieldsort='+inttostr(IdSort);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if qr.RecordCount>0 then begin
      ActionName:=qr.FieldByname('name').AsString;
      result:=qr.FieldByname('id').AsInteger;
    end;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

function IsServer: Boolean;
var
  protocol: TProtocol;
  servername: String;
begin
  GetProtocolAndServerName(dm.IBDbase.DatabaseName,protocol,servername);
  Result:=(protocol=Local);
end;

function isValidKey(Key: Char): Boolean;
begin
  Result:=CharIsPrintable(Key);
  {
  Result:=(Byte(Key) in [byte('A')..byte('z')]) or
          (Byte(Key) in [byte('�')..byte('�')])or
          (Byte(Key) in [byte('0')..byte('9')]);}
end;

function TranslateIBError(Message: string): string;
var
  str: TStringList;
  APos: Integer;
  tmps: string;
const
  ExceptConst='exception';
  NewConst='���������� �';
begin
  str:=TStringList.Create;
  try
   str.Text:=Message;
   if str.Count>1 then begin
     tmps:=str.Strings[0];
     APos:=Pos(ExceptConst,tmps);
     if APos<>0 then begin
{      tmps:=NewConst+Copy(tmps,APos+Length(ExceptConst)+1,
                          Length(tmps)-APos+Length(ExceptConst)+1);
      str.Strings[0]:=tmps;}

     end;
     str.Delete(0);
   end;
   Result:=str.Text;
  finally
   str.Free;
  end;
end;

procedure SelectAllInListView(LV: TListView);
var
  i: Integer;
begin
  LV.Items.BeginUpdate;
  try
    for i:=0 to Lv.Items.Count-1 do begin
      Lv.Items[i].Selected:=true;
    end;
  finally
    LV.Items.EndUpdate;
  end;
end;

procedure SetCurrentDateTimeToDoc(Doc_id: Integer; var CurrentDateTime: TDateTime);
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  CurrentDateTime:=GetDateTimeFromServer;
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    qr.ParamCheck:=false;
    sqls:='Update '+TableDoc+
          ' set lastdate='+QuotedStr(DateTimeToStr(CurrentDateTime))+
          ' where doc_id='+inttostr(Doc_id);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.Commit;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

function CalculateCheckSumByDocId(Doc_id: Integer): LongWord;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  ms: TMemoryStream;
begin
  Result:=0;
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  ms:=TMemoryStream.Create;
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    qr.ParamCheck:=false;
    sqls:='Select datadoc from '+TableDoc+
          ' where doc_id='+inttostr(Doc_id);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.IsEmpty then begin
     ms.Clear;
     TBlobField(qr.fieldByName('DataDoc')).SaveToStream(ms);
     Result:=CalculateCheckSum(ms.Memory,ms.Size);
    end; 
  finally
    ms.Free;
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

function CalculateCheckSumByReestrId(Reestr_id: Integer): LongWord;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  ms: TMemoryStream;
begin
  Result:=0;
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  ms:=TMemoryStream.Create;
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    qr.ParamCheck:=false;
    sqls:='Select datadoc from '+TableReestr+
          ' where reestr_id='+inttostr(Reestr_id);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.IsEmpty then begin
     ms.Clear;
     TBlobField(qr.fieldByName('DataDoc')).SaveToStream(ms);
     Result:=CalculateCheckSum(ms.Memory,ms.Size);
    end; 
  finally
    ms.Free;
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

function GetTownDefault(isHelper: Boolean; RenovationId: Integer): String;
begin
  Result:=GetConstValueByName(WordFieldTownDefault,isHelper,RenovationId);
end;

function CheckFileClosed(FileName: string): Boolean;
var
  hFile: THandle;
begin
  hFile:=0;
  try
    hFile:=FileOpen(FileName, fmOpenRead);
    Result:=hFile<>INVALID_HANDLE_VALUE;
  finally
   CloseHandle(HFile);
  end;
end;

function GetListItemByDocId(LV: TListView; doc_id: Integer): TListItem;
var
  PList: PInfoDoc;
  i: Integer;
  li: TListItem;
begin
  Result:=nil;
  if lV=nil then exit;
  for i:=0 to LV.Items.Count-1 do begin
    li:=LV.Items[i];
    PList:=li.data;
    if Plist.ID=doc_id then begin
      Result:=li;
      exit;
    end;
  end;
end;

procedure InitDefaultConst;
begin
  ListDefaultConst.Add(WordFieldNumInReestr);
  ListDefaultConst.Add(WordFieldSumm);

  ListDefaultConst.Add(WordFieldTownFull_Normal);
  ListDefaultConst.Add(WordFieldTownFull_Where);
  ListDefaultConst.Add(WordFieldTownFull_What);

  ListDefaultConst.Add(WordFieldTownSmall_Normal);
  ListDefaultConst.Add(WordFieldTownSmall_Where);
  ListDefaultConst.Add(WordFieldTownSmall_What);

  ListDefaultConst.Add(WordFieldTownFull_Normal2);
  ListDefaultConst.Add(WordFieldTownFull_Where2);
  ListDefaultConst.Add(WordFieldTownFull_What2);

  ListDefaultConst.Add(WordFieldTownSmall_Normal2);
  ListDefaultConst.Add(WordFieldTownSmall_Where2);
  ListDefaultConst.Add(WordFieldTownSmall_What2);

  ListDefaultConst.Add(WordFieldFIO_Imenit);
  ListDefaultConst.Add(WordFieldFIO_Rodit);
  ListDefaultConst.Add(WordFieldFIO_Datel);
  ListDefaultConst.Add(WordFieldFIO_Vinit);
  ListDefaultConst.Add(WordFieldFIO_Tvorit);
  ListDefaultConst.Add(WordFieldFIO_Predl);
  ListDefaultConst.Add(WordFieldFIO_Imenit_sm);

  ListDefaultConst.Add(WordFieldFIO_Imenit_h);
  ListDefaultConst.Add(WordFieldFIO_Rodit_h);
  ListDefaultConst.Add(WordFieldFIO_Datel_h);
  ListDefaultConst.Add(WordFieldFIO_Vinit_h);
  ListDefaultConst.Add(WordFieldFIO_Tvorit_h);
  ListDefaultConst.Add(WordFieldFIO_Predl_h);
  ListDefaultConst.Add(WordFieldFIO_Imenit_sm_h);

  ListDefaultConst.Add(WordFieldNumLicense);
  ListDefaultConst.Add(WordFieldUrAdres);
  ListDefaultConst.Add(WordFieldUrAdres2);
  ListDefaultConst.Add(WordFieldPhone);
  ListDefaultConst.Add(WordFieldINN);

  ListDefaultConst.Add(WordFieldBlankSeries);
  ListDefaultConst.Add(WordFieldBlankNum);

  //  ListDefaultConst.Add(WordFieldDateEndDeistviyDover);
  ListDefaultConst.Add(WordFieldTownDefault);
end;

procedure InitFieldNoCreate;
begin
  ListFieldNoCreate.Add(WordFieldToday);
  ListFieldNoCreate.Add(WordFieldToday2);

end;


procedure LoadDocumentFromFile(FileName: string; doc_id: Integer; LV: TListView; msBack: TStream=nil);
var
  msOutDoc: TMemoryStream;
  msOutForm: TMemoryStream;
  List: TList;
  tb: TIBTable;
  tr: TIBTransaction;
  cdt: TDateTime;
  li: TListItem;
  mr: TModalResult;
begin
  Screen.Cursor:=crHourGlass;
  msOutDoc:=TMemoryStream.Create;
  try

   tr:=TIBTransaction.Create(nil);
   tb:=TIBTable.Create(nil);
   try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    tb.Database:=dm.IBDbase;
    tb.Transaction:=tr;
    tb.Transaction.Active:=true;
    tb.Filter:='doc_id='+inttostr(doc_id)+' ';
    tb.TableName:=TableDoc;
    tb.Filtered:=true;
    tb.Active:=true;
    if tb.RecordCount<>0 then begin
     msOutDoc.Position:=0;
     tb.Locate('doc_id',doc_id,[loCaseInsensitive]);
     tb.Edit;

     CompressAndCryptFile(FileName,msOutDoc);
     TBlobField(tb.FieldByName('DataDoc')).LoadFromStream(msOutDoc);
     if msBack<>nil then
       msBack.CopyFrom(msOutDoc,msOutDoc.Size);

     if isRefreshFormOnDocumentLoad then begin
       mr:=MessageDlg(Format(fmtUpdateForm,[tb.FieldByName('name').AsString]),mtConfirmation,[mbNo,mbYes],-1);
       if mr=mrYes then begin
        List:=TList.Create;
        msOutForm:=TMemoryStream.Create;
        try
         if GetListTextObjectFromWord(Application.MainForm,FileName,List) then begin
           TBlobField(tb.FieldByName('DataForm')).SaveToStream(msOutForm);
           msOutForm.Position:=0;
           ExtractObjectFromStream(msOutForm);
           msOutForm.Position:=0;
           UpdateFormFromStream(List,msOutForm,false);
           msOutForm.Position:=0;
           CompressAndCrypt(msOutForm);
           msOutForm.Position:=0;
           TBlobField(tb.FieldByName('DataForm')).LoadFromStream(msOutForm);
         end;
        finally
         msOutForm.Free;
         List.Free;
        end;
       end;
     end;  


     tb.Post;
     tb.Transaction.CommitRetaining;
     SetCurrentDateTimeToDoc(doc_id,cdt);
     li:=GetListItemByDocId(LV,doc_id);
     if li<>nil then begin
      li.SubItems[4]:=DateTimeToStr(cdt);
      li.SubItems[5]:=Format('%p',[Pointer(CalculateCheckSum(msOutDoc.Memory,msOutDoc.Size))]);
     end;
     
    end;
   finally
    tb.Free;
    tr.Free;
   end;
  finally
   msOutDoc.free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure ExtractFormToFile(Stream: TStream; FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
   fs:=TFileStream.Create(FileName,fmCreate or fmOpenWrite);
   fs.Position:=0;
   Stream.Position:=0;
   ObjectBinaryToText(Stream,fs);
   Stream.Position:=0;
  finally
   fs.Free;
  end; 
end;

procedure FreeAllControls(wt: TWinControl);
var
  i: Integer;
  ct: TControl;
begin
  for i:=wt.ControlCount-1 downto 0 do begin
    ct:=wt.Controls[i];
    if ct is TWinControl then FreeAllControls(TWinControl(ct));
    wt.RemoveControl(ct);
    ct.Free;
  end;
end;

procedure AddDefaultStyles;
begin
  ListDefaultStyles.Add('��������� 1');
  ListDefaultStyles.Add('��������� 2');
  ListDefaultStyles.Add('��������� 3');
  ListDefaultStyles.Add('����������������� �������');
end;

function GetRenovationIdByDocId(DocId: Integer): Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Result:=-1;
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select renovation_id as id from '+TableDoc+
          ' where doc_id='+inttostr(DocId);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.IsEmpty then
      result:=qr.FieldByname('id').AsInteger;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

function GetNotarialActionIdByDocId(DocId: Integer): Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Result:=-1;
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select notarialaction_id as id from '+TableDoc+
          ' where doc_id='+inttostr(DocId);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.IsEmpty then
      result:=qr.FieldByname('id').AsInteger;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure SetRenovationIdByDocId(RenovationId,DocId: Integer);
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Update '+TableDoc+
          ' set renovation_id '+iff(renovationid<>0,'= '+inttostr(RenovationId),' = null')+
          ' where doc_id='+inttostr(DocId);
    qr.SQL.Add(sqls);
    qr.ExecSql;
    qr.Transaction.Commit;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure SetNotarialActionIdByDocId(NotarialActionId,DocId: Integer; NotarialName: string);
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Update '+TableDoc+
          ' set notarialaction_id '+iff(NotarialActionId<>0,'= '+inttostr(NotarialActionId),' = null')+
          ' where doc_id='+inttostr(DocId);
    qr.SQL.Add(sqls);
    qr.ExecSql;
    qr.Transaction.Commit;
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

function GetConstValueByName(Name: string; isHelper: Boolean; RenovationID: Integer): String;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  renovation_id: Integer;
begin
  Result:='';
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    qr.ParamCheck:=false;
    if RenovationID=0 then
      renovation_id:=GetRenovationIdByWorkDate()
    else renovation_id:=RenovationID;
    sqls:='Select * from '+TableConst+
          ' where Upper(name)='+QuotedStr(AnsiUpperCase(Name))+
          iff(renovation_id<>0,' and renovation_id='+inttostr(renovation_id),'');
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.IsEmpty then begin
     if not isHelper then
      Result:=Trim(qr.FieldByName('val').AsString)
     else Result:=Trim(qr.FieldByName('valplus').AsString);
    end;
  finally
    qr.Free;
    tr.Free;
  end;
end;

function GetMinWidth(ct: TControl): Integer;
begin
  Result:=50;
  if ct is TLabel then Result:=250;
  if ct is TEdit then begin
    if not isNewControl(ct) then Result:=250
    else begin
      Result:=250;
    end;
  end;
  if ct is TCombobox then Result:=150;
  if ct is TMemo then Result:=250;
  if ct is TCheckBox then Result:=100;
  if ct is TRadioButton then Result:=100;
  if ct is TListBox then Result:=150;
  if ct is TRadioGroup then Result:=200;
  if ct is TMaskEdit then Result:=150;
  if ct is TRichEdit then Result:=250;
  if ct is TDateTimePicker then Result:=150;
  if ct is TRxCalcEdit then Result:=100;
  if ct is TDateEdit then Result:=100;
end;

var
  GlobalAlignCount: Integer=0;
  qrRule: TIBQuery=nil;
  trRule: TIBTransaction=nil;

type
  TReaderTemp=class(TReader)
  public
    procedure SetNameEvent(Reader: TReader; Component: TComponent; var Name: string);
  end;

procedure TReaderTemp.SetNameEvent(Reader: TReader; Component: TComponent; var Name: string);
begin
  Name:='';
end;

function GetNewName(ct: TComponent): String;
var
  S: String;
begin
  S:=ct.ClassName;
  Delete(S,1,1);
  Result:=S+'1';
end;

function GetFirstWord(s: string; SetOfChar: TSetOfChar; var Pos: Integer): string;
var
  tmps: string;
  i: integer;
begin
  for i:=1 to Length(s) do begin
    if S[i] in SetOfChar then break;
    tmps:=tmps+S[i];
    Pos:=i;
  end;
  Result:=tmps;
end;

function GetLabelByControl(ct: TControl): TLabel;
var
  j: Integer;
  y1,y2: Integer;
  ct1: TControl;
  wt: TWinControl;
const
  DefLeft=23;
begin
  Result:=nil;
  if ct=nil then exit;
  wt:=ct.Parent;
  if wt=nil then exit;
  y1:=ct.Top;
  y2:=ct.Top+ct.Height;
  for j:=y1 to y2 do begin
    ct1:=wt.ControlAtPos(Point(ct.Left-DefLeft,j),false,false);
    if ct1<>nil then
     if ct1 is TLabel then begin
       Result:=TLabel(ct1);
       exit;
     end;
  end;
end;

function GetCaptionByFieldName(FieldName: string): string;
var
  i,L: Integer;
const
  Numbers: set of char = ['1','2','3','4','5','6','7','8','9','0'];
begin
  Result:='';
  L:=Length(FieldName);
  if L>0 then
    for i:=L downto 0 do begin
      if not (FieldName[i] in Numbers) then begin
        Result:=Copy(FieldName,1,i);
        exit;
      end;
    end;
end;

procedure ReAlignControls(wt: TWinControl; UseTabOrder: Boolean=false; UseDialog: Boolean=false; UseCheckBlocking: Boolean=false);
var
  ListStoreProps: TList;
type
  PInfoStoreProp=^TInfoStoreProp;
  TInfoStoreProp=packed record
    PropName: String;
    ValueProp: Variant;
  end;

   procedure AddToStoreProp(PropName: string; ValueProp: Variant);
   var
     P: PInfoStoreProp;
   begin
     New(P);
     FillChar(P^,SizeOf(P^),0);
     P.PropName:=PropName;
     P.ValueProp:=ValueProp;
     ListStoreProps.Add(P);
   end;

   procedure RemoveStoreProp(PropName: string);
   var
     i: Integer;
     P: PInfoStoreProp;
   begin
     for i:=ListStoreProps.Count-1 downto 0 do begin
       P:=ListStoreProps.Items[i];
       if AnsiSameText(P.PropName,PropName) then begin
        Dispose(P);
        ListStoreProps.Delete(i);
       end; 
     end;
   end;  

   procedure ClearListStoreProps;
   var
     i: Integer;
     P: PInfoStoreProp;
   begin
     for i:=0 to ListStoreProps.Count-1 do begin
       P:=ListStoreProps.Items[i];
       Dispose(P);
     end;
     ListStoreProps.Clear;
   end;

   procedure RestoreProps(ct: TControl);
   var
     i: Integer;
     P: PInfoStoreProp;
   begin
     for i:=0 to ListStoreProps.Count-1 do begin
       P:=ListStoreProps.Items[i];
       try
        SetPropValue(ct,P.PropName,P.ValueProp);
       except
       end;
     end;
   end;

   function LocalPrepear(s: string): string;
   var
     i: Integer;
   const
     Separators: set of char = ['1','2','3','4','5','6','7','8', '9', '0'];
   begin
     for i:=1 to Length(s) do begin
       if not (s[i] in Separators) then
         Result:=Result+s[i];
     end;
   end;

   procedure SetRuleProperty(var ct: TControl);
   var
     s,sIn: string;
     near: Integer;
     ctOld: TControl;
     Index: Integer;
     P: PInfoClass;
     msIn: TMemoryStream;
     msOut: TMemoryStream;
     rd: TReaderTemp;
     isApply: Boolean;
     isBlocking: Boolean;
     APos,l: Integer;
     lb: TBoundLabel;
   const
     PropDocFieldName=ConstPropDocFieldName;
     PropLabelCaption='LabelCaption';
     Separators: set of char = [#00,' ','-',#13, #10,'.',',','/','\', '#', '"', '''','!','?','$','@',
                               ':','+','%','*','(',')',';','=','{','}','[',']', '{', '}', '<', '>'];

   begin
     if IsPublishedProp(ct,PropDocFieldName) then begin
      ListStoreProps:=TList.Create;
      try
       s:=GetStrProp(ct,PropDocFieldName);
       s:=LocalPrepear(s);
       if UseCheckBlocking then
         isBlocking:=Boolean(GetOrdProp(ct,ConstPropBlocking))
       else isBlocking:=false;
       if qrRule<>nil then begin
        if not qrRule.IsEmpty then begin
           qrRule.First;
           while not qrRule.Eof do begin
            Index:=qrRule.FieldByName('elementtype').AsInteger;
            sIn:=qrRule.FieldByName('name').AsString;
            near:=qrRule.FieldByName('near').AsInteger;
            if near=0 then begin
              APos:=AnsiPos(AnsiUpperCase(sIn),AnsiUpperCase(s));
              isApply:=APos>0;
              if isApply then begin
                l:=Length(sIn);
                if (APos+l)<Length(s) then isApply:=s[APos+l] in Separators;
                if APos>1 then isApply:=s[APos-1] in Separators;
              end;

            end else isApply:=AnsiSameText(sIn,s);
            
            isApply:=isApply and (not isBlocking);

            if isApply then begin
              AddToStoreProp('Left',ct.left);
              AddToStoreProp('Top',ct.Top);
              AddToStoreProp('Name',ct.Name);
              AddToStoreProp(PropDocFieldName,GetStrProp(ct,PropDocFieldName));
              if IsPublishedProp(ct,PropLabelCaption) then
                AddToStoreProp(PropLabelCaption,GetStrProp(ct,PropLabelCaption));
              try
               if (Index>=0)or(Index<=ListClassesForWord.Count-1) then begin
                P:=ListClassesForWord.Items[Index];
                msIn:=TMemoryStream.Create;
                msOut:=TMemoryStream.Create;
                try
                  TBlobField(qrRule.FieldByName('property')).SaveToStream(msIn);
                  msIn.Position:=0;
                  ObjectTextToBinary(msIn,msOut);
                  msOut.Position:=0;
                  rd:=TReaderTemp.Create(msOut,4096);
                  try
                    rd.Parent:=ct.Parent;
                    rd.OnSetName:=rd.SetNameEvent;
                    if P.TypeClass=ct.ClassType then begin
                      rd.ReadRootComponent(ct);
                    end else begin
                      ctOld:=ct;
                      ct:=TControl(TComponentClass(P.TypeClass).Create(ctOld.Owner));
                      rd.ReadRootComponent(ct);
                      lb:=GetBoundLabel(ctOld);
                      if lb<>nil then
                        lb.Parent:=nil;
                      if ctOld.Parent<>nil then begin
                       ctOld.Parent:=nil;
                       ctOld.Free;
                      end;
                      if not IsPublishedProp(ct,PropLabelCaption) then
                         RemoveStoreProp(PropLabelCaption);
                      RemoveStoreProp('Name');
                      AddToStoreProp('Name',DsnCheckNameNew(GetParentForm(ct),ct,GetNewName(ct)));
                      
                    end;
                    SetOrdProp(ct,ConstPropBlocking,Integer(true));

                    Break;
                  finally
                    rd.Free;
                  end;
                finally
                  msIn.Free;
                  msOut.Free;
                end;
               end;
              finally
               RestoreProps(ct);
              end;
            end; // isApply
            qrRule.Next;
           end; // while
        end;
       end;
      finally
       ClearListStoreProps;
       ListStoreProps.Free;
      end;
     end;
   end;

   procedure GetControls(List,ListControls: TList; Cls: TClass);
   var
     i: Integer;
   begin
     for i:=0 to List.Count-1 do begin
       if TControl(List.Items[i]) is Cls then
         ListControls.Add(List.Items[i]);
     end;
   end;


type
   PInfoDefault=^TInfoDefault;
   TInfoDefault=packed record
     ControlField: TControl;
     ControlLabel: TBoundLabel;
   end;

   procedure RemoveDefaults(ListDefaults: TList; P: PInfoDefault);
   var
     val: Integer;
   begin
     val:=ListDefaults.IndexOf(P);
     if val<>-1 then begin
       ListDefaults.Delete(val);
       Dispose(P);
     end;
   end;

   procedure InsertDefaults(ListDefaults: TList; Index: Integer; ct: TControl);
   var
     P: PInfoDefault;
   begin
     New(P);
     FillChar(P^,SizeOf(P^),0);
     P.ControlField:=ct;
     P.ControlLabel:=GetBoundLabel(ct);
     ListDefaults.Insert(Index,P);
   end;

   procedure ClearListDefaults(ListDefaults: TList);
   var
     i: Integer;
     P: PInfoDefault;
   begin
     for i:=ListDefaults.Count-1 downto 0 do begin
       P:=ListDefaults.Items[i];
       RemoveDefaults(ListDefaults,P);
     end;
     ListDefaults.Clear;
   end;

   procedure GroupControlByTypeCase(wtParent: TWinControl; var ct: TControl; var lb: TBoundLabel;
                                    ListControls: TList; const DefLeft,dTop: Integer; ListDefaults: TList);

     function GetControlByCase(TypeCase: TTypeCase): TControl;
     var
       List: TList;
     begin
       Result:=nil;
       List:=TList.Create;
       try
         GetControlByPropValue(wtParent,ConstPropTypeCase,TypeCase,List,true,true);
         if List.Count>0 then begin
           Result:=List.Items[0];
           if Result is TNewLabel then Result:=nil;
         end;
       finally
         List.Free;
       end;
     end;

   type
     PInfoTypeCaseControl=^TInfoTypeCaseControl;
     TInfoTypeCaseControl=packed record
       ControlField: TControl;
       ControlLabel: TBoundLabel;
       TypeCase: TTypeCase;
     end;

     procedure PackList(List: TList);
     var
        P: PInfoTypeCaseControl;
        i: Integer;
     begin
       for i:=List.Count-1 downto 0 do begin
         P:=List.Items[i];
         if P.TypeCase<>tcIminit then
          if (P.ControlField=nil)or(P.ControlLabel=nil) then begin
            List.Delete(i);
            Dispose(P);
          end;
       end;
       if List.Count=1 then begin
         P:=List.Items[List.Count-1];
         if P.TypeCase=tcIminit then begin
           List.Delete(List.Count-1);
           Dispose(P);
         end;
       end;
     end;

     function GetCaseStr(TypeCase: TTypeCase): string;
     begin
       case TypeCase of
         tcIminit: Result:='(��.�.)';
         tcRodit: Result:='(���.�.)';
         tcDatel: Result:='(���.�.)';
         tcTvorit: Result:='(��.�.)';
         tcVinit: Result:='(���.�.)';
         tcPredl: Result:='(����.�.)';
       end;
     end;

     function GetFieldNameByTypeCase(TypeCase: TTypeCase; DocFieldName: string): String;
     var
       s1,s2: string;
       sPos: string;
       APos: Integer;
     begin
       sPos:=GetCaseStr(TypeCase);
       APos:=AnsiPos(AnsiUpperCase(sPos),AnsiUpperCase(DocFieldName));
       if APos>0 then begin
         s1:=Copy(DocFieldName,1,APos-1);
         s2:=Copy(DocFieldName,APos+Length(sPos),Length(DocFieldName)-APos-Length(sPos)+1);
       end;
       Result:=s1+GetCaseStr(tcIminit)+s2;
     end;

     function GetDefaultsIndexByControl(ct: TControl; var POut: PInfoDefault): Integer;
     var
       P: PInfoDefault;
       i: Integer;
     begin
       Result:=-1;
       POut:=nil;
       if ListDefaults=nil then exit;
       for i:=0 to ListDefaults.Count-1 do begin
         P:=ListDefaults.Items[i];
         if P.ControlField=ct then begin
           Result:=i;
           POut:=P;
           exit;
         end;
       end;
     end;

   var
     TypeCase: TTypeCase;
     ListCases: TList;
     i: Integer;
     P: PInfoTypeCaseControl;
     TopControl: TControl;
     DefFieldNameIminit: string;
     RealyFieldName: string;
     fm: TCustomForm;
     RealyTop: Integer;
     ctOld: TControl;
     IndexTop: Integer;
     PTop: PInfoDefault;
   begin
     if ct=nil then exit;
     fm:=GetParentForm(wtParent);
     if fm=nil then exit;
     if not isPublishedProp(ct,ConstPropTypeCase) then exit;
     TypeCase:=TTypeCase(GetInt64Prop(ct,ConstPropTypeCase));
     if TypeCase=tcNone then exit;
     ListCases:=TList.Create;
     try
       for i:=Integer(tcIminit) to Integer(tcPredl) do begin
         New(P);
         FillChar(P^,SizeOf(P^),0);
         P.ControlField:=GetControlByCase(TTypeCase(i));
         P.ControlLabel:=GetBoundLabel(P.ControlField);
         P.TypeCase:=TTypeCase(i);
         ListCases.Add(P);
       end;

       PackList(ListCases);

       if ListCases.Count>0 then begin

         TopControl:=ct;
         if TopControl<>nil then
           DefFieldNameIminit:=GetFieldNameByTypeCase(TTypeCase(GetInt64Prop(TopControl,ConstPropTypeCase)),
                                                      GetStrProp(TopControl,ConstPropDocFieldName))
         else DefFieldNameIminit:=GetCaseStr(tcIminit);

         RealyTop:=TopControl.Top;
         IndexTop:=GetDefaultsIndexByControl(ct,PTop);

         for i:=0 to ListCases.Count-1 do begin
           P:=ListCases.Items[i];
           if i=0 then begin
             if P.ControlField<>nil then RealyFieldName:=GetStrProp(P.ControlField,ConstPropDocFieldName);
             if Trim(RealyFieldName)='' then RealyFieldName:=DefFieldNameIminit;
             if P.ControlField=nil then begin
               P.ControlField:=TNewEdit.Create(fm);
               P.ControlField.Parent:=wtParent;
               P.ControlField.Name:=DsnCheckNameNew(fm,P.ControlField,GetNewName(P.ControlField));
               TNewEdit(P.ControlField).Text:='';
               TNewEdit(P.ControlField).DocFieldName:=RealyFieldName;
               TNewEdit(P.ControlField).TypeCase:=tcIminit;
               TNewEdit(P.ControlField).LabelCaption:=Trim(GetCaptionByFieldName(RealyFieldName))+':';
             end;
             ct:=P.ControlField;
             lb:=GetBoundLabel(P.ControlField);
           end;
           P.ControlField.Top:=RealyTop;
           P.ControlField.Left:=DefLeft;
           
           ListControls.Add(P.ControlField);

           GetDefaultsIndexByControl(P.ControlField,PTop);
           RemoveDefaults(ListDefaults,PTop);
           InsertDefaults(ListDefaults,IndexTop+i,P.ControlField);
           RealyTop:=RealyTop+dTop;

           ctOld:=P.ControlField;
           SetRuleProperty(P.ControlField);
           if P.ControlField<>ctOld then begin
             if ctOld=ct then ct:=P.ControlField;
             ListControls.Remove(ctOld);
             ListControls.Add(P.ControlField);
           end;

         end; // for


       end;
     finally
       for i:=0 to ListCases.Count-1 do
        Dispose(PInfoTypeCaseControl(ListCases.Items[i]));
       ListCases.Free;
     end;
   end;

   function GetNewCaptionByWidth(lb: TBoundLabel; RW: Integer): String;
   var
     i,newi,space1,space2: Integer;
     str: TStringList;
     s: string;
     len: Integer;
   begin
     str:=TStringList.Create;
     try
       s:='';
       space1:=1;
       space2:=1;
       i:=1;
       newi:=1;
       len:=Length(lb.Caption);
       repeat
//       while i<>Length(lb.Caption) do begin
         s:=s+lb.Caption[i];
         if lb.Caption[i]=' ' then begin
           space1:=newi;
           space2:=i;
         end;
         if lb.Canvas.TextWidth(s)>=RW then begin
           if i<len then begin
             if (space1-1)>0 then begin
               s:=Copy(s,1,space1-1);
               str.Add(Trim(s));
               s:='';
               dec(i,i-space2);
               newi:=1;
             end else begin
               str.Add(Trim(s));
               s:='';
               newi:=1;
             end;  
           end else begin
             str.Add(Trim(Copy(s,1,Length(s))));
             inc(i);
           end;
         end else begin
           if i=len then
             str.Add(Trim(Copy(s,1,Length(s))));
           inc(newi);
           inc(i);
         end;
       until i>len;
       Result:=Trim(str.Text);
     finally
       str.free;
     end;
   end;

   function GetFirstCaption(lb: TBoundLabel): string;
   var
     str: TStringList;
     imax,i: Integer;
     mw: Integer;
   begin
     str:=TStringList.Create;
     try
       str.Text:=lb.Caption;
       imax:=0;
       mw:=0;
       for i:=0 to str.Count-1 do begin
         if lb.Canvas.TextWidth(str.Strings[i])>mw then begin
           mw:=lb.Canvas.TextWidth(str.Strings[i]);
           imax:=i;
         end;  
       end;
       if str.Count>0 then
         Result:=Trim(str.Strings[imax])
       else Result:=lb.Caption;
     finally
       str.Free;
     end;
   end;

   function CorrectControl(ct: TControl): Boolean;
   var
     i: Integer;
     P: PInfoClass;
   begin
     Result:=false;
     for I:=0 to ListClassesForWord.Count-1 do begin
       P:=ListClassesForWord.Items[i];
       if P.TypeClass=ct.ClassType then begin
         Result:=true;
         exit;
       end;
     end;
     if ct.ClassType=TPageControl then Result:=true;
     if ct.ClassType=TTabSheet then Result:=true;
     if ct.ClassType=TScrollBox then Result:=true;
     if ct.ClassType=TDsnStage then Result:=true;
   end;

   procedure ReAlignControl(List: TList);
   var
     i: Integer;
     ct: TControl;
     ctPrev: TControl;
     ListControls: TList;
     ListCases: TList;
     ListDefaults: TList;
     tw: Integer;
     NewTop: Integer;
     clsname: string;
     ctOld: TControl;
     Check: Boolean;
     PDefault: PInfoDefault;
     lb,lbPrev: TBoundLabel;
   const
     DefLeft=200;
     DefTop=15;
     dLeft=15;
     dTop=5;
   begin
     if List.Count=0 then exit;
     ListControls:=TList.Create;
     ListCases:=TList.Create;
     ListDefaults:=TList.Create;
     try
      for i:=0 to List.Count-1 do
       if TControl(List.Items[i]) is TWinControl then
         if (TWinControl(List.Items[i]).ControlCount>0){and
            (csAcceptsControls in TWinControl(List.Items[i]).ControlStyle)} then
           ReAlignControls(TWinControl(List.Items[i]),UseTabOrder,false,UseCheckBlocking);

      for i:=List.Count-1 downto 0 do begin
        ct:=List.Items[i];
        ctOld:=ct;
        SetRuleProperty(ct);
        if ct<>ctOld then begin
          List.Remove(ctOld);
          List.Add(ct);
        end;
      end;

      GetControls(List,ListControls,TControl);
      ListControls.Sort(ListCompareTop);

      if UseDialog then begin

      end;

      for i:=0 to ListControls.Count-1 do begin
        New(PDefault);
        FillChar(PDefault^,SizeOf(PDefault^),0);
        PDefault.ControlField:=ListControls.Items[i];
        if PDefault.ControlField.Visible then begin
          PDefault.ControlLabel:=GetBoundLabel(PDefault.ControlField);
          ListDefaults.Add(PDefault);
        end;
      end;

      lbPrev:=nil;
      ctPrev:=nil;
      i:=0;
      while i<=ListDefaults.Count-1 do begin
        PDefault:=ListDefaults.Items[i];
        ct:=PDefault.ControlField;
        clsname:=ct.ClassName;
        if clsname='' then ct:=ct;
        lb:=PDefault.ControlLabel;
        if ListCases.IndexOf(ct)=-1 then begin
          GroupControlByTypeCase(wt,ct,lb,ListCases,DefLeft,dTop,ListDefaults);
        end;
        if lb<>nil then begin
          tw:=lb.Canvas.TextWidth(GetFirstCaption(lb))+dLeft+ConstLabelSpacing;
          if tw>DefLeft then begin
            lb.AutoSize:=false;
            lb.Caption:=GetNewCaptionByWidth(lb,DefLeft-dLeft-ConstLabelSpacing);
            lb.AutoSize:=true;
          end;
          if ct<>nil then begin
            List.Remove(ct);
          end;
          if i=0 then begin
            NewTop:=DefTop;
            if ct.Height<lb.Height then begin
              NewTop:=NewTop+(lb.Height-ct.Height) div 2;
            end;
            ct.Top:=NewTop;
            ct.Left:=DefLeft;
          end else begin
            ct.Left:=ctPrev.Left;
            if lbPrev<>nil then begin
              if (ctPrev.Height)>(lbPrev.Height) then begin
                NewTop:=ctPrev.Top+ctPrev.Height;
              end else begin
                NewTop:=ctPrev.Top+ctPrev.Height+(lbPrev.Height-ctPrev.Height) div 2;
                if ct.Height<lb.Height then begin
                  NewTop:=NewTop+(lb.Height-ct.Height) div 2;
                end;
              end;
            end else begin
              NewTop:=ctPrev.Top+ctPrev.Height;
              if ct.Height<lb.Height then begin
                NewTop:=NewTop+(lb.Height-ct.Height) div 2;
              end;
            end;
            ct.Top:=NewTop+dTop;
          end;
        end else begin
          if ctPrev=nil then begin
            ct.Top:=DefTop;
            ct.Left:=DefLeft;
          end else begin
            ct.Top:=ctPrev.Top+ctPrev.Height+dTop;
            ct.Left:=ctPrev.Left;
          end;  
        end;

        if ct<>nil then begin
          if UseTabOrder then
           if ct is TWinControl then begin
             Check:=false;
             if ct is TDateTimePicker then
               Check:=TDateTimePicker(ct).Checked;
             TWinControl(ct).TabOrder:=i;
             if ct is TDateTimePicker then begin
               TDateTimePicker(ct).Checked:=Check;
               TDateTimePicker(ct).Checked:=Check;
             end;
           end;
        end;
        lbPrev:=lb;
        ctPrev:=ct;
        Inc(i);
      end;

     finally
      ClearListDefaults(ListDefaults);
      ListDefaults.Free;
      ListCases.Free;
      ListControls.Free;
     end;
   end;

var
  List: TList;
  i: Integer;
begin
  if wt=nil then exit;
  if GlobalAlignCount=0 then begin
    qrRule:=TIBQuery.Create(nil);
    trRule:=TIBTransaction.Create(nil);

    trRule.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(trRule);
    trRule.Params.Text:=DefaultTransactionParamsTwo;
    qrRule.Database:=dm.IBDbase;
    qrRule.Transaction:=trRule;
    qrRule.Transaction.Active:=true;
    qrRule.ParamCheck:=false;
    qrRule.SQL.Text:='Select * from '+TableRuleForElement+' order by priority';
    qrRule.Active:=true;

  end;
  Inc(GlobalAlignCount);
  List:=TList.Create;
//  wt.Enabled:=false;
  try
    for i:=0 to wt.ControlCount-1 do begin
      if wt.Controls[i].Parent=wt then begin
        if CorrectControl(wt.Controls[i]) then
          List.Add(wt.Controls[i]);
      end;  
    end;
    ReAlignControl(List);
  finally
//    wt.Enabled:=true;
    Dec(GlobalAlignCount);
    if GlobalAlignCount=0 then begin
      FreeAndNil(qrRule);
      FreeAndNil(trRule);
    end;
    List.Free;
  end;
end;

procedure GetControlByPropValue(wtParent: TWInControl; PropName: string; PropValue: Variant;
                                ListControls: TList; UsePropValue: Boolean=true; OnlyThisParent: Boolean=false);

  procedure LocalRecurse(wt: TWinControl);
  var
    i: Integer;
    ct: TControl;
    Value: Variant;
    isCheck: Boolean;
  begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      if not OnlyThisParent then isCheck:=true
      else isCheck:=wt=wtParent;
      if isCheck then begin
        if ct is TWinControl then LocalRecurse(TWinControl(ct));
        if IsPublishedProp(ct,PropName) then begin
          if UsePropValue then begin
            Value:=GetPropValue(ct,PropName,false);
            if Value=PropValue then begin
              ListControls.Add(ct);
            end;
          end else ListControls.Add(ct);
        end;
      end;
    end;
  end;

begin
  if ListControls=nil then exit;
  LocalRecurse(wtParent);
end;

procedure PrepearListFields(ListFields: TList);
var
  ListExists: TList;

  function ifExistsInList(FieldName: string): Boolean;
  var
    i: Integer;
    P: PInfoWordType;
  begin
    Result:=false;
    for i:=0 to ListExists.Count-1 do begin
      P:=ListExists.Items[i];
      if P.WordType=wtFieldQuote then begin
        if AnsiSameText(PFieldQuote(P.PField).FieldName,FieldName) then begin
          Result:=true;
          exit;
        end;
      end;
    end;
  end;

var
  i: Integer;
  P: PInfoWordType;
begin
  ListExists:=TList.Create;
  try
   for i:=0 to ListFields.Count-1 do begin
     P:=ListFields.Items[i];
     case P.WordType of
       wtFieldQuote: begin
         if not ifExistsInList(PFieldQuote(P.PField).FieldName) then
           ListExists.Add(P);
       end;
     end;
   end;
   ListFields.clear;
   for i:=0 to ListExists.Count-1 do ListFields.Add(ListExists.Items[i]);
  finally
   ListExists.Free;
  end;
end;

function GetParentByClass(ClassType: TClass; wt: TWinControl): TControl;
begin
  Result:=nil;
  if wt is ClassType then begin
    Result:=wt;
    exit;
  end;
  while wt.Parent<>nil do begin
    if wt.Parent is ClassType then begin
      Result:=wt.Parent;
      exit;
    end;
    wt:=wt.Parent;
  end;
end;

function ListCompareTabOrder(Item1, Item2: Pointer): Integer;
var
  ct1,ct2: TWinControl;
begin
  Result:=0;
  ct1:=Item1;
  ct2:=Item2;
  if (ct1<>nil) and (ct2<>nil) then begin
   if ct2.TabOrder>ct1.TabOrder then Result:=-1;
   if ct2.TabOrder<ct1.TabOrder then Result:=1;
  end;
end;

function ListCompareTop(Item1, Item2: Pointer): Integer;
var
  ct1,ct2: TControl;
begin
  Result:=0;
  ct1:=Item1;
  ct2:=Item2;
  if (ct1<>nil) and (ct2<>nil) then begin
   if ct2.Top>ct1.Top then Result:=-1;
   if ct2.Top<ct1.Top then Result:=1;
  end;
end;

procedure SortListByTabOrder(List: TList);
begin
  List.Sort(ListCompareTabOrder);
end;

procedure UpdateFormFromStream(ListFields: TList; msOutForm: TMemoryStream; isFirstLoad: Boolean=false; ViewProgress: Boolean=false);
var
  qrConst: TIBQuery;
  trConst: TIBTransaction;
  fm: TfmNewForm;
  RealyTop: Integer;
  ListRealyNeeded: TList;
  isRenameExists: Boolean;
  renovation_id: Integer;
const
  PropDocFieldName='DocFieldName';  

  procedure OpenConst;
  begin
   qrConst:=TIBQuery.Create(nil);
   trConst:=TIBTransaction.Create(nil);
   trConst.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(trConst);
   trConst.Params.Text:=DefaultTransactionParamsTwo;
   qrConst.Database:=dm.IBDbase;
   qrConst.Transaction:=trConst;
   qrConst.Transaction.Active:=true;
   qrConst.ParamCheck:=false;
   renovation_id:=GetRenovationIdByWorkDate();
   qrConst.SQL.Text:='Select * from '+TableConst+
                     iff(renovation_id<>0,' where renovation_id='+inttostr(renovation_id),'')+ 
                     ' order by priority desc';
   qrConst.Active:=true;
  end;

  procedure CloseConst;
  begin
   qrConst.Free;
   trConst.Free;
  end;

  function InConst(Value: string): Boolean;
  var
    val: Integer;
  begin
    val:=ListDefaultConst.IndexOf(Value);
    if val<>-1 then begin
     Result:=true;
     exit;
    end;
    qrConst.First;
    Result:=qrConst.Locate('name',Value,[loCaseInsensitive]);
  end;

  function InFieldNoCreate(Value: string): Boolean;
  begin
    Result:=ListFieldNoCreate.IndexOf(Value)<>-1;
  end;

  function GetTabTempIndex(FieldName: string): Integer;
  var
    i,L: Integer;
    s: string;
  begin
    Result:=0;
    L:=Length(FieldName);
    if L>0 then
      for i:=L downto 0 do begin
        if FieldName[i] in ['1'..'9'] then begin
          s:=FieldName[i]+s;
          Result:=strtoint(s);
        end else break;
      end;
  end;

  function GetParentByFieldName(FieldName: string): TWinControl;
  var
    tti: Integer;
    ts: TTabSheet;
    sb: TScrollBox;
    pc: TPageControl;
  begin
    Result:=fm.pnDesign;
    tti:=GetTabTempIndex(FieldName);
    pc:=TPageControl(fm.FindComponent(ConstPageControlMain));
    if pc=nil then begin
      pc:=TPageControl(fm.FindComponent(ConstPageControlMainOld));
      if pc=nil then begin
        pc:=TPageControl.Create(fm);
        pc.Align:=alClient;
        pc.Parent:=Result;
        pc.Name:=ConstPageControlMain;
        isRenameExists:=true;
      end;
    end;
    if ListRealyNeeded.IndexOf(pc)=-1 then ListRealyNeeded.Add(pc);

    ts:=TTabSheet(fm.FindComponent(ConstTabSheetMain+inttostr(tti)));
    if ts=nil then begin
      ts:=TTabSheet(fm.FindComponent(ConstTabSheetMainOld+inttostr(tti)));
      if ts=nil then begin
        ts:=TTabSheet.Create(fm);
        ts.PageControl:=pc;
        ts.Name:=ConstTabSheetMain+inttostr(tti);
        ts.Parent:=pc;
        isRenameExists:=true;
      end;
    end;
    if ListRealyNeeded.IndexOf(ts)=-1 then ListRealyNeeded.Add(ts);

    sb:=TScrollBox(fm.FindComponent(ConstScrollBox+ts.Name));
    if sb=nil then begin
      sb:=TScrollBox.Create(fm);
      sb.Parent:=ts;
      sb.Name:=ConstScrollBox+ts.Name;
      sb.Align:=alClient;
      sb.BorderStyle:=bsNone;
    end;
    if ListRealyNeeded.IndexOf(sb)=-1 then ListRealyNeeded.Add(sb);

    Result:=sb;
  end;

  function CreateControlByFieldName(FieldName: string; Prev: TControl): TControl;
  var
    ed: TNewEdit;
    Parent: TWinControl;
    ListControls: TList;
    i: Integer;
  const
    DefLeft=350;
    IncTop=IncUpdateHeight;
  begin
    Result:=nil;
    Parent:=GetParentByFieldName(FieldName);
    if Parent=nil then exit;
    ListControls:=TList.Create;
    try
      GetControlByPropValue(fm.pnDesign,PropDocFieldName,FieldName,ListControls);
      if ListControls.Count>0 then begin
       for i:=0 to ListControls.Count-1 do begin
         ListRealyNeeded.Add(ListControls.Items[i]);
       end;
       exit;
      end;
      ed:=TNewEdit.Create(fm);
      ed.Parent:=Parent;
      ed.Name:=DsnCheckNameNew(fm,ed,GetNewName(ed));
      if Prev<>nil then
        ed.Top:=Prev.Top+1
      else
        ed.Top:=RealyTop;
      RealyTop:=RealyTop+IncTop;
      ed.Left:=DefLeft;
      ed.Text:='';
      ed.LabelCaption:=Trim(GetCaptionByFieldName(FieldName))+':';
      ed.DocFieldName:=FieldName;
      ListRealyNeeded.Add(ed);
      Result:=ed;
    finally
      ListControls.Free;
    end;
  end;

  procedure GetConstFiedls(val: string; str: TStringList);
  var
    APos1,APos2: Integer;
    s: string;
  begin
    while true do begin
      APos1:=AnsiPos(AnsiUpperCase(ConstLeftBreak),AnsiUpperCase(val));
      APos2:=AnsiPos(AnsiUpperCase(ConstRightBreak),AnsiUpperCase(val));
      if Apos2>APos1 then begin
        s:=Copy(val,APos1+Length(ConstLeftBreak),APos2-APos1-Length(ConstLeftBreak));
        str.Add(s);
        val:=Copy(val,APos2+Length(ConstRightBreak),Length(val)-APos2-Length(ConstRightBreak)+1);
      end else Break;
    end;
  end;
  
  function ParseConst(FieldName: string; Prev: TControl; Level: Integer=MaxInt): TControl;
  var
    i: Integer;
    val: string;
    str: TStringList;
    priority: Integer;

    function NeedCreateControl(ConstName: string): TControl;
    var
      Index: Integer;
    begin
      Result:=nil;
      Index:=ListDefaultConst.IndexOf(ConstName);
      if (Index=-1) and not InFieldNoCreate(ConstName) then
        Result:=CreateControlByFieldName(ConstName,Prev);
    end;

  begin
    qrConst.First;
    Result:=nil;
    if qrConst.Locate('name',FieldName,[loCaseInsensitive]) then begin
      val:=qrConst.FieldByName('val').AsString;
      priority:=qrConst.FieldByName('priority').AsInteger;
      str:=TStringList.Create;
      try
        GetConstFiedls(val,str);
        if priority<Level then begin
          for i:=0 to str.Count-1 do
            Result:=ParseConst(str.Strings[i],Prev,priority);
        end else begin
       {   for i:=0 to str.Count-1 do
            NeedCreateControl(str.Strings[i]); }
           Result:=NeedCreateControl(FieldName);  
        end; 
      finally
        str.Free;
      end;  
    end else Result:=NeedCreateControl(FieldName);
  end;

  procedure RemoveNonUseTabSheet(wt: TWinControl);
  var
    i: Integer;
    ct: TControl;
  begin
    for i:=wt.ControlCount-1 downto 0 do begin
      ct:=wt.Controls[i];
      if ct is TWinControl then begin
        RemoveNonUseTabSheet(TWinControl(ct));
        if TWinControl(ct).ControlCount=0 then begin
          if csAcceptsControls in ct.ControlStyle then begin
            ct.Parent:=nil;
            ct.Free;
          end else begin
            if ct is TPageControl then begin
              ct.Parent:=nil;
              ct.Free;
            end;
          end;
        end;
      end;  
    end;
  end;

  function DocFieldNameExistsAndNotEmpty(ct: TControl): Boolean;
  var
    S: String;
  begin
    Result:=false;
    if IsPublishedProp(ct,ConstPropDocFieldName) then begin
      S:=GetStrProp(ct,ConstPropDocFieldName);
      Result:=Trim(S)<>'';
    end;
  end;

  procedure RemoveNonUseControl(wt: TWinControl);
  var
    i: Integer;
    ct: TControl;
    val: Integer;
    lb: TBoundLabel;
  begin
    i:=0;
    while i<>wt.ControlCount do begin
      ct:=wt.Controls[i];
      if ct is TWinControl then RemoveNonUseControl(TWinControl(ct));
      val:=ListRealyNeeded.IndexOf(ct);
      inc(i);
      if val=-1 then begin
       if isNewControl(ct) and DocFieldNameExistsAndNotEmpty(ct) then begin
         lb:=GetBoundLabel(ct);
         if lb<>nil then begin
           lb.Parent:=nil;
           dec(i);
         end;
         ct.Parent:=nil;
         ct.Free;
         dec(i);
       end;
      end; 
    end;
  end;

  function GetFirstPageControl(wt: TWinControl): TPageControl;
  var
    isBreak: Boolean;

    function LocalGetFirstPageControl(wtParent: TWinControl): TPageControl;
    var
      i: Integer;
      ct: TControl;
    begin
      Result:=nil; // ?????????????????????/
      if isBreak then begin
        exit;
      end;
      for i:=0 to wtParent.ControlCount-1 do begin
        ct:=wtParent.Controls[i];
        if ct is TPageControl then begin
          Result:=TPageControl(ct);
          isBreak:=true;
          exit;
        end;
        if ct is TWinControl then begin
          Result:=LocalGetFirstPageControl(TWinControl(ct));
          if Result<>nil then begin
            isBreak:=true;
            exit;
          end;
        end;
      end;
    end;

  begin
    isBreak:=false;
    Result:=LocalGetFirstPageControl(wt);
  end;

var
  i,j: Integer;
  P: PInfoWordType;
  ct: TControl;
  ListControls: TList;
  fmRename: TfmRenameTabSheet;
  Check: Boolean;
  Prev: TControl;
  fmP: TfmProgress;
  Error: Boolean;
const
  DefTop=StartUpdateHeight;
begin
  fm:=TfmNewForm.Create(nil);
  ListRealyNeeded:=TList.Create;
  try
   OpenConst;

   fm.Visible:=false;

   Error:=false;
   if not isFirstLoad then begin
    FreeAllComponents(fm);

    LoadControlFromStream(fm,msOutForm,Error);
   end else begin
    fm.CreateSmall;
   end;

   if not Error then begin

     fm.GridSize:=2;

     fm.InitSmall;

     ListRealyNeeded.Add(fm.pnDesign);
     RealyTop:=DefTop;
     isRenameExists:=false;
     Prev:=nil;
   
     PrepearListFields(ListFields);

     fmP:=TfmProgress.Create(nil);
     fmP.Caption:=ConstRefreshForm;
     fmP.lbProgress.Caption:='';
     fmP.bibBreak.Visible:=false;
     fmP.gag.Position:=0;
     fmP.Visible:=(ListFields.Count>0) and ViewProgress;
     fmP.Update;
     fmP.FormStyle:=fsStayOnTop;
     try
       for i:=0 to ListFields.Count-1 do begin
         P:=ListFields.Items[i];
         case P.WordType of
           wtFieldQuote: begin
             SetPositonAndText(i,Format(fmtRefreshField,[PFieldQuote(P.PField).FieldName]),'����:',fmP,ListFields.Count);
             ListControls:=TList.Create;
             try
               GetControlByPropValue(fm.pnDesign,PropDocFieldName,PFieldQuote(P.PField).FieldName,ListControls);
               if ListControls.Count>0 then begin
                for j:=0 to ListControls.Count-1 do begin
                 ct:=ListControls.Items[j];
                 if j=0 then begin
                   Check:=false;
                   if ct is TDateTimePicker then Check:=TDateTimePicker(ct).Checked;
                   ct.Parent:=GetParentByFieldName(PFieldQuote(P.PField).FieldName);
                   if ct is TDateTimePicker then begin
                     TDateTimePicker(ct).Checked:=Check;
                     TDateTimePicker(ct).Checked:=Check;
                   end;
                   ListRealyNeeded.Add(ct);
                   Prev:=ct;
                 end;
                end;
               end else begin
                 if not InConst(PFieldQuote(P.PField).FieldName) then begin
                   Prev:=CreateControlByFieldName(PFieldQuote(P.PField).FieldName,Prev);
                 end else begin
                   Prev:=ParseConst(PFieldQuote(P.PField).FieldName,Prev);
                 end;
               end;
             finally
               LIstControls.Free;
             end;
           end;
         end;
       end;
     finally
       fmP.Free;
     end;  

     ListRealyNeeded.Pack;
     RemoveNonUseControl(fm.pnDesign);
     RemoveNonUseTabSheet(fm.pnDesign);

     ReAlignControls(fm.pnDesign,true,false,not isFirstLoad);

     if isRenameExists then begin
       fmRename:=TfmRenameTabSheet.Create(nil);
       try
        fmRename.FillTabSheets(GetFirstPageControl(fm.pnDesign));
        fmRename.ApplyTabSheets;
        if fmRename.lbTabSheet.Items.Count>0 then
         if fmRename.ShowModal=mrOk then begin
           fmRename.ApplyTabSheets;
         end;
       finally
        fmRename.Free;
       end;
     end;

     fm.OnKeyDown:=fmMain.OnKeyDown;
     fm.OnKeyPress:=fmMain.OnKeyPress;
     fm.OnKeyUp:=fmMain.OnKeyUp;

     msOutForm.Position:=0;
     msOutForm.Clear;
     SaveControlToStream(fm,msOutForm);
   end;
  finally
   CloseConst;
   ListRealyNeeded.Free;
   fm.free;
  end;
end;

function IsValidPointer(P: Pointer; Size: Integer=0): Boolean;
begin
  result:=False;
  if P=nil then exit;
  if isBadCodePtr(P) then exit;
  if Size>0 then
   if IsBadReadPtr(P,Size) then exit;
  Result:=true;
end;

function GetDocumentRefByFileName(FileName: string): Variant;
var
  W: Variant;

  function CreateAndPrepairWord: Boolean;
  begin
   result:=false;
   Screen.Cursor:=crHourGlass;
   try
    try
     VarClear(W);
     W:=CreateOleObject(WordOle);
     Application.MainForm.Update;
     result:=true;
    except
     on E: Exception do begin
        ShowError(Application.Handle,ConstWordFailed);
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

  function PrepairWord: Boolean;
  begin
   Screen.Cursor:=crHourGlass;
   try
    try
     CoInitialize(nil);
     W:=GetActiveOleObject(WordOle);
     Application.MainForm.Update;
     result:=true;
    except
     on E: Exception do begin
       if E.Message=MesOperationInaccessible then
        result:=CreateAndPrepairWord
       else if E.Message=MesCallingWasDeclined then
        result:=CreateAndPrepairWord
       else begin
         Result:=False;
         ShowError(Application.Handle,ConstWordFailed);
       end;
     end;
    end;
   finally
    Screen.Cursor:=crDefault;
   end;
  end;

begin
  Result:=varEmpty;
  if PrepairWord then begin
    Result:=W.Documents.Open(Filename,false,false,false,'','',false,'','',wdOpenFormatAuto);
  end;
end;

function ViewFieldsInDocument(FieldName: string): Boolean;
var
  D,F,Range: Variant;
  Count: Integer;
  p1,p2: Integer;
  p1f,p2f: Integer;
  isFind: Boolean;
  i: Integer;
  s: string;
begin
  Result:=false;
  Screen.Cursor:=crHourGlass;
  try
    isFind:=false;
    D:=GetDocumentRefByFileName(lastFileDoc);
    if VarIsEmpty(D) then exit;

    p1:=0;
    p2:=0;
    Count:=D.Fields.Count;
    for i:=1 to Count do begin
     try
      F:=D.Fields.Item(I);
      if F.Type=wdFieldQuote then begin
        s:=GetStringInQuote(F.Code);
        if AnsiSameText(s,FieldName) then begin
          p1:=F.Result.Start;
          p2:=F.Result.End;
          if not isFind then begin
           p1f:=p1;
           p2f:=p2;
          end;
          Range:=D.Range(p1,p2);
          Range.HighlightColorIndex:=wdRed;
          isFind:=true;
        end;
      end;
     except
     end;
    end;

    if isFind then begin
      D.Application.ActiveWindow.ScrollIntoView(D.Range(p1f,p2f),true);
      D.Application.ActiveWindow.ScrollIntoView(D.Range(p1f,p2f),true);
      D.Saved:=true;
      D.Application.Visible:=true;
      D.Application.Activate;
      D.Application.Visible:=true;
      D.Application.WindowState:=wdWindowStateMaximize;

      Result:=true;
    end else begin
      D.Saved:=false;
      D.Close(SaveChanges:=true);
    end;
  finally
    Screen.Cursor:=crDefault;
  end;  
end;

function Iff(isTrue: Boolean; TrueValue, FalseValue: Variant): Variant;
begin
  if isTrue then Result:=TrueValue
  else Result:=FalseValue;
end;

function GetGenIdEx(DB: TIBDatabase; TableName: string; Increment: Word): Longword;
var
 sqls: string;
 qrnew: TIBQuery;
 tran: TIBTransaction;
begin
 Result:=0;
 try
  Screen.Cursor:=crHourGlass;
  qrnew:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qrnew.Database:=DB;
   tran.AddDatabase(DB);
   DB.AddTransaction(tran);
   qrnew.Transaction:=tran;
   qrnew.Transaction.Active:=true;
   sqls:='Select (gen_id(Set'+Tablename+'_id,'+inttostr(Increment)+')) from dual';
   qrnew.SQL.Add(sqls);
   qrnew.Active:=true;
   if not qrnew.IsEmpty then begin
     Result:=qrnew.FieldByName('gen_id').AsInteger;
   end;
  finally
   tran.free;
   qrnew.free;
   Screen.Cursor:=crDefault;
  end;
 except
  {$IFDEF DEBUG} on E: Exception do Assert(false,E.message); {$ENDIF}
 end;
end;

function GetGenId(TableName: string; Increment: Word): Longword;
begin
 Result:=GetGenIdEx(dm.IBDbase,TableName,Increment);
end;


function toTrimSpaceForOne(const s: string): string;
var
  I: Integer;
  tmps: string;
begin
  for i:=1 to Length(s) do begin
   if i=1 then begin
     tmps:=s[i];
   end else begin
     if (s[i]<>' ') then
      tmps:=tmps+s[i]
     else
      if (s[i-1]<>' ') then
        tmps:=tmps+s[i];
   end;
  end;
  Result:=tmps;
end;

function ParamExists(const Param: String): WordBool; stdcall;
begin
  Result:=FindCmdLineSwitch(Param);
end;

function ValueByParam(const Param: String; Index: Integer=0): String; stdcall;
var
  i: Integer;
  ParamExists: Boolean;
  S: string;
  Chars: TSysCharSet;
  Incr: Integer;
begin
  ParamExists:=false;
  Chars:=SwitchChars;
  Incr:=1;
  for i:=1 to ParamCount do begin
    S:=ParamStr(i);
    if (Chars = []) or (S[1] in Chars) then begin
      if (AnsiCompareText(Copy(S, 2, Maxint), Param) = 0) then begin
        ParamExists:=True;
      end;
    end else begin
      if ParamExists then begin
        if Incr=(Index+1) then begin
          Result:=S;
          exit;
        end;  
        Inc(Incr);
      end;
    end;  
  end;
end;

procedure SwitchParams;
var
  AUserName: String;
  APassword: String;
  AKey: String;
begin
  if ParamExists(SwitchRunParamConfig) then begin
    isExit:=false;
    FConfigFileName:=ValueByParam(SwitchRunParamConfig);
    if FileExists(FConfigFileName) then begin
      FConfigFileName:=ExpandFileName(FConfigFileName)
    end else begin
      if ExtractFilePath(FConfigFileName)='' then
        FConfigFileName:=ExtractFilePath(Application.ExeName)+FConfigFileName;
    end;
  end;
  if ParamExists(SwitchRunParamSqlFile) then begin
    isExit:=true;
    FSqlFileName:=ValueByParam(SwitchRunParamSqlFile);
    isExitCode:=true;
  end;
  if ParamExists(SwitchRunParamUser) then begin
    isExit:=true;
    AUserName:=ValueByParam(SwitchRunParamUser,0);
    APassword:=ValueByParam(SwitchRunParamUser,1);
    LocalDb.WriteParam(SDb_ParamUserName,AUserName,true);
    LocalDb.WriteParam(SDb_ParamPassword,APassword,true);
    LocalDb.UpdateFile(true);
    isExitCode:=true;
  end;
  if ParamExists(SwitchRunParamKey) then begin
    isExit:=true;
    AKey:=ValueByParam(SwitchRunParamKey,0);
    LocalDb.WriteParam(SDb_ParamKey,AKey,true);
    LocalDb.UpdateFile(true);
    isExitCode:=true;
  end;
  if ParamExists(SwitchRunParamAdmin) then begin
    isExit:=false;
    FAdminPresent:=true;
  end;
end;

function PosEx(SubStr,Str: string; Count: Integer): Integer;
var
  ct,Apos,i: Integer;
  s: string;
const
  C1='''';
begin
  Result:=0;
  Apos:=Pos(SubStr,Str);
  if Apos>0 then begin
    s:=Copy(Str,1,Apos);
    str:=Copy(Str,Apos+1,Length(str));
    ct:=0;
    for i:=1 to Length(s) do begin
      if s[i]=C1 then Inc(ct);
    end;
    ct:=Count+ct;
    if Odd(ct) then begin
      Result:=Apos+PosEx(SubStr,Str,ct);
      exit;
    end else begin
      Result:=Apos;
      exit;
    end;
  end;
end;

procedure RunParamSqlFile(SqlFile: string);
var
  DefCommands: TStringList;
  fm: TfmProgress;
  strLog: TStringList;
  Base: TIBDataBase;
  Tran: TIBTransaction;
  ListFS: TList;
  fPath: string;
type
  ExecuteCommand=(ecNone,ecSetBlobFile,ecSql);

  PEC=^TEC;
  TEC=packed record
    EC: ExecuteCommand;
    Name: string;
    P: Pointer;
  end;

  PECSetBlobFile=^TECSetBlobFile;
  TECSetBlobFile=packed record
    FileName: string;
    FS: TFileStream;
  end;

  PECSql=^TECSql;
  TECSql=packed record
    Sql: string;
  end;

  procedure RegisterCommands();
  begin
    DefCommands.AddObject(ConstRenovationCommandSetBlobFile,TObject(Pointer(ecSetBlobFile)));
    DefCommands.AddObject(ConstRenovationCommandSql,TObject(Pointer(ecSql)));
  end;

  function CreateCommands(s: string): TList;
  var
    P1: PEC;
    P2: Pointer;
    APosB,APosE: Integer;
    val: Integer;
    cre,s1,sCommand,sLower,sTemp: string;
  begin
    Result:=TList.Create;
    APosB:=-1;
    while AposB<>0 do begin
       APosB:=Pos(ConstRenovationCommandB,s);
       APosE:=Pos(ConstRenovationCommandE,s);
       if (APosB>0)and(APosB<APosE) then begin
         sCommand:=Copy(s,APosB+Length(ConstRenovationCommandB),APosE-APosB-Length(ConstRenovationCommandE));
         val:=DefCommands.IndexOf(sCommand);
         if val<>-1 then begin
           s:=Copy(s,APosE+Length(ConstRenovationCommandE),Length(s));
           sLower:=LowerCase(s);
           cre:=LowerCase(Format(fmtRenovationCommandEnd,[sCommand]));
           APosB:=Pos(cre,sLower);
           if AposB>0 then begin
              s1:=Copy(s,1,APosB-1);
              New(P1);
              FillChar(P1^,SizeOf(P1^),0);
              P1.EC:=ExecuteCommand(Pointer(DefCommands.Objects[val]));
              P1.Name:=LowerCase(Format(fmtRenovationCommandBegin,[sCommand]));
              P2:=nil;
              case P1.EC of
                ecSetBlobFile: begin
                  New(PECSetBlobFile(P2));
                  FillChar(PECSetBlobFile(P2)^,SizeOf(PECSetBlobFile(P2)^),0);
                  s1:=Trim(s1);
                  sTemp:=ExtractFilePath(s1);
                  if Trim(sTemp)<>'' then
                    PECSetBlobFile(P2).FileName:=s1
                  else
                    PECSetBlobFile(P2).FileName:=fPath+s1;
                end;
                ecSql: begin
                  New(PECSql(P2));
                  FillChar(PECSql(P2)^,SizeOf(PECSql(P2)^),0);
                  PECSql(P2).Sql:=s1;
                end;
              end;
              P1.P:=P2;
              s:=Copy(s,APosB+Length(cre),Length(s));
              Result.Add(P1);
           end;
         end;
       end;
    end;
  end;

  procedure ClearCommands(List: TList);
  var
    i: Integer;
    P: PEC;
  begin
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      case P.EC of
        ecSetBlobFile: begin
          if PECSetBlobFile(P.P).FS<>nil then
           PECSetBlobFile(P.P).FS.Free;
          Dispose(PECSetBlobFile(P.P));
        end;  
        ecSql: Dispose(PECSql(P.P));
      end;
      Dispose(P);
    end;
    List.Clear;
  end;

  procedure RunCommands(List: TList);

    function GetLastFileStream: TFileStream;
    var
      i: Integer;
      P: PEC;
    begin
      Result:=nil;
      for i:=List.Count-1 downto 0 do begin
        P:=List.Items[i];
        if P.EC=ecSetBlobFile then begin
          Result:=PECSetBlobFile(P.P).FS;
          exit;
        end;
      end;
    end;

    procedure SetParams(Query: TIBQuery);
    var
      Buffer: String;
      i: Integer;
      pr: TParam;
      b,s: string;
      b1,s1: Integer;
      fs: TFileStream;
    begin
      for i:=0 to Query.Params.Count-1 do begin
        pr:=Query.Params.Items[i];
        if AnsiSameText(Copy(pr.Name,1,1),'H') then begin
          b:=Copy(pr.Name,2,8);
          s:=Copy(pr.Name,11,8);
          b1:=strtoint('$'+b);
          s1:=strtoint('$'+s);
          fs:=GetLastFileStream;
          if fs<>nil then begin
            fs.Position:=b1;
            SetLength(Buffer,s1);
            fs.Read(Pointer(Buffer)^,s1);
            pr.AsBlob:=Buffer;
          end;
        end;
      end;
    end;
    
  var
    i: Integer;
    P: PEC;
    Sql: TIBQuery;
  begin
    for i:=0 to List.Count-1 do begin
      P:=List.Items[i];
      SetPositonAndText(i,Format(fmtRenovationId,[i+1]),'�������:',fm,List.Count);
      try
        case P.EC of
          ecSetBlobFile: begin
            PECSetBlobFile(P.P).FS:=TFileStream.Create(PECSetBlobFile(P.P).FileName,fmOpenRead);
          end;
          ecSql: begin
            Sql:=TIBQuery.Create(nil);
            try
              Sql.DataBase:=Base;
              Sql.Transaction:=Tran;
              Sql.Sql.Text:=PECSql(P.P).Sql;
              Sql.Transaction.Active:=false;
              Sql.Transaction.Active:=true;
              Sql.Prepare;
              SetParams(Sql);
              Sql.ExecSql;
              case Sql.StatementType of
                SQLCommit,SQLRollback: begin
                end;
                else begin
                  Sql.Transaction.Commit;
                end;
              end;    
            finally
              Sql.Free;
            end;
          end;
        end;
        strLog.Add(Format(fmtRenovationLogSuccess,[P.Name]));
      except
        on E: Exception do begin
          strLog.Add(Format(fmtRenovationLogFail,[P.Name]));
          strLog.Add(E.Message);
          ShowError(Application.Handle,E.Message);
          isExitCode:=true;
        end;
      end;
    end;
  end;

var
  str: TStringList;
  s,FileLog: string;
  Commands: TList;
  Buffer: String;
begin
  fPath:=ExtractFilePath(SqlFile);
  if Trim(fPath)='' then begin
    fPath:=ExtractFileDir(Application.Exename)+'\';
    SqlFile:=fPath+SqlFile;
  end;

  if not FileExists(SqlFile) then exit;

  isExitCode:=false;
  Base:=TIBDataBase.Create(nil);
  Tran:=TIBTransaction.Create(nil);
  ListFS:=TList.Create;

  strLog:=TStringList.Create;
  DefCommands:=TStringList.Create;
  try
    try
      Tran.Params.Text:=DefaultTransactionParamsTwo;
      Tran.AddDatabase(Base);
      Base.AddTransaction(Tran);
      Base.DatabaseName:=DataBaseName;
      Base.LoginPrompt:=false;

      Buffer:='';
      if LocalDb.ReadParam(SDb_ParamUserName,Buffer) then
        Base.Params.Add(Format(DataBaseUserName,[Buffer]));

      Buffer:='';
      if LocalDb.ReadParam(SDb_ParamPassword,Buffer) then
        Base.Params.Add(Format(DataBaseUserPass,[Buffer]));

      Base.Params.Add(DataBaseCodePage);
      Base.Connected:=true;

      str:=TStringList.Create;
      try
        str.LoadFromFile(SqlFile);
        s:=Trim(str.Text);
      finally
        str.Free;
      end;

      RegisterCommands;

      Commands:=CreateCommands(s);
      fm:=TfmProgress.Create(nil);
      fm.Caption:=ConstRenovationBase;
      fm.lbProgress.Caption:='';
      fm.bibBreak.Visible:=false;
      fm.gag.Position:=0;
      fm.Visible:=Commands.Count>0;
      fm.Update;
      fm.FormStyle:=fsStayOnTop;
      try
        RunCommands(Commands);
      finally
        fm.Free;
        ClearCommands(Commands);
        Commands.Free;
      end;

    except
      on E: Exception do begin
        strLog.Add(E.Message);
        ShowError(Application.Handle,E.Message);
        isExitCode:=true;
      end;
    end;
  finally
    DefCommands.Free;
    try
      FileLog:=ExtractFileName(sqlFile);
      FileLog:=ChangeFileExt(ExtractFileName(sqlFile),ConstExtRenovationLog);
      if isExitCode then
        strLog.SaveToFile(fPath+FileLog);
    except
    end;  
    strLog.Free;
    ListFS.Free;
    Tran.Free;
    Base.Free;
  end;
end;

function GetSubsId(SubsName: string): Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Result:=-1;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select subs_id from '+TableSubs+
         ' where Upper(name)='+QuotedStr(AnsiUpperCase(SubsName));
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.isEmpty then begin
      Result:=qr.FieldByName('subs_id').AsInteger;
    end;
  finally
    qr.Free;
    tr.Free;
  end;
end;

procedure OpenSubs(Control: TControl; isLocate: Boolean; LocateSubs,LocateSubsValue: Variant; isFirst: Boolean=true);
var
  s: String;
  fmS: TfmSubs;
  fmSV: TfmSubsValue;
  isView: Boolean;
  subsname,subsvalue: string;
  subsid: Integer;
  isOk: Boolean;
begin
  try
   isView:=false;
   isOk:=false;
   subsid:=-1;
   s:='';
   if Control=nil then exit;
   if isFirst then
     subsid:=GetSubsId(LocateSubs);
   if subsid>-1 then begin
     subsname:=LocateSubs;
     isOk:=true;
   end else begin
     fmS:=TfmSubs.Create(nil);
     try
      fmS.BorderIcons:=[biSystemMenu, biMaximize];
      fmS.bibOk.Visible:=true;
      fmS.bibOk.OnClick:=fmS.MR;
      fmS.Grid.OnDblClick:=fmS.MR;
      fmS.LoadFilter;
      fmS.ActiveQuery;
      if isLocate then
        fmS.Mainqr.Locate('name',LocateSubs,[loCaseInsensitive]);
      if fmS.ShowModal=mrOk then begin
        if not fmS.Mainqr.IsEmpty then begin
          isOk:=true;
          subsname:=fmS.Mainqr.FieldByName('name').AsString;
          subsid:=fmS.Mainqr.FieldByName('subs_id').AsInteger;
        end;
      end;
     finally
      fmS.free;
     end;
   end;
   if isOk then begin
    fmSV:=TfmSubsValue.Create(nil);
    try
     fmSV.BorderIcons:=[biSystemMenu, biMaximize];
     fmSV.bibOk.Visible:=true;
     fmSV.bibOk.OnClick:=fmSV.MR;
     fmSV.Grid.OnDblClick:=fmSV.MR;
     fmSV.SetFilter(subsname,'');
     fmSV.SetEditValue(subsname,subsid);
     fmSV.ActiveQuery;
     subsvalue:=LocateSubsValue;
     if isLocate then
       fmSV.Mainqr.Locate('text',subsvalue,[loCaseInsensitive]);
     if fmSV.ShowModal=mrOk then begin
       if not fmSV.Mainqr.IsEmpty then begin
          subsvalue:=fmSV.Mainqr.FieldByName('text').AsString;
          SetTextToControl(Control,subsvalue);
       end;
     end else isView:=true;
    finally
     fmSV.Free;
    end;
   end;

   if isView then OpenSubs(Control,true,subsname,subsvalue,false);

  except
  end;
end;

procedure SetTextToControl(ct: TControl; const Value: Variant);
var
  Check: Boolean;
begin
 if ct=nil then exit;
 try
  if ct is TLabel then SetPropValue(ct,'Caption',Value);
  if ct is TEdit then SetPropValue(ct,'Text',Value);
  if ct is TComboBox then SetPropValue(ct,'Text',Value);
  if ct is TMemo then SetPropValue(ct,'Text',Value);
  if ct is TCheckBox then SetPropValue(ct,'Caption',Value);
  if ct is TRadioButton then SetPropValue(ct,'Caption',Value);
  if ct is TListBox then SetPropValue(ct,'Text',Value);
  if ct is TRadioGroup then SetPropValue(ct,'Caption',Value);
  if ct is TMaskEdit then SetPropValue(ct,'Text',Value);
  if ct is TRichEdit then SetPropValue(ct,'Text',Value);
  if ct is TDateTimePicker then begin
   Check:=TDateTimePicker(ct).Checked;
   case TDateTimePicker(ct).Kind of
      dtkDate:SetPropValue(ct,'Date',StrToDate(Value));
      dtkTime:SetPropValue(ct,'Time',strToTime(Value));
   end;
   TDateTimePicker(ct).Checked:=Check;
   TDateTimePicker(ct).Checked:=Check;
  end;
  if ct is TNewComboBoxMarkCar then SetPropValue(ct,'Text',Value);
  if ct is TNewComboBoxColor then SetPropValue(ct,'Text',Value);
  if ct is TRxCalcEdit then SetPropValue(ct,'Value',Value);
 except
 end;
end;

procedure FillSubsToStrings(Subs: string; Items: TStrings);
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  subsid: Integer;
begin
  subsid:=GetSubsId(Subs);
  if subsid<0 then exit;
  Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select text from '+TableSubsValue+
         ' where subs_id='+inttostr(subsid)+
         ' order by priority';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    Items.Clear;
    qr.First;
    while not qr.Eof do begin
      Items.Add(qr.FieldByName('text').AsString);
      qr.Next;
    end;
  finally
    Items.EndUpdate;
    qr.Free;
    tr.Free;
  end;
end;

function ChangeString(Value: string; strOld, strNew: string): string;
var
  tmps: string;
  APos: Integer;
  s1,s3: string;
  lOld: Integer;
begin
  Apos:=-1;
  s3:=Value;
  lOld:=Length(strOld);
  while APos<>0 do begin
    APos:=Pos(strOld,s3);
    if APos>0 then begin
      SetLength(s1,APos-1);
      Move(Pointer(s3)^,Pointer(s1)^,APos-1);
      s3:=Copy(s3,APos+lOld,Length(s3)-APos-lOld+1);
      tmps:=tmps+s1+strNew;
    end else
      tmps:=tmps+s3;
  end;
  Result:=tmps;
end;

procedure ViewUpdateInfo;
var
  fm: TfmUpdateInfo;
begin
  fm:=TfmUpdateInfo.Create(nil);
  try
    fm.FillInfo;
    fm.ShowModal;
    isViewUpdateInfo:=not fm.chbNotViewOnLoad.Checked;
  finally
    fm.Free;
  end;
end;

function GetRenovationIdByDate(Date: TDate): Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Result:=0;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select * from '+TableRenovation+
         ' where indate=(select max(indate) from '+TableRenovation+
         ' where indate<='+QuotedStr(DateToStr(date))+')';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    qr.First;
    if not qr.isEmpty then begin
      Result:=qr.FieldByName('renovation_id').AsInteger;
    end;
  finally
    qr.Free;
    tr.Free;
  end;
end;

function GetRenovationIdByWorkDate(): Integer;
begin
  Result:=GetRenovationIdByDate(WorkDate);
end;

function GetRenovationNameById(Id: Integer): string;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
  Result:='';
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select * from '+TableRenovation+
         ' where renovation_id='+inttostr(id);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    qr.First;
    if not qr.isEmpty then begin
      Result:=qr.FieldByName('name').AsString;
    end;
  finally
    qr.Free;
    tr.Free;
  end;
end;

function GetRenovationVersion(Version: string): string;
var
  s: string;
begin
  s:=GetRenovationNameById(GetRenovationIdByDate(GetDateTimeFromServer));
  Result:=Iff(Trim(s)<>'',Format(fmtAboutVerSplash,[Version,s]),Version)
end;

procedure GetStringsByString(const S: string; const Delim: string; Strings: TStringList);
var
  Apos: Integer;
  Str: TStringList;
  NewS,OldS: string;
begin
  Apos:=-1;
  NewS:=S;
  Str:=TStringList.Create;
  try
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,NewS);
      if Apos>0 then begin
        OldS:=Copy(NewS,1,APos-1);
        NewS:=Copy(NewS,Apos+Length(Delim),Length(NewS));
        if OldS<>'' then
          Str.Add(OldS);
      end else
        if NewS<>'' then
          Str.Add(NewS);
    end;
    Strings.Assign(str);
  finally
    Str.Free;
  end;
end;

procedure UpdateWordsInReestr(DateForm,DateTo: TDateTime);

  procedure UpdateWords(Reestr_id: Integer; msForm,msDoc,msWords: TMemoryStream);
  var
    qr: TIBQuery;
    tr: TIBTransaction;
    sqls: string;
  begin
    qr:=TIBQuery.Create(nil);
    tr:=TIBTransaction.Create(nil);
    try
      tr.AddDatabase(dm.IBDbase);
      dm.IBDbase.AddTransaction(tr);
      tr.Params.Text:=DefaultTransactionParamsTwo;
      qr.Database:=dm.IBDbase;
      qr.Transaction:=tr;
      qr.Transaction.Active:=true;
      sqls:='Update '+TableReestr+' set words=:words, dataform=:dataform, datadoc=:datadoc where reestr_id='+inttostr(Reestr_id);
      qr.Sql.Add(sqls);
      qr.ParamByName('words').LoadFromStream(msWords,ftBlob);
      qr.ParamByName('dataform').LoadFromStream(msForm,ftBlob);
      qr.ParamByName('datadoc').LoadFromStream(msDoc,ftBlob);
      qr.ExecSql;
      qr.Transaction.Commit;
    finally
      tr.Free;
      qr.Free;
    end;
  end;
  
var
  qr: TIBQuery;
  tr: TIBTransaction;
  sqls: string;
  FileDoc: string;
  Words: TStringList;
  ms: TMemoryStream;
  MsForm: TMemoryStream;
  msWords: TMemoryStream;
  timestr: string;
  datestr: string;
  tmps: string;
  D: Variant;
  i: Integer;
  NewS: string;
begin
  SCreen.Cursor:=crHourGlass;
  fmProgress.gag.Position:=0;
  fmProgress.Caption:='��������� ������...';
  fmProgress.lbProgress.Caption:='��������: ';
  fmProgress.Visible:=true;
  fmProgress.Update;

  BreakAnyProgress:=false;

  qr:=TIBQuery.Create(nil);
  tr:=TIBTransaction.Create(nil);
  Words:=TStringList.Create;
  ms:=TMemoryStream.Create;
  MsForm:=TMemoryStream.Create;
  msWords:=TMemoryStream.Create;
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select reestr_id, dataform, datadoc, tmpname from '+TableReestr+
          ' where datechange >='+QuotedStr(formatdatetime(fmtDateTime,DateForm))+
          ' and datechange <='+QuotedStr(formatdatetime(fmtDateTime,DateTo))+
          ' and isdel is null ';
    qr.Sql.Add(sqls);
    qr.Active:=true;
    qr.FetchAll;
    i:=0;

    fmProgress.gag.Max:=qr.RecordCount;
    while not qr.Eof do begin
      inc(i);
      Application.ProcessMessages;
      if BreakAnyProgress then exit;

      NewS:=Format('�������� %d �� %d: ',[i,qr.RecordCount]);
      SetPositonAndText(i,qr.FieldByname('tmpname').AsString,NewS,nil,qr.RecordCount);

      MsForm.Clear;
      TBlobField(qr.FieldByName('dataform')).SaveToStream(MsForm);
      ExtractObjectFromStream(MsForm);
      MsForm.Position:=0;
      CompressAndCrypt(MsForm);
      MsForm.Position:=0;

      ms.Clear;
      TBlobField(qr.FieldByName('datadoc')).SaveToStream(ms);
      ExtractObjectFromStream(ms);
      ms.Position:=0;

      if ms.Size>0 then begin

        timestr:=FormatDateTime(fmtFileTime,WorkDate);
        datestr:=FormatDateTimeTSV(fmtDateLong,WorkDate);
        tmps:=qr.FieldByname('tmpname').AsString+' ('+timestr+', ' +datestr+').doc';
        FileDoc:=GetUniqueFileName(TempDocFilePath+'\'+tmps,0);
        ms.SaveToFile(FileDoc);

        CompressAndCrypt(ms);
        ms.Position:=0;

        D:=GetDocumentRefByFileName(FileDoc);
        GetTextByDocument(D,Words);
        msWords.Clear;
        msWords.Write(Pointer(Words.Text)^,Length(Words.Text));
        msWords.Position:=0;
        CompressAndCrypt(msWords);
        msWords.Position:=0;

        DeleteFile(FileDoc);

        UpdateWords(qr.FieldByName('reestr_id').AsInteger,MsForm,ms,msWords);


      end;
      qr.Next;
    end;
  finally
    fmProgress.bibBreak.Enabled:=true;
    fmProgress.Visible:=false;
    msWords.Free;
    MsForm.Free;
    ms.Free;
    Words.Free;
    tr.Free;
    qr.Free;
    SCreen.Cursor:=crDefault;
  end;
end;

procedure UpdateWordsInReestrByToday;
var
  dbegin,dend: TDateTime;
begin
  dbegin:=StrToDate(DateToStr(Now));
  dend:=StrToDate(DateToStr(Now))+StrToTime('23:59:59');
  UpdateWordsInReestr(dbegin,dend);
end;

function TrimCharForOne(ch: Char; const s: string): string;
var
  I: Integer;
  tmps: string;
begin
  for i:=1 to Length(s) do begin
   if i=1 then begin
     tmps:=s[i];
   end else begin
     if (s[i]<>ch) then
      tmps:=tmps+s[i]
     else
      if (s[i-1]<>ch) then
        tmps:=tmps+s[i];
   end;
  end;
  Result:=tmps;
end;

procedure CreateWordTableByGrid(AGrid: TNewdbGrid; const ACaption: string='');
var
  Ds: TIBCustomDataSet;
  W: OleVariant;
  D: OleVariant;

  function GetGridMaxWidth: Integer;
  var
    i: Integer;
  begin
    Result:=0;
    with AGrid do
      for i:=0 to Columns.Count-1 do begin
        if Columns.Items[i].Visible and
           Assigned(Columns.Items[i].Field) and
           (Columns.Items[i].Width>0) then begin
          Result:=Result+Columns.Items[i].Width;
        end;
      end;
  end;

  procedure ViewReport;
  var
    i: Integer;
    List: TList;
    ListW: TStringList;
    tb,R: OleVariant;
    last: Integer;
    k: Extended;
    TableW,Wd: Integer;
    Column: TColumn;
    Counter: Integer;
    NewValue: OleVariant;
    MaxGridWidth: Integer;
  begin
    BreakAnyProgress:=false;
    SetPositonAndText(0,'','����������',nil,fmProgress.gag.Max);
    D:=W.Documents.Add;
    D.ActiveWindow.View.Zoom.PageFit:=wdPageFitFullPage;
    D.PageSetup.Orientation:=wdOrientLandscape;

    List:=TList.Create;
    ListW:=TStringList.Create;
    try

      MaxGridWidth:=GetGridMaxWidth;
      with AGrid do
        for i:=0 to Columns.Count-1 do begin
          if Columns.Items[i].Visible and
             Assigned(Columns.Items[i].Field) and
             (Columns.Items[i].Width>0) then begin
            List.Add(Columns.Items[i]);
            k:=MaxGridWidth/Columns.Items[i].Width;
            ListW.Add(FloatToStr(k));
          end;
        end;

      last:=1;
      tb:=D.Paragraphs.Item(1).Range.Tables.Add(D.Paragraphs.Item(1).Range,1,1);
      tb.Rows.Borders.InsideLineStyle:= wdLineStyleNone;
      tb.Rows.Borders.OutsideLineStyle:= wdLineStyleNone;

      tb.Cell(last,1).Range.Font.Bold:=true;
      tb.Cell(last,1).Range.Font.Size:=16;
      tb.Cell(last,1).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
      tb.Cell(last,1).Range.InsertBefore(ACaption);

      inc(last);
      tb.Rows.Add;
      tb.Cell(last,1).Borders.OutsideLineStyle:= wdLineStyleSingle;
      tb.Cell(last,1).Borders.OutsideLineWidth:= wdLineWidth025pt;
      tb.Cell(last,1).Range.Font.Bold:=true;
      tb.Cell(last,1).Range.Font.Size:=12;
      tb.Cell(last,1).Range.Paragraphs.Alignment:=wdAlignParagraphCenter;
      tb.Cell(last,1).Split(1,List.Count);
      TableW:=0;
      for i:=1 to List.Count do begin
        TableW:=TableW+tb.Cell(last,i).Width;
      end;

      for i:=0 to List.Count-1 do begin
        Column:=TColumn(List.Items[i]);
        k:=StrToFloat(ListW.Strings[i]);
        Wd:=Round(TableW/k);
        tb.Cell(last,i+1).Width:=Wd;
        tb.Cell(last,i+1).Range.InsertBefore(Column.Title.Caption);
      end;

      Counter:=1;
      Ds.First;
      while not Ds.Eof do begin
        Application.ProcessMessages;
        if BreakAnyProgress then exit;
        inc(last);
        tb.Rows.Add;
        for i:=0 to List.Count-1 do begin
          NewValue:=TColumn(List.Items[i]).Field.Value;
          if i=0 then
            SetPositonAndText(Round(Counter),VarToStrDef(NewValue,''),TColumn(List.Items[i]).Title.Caption+': ',
                              nil,fmProgress.gag.Max);
          R:=tb.Cell(last,i+1).Range;
          R.Font.Bold:=false;
          R.Paragraphs.Alignment:=wdAlignParagraphLeft;
          R.InsertBefore(VarToStrDef(NewValue,''));
        end;
        Inc(Counter);
        Ds.Next;
      end;

    finally
      ListW.Free;
      List.Free;
      W.Visible:=true;
      SetPositonAndText(fmProgress.gag.Max,'','��� ������',nil,fmProgress.gag.Max);
      W.Activate;
      W.WindowState:=wdWindowStateMaximize;
    end;  
  end;

  procedure CreateAndPrepairReport;
  begin
    try
      VarClear(W);
      W:=CreateOleObject(WordOle);
      ViewReport;
    except
      on E: Exception do begin
        Application.ShowException(E);
      end;
    end;
  end;

  procedure PrepairReport;
  begin
    fmProgress.Caption:=CaptionCreateReport;
    fmProgress.lbProgress.Caption:='����������';
    fmProgress.gag.Position:=0;
    fmProgress.gag.Max:=Ds.RecordCount;
    fmProgress.Visible:=true;
    fmProgress.Update;
    try
      try
       W:=GetActiveOleObject(WordOle);
       ViewReport;
      except
        on E: Exception do begin
          if E.Message=MesOperationInaccessible then
            CreateAndPrepairReport
          else if E.Message=MesCallingWasDeclined then
            CreateAndPrepairReport
          else begin
            W.Quit;
            Application.ShowException(E);
          end;
        end;
      end;
    finally
      fmProgress.Visible:=false;
    end;
  end;

var
  B: TBookmark;
begin
  if Assigned(AGrid) and
     Assigned(AGrid.DataSource) and
     Assigned(AGrid.DataSource.DataSet) then begin
    Ds:=TIBCustomDataSet(AGrid.DataSource.DataSet);
    Screen.Cursor:=crHourGlass;
    Ds.DisableControls;
    B:=Ds.GetBookmark;
    try
      if Assigned(fmMain) then
        fmMain.Update;
      Ds.FetchAll;       
      PrepairReport;
    finally
      if Ds.BookMarkValid(B) then
        Ds.GotoBookmark(B);
      Ds.EnableControls;
      Screen.Cursor:=crDefault;
    end;
  end;
end;

function GetMaxNumReestr(LastTypeReestrID: Integer; NewUserId: Integer): Integer;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
  MaxNumReestr: Integer;
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=0;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select Max(numreestr) as numreestr from '+TableReestr+
         ' where typereestr_id='+inttostr(LastTypeReestrID)+
         ' and CERTIFICATEDATE>='+QuotedStr(FormatDateTime('01.01.yyyy',WorkDate))+
         ' and CERTIFICATEDATE<'+QuotedStr(FormatDateTime('01.01.yyyy',IncYear(WorkDate)))+
         ' and isdel is null';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then begin
     MaxNumReestr:=qr.FieldByName('numreestr').AsInteger;
     while true do begin
       qr.Transaction.Active:=false;
       qr.Close;
       sqls:='Select count(*) as CT from '+TableDocLock+
             ' where numreestr='+Inttostr(MaxNumReestr+1)+
             ' and yearwork='+inttostr(WorkYear)+
             ' and typereestr_id='+inttostr(LastTypeReestrID)+' ';
       qr.Sql.Text:=sqls;      
       qr.Transaction.Active:=true;
       qr.Open;
       if qr.FieldByName('CT').AsInteger>0 then
         MaxNumReestr:=MaxNumReestr+1
       else begin
         Result:=MaxNumReestr+1;
         break;
       end;    
     end; 
   end; 
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function isNumReestrAlready(NumReestr,LastTypeReestrID: Integer): Boolean;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;  
begin
  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   Result:=false;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select numreestr from '+TableReestr+
         ' where numreestr='+inttostr(NumReestr)+
         ' and typereestr_id='+inttostr(LastTypeReestrID)+
         ' and CERTIFICATEDATE>='+QuotedStr(FormatDateTime('01.01.yyyy',WorkDate))+
         ' and CERTIFICATEDATE<'+QuotedStr(FormatDateTime('01.01.yyyy',IncYear(WorkDate)))+
         ' and isdel is null';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then
    Result:=true
   else begin
     qr.Transaction.Active:=false;
     qr.Close;
     sqls:='Select count(*) as CT from '+TableDocLock+
           ' where numreestr='+Inttostr(NumReestr)+
           ' and yearwork='+inttostr(WorkYear)+
           ' and typereestr_id='+inttostr(LastTypeReestrID)+' ';
     qr.Sql.Text:=sqls;
     qr.Transaction.Active:=true;
     qr.Open;
     Result:=qr.FieldByName('CT').AsInteger>0;
   end;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure DocumentLock(NumReestr,LastTypeReestrID: Integer);
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  if not isDocumentLock then exit;
  DocumentUnLock(NumReestr,LastTypeReestrID);
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Insert into '+TableDocLock+
          ' (numreestr,yearwork,typereestr_id) values '+
          '('+inttostr(NumReestr)+','+inttostr(WorkYear)+','+inttostr(LastTypeReestrID)+')';
    qr.SQL.Add(sqls);
    qr.ExecSql;
    tr.Commit;
  finally
    qr.Free;
    tr.Free;
  end;
end;

procedure DocumentUnLock(NumReestr, LastTypeReestrID: Integer);
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Delete from '+TableDocLock+
          ' where numreestr='+inttostr(NumReestr)+
          ' and yearwork='+inttostr(WorkYear)+
          ' and typereestr_id='+inttostr(LastTypeReestrID);
    qr.SQL.Add(sqls);
    qr.ExecSql;
    tr.Commit;
  finally
    qr.Free;
    tr.Free;
  end;
end;

function RemoveDocumentsLocks: Boolean;
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    Result:=false;
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Delete from '+TableDocLock;
    qr.SQL.Add(sqls);
    qr.ExecSql;
    tr.Commit;
    Result:=true;
  finally
    qr.Free;
    tr.Free;
  end;
end;

procedure SetDocSortNum(DocId: Integer; SortNum: Integer);
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Update '+TableDoc+
          ' set sortnum='+iff(SortNum=-1,'null',inttostr(SortNum))+
          ' where doc_id='+inttostr(DocId);
    qr.SQL.Add(sqls);
    qr.ExecSql;
    tr.Commit;
  finally
    qr.Free;
    tr.Free;
  end;
end;

procedure SetDocSumm(DocId: Integer; Summ: Double);
var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;
begin
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Update '+TableDoc+
          ' set summ='+iff(Summ=-1.0,'null',ChangeChar(FloatToStr(Summ),',','.'))+
          ' where doc_id='+inttostr(DocId);
    qr.SQL.Add(sqls);
    qr.ExecSql;
    tr.Commit;
  finally
    qr.Free;
    tr.Free;
  end;
end;

procedure AddDopField(List: TList; var Plus: Integer;
                      Value,FieldName,ControlName: string; AutoFormat: Boolean=false;
                      Style: string='');
var
  Pfield: Pointer;
begin
  inc(Plus);
  New(PFieldQuote(Pfield));
  FillChar(PFieldQuote(Pfield)^,SizeOf(PFieldQuote(Pfield)^),0);
  PFieldQuote(Pfield).Result:=Value;
  PFieldQuote(Pfield).FieldName:=FieldName;
  PFieldQuote(Pfield).ID:=Plus;
  PFieldQuote(Pfield).AutoFormat:=AutoFormat;
  PFieldQuote(Pfield).Style:=Style;
  AddToWordObjectList(List,Pfield,wtFieldQuote,ControlName);
end;

function ParseListValue(List: TList; Value: string): string;
var
  tmps: string;
  i: Integer;
  P: PInfoWordType;
  PQuote: PFieldQuote;
  SPos: Integer;
  l,lcur: Integer;
  s1,s2,s3: string;
const
  lbr=ConstLeftBreak;
  rbr=ConstRightBreak;
begin
  Result:=Value;
  tmps:=Value;
  l:=Length(Value);
  for i:=0 to List.Count-1 do begin
    P:=List.Items[i];
    case P.WordType of
       wtFieldQuote: begin
         PQuote:=PFieldQuote(P.PField);
         while true do begin
           SPos:=Pos(AnsiUpperCase(lbr+PQuote.FieldName+rbr),AnsiUpperCase(tmps));
           if SPos=0 then break
           else begin
            s1:=Copy(tmps,0,SPos-1);
            s2:=PQuote.Result;
            lcur:=Length(PQuote.FieldName)+Length(lbr)+Length(rbr);
            s3:=Copy(tmps,SPos+lcur,L-lcur);
            tmps:=s1+s2+s3;
            L:=Length(tmps);
           end;           
         end;
       end;
    end;
  end;
  Result:=tmps;

end;

procedure AddDopFieldFromConst(List: TList; var Plus: Integer; isHelper: Boolean; RenovationId: Integer);
var
 qr: TIBQuery;
 sqls: string;
 tr: TIBTransaction;
 tmps: string;
begin
 tr:=TIBTransaction.Create(nil);
 qr:=TIBQuery.Create(nil);
 try
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableConst+
         ' where '+iff(RenovationId<>0,'renovation_id='+inttostr(RenovationId),'renovation_id is null')+
         ' order by priority';
   qr.sql.Add(sqls);
   qr.Active:=true;
   qr.First;
   while not qr.Eof do begin
     if not Ishelper then
      tmps:=qr.FieldByName('val').AsString
     else
      tmps:=qr.FieldByName('valplus').AsString;
      AddDopField(List,Plus,
                  ParseListValue(List,tmps),
                  qr.FieldByName('name').AsString,
                  qr.FieldByName('name').AsString,
                  Boolean(qr.FieldByName('autoformat').AsInteger),
                  qr.FieldByName('style').AsString);
     qr.Next;
   end;
  except
  end;
 finally
  qr.Free;
  tr.Free;
 end;
end;

function CharIsNumber(const C: AnsiChar): Boolean;
begin
  Result := ((AnsiCharTypes[C] and C1_DIGIT) <> 0) or
     (C in AnsiSigns) or (C = DecimalSeparator);
end;

function CharIsDigit(const C: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[C] and C1_DIGIT) <> 0;
end;

function CharIsControl(const C: AnsiChar): Boolean;
begin
  Result := (AnsiCharTypes[C] and C1_CNTRL) <> 0;
end;

function CharIsPrintable(const C: AnsiChar): Boolean;
begin
  Result := not CharIsControl(C);
end;

procedure LoadCharTypes;
var
  CurrChar: AnsiChar;
  CurrType: Word;
begin
  {$IFDEF MSWINDOWS}
  for CurrChar := Low(AnsiChar) to High(AnsiChar) do
  begin
    GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @CurrChar, SizeOf(AnsiChar), CurrType);
    AnsiCharTypes[CurrChar] := CurrType;
  end;
  {$ENDIF}
end;

function SelectDatabaseEx(var ADataBase: String; CheckCurrent: Boolean): Boolean;
var
  Form: TfmSelectDatabase;
  fi: TIniFile;
  i, Index: Integer;
begin
  Result:=false;
  Form:=TfmSelectDatabase.Create(nil);
  fi:=TIniFile.Create(GetIniFileName);
  try
    fi.ReadSectionValues('Databases',Form.Values);
    Index:=-1;
    for i:=0 to Form.Values.Count-1 do begin
      Form.cmbBases.Items.Add(Form.Values.Names[i]);
      if (Index=-1) and AnsiSameText(ADataBase,Form.Values.ValueFromIndex[i]) then begin
        Index:=i;
      end;
    end;
    if Index<>-1 then begin
      Form.cmbBases.ItemIndex:=Index;
      if CheckCurrent then
        Form.CurrentDataBase:=ADataBase;
      if Form.ShowModal=mrOk then begin
        if CheckCurrent then begin
          if Form.cmbBases.ItemIndex<>Index then begin
            ADataBase:=Form.Values.ValueFromIndex[Form.cmbBases.ItemIndex];
            Result:=true;
          end;
        end else begin
          ADataBase:=Form.Values.ValueFromIndex[Form.cmbBases.ItemIndex];
          Result:=true;
        end;
      end;
    end;
  finally
    fi.Free;
    Form.Free;
  end;
end;

function SelectDatabase(CheckCurrent: Boolean): Boolean;
begin
  Result:=SelectDatabaseEx(DataBaseName,CheckCurrent);
end;

function VarToIntDef(const V: Variant; const ADefault: Integer): Integer;
begin
  try
    if not VarIsNull(V) then
      Result:=V
    else
      Result:=ADefault;
  except
    Result:=ADefault;
  end;    
end;

function VarToExtendedDef(const V: Variant; const ADefault: Extended): Extended;
begin
  try
    if not VarIsNull(V) then
      Result:=V
    else
      Result:=ADefault;
  except
    Result:=ADefault
  end;
end;

function VarToDateDef(const V: Variant; const ADefault: TDateTime): TDateTime;
begin
  try
    if not VarIsNull(V) then
      Result:=VarToDateTime(V)
    else
      Result:=ADefault;
  except
    Result:=ADefault;
  end;
end;

procedure InvalidKey(S: String);
var
  Mess: String;
const
  SInvalid='������������� ������������� �����, ���������� � �������������.';
begin
  if Trim(S)='' then
    Mess:=SInvalid
  else
    Mess:=Format(SInvalid+' ������: %s',[S]);
  ShowError(Application.Handle,Mess);
end;

function GetVersion: String;
var
  dwLen: DWord;
  lpData: Pointer;
  v1,v2,v3,v4: Word;
  tmps: string;
  VerValue: PVSFixedFileInfo;
  dwHandle: DWord;
begin
  dwLen:=GetFileVersionInfoSize(Pchar(Application.ExeName),dwHandle);
  if dwlen<>0 then begin
   GetMem(lpData, dwLen);
   try
    if GetFileVersionInfo(Pchar(Application.ExeName),dwHandle,dwLen,lpData) then begin
      VerQueryValue(lpData, '\', Pointer(VerValue), dwLen);
      V1 := VerValue.dwFileVersionMS shr 16;
      V2 := VerValue.dwFileVersionMS and $FFFF;
      V3 := VerValue.dwFileVersionLS shr 16;
      V4 := VerValue.dwFileVersionLS and $FFFF;
      tmps:=inttostr(V1)+'.'+inttostr(V2)+'.'+inttostr(V3)+'.'+inttostr(V4);
      Result:=GetRenovationVersion(Format(fmtAboutVer,[tmps]));
    end;
   finally
     FreeMem(lpData, dwLen);
   end;
 end;
end;

procedure AddPageHeaders(Document: Variant);
var
  Text,Programm: String;
  SectionCount: Integer;
  Section: Variant;
  FooterCount: Integer;
  Footer: Variant;
begin
  Text:='';
  Programm:='';
  if LocalDb.ReadParam(SDb_ParamFooter,Text) and
     LocalDb.ReadParam(SDb_ParamProgramm,Programm) then begin
    if Trim(Text)<>'' then begin
      SectionCount:=Document.Sections.Count;
      if SectionCount>0 then begin
        Section:=Document.Sections.Item(1);
        FooterCount:=Section.Footers.Count;
        if FooterCount>0 then begin
          Footer:=Section.Footers.Item(1);
          Footer.Range.Text:=Format(Text,[Programm,GetVersion]);
          Footer.Range.Font.Size:=4;
          Footer.Range.ParagraphFormat.Alignment:=wdAlignParagraphCenter;
        end;
      end;
    end;
  end;
end;

function CheckDemo: Boolean;
var
 qr: TIBQuery;
 sqls: string;
 tr: TIBTransaction;
 Buffer: String;
 RecCount: Integer;
begin
  Result:=false;
  if LocalDb.ReadParam(SDb_ParamMaxReestrCount,Buffer) then begin
    RecCount:=StrToIntDef(Buffer,0);
    if RecCount>0 then begin
      tr:=TIBTransaction.Create(nil);
      qr:=TIBQuery.Create(nil);
      try
        try
          tr.AddDatabase(dm.IBDbase);
          dm.IBDbase.AddTransaction(tr);
          tr.Params.Text:=DefaultTransactionParamsTwo;
          qr.Database:=dm.IBDbase;
          qr.Transaction:=tr;
          qr.Transaction.Active:=true;
          sqls:='Select count(*) as ct from '+TableReestr;
          qr.sql.Add(sqls);
          qr.Open;
          if qr.Active then begin
            if (RecCount<qr.FieldByName('ct').AsInteger) then begin
              Result:=true;
            end;
          end;
        except
        end;
      finally
        qr.Free;
        tr.Free;
      end;
    end;
  end;
end;

procedure ClearStrings(Strings: TStrings);
var
  i: Integer;
  Obj: TObject;
begin
  if Assigned(Strings) then begin
    Strings.BeginUpdate;
    try
      for i:=0 to Strings.Count-1 do begin
        Obj:=Strings.Objects[i];
        if Assigned(Obj) then 
          FreeAndNil(Obj);
      end;
      Strings.Clear;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

initialization

  LoadCharTypes;

end.

