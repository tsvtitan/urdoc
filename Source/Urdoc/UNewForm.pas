unit UNewForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, UDm, ComCtrls, Menus, RxCalc,
  DsnUnit, DsnSelect, DsnProp, DsnSubDp, tsvGrids, DsnList, UNewControls,UUnited,
  DsnFunc, typinfo, IBQuery, IBTable, db, IBBlob, IBDatabase, mask, clipbrd,
  rxToolEdit, marquee, Variants, SeoDbConsts, ScriptEditFm,
  dws2Comp, dws2Exprs, dws2Errors;

type

  PInfoTypeReestr=^TInfoTypeReestr;
  TInfoTypeReestr=packed record
    typereestr_id: Integer;
    prefix: string;
    sufix: string;
  end;

  TInfoBlank=class(TObject)
  public
  var 
    blank_id: Integer;
    num_from: Variant;
    num_to: Variant;
  end;

  TfmNewForm = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pnTop: TPanel;
    grbDoplnit: TGroupBox;
    bibOtlogen: TBitBtn;
    sbHeader: TScrollBox;
    lbSumm: TLabel;
    lbCurReestr: TLabel;
    lbFio: TLabel;
    lbNumLic: TLabel;
    lbMotion: TLabel;
    lbSummPriv: TLabel;
    lbHereditaryDeal: TLabel;
    cbCurReestr: TComboBox;
    cbFio: TComboBox;
    chbOnSogl: TCheckBox;
    cbNumLic: TComboBox;
    cmbMotion: TComboBox;
    chbNoYear: TCheckBox;
    chbDefect: TCheckBox;
    edHereditaryDeal: TEdit;
    btHereditaryDeal: TButton;
    lbDocName: TLabel;
    edDocName: TEdit;
    lbCertificateDate: TLabel;
    dtpCertificateDate: TDateTimePicker;
    lbNumReestr: TLabel;
    edNumReestr: TEdit;
    btNextNumReestr: TButton;
    lbBlank: TLabel;
    cbBlank: TComboBox;
    edBlank: TEdit;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure miFromPropClick(Sender: TObject);
    procedure miPropCtrlClick(Sender: TObject);
    procedure selHotSpotChangeSelected(Sender: TObject;
      Targets: TSelectedComponents; Operation: TSelectOperation);
    procedure miCtrlCutClick(Sender: TObject);
    procedure miCtrlCopyClick(Sender: TObject);
    procedure miDelCtrlClick(Sender: TObject);
    procedure miBringToFrontClick(Sender: TObject);
    procedure miSendToBackClick(Sender: TObject);
    procedure miFormInsertClick(Sender: TObject);
    procedure miFormTabOrderClick(Sender: TObject);
    procedure miCtrlTabOrderClick(Sender: TObject);
    procedure miSelAllCtrlClick(Sender: TObject);
    procedure miInsertCtrlClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure miCtrlAlignClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edHereditaryDealKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btHereditaryDealClick(Sender: TObject);
    procedure cbFioExit(Sender: TObject);
    procedure btNextNumReestrClick(Sender: TObject);
    procedure edBlankKeyPress(Sender: TObject; var Key: Char);
    procedure cbBlankChange(Sender: TObject);

  private
    FScriptEditor: TScriptEditForm;
    pnMarquee: TPanel;
    pnReminder: TddgMarquee;
    FRealCmbName: string;
    prefix: string;
    sufix: string;
    isAreadyFillFio: Boolean;
    Creating: Boolean;
//    MainInsertPoint: TPoint;
    FViewType: TViewType;
    FGridSize: Byte;
    procedure SetViewType(Value: TViewType);
    procedure SetGridSize(Value: Byte);
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMWindowPosChanged(var Message: TWMWindowPosChanged); message WM_WINDOWPOSCHANGED;
    procedure FillCmbList(wc: TWinControl);
    procedure FillMenuCreate(mi: TMenuItem);
    procedure FillAllControls;
    function GetNewName(ct: TComponent): String;
    procedure RefreshFormInInspector;
    procedure FormActivate(Sender: TObject);
    procedure miNewTabClick(Sender: TObject);
    function fUpdate(msOutForm: TMemoryStream; List: TList; Words: TStringList): Boolean;
    function fAppend(msOutForm: TMemoryStream; List: TList; Words: TStringList): Boolean;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure SetInsertedValuesToAll(const Value: Variant; TypeInsertedValue: TTypeInsertedValue; ReplaceFlag: Boolean=true);
    procedure SetNewTextFromUniversal(Control: TControl; isLocate: Boolean; LocateValue: Variant; isFirst: Boolean=true);
    function GetParentTabSheet(wt: TWinControl): TTabSheet;
    function CheckPadeg(ct: TControl; TypeCase: TTypeCase): Boolean;
    function GetFieldNameFromTypeCase(TypeCase: TTypeCase): string;
    function GetPadegFromRBCase(ImenitText: String; TypeCase: TTypeCase): String;
    procedure miCtrlBuildClick(Sender: TObject);
    procedure miCtrlAddToRule(Sender: TObject);
    procedure miScriptClick(Sender: TObject);
    procedure cbFioDropDown(Sender: TObject);
    function GetWhoCertificateId(var whocertificate: string): Integer;
    function GetRealCmbName(ct: TControl): string;
    procedure SetHereditaryByNotarialAction(isClear: Boolean);
    procedure ClearHereditaryDeal;
    procedure SetScript(const Value: TStrings);
    procedure FormInstanceInstantiate(AInstance: Tdws2CustomInstance; var ExtObject: TObject);
    procedure AInstanceInstantiate(AInstance: Tdws2CustomInstance; var ExtObject: TObject);
    procedure FuncCopyEval(Info: TProgramInfo);
    procedure FuncPosEval(Info: TProgramInfo);
    procedure FuncTrimEval(Info: TProgramInfo);
    procedure FuncLengthEval(Info: TProgramInfo);
    procedure FuncShowInfoEval(Info: TProgramInfo);
    procedure FuncConstValue(Info: TProgramInfo);
    procedure FuncTranslateDate(Info: TProgramInfo);
    procedure FuncStrToDateDef(Info: TProgramInfo);
    procedure ScriptEditorChangeScript(Sender: TObject);
    procedure ScriptEditorCompileScript(Sender: TObject; Text: String; var Line,Tab: Integer; var Error: String);
    procedure ProgramExecute(var Line,Tab: Integer; var Error: String; OnlyCompile: Boolean=false; Text: String=''; List: TList=nil);
  public
    FScript: TStrings;
    OldHereditaryDealId: Integer;
    OldHereditaryDealNum: string;
    OldHereditaryDealDate: TDate;
    ViewDoc: Boolean;
    KeepFileName: String;
    isKeepDoc: Boolean;
    ChangeFlagNewForm: Boolean;
    isChangeOnKeyDown: Boolean;
    isCreateReestr: Boolean;
    pnDesign: TDsnStage;
    selHotSpot: TDsnSelect;
    Sel: TDsnSelect;
    reg: TDsnDPRegister;
    isInit: Boolean;
    SummEdit: TRxCalcEdit;
    SummEditPriv: TRxCalcEdit;
    DefLastTypeReestrID: Integer;
    LastTypeReestrID: Integer;
    LastDocId: Integer;
    LastReestrID: Integer;
    RenovationId: Integer;
    IsOtlogen: Boolean;
    isInsert: Boolean;
    IsAlready: Boolean;
    constructor Create(AOwner: TComponent);override;
    destructor Destroy; override;
    procedure WndProc(var Message: TMessage); override;
    procedure Paint; override;
    procedure pnDesignPopUpMenu(Sender: TObject);
    procedure ViewInspector(Ctrl: TControl);
    procedure InitAll;
    procedure ControlMenuOnPopup(Sender: TObject);
    procedure DeleteInInspector;
    Procedure DeleteInInspectorAll;
    procedure AddToObjectInspector(ct: TControl; IgnoreTarget: Boolean);
    procedure regSelectQuery(Sender:TObject;Component:TComponent;
                           var CanSelect:TSelectAccept);
    procedure SelChangeSelected(Sender: TObject; Targets: TSelectedComponents;
                    Operation: TSelectOperation);
    procedure pnDesignControlCreate (Sender:TObject;Component:TComponent);
    procedure pnDesignMove(Sender:TObject;Component:TComponent; var CanMove:Boolean);
    procedure DeleteInInspectorNew(Targets: TSelectedComponents);
    procedure pnDesignDeleteQuery(Sender:TObject;Component:TComponent;var CanDelete:Boolean);
    procedure NewFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NewFormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DeleteInInspectorControl(ct: TControl);
    procedure miCreateClick(Sender: TObject);
    procedure SelectAllControls;
    procedure InitSmall;
    procedure GetParamListByConsts(List: TList; UseInScript: Boolean);
    procedure GetParamListByControls(List: TList);
    procedure SetCurrentDateTime;
    procedure SaveControls(msIn: TMemoryStream);
    procedure LoadControls(msIn: TMemoryStream);
    procedure LocateFirstFocusedControl;
    procedure AlignLeft;
    procedure AlignRight;
    procedure AlignTop;
    procedure AlignBottom;
    procedure AlignHCenter;
    procedure AlignVCenter;
    procedure AlignWinHCenter;
    procedure AlignWinVCenter;
    procedure AlignHSpace;
    procedure AlignVSpace;
    procedure FillAllNeedFieldForAppend;
    procedure FillAllNeedFieldForUpdate(NewNumReestr: Integer;
               newTypeReestrID: Integer; newFio: String; newSumm: Extended;
               newReestrID,newLicenseID: Integer;
               newBlankId, newBlankNum: Variant);
    procedure ClearAllNeedField;
    procedure FillNumLicenseCombo(LicenseID: Integer);
    procedure edNumReestrKeyPress(Sender: TObject; var Key: Char);
    procedure cbFioKeyPress(Sender: TObject; var Key: Char);

    procedure edNumReestrChange(Sender: TObject);
    procedure cbNumLicChange(Sender: TObject);
    procedure ClearTypeReestrCombo;
    procedure FillTypeReestrComboAndSetIndex(TypeReestrID: Integer);
    procedure cbCurReestrChange(Sender: TObject);
    procedure FillFioCombo;
    procedure ClearBlanks;
    procedure FillBlanks;
    function FindBlank(BlankId: Integer; var Index: Integer): TInfoBlank;
    procedure SetBlank(BlankId: Variant);
    function GetBlankId: Variant;
    function GetBlankNum: Variant;
    function GetBlankSeries: Variant;

    procedure bibOkClickTest(Sender: TObject);
    procedure bibCancelClickTest(Sender: TObject);
    procedure bibOtlogenClickTest(Sender: TObject);

    procedure bibOkClickUpdate(Sender: TObject);
    procedure bibCancelClickUpdate(Sender: TObject);
    procedure bibOtlogenClickUpdate(Sender: TObject);

    procedure bibCancelClickAppend(Sender: TObject);
    procedure bibOkClickAppend(Sender: TObject);
    procedure bibOtlogenClickAppend(Sender: TObject);

    function AppendToReestr: Boolean;
    function UpdateReestr: Boolean;
    function isEmptySelfControls(wt: TWinControl; var  BreakF: Boolean): Boolean;
    procedure EnableOnControl(wt: TWinControl; isEnabled: Boolean);
    function IsReestrIDFound: Boolean;
    function SetEmptyPadegControls(Value: TControl): Boolean;
    procedure SetOnExitForImenitControl;
    procedure ControlPagedOnExit(Sender: TObject);
    procedure PrepeareControlsBeforeSave(wt: TWincontrol);
    procedure PrepeareControlsAfterLoad(wt: TWincontrol);
    procedure OnShowTest(Sender: TObject);
    procedure LocateLastControl(wtnew: TWinControl);
//    procedure IncludeComponentsStateForAll(Flag: Boolean; State: TComponentState);
    procedure RecurseRemoveInInspector(wt: TWinControl);
    procedure DestroyHeaderAndCreateNew;
    procedure FillNotarialActions(isUseForUpdate: Boolean);
    procedure cmbMotionChange(Sender: TObject);
    procedure SummEditChange(Sender: TObject);
    procedure SetTextToControl(ct: TControl; const Value: Variant);
    procedure ReFill(Sender: TObject);
    procedure UpFill(Sender: TObject);
    procedure AddPeople;
    procedure ChangePeople;
    procedure GetListImenitControls(wt: TWinControl; List: TList);
    procedure SetFirstTabSheet;
    procedure CreateSmall;
    procedure SaveControlsToClipBoardAsText;
    procedure LoadControlsFromClipBoardAsText;
    procedure ViewFieldsInDocumentByControl(Control: TControl);
    procedure ViewHintByControl(Control: TControl);
    procedure CancelHint;
    procedure FillReminders;
    procedure SetDefaultNotarius(const AsInsert: Boolean);


    property ViewType: TViewType read FViewType write SetViewType;
    property ScriptEditor: TScriptEditForm read FScriptEditor; 

//    property FormStyle: TFormStyle read FFormStyle;
   published
    property GridSize: Byte read FGridSize write SetGridSize;
    property Script: TStrings read FScript write SetScript;
  end;

  TNewForm=class(TfmNewForm)
  end;

var
  fmNewForm: TfmNewForm;

implementation


uses StrUtils,
     UMain, UDocTree, UObjInsp, UTabOrder, UCreateCtrl, UAlignPalette,
   UDocReestr, UEditCase, URBHereditaryDeal, URBSubs, URBSubsValue,
  URBPeople, tsvInterbase, yupack, antAngleLabel, URBRuleForElement;

{var
  pmMainNew: TPopUpMenu;}

{$R *.DFM}

constructor TfmNewForm.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FScript:=TStringList.Create;
   FScriptEditor:=TScriptEditForm.Create(nil);
   FScriptEditor.Script:=TStringList(FScript);
   FScriptEditor.OnChangeScript:=ScriptEditorChangeScript;
   FScriptEditor.OnCompileScript:=ScriptEditorCompileScript;

   ListReestrForms.Add(Self);

   WindowState:=wsMaximized;
   ViewDoc:=true;
   IsAlready:=false;
   OnKeyDown:=NewFormKeyDown;
   FViewType:=vtView;
   FGridSize:=8;
   ChangeFlagNewForm:=false;
   fmMain.pmCtrlEdit.OnPopup:=ControlMenuOnPopup;
   CreateSmall;
end;


destructor TfmNewForm.Destroy;
begin
  if Assigned(FScriptEditor) then
    FScriptEditor.Free;
  FScript.Free;
  ListReestrForms.Remove(Self);
  inherited Destroy;
end;

procedure TfmNewForm.ScriptEditorChangeScript(Sender: TObject);
begin
  ChangeFlagNewForm:=true;
end;

procedure TfmNewForm.ScriptEditorCompileScript(Sender: TObject; Text: String; var Line,Tab: Integer; var Error: String);
var
  List: TList;
begin
  List:=TList.Create;
  try
    GetParamListByConsts(List,true);
    ProgramExecute(Line,Tab,Error,false,Text,List);
  finally
    ClearWordObjectList(List);
    List.Free;
  end;
end;

procedure TfmNewForm.FormInstanceInstantiate(AInstance: Tdws2CustomInstance; var ExtObject: TObject);
begin
  ExtObject:=Self;
end;

procedure TfmNewForm.AInstanceInstantiate(AInstance: Tdws2CustomInstance; var ExtObject: TObject);
begin
  ExtObject:=Self.FindComponent(AInstance.Name);
end;

procedure TfmNewForm.FuncCopyEval(Info: TProgramInfo);
var
  S: String;
  Index: Integer;
  Count: Integer;
begin
  S:=VarToStrDef(Info.Value['S'],'');
  Index:=VarToIntDef(Info.Value['Index'],0);
  Count:=VarToIntDef(Info.Value['Count'],0);
  Info.Result:=Copy(S,Index,Count);
end;

procedure TfmNewForm.FuncPosEval(Info: TProgramInfo);
var
  Substr: String;
  S: String;
begin
  Substr:=VarToStrDef(Info.Value['Substr'],'');
  S:=VarToStrDef(Info.Value['S'],'');
  Info.Result:=AnsiPos(Substr,S);
end;

procedure TfmNewForm.FuncTrimEval(Info: TProgramInfo);
var
  S: String;
begin
  S:=VarToStrDef(Info.Value['S'],'');
  Info.Result:=Trim(S);
end;

procedure TfmNewForm.FuncLengthEval(Info: TProgramInfo);
var
  S: String;
begin
  S:=VarToStrDef(Info.Value['S'],'');
  Info.Result:=Length(S);
end;

procedure TfmNewForm.FuncConstValue(Info: TProgramInfo);
var
  S: String;
  i: Integer;
  List: TList;
  P: PInfoWordType;
  P1: PFieldQuote;
  Ret: String;
begin
  S:=VarToStrDef(Info.Value['Name'],'');
  if Assigned(Info.Caller) and Assigned(Info.Caller.UserDef) and
     (Info.Caller.UserDef is TList) then begin
    Ret:='';
    List:=TList(Info.Caller.UserDef);
    for i:=0 to List.Count-1 do begin
      P:=PInfoWordType(List.Items[i]);
      if Assigned(P) then begin
        case P.WordType of
          wtFieldQuote: begin
            P1:=PFieldQuote(P.PField);
            if AnsiSameText(P1.FieldName,S) then begin
              Ret:=P1.Result;
              break;
            end;
          end;
        end;
      end;
    end;
    Info.Result:=Ret;
  end;
end;

procedure TfmNewForm.FuncShowInfoEval(Info: TProgramInfo);
var
  Message: String;
begin
  Message:=VarToStrDef(Info.Value['Message'],'');
  ShowInfo(Message);
end;

procedure TfmNewForm.FuncTranslateDate(Info: TProgramInfo);
var
  TranslateType: Integer;
  Value: Extended;
  TypeTranslate: TTypeTranslate;
begin
  Value:=VarToExtendedDef(Info.Value['Value'],0.0);
  TranslateType:=VarToIntDef(Info.Value['TranslateType'],0);
  TypeTranslate:=ttDate;
  case TranslateType of
    0: TypeTranslate:=ttDate;
    1: TypeTranslate:=ttDateRodit;
    2: TypeTranslate:=ttDateMonth;
    3: TypeTranslate:=ttDateRoditMonth;
  end;
  Info.Result:=QuantityText(Value,TypeTranslate);
end;

procedure TfmNewForm.FuncStrToDateDef(Info: TProgramInfo);
var
  S: String;
  Default: TDateTime;
begin
  S:=VarToStrDef(Info.Value['S'],'');
  Default:=VarToDateDef(Info.Value['Default'],0.0);
  Info.Result:=StrToDateDef(S,Default);
end;

procedure TfmNewForm.ProgramExecute(var Line,Tab: Integer; var Error: String; OnlyCompile: Boolean=false; Text: String=''; List: TList=nil);
var
  AProgram: TDelphiWebScriptII;
  AUnit: Tdws2Unit;
  AProg: TProgram;

  procedure ProgramError;
  begin
    if AProg.Msgs.HasErrors or {AProg.Msgs.HasCompilerErrors or }AProg.Msgs.HasExecutionErrors then begin
      Error:=Self.Caption+#13#10+AProg.Msgs.AsInfo;
      if AProg.Msgs.Msgs[0] is TScriptMsg then begin
        Line:=TScriptMsg(AProg.Msgs.Msgs[0]).Pos.Line;
        Tab:=TScriptMsg(AProg.Msgs.Msgs[0]).Pos.Col;
      end;
    end;
  end;

  procedure RegisterComponents(AParent: TWinControl);

    function InListClasses(Component: TComponent): Boolean;
    var
      i: Integer;
      P: PInfoClass;
    begin
      for i:=0 to ListClasses.Count-1 do begin
        P:=PInfoClass(ListClasses.Items[i]);
        if P.TypeClass=Component.ClassType then begin
          Result:=true;
          exit;
        end;
      end;

      for i:=0 to ListClassesForWord.Count-1 do begin
        P:=PInfoClass(ListClassesForWord.Items[i]);
        if P.TypeClass=Component.ClassType then begin
          Result:=true;
          exit;
        end;
      end;

      Result:=Component.ClassType=TTabSheet;
    end;

  var
    i: Integer;
    Control: TControl;
    AInstance: Tdws2Instance;
  begin
    if Assigned(AParent) then
      for i := 0 to AParent.ControlCount - 1 do begin
        Control:=AParent.Controls[i];
        if InListClasses(Control) and
           (Trim(Control.Name)<>'') then begin
          RegisterClass(TPersistentClass(Control.ClassType));
          AInstance:=Tdws2Instance(AUnit.Instances.Add);
          AInstance.Name:=Control.Name;
          AInstance.DataType:=Control.ClassName;
          AInstance.OnInstantiate:=AInstanceInstantiate;
          AInstance.AutoDestroyExternalObject:=false;
          if Control is TWinControl then
            RegisterComponents(TWinControl(Control));
        end;
      end;
  end;

  procedure RegisterClassProperties;
  begin
    AUnit.ExposeClassToUnit(TComponent,TObject,nil,'');
    AUnit.ExposeClassToUnit(TControl,TComponent,nil,'');
    AUnit.ExposeClassToUnit(TWinControl,TControl,nil,'');
    AUnit.ExposeClassToUnit(TGraphicControl,TControl,nil,'');

    AUnit.ExposeClassToUnit(TLabel,TGraphicControl,nil,'');
    AUnit.ExposeClassToUnit(TEdit,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TComboBox,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TMemo,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TCheckBox,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TRadioButton,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TListBox,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TGroupBox,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TRadioGroup,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TPanel,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TSpeedButton,TGraphicControl,nil,'');
    AUnit.ExposeClassToUnit(TMaskEdit,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TImage,TGraphicControl,nil,'');
    AUnit.ExposeClassToUnit(TShape,TGraphicControl,nil,'');
    AUnit.ExposeClassToUnit(TBevel,TGraphicControl,nil,'');
    AUnit.ExposeClassToUnit(TScrollBox,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TSplitter,TGraphicControl,nil,'');
    AUnit.ExposeClassToUnit(TRichEdit,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TTrackBar,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TAnimate,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TDateTimePicker,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TPageControl,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TTabSheet,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TRxCalcEdit,TWinControl,nil,'');
    AUnit.ExposeClassToUnit(TDateEdit,TWinControl,nil,'');

    AUnit.ExposeClassToUnit(TNewLabel,TLabel,nil,'');
    AUnit.ExposeClassToUnit(TNewEdit,TEdit,nil,'');
    AUnit.ExposeClassToUnit(TNewComboBox,TComboBox,nil,'');
    AUnit.ExposeClassToUnit(TNewMemo,TMemo,nil,'');
    AUnit.ExposeClassToUnit(TNewCheckBox,TCheckBox,nil,'');
    AUnit.ExposeClassToUnit(TNewRadioButton,TRadioButton,nil,'');
    AUnit.ExposeClassToUnit(TNewListBox,TListBox,nil,'');
    AUnit.ExposeClassToUnit(TNewRadioGroup,TRadioGroup,nil,'');
    AUnit.ExposeClassToUnit(TNewMaskEdit,TMaskEdit,nil,'');
    AUnit.ExposeClassToUnit(TNewRichEdit,TRichEdit,nil,'');
    AUnit.ExposeClassToUnit(TNewDateTimePicker,TDateTimePicker,nil,'');
    AUnit.ExposeClassToUnit(TNewRxCalcEdit,TRxCalcEdit,nil,'');
    AUnit.ExposeClassToUnit(TNewComboBoxMarkCar,TComboBox,nil,'');
    AUnit.ExposeClassToUnit(TNewComboBoxColor,TComboBox,nil,'');
    AUnit.ExposeClassToUnit(TNewRxDateEdit,TDateEdit,nil,'');

    AUnit.ExposeClassToUnit(TNewForm,TWinControl,nil,'');
  end;

  procedure RegisterTypes;
  begin

  end;
  
  procedure RegisterFunctions;

    function AddFunc(AName, AResultType: String; OnEval: TFuncEvalEvent): Tdws2Function;
    begin
      Result:=Tdws2Function(AUnit.Functions.Add);
      Result.Name:=AName;
      Result.ResultType:=AResultType;
      Result.OnEval:=OnEval;
    end;

    function AddFuncParam(Func: Tdws2Function; AName, ADataType: String; ADefault: Variant): Tdws2Parameter;
    begin
      Result:=Tdws2Parameter(Func.Parameters.Add);
      Result.Name:=AName;
      Result.DataType:=ADataType;
      Result.DefaultValue:=ADefault;
    end;

  var
    Func: Tdws2Function;
  begin
    Func:=AddFunc('Copy','String',FuncCopyEval);
    AddFuncParam(Func,'S','String','');
    AddFuncParam(Func,'Index','Integer',0);
    AddFuncParam(Func,'Count','Integer',0);

    Func:=AddFunc('Pos','Integer',FuncPosEval);
    AddFuncParam(Func,'Substr','String','');
    AddFuncParam(Func,'S','String','');

    Func:=AddFunc('Trim','String',FuncTrimEval);
    AddFuncParam(Func,'S','String','');

    Func:=AddFunc('Length','Integer',FuncLengthEval);
    AddFuncParam(Func,'S','String','');

    Func:=AddFunc('ShowInfo','',FuncShowInfoEval);
    AddFuncParam(Func,'Message','String','');

    Func:=AddFunc('ConstValue','String',FuncConstValue);
    AddFuncParam(Func,'Name','String','');

    Func:=AddFunc('TranslateDate','String',FuncTranslateDate);
    AddFuncParam(Func,'Value','DateTime',0.0);
    AddFuncParam(Func,'TranslateType','Integer',0);

    Func:=AddFunc('StrToDateDef','DateTime',FuncStrToDateDef);
    AddFuncParam(Func,'S','String','');
    AddFuncParam(Func,'Default','DateTime',0.0);
  end;

var
  FormInstance: Tdws2Instance;
begin
  try
    AProgram:=TDelphiWebScriptII.Create(nil);
    AUnit:=Tdws2Unit.Create(nil);
    try
      AUnit.UnitName:='SelfUnit';
      AUnit.Script:=AProgram;
      RegisterClassProperties;

      FormInstance:=Tdws2Instance(AUnit.Instances.Add);
      FormInstance.Name:=SForm;
      FormInstance.DataType:=TNewForm.ClassName;
      FormInstance.OnInstantiate:=FormInstanceInstantiate;
      FormInstance.AutoDestroyExternalObject:=false;

      RegisterTypes;
      RegisterFunctions;
      RegisterComponents(pnDesign);

      AProg:=AProgram.Compile(Text);
      AProg.UserDef:=List;
      ProgramError;

      if not OnlyCompile then begin
        try
          AProg.Execute;
        finally
          ProgramError;
        end;
      end;

    finally
      AProg.Free;
      AUnit.Free;
      AProgram.Free;
    end;
  except
  end;
end;

procedure TfmNewForm.CreateSmall;
begin
   pnDesign:=TDsnStage(FindComponent('pnDesign'));
   if not Assigned(pnDesign) then begin
     pnDesign:=TDsnStage.Create(Self);
     pnDesign.Parent:=Self;
     pnDesign.Align:=alClient;
     pnDesign.BevelOuter:=bvNone;
     pnDesign.Name:='pnDesign';
     pnDesign.Caption:='';
     pnDesign.SelfProps.Add('Test');
   end;
   reg:=TDsnDpRegister(FindComponent('reg'));
   if not Assigned(reg) then begin
     reg:=TDsnDpRegister.Create(Self);
     reg.Name:='reg';
     reg.DsnStage:=pnDesign;
     reg.ControlMenu:=fmMain.pmCtrlEdit;
     reg.FormMenu:=fmMain.pmCtrlEdit;
   end;
   Sel:=TDsnSelect(FindComponent('Sel'));
   if not Assigned(Sel) then begin
    Sel:=TDsnSelect.Create(self);
    sel.Name:='sel';
    sel.DsnRegister:=reg;
   end;
   Creating:=true;
   SummEdit:=TRxCalcEdit(FindComponent('SummEdit'));
   if not Assigned(SummEdit) then begin
     SummEdit:=TRxCalcEdit.Create(Self);
     SummEdit.parent:=grbDoplnit;
     SummEdit.Name:='SummEdit';
   end;
   SummEditPriv:=TRxCalcEdit(FindComponent('SummEditPriv'));
   if not Assigned(SummEditPriv) then begin
     SummEditPriv:=TRxCalcEdit.Create(Self);
     SummEditPriv.parent:=grbDoplnit;
     SummEditPriv.Name:='SummEditPriv';
   end;  

end;

procedure TfmNewForm.InitSmall;
begin
   isViewObjectIns:=false;
   LastActive:=Self;
   OnKeyDown:=NewFormKeyDown;
   OnKeyUp:=NewFormKeyUp;
   OnActivate:=FormActivate;
   OnShow:=FormShow;
   pnDesign:=TDsnStage(FindComponent('pnDesign'));
   if pnDesign=nil then exit;
   pnDesign.TabOrder:=9900;
   pnDesign.OnSelectQuery:=regSelectQuery;
   pnDesign.OnControlCreate:=pnDesignControlCreate;
   pnDesign.OnMoveQuery:=pnDesignMove;
   pnDesign.OnDeleteQuery:=pnDesignDeleteQuery;
   pnDesign.ParentColor:=true;
   pnDesign.ParentFont:=true;
   pnDesign.Rubberband.MoveWidth:=FGridSize;
   pnDesign.Rubberband.MoveHeight:=FGridSize;
   reg:=TDsnDpRegister(FindComponent('reg'));
   if reg=nil then exit;

   Sel:=TDsnSelect(FindComponent('Sel'));
   if sel=nil then exit;
   Sel.OnChangeSelected:=SelChangeSelected;

   pnBottom.TabOrder:=9999;

   fmMain.pmCtrlEdit.OnPopup:=ControlMenuOnPopup;
   fmMain.miBringToFront.OnClick:=miBringToFrontClick;
   fmMain.miSendToBack.OnClick:=miSendToBackClick;
   fmMain.miSelAllCtrl.OnClick:=miSelAllCtrlClick;
   fmMain.miInsertCtrl.OnClick:=miInsertCtrlClick;
   fmMain.miPropCtrl.OnClick:=miPropCtrlClick;
   fmMain.miCtrlCreate.OnClick:=miCreateClick;
   fmMain.miCtrlAlign.OnClick:=miCtrlAlignClick;
   fmMain.miDelCtrl.OnClick:=miDelCtrlClick;
   fmMain.miCtrlCut.OnClick:=miCtrlCutClick;
   fmMain.miCtrlCopy.OnClick:=miCtrlCopyClick;
   fmMain.miInsertCtrl.OnClick:=miInsertCtrlClick;
   fmMain.miNewTab.OnClick:=miNewTabClick;
   fmMain.miCtrlTabOrder.OnClick:=miCtrlTabOrderClick;
   fmMain.miCtrlBuild.OnClick:=miCtrlBuildClick;
   fmMain.miCtrlAddToRule.OnClick:=miCtrlAddToRule;
   fmMain.miScript.OnClick:=miScriptClick;

   LocateFirstFocusedControl;

   SetOnExitForImenitControl;

end;

procedure TfmNewForm.InitAll;
begin
   isInit:=true;
   InitSmall;
   FillAllControls;
   FillMenuCreate(fmMain.miCtrlCreate);
   SetGridSize(FormGridSize);
   SetCurrentDateTime;
   Creating:=false;
   ChangeFlagNewForm:=false;
   isInit:=false;
end;

procedure TfmNewForm.SetDefaultNotarius(const AsInsert: Boolean);
var
  T: TInfoNotarius;
  IHI: TInfoHelperItem;
begin
  IHI:=TInfoHelperItem(fmMain.cmbHelper.Items.Objects[fmMain.cmbHelper.ItemIndex]);
  FillChar(T,SizeOf(T),0);
  GetInfoNotariusEx(IHI.NotId,@T,RenovationId,false,false,false);
  if AsInsert then
    SetInsertedValuesToAll(GetTownDefault(T.isHelper<>0,RenovationId),tivFromConstTownDefault);
end;

procedure TfmNewForm.SetCurrentDateTime;
var
  CurrentDateTime: TDateTime;
type
  TTypeDateTimeRule=(tdtrNone,tdtrDateEndDover);

  function GetTypeDateTimeRule(dtp: TDateTimePicker): TTypeDateTimeRule;
  var
   newdtp: TNewDateTimePicker;
  begin
    result:=tdtrNone;
    if not (dtp is TNewDateTimePicker) then exit;
    newdtp:=TNewDateTimePicker(dtp);
    if AnsiUpperCase(newdtp.DocFieldName)=AnsiUpperCase(WordFieldDateEndDeistviyDover) then begin
      Result:=tdtrDateEndDover;
      exit;
    end;
  end;

  procedure SetDateEndDover(ct: TControl);
  var
    newdtp: TNewDateTimePicker;
    Year,Month,Day: Word;
    Check: Boolean;
  begin
    if not (ct is TNewDateTimePicker) then exit;
    newdtp:=TNewDateTimePicker(ct);
    DecodeDate(WorkDate,Year,Month,Day);
    Check:=newdtp.Checked;
    newdtp.Date:=EncodeDate(Year+3,Month,Day)+DayDoverOffset;
    newdtp.Checked:=Check;
    newdtp.Checked:=Check;
  end;

  function GetTypeDateTimeRuleEx(de: TDateEdit): TTypeDateTimeRule;
  var
   newde: TNewRxDateEdit;
  begin
    result:=tdtrNone;
    if not (de is TNewRxDateEdit) then exit;
    newde:=TNewRxDateEdit(de);
    if AnsiUpperCase(newde.DocFieldName)=AnsiUpperCase(WordFieldDateEndDeistviyDover) then begin
      Result:=tdtrDateEndDover;
      exit;
    end;
  end;

  procedure SetDateEndDoverEx(ct: TControl);
  var
    newde: TNewRxDateEdit;
    Year,Month,Day: Word;
  begin
    if not (ct is TNewRxDateEdit) then exit;
    newde:=TNewRxDateEdit(ct);
    DecodeDate(WorkDate,Year,Month,Day);
    newde.Date:=EncodeDate(Year+3,Month,Day)-1;
  end;

var
  i: Integer;
  ct: TControl;
  tdtr: TTypeDateTimeRule;
  Check: Boolean;
begin
  CurrentDateTime:=GetDateTimeFromServer;
  for i:=0 to ComponentCount-1 do begin
    if Components[i] is TControl then begin
      ct:=TControl(Components[i]);
      if ct is TDateTimePicker then begin
        tdtr:=GetTypeDateTimeRule(TDateTimePicker(ct));
        case tdtr of
          tdtrNone: begin
            Check:=TDateTimePicker(ct).Checked;
            TDateTimePicker(ct).Date:=WorkDate;
            TDateTimePicker(ct).Time:=CurrentDateTime;
            if ct is TNewDateTimePicker then begin
              TNewDateTimePicker(ct).ActiveTimer:=true;
            end;
            TDateTimePicker(ct).Checked:=Check;
            TDateTimePicker(ct).Checked:=Check;
          end;
          tdtrDateEndDover: SetDateEndDover(ct);
        end;
      end;
      if ct is TDateEdit then begin
        tdtr:=GetTypeDateTimeRuleEx(TDateEdit(ct));
        case tdtr of
          tdtrNone: begin
            if ct is TNewRxDateEdit then begin
              if TNewRxDateEdit(ct).DefaultWorkDate then begin
                TNewRxDateEdit(ct).Date:=WorkDate;
              end else begin
                TNewRxDateEdit(ct).Date:=0;
              end;  
            end else begin
              TDateEdit(ct).Date:=WorkDate;
            end;  
          end;
          tdtrDateEndDover: SetDateEndDoverEx(ct);
        end;
      end;
    end;
  end;
end;

procedure TfmNewForm.SetViewType(Value: TViewType);
var
 List: TList;
 i: Integer;
 ct: TControl;
begin
 List:=TList.Create;
 GetControlByPropValue(Self,'Checked',false,List);
 try
  if Value=FViewType then exit;
  FViewType:=Value;
  case FViewType of
    vtView: begin
      EnableOnControl(pnBottom,true);
      EnableOnControl(grbDoplnit,true);
    end;
    vtEdit: begin
      EnableOnControl(pnBottom,false);
      EnableOnControl(grbDoplnit,false);
    end;
  end;
  InitSmall;
   case FViewType of
    vtView: begin
      reg.Designing:=false;
      pnDesign.UpdateControl;
      EnableOnControl(pnBottom,true);
      EnableOnControl(grbDoplnit,true);
//      IncludeComponentsStateForAll(false,[csLoading]);
    end;
    vtEdit: begin
      reg.Designing:=true;
      pnDesign.UpdateControl;
      EnableOnControl(pnBottom,false);
      EnableOnControl(grbDoplnit,false);
//      IncludeComponentsStateForAll(true,[csLoading]);
    end;
   end;
 finally
   for i:=0 to List.Count-1 do begin
     ct:=List.Items[i];
     if ct is TDateTimePicker then begin
       TDateTimePicker(ct).Checked:=false;
     end;
   end;
   List.Free;
 end;  
end;

procedure TfmNewForm.WMSize(var Message: TWMSize);
begin
 inherited;
end;

procedure TfmNewForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  mr: TModalResult;
  N1,N2: TNotifyEvent;
begin
  case FViewType of
     vtEdit: begin
      if ChangeFlagNewForm then begin
//       SetFirstTabSheet;
       mr:=MessageDlg('��������� ��������� � ����� <'+Caption+'> ?',mtConfirmation,[mbYes,mbNo,mbCancel],-1);
{       but:=MessageBox(Application.Handle,pchar('��������� ��������� � ����� <'+Caption+'> ?'),
                      '������',MB_ICONQUESTION+MB_YESNO);}
       case mr of
         mrYes: begin
         {  ctTemp:=TWinControl(FindComponent('NewMemo1'));
           if ctTemp<>nil then begin
             if not ctTemp.HandleAllocated then
               ctTemp.HandleNeeded;
           end;}
           ClearAllNeedField;
           DeleteInInspectorAll;
           SaveNewForm(Self);
           RemoveLinksForm_ListItem(Self);
           CanClose:=true;
           exit;
         end;
         mrNo: begin
           DeleteInInspectorAll;
           RemoveLinksForm_ListItem(Self);
           CanClose:=true;
           exit;
         end;
         mrCancel: begin
           CanClose:=false;
           exit;
         end;
       end;
      end else begin
       DeleteInInspectorAll;
       RemoveLinksForm_ListItem(Self);
       CanClose:=true;
       exit;
      end;
     end;
     vtView: begin
       N1:=bibOkClickAppend;
       N2:=bibOkClickUpdate;
       if (@bibOk.OnClick=@N1)or(@bibOk.OnClick=@N2) then begin
         if not IsAlready then begin
//           mr:=MessageDlg('�������� <'+GetDocName(LastDocId)+'> �� ����� ��������. ����������?',mtWarning,[mbYes,mbNo],-1);
           mr:=MessageDlg('��������� ��������� � ��������� <'+GetDocName(LastDocId)+'>?',mtConfirmation,[mbYes,mbNo,mbCancel],-1);
           case mr of
             mrYes: begin
               bibOk.OnClick(nil);
               CanClose:=false;
               exit;
             end;
             mrNo: begin
               DeleteInInspectorAll;
               RemoveLinksForm_ListItem(Self);
               CanClose:=true;
               exit;
             end;
             mrCancel: begin
               CanClose:=false;
               exit;
             end;
           end;
         end else begin
           DeleteInInspectorAll;
           RemoveLinksForm_ListItem(Self);
           CanClose:=true;
           exit;
         end;
       end else begin
         DeleteInInspectorAll;
         RemoveLinksForm_ListItem(Self);
         CanClose:=true;
         exit;
       end;
     end;
  end;
end;

procedure TfmNewForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfmNewForm.FormDestroy(Sender: TObject);
begin
  CancelHint;
  ClearTypeReestrCombo;
  ClearBlanks;
end;

procedure TfmNewForm.selHotSpotChangeSelected(Sender: TObject;
  Targets: TSelectedComponents; Operation: TSelectOperation);
begin
// Showmessage(Sender.ClassName);
end;

procedure TfmNewForm.pnDesignPopUpMenu(Sender: TObject);
begin
end;

procedure TfmNewForm.miCtrlCutClick(Sender: TObject);
begin
   DeleteInInspector;
   pnDesign.Cut;
end;

procedure TfmNewForm.miCtrlCopyClick(Sender: TObject);
begin
  if pnDesign.CanCopy then
   pnDesign.Copy;
end;

procedure TfmNewForm.miDelCtrlClick(Sender: TObject);
begin
  DeleteInInspector;
  if reg.DsnStage<>nil then
   pnDesign.Delete;

end;

procedure TfmNewForm.ControlMenuOnPopup(Sender: TObject);
begin
   if pnDesign.TargetsCount=0 then begin
     fmMain.miCtrlPorydok.Enabled:=false;
     fmMain.miCtrlCut.Enabled:=false;
     fmMain.miCtrlCopy.Enabled:=false;
     fmMain.miDelCtrl.Enabled:=false;
     fmMain.miPropCtrl.Enabled:=false;
     fmMain.miCtrlTabOrder.Enabled:=true;
     fmMain.miInsertCtrl.Enabled:=false;
     if pnDesign.CanPaste then
      fmMain.miInsertCtrl.Enabled:=true;
     fmMain.miSelAllCtrl.Enabled:=false;
     if pnDesign.ControlCount<>0 then
      fmMain.miSelAllCtrl.Enabled:=true;
     fmMain.miPropCtrl.Enabled:=true;
     fmMain.miCtrlCreate.Enabled:=true;
     fmMain.miCtrlAlign.Enabled:=true;
     fmMain.miNewTab.Visible:=false;
     fmMain.miCtrlBuild.Enabled:=true;
     fmMain.miCtrlAddToRule.Enabled:=false;
   end else begin
     fmMain.miCtrlPorydok.Enabled:=true;
     fmMain.miCtrlCut.Enabled:=true;
     fmMain.miCtrlCreate.Enabled:=false;
     fmMain.miCtrlAlign.Enabled:=true;
     fmMain.miNewTab.Visible:=false;
     if pnDesign.CanCopy then
      fmMain.miCtrlCopy.Enabled:=true
     else fmMain.miCtrlCopy.Enabled:=false;
     fmMain.miDelCtrl.Enabled:=true;
     if pnDesign.TargetsCount=1 then begin
       fmMain.miPropCtrl.Enabled:=true;
     end else begin
       fmMain.miPropCtrl.Enabled:=false;
     end;
     if pnDesign.TargetsCount=1 then begin
       fmMain.miSelAllCtrl.Enabled:=false;
       if (pnDesign.Targets[0] is TWinControl)and
          (csAcceptsControls in pnDesign.Targets[0].ControlStyle) then begin

        fmMain.miCtrlCreate.Enabled:=true;
        fmMain.miCtrlTabOrder.Enabled:=true;
        if TWinControl(pnDesign.Targets[0]).ControlCount<>0 then begin
         fmMain.miSelAllCtrl.Enabled:=true;
        end;
       end else begin
        fmMain.miCtrlTabOrder.Enabled:=false;
       end;
       if (pnDesign.Targets[0] is TPageControl)then
        fmMain.miNewTab.Visible:=true;

       fmMain.miCtrlAddToRule.Enabled:=isNewControl(pnDesign.Targets[0]);
     end else begin
       fmMain.miSelAllCtrl.Enabled:=false;
       fmMain.miCtrlTabOrder.Enabled:=false;
       fmMain.miNewTab.Visible:=false;
       fmMain.miCtrlAddToRule.Enabled:=false;
     end;
     fmMain.miInsertCtrl.Enabled:=false;
     if pnDesign.CanPaste then
      fmMain.miInsertCtrl.Enabled:=true;
   end;
end;

procedure TfmNewForm.miBringToFrontClick(Sender: TObject);
var
  i,Count: Integer;
  ctrl: TControl;
begin
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ctrl:=pnDesign.Targets[i];
    ctrl.BringToFront;
  end;
  ChangeFlagNewForm:=true;
end;

procedure TfmNewForm.miSendToBackClick(Sender: TObject);
var
  i,Count: Integer;
  ctrl: TControl;
begin
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ctrl:=pnDesign.Targets[i];
    ctrl.SendToBack;
  end;
  ChangeFlagNewForm:=true;
end;

procedure TfmNewForm.regSelectQuery(Sender:TObject;Component:TComponent;
                                            var CanSelect:TSelectAccept);
begin
  if Component<>nil then
    if Component is TBoundLabel then CanSelect:=[saCreate];
end;

procedure TfmNewForm.miPropCtrlClick(Sender: TObject);
begin
   if pnDesign.TargetsCount<>0 then begin
    ViewInspector(pnDesign.Targets[0]);
    fmObjInsp.Show;
    fmObjInsp.ObjInsp.GridP.SetFocus;
   end else begin
    ViewInspector(Self);
    fmObjInsp.Show;
    fmObjInsp.ObjInsp.GridP.SetFocus;
   end;
end;

procedure TfmNewForm.ViewInspector(Ctrl: TControl);
var
  index: Integer;
begin
   index:=fmObjInsp.ObjInsp.Combo.Items.IndexOfObject(Ctrl);
   FRealCmbName:=GetRealCmbName(Ctrl);
   if Index>-1 then
    fmObjInsp.ObjInsp.Combo.Items[Index]:=FRealCmbName;
   fmObjInsp.ObjInsp.Combo.ItemIndex:=Index;
   fmObjInsp.ObjInsp.UpdateInspector(Ctrl);
end;

procedure TfmNewForm.miFromPropClick(Sender: TObject);
begin
   ViewInspector(Self);
   fmObjInsp.Show;
   fmObjInsp.ObjInsp.GridP.SetFocus;
end;

procedure TfmNewForm.miFormInsertClick(Sender: TObject);
begin
  if pnDesign.CanPaste then begin
   pnDesign.Paste;
   ChangeFlagNewForm:=true;
  end;
end;

procedure TfmNewForm.SetGridSize(Value: Byte);
begin
 if isInit then exit;
  if Value<>FGridSize then begin
   FGridSize:=Value;
   InitSmall;
   if Assigned(pnDesign) then begin
    pnDesign.Rubberband.MoveWidth:=FGridSize;
    pnDesign.Rubberband.MoveHeight:=FGridSize;
    if Assigned(reg) then begin
      reg.DsnStage:=pnDesign;
      if reg.Designing then
        pnDesign.Invalidate;
    end;

   end;
  end;
end;

function TfmNewForm.GetRealCmbName(ct: TControl): string;
begin
  if ct=nil then exit;
  if isNewControl(ct) then begin
    if ct is TNewLabel then begin
      Result:=ct.Name+' - '+GetTextFromControl(ct);
    end else begin
      Result:=ct.Name+' - '+GetStrProp(ct,ConstPropDocFieldName);
    end;
  end else begin
    if ct=Self then
      Result:=SForm+' - '+GetTextFromControl(ct)
    else
      Result:=ct.Name+' - '+GetTextFromControl(ct);
  end;
end;

procedure TfmNewForm.FillCmbList(wc: TWinControl);
var
  i: Integer;
  ct: TControl;
  str: string;
begin
  if fmObjInsp=nil then exit;
  for i:=0 to wc.ControlCount-1 do begin
   ct:=wc.Controls[i];
   if ct is TWinControl then
     FillCmbList(TWinControl(ct));
   if Trim(ct.Name)<>'' then begin
    str:=GetRealCmbName(ct);
    fmObjInsp.ObjInsp.Combo.Items.AddObject(str,ct);
   end;
  end;
end;

procedure TfmNewForm.FillAllControls;
begin
  fmObjInsp.ObjInsp.Combo.Clear;
  AddToObjectInspector(Self,true);
  FillCmbList(pnDesign);
end;

procedure TfmNewForm.RecurseRemoveInInspector(wt: TWinControl);
var
  i: Integer;
  ct: TControl;
  Index: Integer;
begin
  for i:=0 to wt.ControlCount-1 do begin
    ct:=wt.Controls[i];
    index:=fmObjInsp.ObjInsp.Combo.Items.IndexOfObject(Ct);
    fmObjInsp.ObjInsp.Combo.Items.Delete(Index);
    if ct is TWinControl then
      RecurseRemoveInInspector(TWinControl(ct));
  end;
end;

procedure TfmNewForm.DeleteInInspector;
var
  index: Integer;
  i: Integer;
  ct: TControl;
  isUpdate: Boolean;
begin
  isUpdate:=false;
   for i:=0 to pnDesign.TargetsCount-1 do begin
    ct:=pnDesign.Targets[i];
    if ct=TControl(fmObjInsp.ObjInsp.ValueObj) then begin
     isUpdate:=true;
    end;
    index:=fmObjInsp.ObjInsp.Combo.Items.IndexOfObject(Ct);
    fmObjInsp.ObjInsp.Combo.Items.Delete(Index);
    if ct is TWinControl then
      RecurseRemoveInInspector(TWinControl(ct));
   end;
   if isUpdate then begin
{     if fmObjInsp.ObjInsp.Combo.Items.Count<>0 then begin
      ct:=nil;
      ct:=TControl(fmObjInsp.ObjInsp.Combo.Items.Objects
                  [fmObjInsp.ObjInsp.Combo.Items.Count-1]);
      fmObjInsp.ObjInsp.Combo.ItemIndex:=fmObjInsp.ObjInsp.Combo.Items.Count-1;
      fmObjInsp.ObjInsp.UpdateInspector(ct);
     end else begin       }
       ViewInspector(nil);

   end;
   ChangeFlagNewForm:=true;
end;

Procedure TfmNewForm.DeleteInInspectorAll;
begin
  if Assigned(fmObjInsp) then begin
    fmObjInsp.ObjInsp.Combo.Clear;
    fmObjInsp.Close;
  end;  
  AlignPalette.Close;
  ViewInspector(nil);
  ChangeFlagNewForm:=true;
end;

procedure TfmNewForm.miFormTabOrderClick(Sender: TObject);
begin
   fmTabOrder.InitTabOrder(pnDesign,Self);
   if fmTabOrder.ShowModal=mrOk then begin
    fmTabOrder.BackUpTabOrder;
    ChangeFlagNewForm:=true;
   end;
end;

procedure TfmNewForm.pnDesignControlCreate(Sender:TObject;Component:TComponent);
begin
   AddToObjectInspector(TControl(Component),false);
end;

procedure TfmNewForm.AddToObjectInspector(ct: TControl; IgnoreTarget: Boolean);
var
  str: String;
begin
  str:=GetRealCmbName(ct);
  FRealCmbName:=str;
  if IgnoreTarget then begin
   fmObjInsp.ObjInsp.Combo.Items.AddObject(str,ct);
   ViewInspector(ct);
  end else begin
    fmObjInsp.ObjInsp.Combo.Items.AddObject(str,ct);
    if pnDesign.TargetsCount=1 then
     ViewInspector(ct);
  end;
  if not Creating then
   ChangeFlagNewForm:=true;
end;

procedure TfmNewForm.miCtrlTabOrderClick(Sender: TObject);
begin
   if pnDesign.TargetsCount<>0 then
    fmTabOrder.InitTabOrder(TWinControl(pnDesign.Targets[0]),Self)
   else
    fmTabOrder.InitTabOrder(TWinControl(pnDesign),Self);
   if fmTabOrder.ShowModal=mrOk then begin
    fmTabOrder.BackUpTabOrder;
    ChangeFlagNewForm:=true;
   end;
end;

procedure TfmNewForm.pnDesignMove(Sender:TObject;Component:TComponent; var CanMove:Boolean);
begin
  ChangeFlagNewForm:=true;
  if pnDesign.TargetsCount=1 then begin
    if fmObjInsp.ObjInsp.ValueObj=Component then begin
      fmObjInsp.ObjInsp.RefreshInspector;
    end else
      ViewInspector(TControl(Component));
  end;

end;

procedure TfmNewForm.WndProc(var Message: TMessage);
begin
  if Message.Msg=WM_PropChange then begin
    if not isChangeOnKeyDown then begin
     if fmObjInsp.ObjInsp.ValueObj is TForm then begin
       reg.ClearSelect;
       if Reg.Designing then begin
         reg.Designing:=false;
         reg.Designing:=true;
       end;
     end else begin
       Sel.Select(TControl(fmObjInsp.ObjInsp.ValueObj));
       FRealCmbName:=GetRealCmbName(TControl(fmObjInsp.ObjInsp.ValueObj));
     end;
    end;
    ChangeFlagNewForm:=true;
  end;
  inherited;
end;

function TfmNewForm.GetNewName(ct: TComponent): String;
var
  S: String;
begin
  S:=ct.ClassName;
  Delete(S,1,1);
  Result:=S+'1';
end;

procedure TfmNewForm.SelChangeSelected(Sender: TObject; Targets: TSelectedComponents;
                    Operation: TSelectOperation);
begin
  case Operation of
    opClear: begin
       //DeleteInInspectorNew(Targets);
    end;
  end;
end;

procedure TfmNewForm.DeleteInInspectorNew(Targets: TSelectedComponents);
var
  index: Integer;
  i: Integer;
  ct: TControl;
begin
   for i:=0 to Targets.Count-1 do begin
    ct:=TControl(Targets[i]);
    if ct=TControl(fmObjInsp.ObjInsp.ValueObj) then begin
     ViewInspector(nil);
    end;
    index:=fmObjInsp.ObjInsp.Combo.Items.IndexOfObject(Ct);
    fmObjInsp.ObjInsp.Combo.Items.Delete(Index);
   end;
   ChangeFlagNewForm:=true;
end;

procedure TfmNewForm.pnDesignDeleteQuery(Sender:TObject;Component:TComponent;
                           var CanDelete:Boolean);
begin
  CanDelete:=true;
end;

procedure TfmNewForm.DeleteInInspectorControl(ct: TControl);
var
  nextctrl: TControl;
  index: Integer;
begin
  ViewInspector(nil);
  if (fmObjInsp.ObjInsp.Combo.Items.Count<>0) then begin
    index:=fmObjInsp.ObjInsp.Combo.Items.IndexOfObject(Ct);
    fmObjInsp.ObjInsp.Combo.Items.Delete(Index);
    nextctrl:=TControl(fmObjInsp.ObjInsp.Combo.Items.Objects
                    [fmObjInsp.ObjInsp.Combo.Items.Count-1]);
    fmObjInsp.ObjInsp.Combo.ItemIndex:=fmObjInsp.ObjInsp.Combo.Items.Count-1;
    fmObjInsp.ObjInsp.UpdateInspector(nextctrl);
  end;
  ChangeFlagNewForm:=true;
end;

procedure TfmNewForm.NewFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

type
  TTypeMove=(tmUp,tmDown,tmLeft,tmRight);

  procedure MoveSelection(TypeMove: TTypeMove);
  var
    i: Integer;
    ct: TControl;
  begin
    for i:=0 to pnDesign.TargetsCount-1 do begin
      ct:=pnDesign.Targets[i];
      case TypeMove of
        tmUp: ct.Top:=ct.Top-FGridSize;
        tmDown: ct.Top:=ct.Top+FGridSize;
        tmLeft: ct.Left:=ct.Left-FGridSize;
        tmRight: ct.Left:=ct.Left+FGridSize;
      end;
    end;
    if pnDesign.TargetsCount<>0 then begin
     pnDesign.UpdateControl;
     isChangeOnKeyDown:=true;
     ChangeFlagNewForm:=true;
    end;
  end;

  procedure ChangeSelection(TypeMove: TTypeMove);
  var
    i: Integer;
    ct: TControl;
  begin
    for i:=0 to pnDesign.TargetsCount-1 do begin
      ct:=pnDesign.Targets[i];
      case TypeMove of
        tmUp: ct.Height:=ct.Height-FGridSize;
        tmDown: ct.Height:=ct.Height+FGridSize;
        tmLeft: ct.Width:=ct.Width-FGridSize;
        tmRight: ct.Width:=ct.Width+FGridSize;
      end;
    end;
    if pnDesign.TargetsCount<>0 then begin
     pnDesign.UpdateControl;
     isChangeOnKeyDown:=true;
     ChangeFlagNewForm:=true;
    end;
  end;

  procedure SelectNextControl;
{  var
    ct: TControl;
    i: Integer;}
  begin
{   if pnDesign.TargetsCount<>0 then begin
     ct:=pnDesign.Targets[0];
     if ct is TWinControl then begin
      for i:=0 to TWinControl(ct).ControlCount-1 do begin

      end;
     end else begin

     end;
   end else begin
     if pnDesign.ControlCount<>0 then
       sel.Select(pnDesign.Controls[0]);
   end;}
  end;

var
  pt: TPoint;
  val: Variant;
begin
  isChangeOnKeyDown:=false;
  case FViewType of
    vtEdit: begin
     case Key of
      VK_DELETE: begin
        DeleteInInspector;
      end;
      VK_ESCAPE: begin
        reg.ClearSelect;
      end;
      VK_F5: begin
        pnDesign.Invalidate;             
        pnDesign.UpdateControl;
        pnDesign.Invalidate;
      end;
      VK_F6: begin
        if pnDesign.TargetsCount>0 then
          ViewFieldsInDocumentByControl(pnDesign.Targets[0]);
      end;
      VK_TAB: begin
        SelectNextControl;
      end;
      VK_F11: begin
        if not isViewObjectIns then begin
          miPropCtrlClick(nil);
          isViewObjectIns:=true;
        end else begin
          fmObjInsp.Visible:=false;

          isViewObjectIns:=false;
        end;
      end;
     end;

     if Shift=[ssCtrl] then begin
      case Key of
       VK_UP:   MoveSelection(tmUp);
       VK_DOWN: MoveSelection(tmDown);
       VK_LEFT: MoveSelection(tmLeft);
       VK_RIGHT:MoveSelection(tmRight);
      end;
      if (char(Key)='A') or (char(Key)='a') then begin
        SelectAllControls;
      end;
      if (char(Key)='S') or (char(Key)='s') then begin
        SaveControlsToClipBoardAsText;
      end;
      if (char(Key)='L') or (char(Key)='l') then begin
        LoadControlsFromClipBoardAsText;
      end;
     end;

     if Shift=[ssShift] then begin
      case Key of
       VK_UP:   ChangeSelection(tmUp);
       VK_DOWN: ChangeSelection(tmDown);
       VK_LEFT: ChangeSelection(tmLeft);
       VK_RIGHT:ChangeSelection(tmRight);

       VK_F10: begin
         if pnDesign.TargetsCount<>0 then begin
           pt:=Point(pnDesign.Targets[0].Left,
                     pnDesign.Targets[0].Top+pnDesign.Targets[0].Height);
           pt:=pnDesign.ClientToScreen(pt);
         end else begin
           pt:=Point(pnDesign.Left,pnDesign.Top);
           pt:=pnDesign.ClientToScreen(pt);
         end;
        fmMain.pmCtrlEdit.Popup(pt.x,pt.y);
       end;
      end;

     end;

    end;
    vtView: begin
     case Key of
       VK_F5: begin
         ViewHintByControl(ActiveControl);
       end;
       VK_F6: begin
         ViewFieldsInDocumentByControl(ActiveControl);
       end;
       VK_F7: begin
         val:=GetPropValue(ActiveControl,ConstPropSubs);
         SetNewTextFromUniversal(ActiveControl,true,val,true);
       end;
       VK_F8: begin
         if Shift=[ssCtrl] then
              UpFill(self)
            else
              ReFill(self);
       end;
     end; 
    end;
  end;
  fmMain.OnKeyDown(Sender,Key,Shift);
end;

procedure TfmNewForm.NewFormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if isChangeOnKeyDown then
    if fmObjInsp.Visible then fmObjInsp.ObjInsp.RefreshInspector;
  fmMain.OnKeyDown(Sender,Key,Shift);
end;

procedure TfmNewForm.miSelAllCtrlClick(Sender: TObject);
begin
  SelectAllControls;
end;

procedure TfmNewForm.SelectAllControls;
var
  List: TList;
  i: Integer;
  wt: TWinControl;
begin
  List:=TList.Create;
  try
   if pnDesign.TargetsCount<>0 then begin
    if pnDesign.Targets[0] is TWinControl then begin
     wt:=TWinControl(pnDesign.Targets[0]);
    end else begin
     exit;
    end; 
   end else begin
    wt:=pnDesign;
   end;
   for i:=0 to wt.ControlCount-1 do begin
    List.Add(wt.Controls[i]);
   end;
   sel.MultipleSelect(List);
  finally
    List.Free;
  end; 
end;

procedure TfmNewForm.miInsertCtrlClick(Sender: TObject);
begin
  if pnDesign.CanPaste then
    pnDesign.Paste;
end;

procedure TfmNewForm.FillMenuCreate(mi: TMenuItem);
var
  miNew: TMenuItem;
  i: Integer;
  P: PInfoClass;
begin
  exit;
  for i:=0 to ListClasses.Count-1 do begin
   P:=ListClasses.Items[i];
   miNew:=TMenuItem.Create(self);
   mi.Add(miNew);
   miNew.Caption:=P.Caption;
   miNew.ImageIndex:=P.ImageIndex;
   miNew.OnClick:=miCreateClick;
  end;
end;

procedure TfmNewForm.miCreateClick(Sender: TObject);
var
  pt: TPoint;
  ct: TComponent;
  ctNew: TControl;
  P: PinfoClass;
  cls: TClass;
  wtParent: TWinControl;
  Index: Integer;
begin
  pt:=reg.MainInsertPoint;
  if fmCreateCtrl.ShowModal=mrOk then begin
    Index:=fmCreateCtrl.cbObj.ItemIndex;
    if Index=-1 then exit;
    if fmCreateCtrl.rbStandart.Checked then
     P:=ListClasses.Items[Index]
    else P:=ListClassesForWord.Items[Index];
    cls:=P.TypeClass;
    ct:=TComponentClass(cls).Create(Self);
    ctnew:=TControl(ct);
    if pnDesign.TargetsCount<>0 then begin
     wtParent:=TWinControl(pnDesign.Targets[0]);
    end else begin
     wtParent:=pnDesign;
    end;
    ctnew.Parent:=wtParent;
    ctnew.left:=pt.x-ctnew.Width div 2;
    ctnew.Top:=pt.y-ctnew.Height div 2;
    ctnew.Name:=DsnCheckNameNew(Self,ctnew,GetNewName(ctnew));
    AddToObjectInspector(ctnew,true);
 //  pnDesign.UpdateControl;
    reg.Designing:=false;
    reg.Designing:=true;
    sel.Select(ctnew);
  end;  
end;

procedure TfmNewForm.WMWindowPosChanged(var Message: TWMWindowPosChanged);
var
  OldLeft,OldTop: Integer;
begin
 OldLeft:=Left;
 OldTop:=Top;
 inherited;
 if (Message.WindowPos.x<>OldLeft) or (Message.WindowPos.y<>OldTop) then begin
   if (Message.WindowPos.cx<>0) or (Message.WindowPos.cy<>0) then
    if Message.WindowPos.flags<>2077 then
     RefreshFormInInspector;
 end; 
end;

procedure TfmNewForm.RefreshFormInInspector;
begin
 if fmObjInsp.Visible then  begin
  if fmObjInsp.ObjInsp.ValueObj=Self then
   fmObjInsp.ObjInsp.RefreshInspector;
 end;
 ChangeFlagNewForm:=true;
end;

procedure TfmNewForm.FormResize(Sender: TObject);
begin
  RefreshFormInInspector;
  if Assigned(pnDesign) then
   pnDesign.UpdateControl;
  pnMarquee.Width:=lbNumReestr.Left-10;
end;

procedure TfmNewForm.GetParamListByConsts(List: TList; UseInScript: Boolean);
var
  plus: Integer;

  procedure FillDopField;

   function GetPagedFromRBCase(Imenit: string; TypeCase: TTypeCase): string;
   var
     tmps: string;
   begin
     tmps:=GetPadegStr(Imenit,TypeCase);
     if AnsiSameText(Trim(tmps),Trim(Imenit)) then begin
       tmps:=GetPadegFromRBCase(Imenit,TypeCase);
     end;
     Result:=Trim(tmps);
   end;

  var
    PInNot: PInfoNotarius;
    TypeReestr_id: Integer;
    PITR: PInfoTypeReestr;
    IHI: TInfoHelperItem;
    Flag: Boolean;
  begin

    New(PInNot);
    try
      Flag:=false;

      FillChar(PInNot^,SizeOf(PInNot),0);
      if cbCurReestr.ItemIndex<>-1 then begin
        PITR:=Pointer(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex]));
        TypeReestr_id:=PITR.typereestr_id;
        if UseInScript then
          AddDopField(List,Plus,Trim(PITR.prefix)+Trim(edNumReestr.Text)+Trim(PITR.sufix),WordFieldNumInReestr,WordFieldNumInReestr,false);

        GetInfoNotarius(TypeReestr_id,PInNot,RenovationId);
        if fmMain.cmbHelper.ItemIndex<>-1 then begin
          IHI:=TInfoHelperItem(fmMain.cmbHelper.Items.Objects[fmMain.cmbHelper.ItemIndex]);
          GetInfoNotariusEx(IHI.NotId,PInNot,RenovationId,false,not Boolean(PInNot.isHelper),false);
        end;
        Flag:=true;
      end else  begin
        if UseInScript then
          AddDopField(List,Plus,Trim(edNumReestr.Text),WordFieldNumInReestr,WordFieldNumInReestr,false);
        if fmMain.cmbHelper.ItemIndex<>-1 then begin
          IHI:=TInfoHelperItem(fmMain.cmbHelper.Items.Objects[fmMain.cmbHelper.ItemIndex]);
          GetInfoNotariusEx(IHI.NotId,PInNot,RenovationId,not Boolean(IHI.isHelper),Boolean(IHI.isHelper),true);
          Flag:=true;
        end;
      end;

      if Flag then begin

        if Assigned(SummEditPriv) and UseInScript then begin
          AddDopField(List,Plus,QuantityText(SummEditPriv.Value,ttMoneyTariff),WordFieldSumm,WordFieldSumm,false);
        end;

        if Assigned(cbBlank) and Assigned(edBlank) and UseInScript then begin
          if cbBlank.ItemIndex>0 then
            AddDopField(List,Plus,cbBlank.Text,WordFieldBlankSeries,WordFieldBlankSeries,false)
          else
            AddDopField(List,Plus,'',WordFieldBlankSeries,WordFieldBlankSeries,false);
          AddDopField(List,Plus,edBlank.Text,WordFieldBlankNum,WordFieldBlankNum,false);
        end;

        if UseInScript then begin

          AddDopField(List,Plus,Trim(PInNot.TownFull_Normal+' '+PInNot.NameFull_Normal),WordFieldTownFull_Normal,WordFieldTownFull_Normal,false);
          AddDopField(List,Plus,Trim(PInNot.TownFull_Where+' '+PInNot.NameFull_Where),WordFieldTownFull_Where,WordFieldTownFull_Where,false);
          AddDopField(List,Plus,Trim(PInNot.TownFull_What+' '+PInNot.NameFull_What),WordFieldTownFull_What,WordFieldTownFull_What,false);
          AddDopField(List,Plus,Trim(PInNot.TownSmall_Normal+' '+PInNot.NameSmall_Normal),WordFieldTownSmall_Normal,WordFieldTownSmall_Normal,false);
          AddDopField(List,Plus,Trim(PInNot.TownSmall_Where+' '+PInNot.NameSmall_Where),WordFieldTownSmall_Where,WordFieldTownSmall_Where,false);
          AddDopField(List,Plus,Trim(PInNot.TownSmall_What+' '+PInNot.NameSmall_What),WordFieldTownSmall_What,WordFieldTownSmall_What,false);

          AddDopField(List,Plus,PInNot.FIO,WordFieldFIO_Imenit,WordFieldFIO_Imenit,false);
          AddDopField(List,Plus,PInNot.FIORodit,WordFieldFIO_Rodit,WordFieldFIO_Rodit,false);
          AddDopField(List,Plus,PInNot.FIODatel,WordFieldFIO_Datel,WordFieldFIO_Datel,false);
          AddDopField(List,Plus,PInNot.FIOVinit,WordFieldFIO_Vinit,WordFieldFIO_Vinit,false);
          AddDopField(List,Plus,PInNot.FIOTvorit,WordFieldFIO_Tvorit,WordFieldFIO_Tvorit,false);
          AddDopField(List,Plus,PInNot.FIOPredl,WordFieldFIO_Predl,WordFieldFIO_Predl,false);
          AddDopField(List,Plus,PInNot.FIOSmall,WordFieldFIO_Imenit_sm,WordFieldFIO_Imenit_sm,false);

          AddDopField(List,Plus,PInNot.FIO_h,WordFieldFIO_Imenit_h,WordFieldFIO_Imenit_h,false);
          AddDopField(List,Plus,PInNot.FIORodit_h,WordFieldFIO_Rodit_h,WordFieldFIO_Rodit_h,false);
          AddDopField(List,Plus,PInNot.FIODatel_h,WordFieldFIO_Datel_h,WordFieldFIO_Datel_h,false);
          AddDopField(List,Plus,PInNot.FIOVinit_h,WordFieldFIO_Vinit_h,WordFieldFIO_Vinit_h,false);
          AddDopField(List,Plus,PInNot.FIOTvorit_h,WordFieldFIO_Tvorit_h,WordFieldFIO_Tvorit_h,false);
          AddDopField(List,Plus,PInNot.FIOPredl_h,WordFieldFIO_Predl_h,WordFieldFIO_Predl_h,false);
          AddDopField(List,Plus,PInNot.FIOSmall_h,WordFieldFIO_Imenit_sm_h,WordFieldFIO_Imenit_sm_h,false);

          AddDopField(List,Plus,PInNot.UrAdres,WordFieldUrAdres,WordFieldUrAdres,false);
          AddDopField(List,Plus,Trim(cbNumLic.Text),WordFieldNumLicense,WordFieldNumLicense,false);
          AddDopField(List,Plus,PInNot.Phone,WordFieldPhone,WordFieldPhone,false);
          AddDopField(List,Plus,PInNot.INN,WordFieldINN,WordFieldINN,false);

          AddDopField(List,Plus,Trim(PInNot.TownFull_Normal+' '+PInNot.NameFull_Normal),WordFieldTownFull_Normal2,WordFieldTownFull_Normal2,false);
          AddDopField(List,Plus,Trim(PInNot.TownFull_Where+' '+PInNot.NameFull_Where),WordFieldTownFull_Where2,WordFieldTownFull_Where2,false);
          AddDopField(List,Plus,Trim(PInNot.TownFull_What+' '+PInNot.NameFull_What),WordFieldTownFull_What2,WordFieldTownFull_What2,false);
          AddDopField(List,Plus,Trim(PInNot.TownFull_Normal+' '+PInNot.NameSmall_Normal),WordFieldTownSmall_Normal2,WordFieldTownSmall_Normal2,false);
          AddDopField(List,Plus,Trim(PInNot.TownSmall_Where+' '+PInNot.NameSmall_Where),WordFieldTownSmall_Where2,WordFieldTownSmall_Where2,false);
          AddDopField(List,Plus,Trim(PInNot.TownSmall_What+' '+PInNot.NameSmall_What),WordFieldTownSmall_What2,WordFieldTownSmall_What2,false);
          AddDopField(List,Plus,PInNot.UrAdres,WordFieldUrAdres2,WordFieldUrAdres2,false);
        end;


        if not UseInScript then
          AddDopFieldFromConst(List,Plus,PInNot.isHelper=1,RenovationId);
      end;

    finally
      Dispose(PInNot);
    end;
  end;

begin
  if not Assigned(pndesign) then exit;
  plus:=0;
  FillDopField;
end;

procedure TfmNewForm.GetParamListByControls(List: TList);
var
  plus: Integer;

    function GetResultFromDateTimePicker(DTP: TNewDateTimePicker): String;
    begin
      Result:='';
      case DTP.Kind of
         dtkDate: begin
          if DTP.ShowCheckbox then begin
            if DTP.Checked then
              case DTP.DateFormat of
               dfShort: begin
                case DTP.WrittenOut of
                  woNormal: Result:= AnsiLowerCase(FormatDateTimeTSV(fmtDateShortEx,DTP.Date));
                  woLong: Result:=QuantityText(DTP.DateTime,ttDate);
                  woParentheses: Result:=QuantityText(DTP.DateTime,ttDate);
                  woLongRodit: Result:=QuantityText(DTP.DateTime,ttDateRodit);
                end;
               end;
               dfLong: begin
                case DTP.WrittenOut of
                  woNormal: Result:= AnsiLowerCase(FormatDateTimeTSV(fmtDateLong,DTP.Date));
                  woLong: Result:=QuantityText(DTP.DateTime,ttDate);
                  woParentheses: Result:=QuantityText(DTP.DateTime,ttDate);
                  woLongRodit: Result:=QuantityText(DTP.DateTime,ttDateRodit);
                end;
               end;
              end;
          end else begin
            case DTP.DateFormat of
             dfShort: begin
              case DTP.WrittenOut of
               woNormal: Result:=AnsiLowerCase(FormatDateTimeTSV(fmtDateShortEx,DTP.Date));
               woLong: Result:=QuantityText(DTP.DateTime,ttDate);
               woParentheses: Result:=QuantityText(DTP.DateTime,ttDate);
               woLongRodit: Result:=QuantityText(DTP.DateTime,ttDateRodit);
              end;
             end;
             dfLong: begin
              case DTP.WrittenOut of
                woNormal: Result:=AnsiLowerCase(FormatDateTimeTSV(fmtDateLong,DTP.Date));
                woLong: Result:=QuantityText(DTP.DateTime,ttDate);
                woParentheses: Result:=QuantityText(DTP.DateTime,ttDate);
                woLongRodit: Result:=QuantityText(DTP.DateTime,ttDateRodit);
              end;
             end;
            end;
          end;
         end;
         dtkTime: begin
          if DTP.ShowCheckbox then begin
            if DTP.Checked then begin
              case DTP.WrittenOut of
               woNormal: Result:=TimeToStr(DTP.Time);
               woLong: Result:=QuantityText(DTP.DateTime,ttTime);
               woParentheses,woLongRodit: Result:=QuantityText(DTP.DateTime,ttTime);
              end;
            end;
          end else begin
            case DTP.WrittenOut of
              woNormal: Result:=TimeToStr(DTP.Time);
              woLong: Result:=QuantityText(DTP.DateTime,ttTime);
              woParentheses,woLongRodit: Result:=QuantityText(DTP.DateTime,ttTime);
            end;
          end;
         end;
       end;
    end;

    function GetResultFromRxCalcEdit(RXCE: TNewRxCalcEdit):String;
    begin
      Result:='';
      case RXCE.WrittenOut of
//         woNormal: Result:=FloatToStr(RXCE.Value);
         woNormal: Result:=QuantityText(RXCE.Value,ttMoneyShort);
         woLong: begin
           Result:=QuantityText(RXCE.Value,ttMoneyLongShort);
         end;
         woParentheses,woLongRodit: begin
           Result:=floattostr(RXCE.Value)+' ('+QuantityText(RXCE.Value,ttNormal)+') ';
         end;
      end;
    end;

    function GetResultFromDateEdit(DTP: TNewRxDateEdit): String;
    begin
      Result:='';
      if DTP.Date<>0 then
        case DTP.DateFormat of
         dfShort: begin
          case DTP.WrittenOut of
            woNormal: Result:= AnsiLowerCase(FormatDateTimeTSV(fmtDateShortEx,DTP.Date));
            woLong: Result:=QuantityText(DTP.Date,ttDate);
            woParentheses: Result:=QuantityText(DTP.Date,ttDate);
            woLongRodit: Result:=QuantityText(DTP.Date,ttDateRodit);
          end;
         end;
         dfLong: begin
          case DTP.WrittenOut of
            woNormal: Result:= AnsiLowerCase(FormatDateTimeTSV(fmtDateLong,DTP.Date));
            woLong: Result:=QuantityText(DTP.Date,ttDate);
            woParentheses: Result:=QuantityText(DTP.Date,ttDate);
            woLongRodit: Result:=QuantityText(DTP.Date,ttDateRodit);
          end;
         end;
        end;
    end;

    procedure AddToListWord(ct: TControl);
    var
     Pfield: Pointer;
     WordType: TWordFormType;
     EnumProp: Integer;
     DocFieldName: String;
     WordStyle: string;
     WordAutoFormat: Boolean;
    begin
        inc(Plus);
        DocFieldName:=GetStrProp(ct,'DocFieldName');
        EnumProp:=GetOrdProp(ct,'WordFormType');
        WordType:=TWordFormType(EnumProp);
        WordStyle:=GetStrProp(ct,'WordStyle');
        WordAutoFormat:=GetPropValue(ct,'WordAutoFormat');
        case WordType of
           wtFieldQuote: begin
            if Trim(DocFieldName)<>'' then begin
             New(PFieldQuote(Pfield));
             FillChar(PFieldQuote(Pfield)^,SizeOf(PFieldQuote(Pfield)^),0);
             if ct is TNewLabel then
               if Trim(TNewLabel(ct).Caption)<>'' then
                 PFieldQuote(Pfield).Result:=Trim(TNewLabel(ct).ToSign+TNewLabel(ct).Caption+TNewLabel(ct).Signature);

             if ct is TNewEdit then
               if Trim(TNewEdit(ct).Text)<>'' then
                PFieldQuote(Pfield).Result:=Trim(TNewEdit(ct).ToSign+TNewEdit(ct).Text+TNewEdit(ct).Signature);

             if ct is TNewComboBox then
               if Trim(TNewComboBox(ct).Text)<>'' then
                PFieldQuote(Pfield).Result:=Trim(TNewComboBox(ct).ToSign+TNewComboBox(ct).Text+TNewComboBox(ct).Signature);

             if ct is TNewMemo then
               if Trim(TNewMemo(ct).Lines.Text)<>'' then
                PFieldQuote(Pfield).Result:=Trim(TNewMemo(ct).ToSign+TNewMemo(ct).Lines.Text+TNewMemo(ct).Signature);

             if ct is TNewCheckBox then
               if TNewCheckBox(ct).Checked then
                if Trim(TNewCheckBox(ct).Text)<>'' then
                 PFieldQuote(Pfield).Result:=Trim(TNewCheckBox(ct).ToSign+TNewCheckBox(ct).Text+TNewCheckBox(ct).Signature);

             if ct is TNewRadioButton then
               if TNewRadioButton(ct).Checked then
                if Trim(TNewRadioButton(ct).Text)<>'' then
                 PFieldQuote(Pfield).Result:=Trim(TNewRadioButton(ct).ToSign+TNewRadioButton(ct).Text+TNewRadioButton(ct).Signature);

             if ct is TNewListBox then begin
               if TNewListBox(ct).ItemIndex<>-1 then
                if Trim(TNewListBox(ct).Items.Strings[TNewListBox(ct).ItemIndex])<>'' then
                 PFieldQuote(Pfield).Result:=Trim(TNewListBox(ct).ToSign+TNewListBox(ct).Items.Strings[TNewListBox(ct).ItemIndex]+TNewListBox(ct).Signature);
             end;

             if ct is TNewRadioGroup then begin
               if TNewRadioGroup(ct).ItemIndex<>-1 then
                if Trim(TNewRadioGroup(ct).Items.Strings[TNewRadioGroup(ct).ItemIndex])<>'' then
                 PFieldQuote(Pfield).Result:=Trim(TNewRadioGroup(ct).ToSign+TNewRadioGroup(ct).Items.Strings[TNewRadioGroup(ct).ItemIndex]+TNewRadioGroup(ct).Signature);
             end;

             if ct is TNewMaskEdit then begin
               if Trim(TNewMaskEdit(ct).Text)<>'' then
                PFieldQuote(Pfield).Result:=Trim(TNewMaskEdit(ct).ToSign+TNewMaskEdit(ct).Text+TNewMaskEdit(ct).Signature);
             end;

             if ct is TNewRichEdit then begin
               if Trim(TNewRichEdit(ct).Lines.Text)<>'' then
                PFieldQuote(Pfield).Result:=Trim(TNewRichEdit(ct).ToSign+TNewRichEdit(ct).Lines.Text+TNewRichEdit(ct).Signature);
             end;

             if ct is TNewDateTimePicker then begin
               PFieldQuote(Pfield).Result:=GetResultFromDateTimePicker(TNewDateTimePicker(ct));
               if Trim(PFieldQuote(Pfield).Result)<>'' then
                 PFieldQuote(Pfield).Result:=Trim(TNewDateTimePicker(ct).ToSign+PFieldQuote(Pfield).Result+TNewDateTimePicker(ct).Signature);
             end;

             if ct is TNewRxCalcEdit then begin
               PFieldQuote(Pfield).Result:=GetResultFromRxCalcEdit(TNewRxCalcEdit(ct));
               if Trim(PFieldQuote(Pfield).Result)<>'' then
                PFieldQuote(Pfield).Result:=Trim(TNewRxCalcEdit(ct).ToSign+PFieldQuote(Pfield).Result+TNewRxCalcEdit(ct).Signature);
             end;

             if ct is TNewRxDateEdit then begin
               PFieldQuote(Pfield).Result:=GetResultFromDateEdit(TNewRxDateEdit(ct));
               if Trim(PFieldQuote(Pfield).Result)<>'' then
                 PFieldQuote(Pfield).Result:=Trim(TNewRxDateEdit(ct).ToSign+PFieldQuote(Pfield).Result+TNewRxDateEdit(ct).Signature);
             end;

             if ct is TNewComboBoxMarkCar then begin
               if Trim(TNewComboBoxMarkCar(ct).Text)<>'' then
                PFieldQuote(Pfield).Result:=Trim(TNewComboBoxMarkCar(ct).ToSign+TNewComboBoxMarkCar(ct).Text+TNewComboBoxMarkCar(ct).Signature);
             end;

             if ct is TNewComboBoxColor then begin
               if Trim(TNewComboBoxColor(ct).Text)<>'' then
                PFieldQuote(Pfield).Result:=Trim(TNewComboBoxColor(ct).ToSign+TNewComboBoxColor(ct).Text+TNewComboBoxColor(ct).Signature)
             end;

             PFieldQuote(Pfield).Result:=GetTransformationResult(PFieldQuote(Pfield).Result,ct);
             PFieldQuote(Pfield).FieldName:=DocFieldName;
             PFieldQuote(Pfield).ID:=Plus;
             PFieldQuote(Pfield).AutoFormat:=WordAutoFormat;
             PFieldQuote(Pfield).Style:=WordStyle;
             AddToWordObjectList(List,Pfield,WordType,ct.name);
            end; 
           end;
        end;
  end;

  procedure FillList(wt: TWinControl);
  var
    i: Integer;
    ct: TControl;
  begin
    if Assigned(wt) then
      for i:=0 to wt.ControlCount-1 do begin
        ct:=wt.Controls[i];
        if isNewControl(ct) then  begin
          AddToListWord(ct);
        end;
        if ct is TWincontrol then begin
          FillList(TWincontrol(ct));
        end;
      end; // for
  end;

begin
  if not Assigned(pndesign) then exit;
  plus:=0;
  FillList(pndesign);
  FillList(grbDoplnit);
end;

procedure TfmNewForm.SaveControls(msIn: TMemoryStream);
begin
  if Not Assigned(pndesign) then exit;
  PrepeareControlsBeforeSave(pndesign);
  pndesign.SaveToStream(msIn);
end;

procedure TfmNewForm.LoadControls(msIn: TMemoryStream);
begin
  if Not Assigned(pndesign) then exit;
  pndesign.LoadFromStream(msIn);
  PrepeareControlsAfterLoad(pndesign);
end;


procedure TfmNewForm.miCtrlAlignClick(Sender: TObject);
begin
  if AlignPalette<>nil then begin
   AlignPalette.Show;
   AlignPalette.BringToFront;
  end;
end;

procedure TfmNewForm.FormShow(Sender: TObject);
begin
  if FViewType=vtEdit then begin
    if reg.Designing then begin
      reg.Designing:=false;
      reg.Designing:=true;
    end;
  end;
  exit;
  if Assigned(pndesign) then begin
     pndesign.Invalidate;
  end;
end;

procedure TfmNewForm.FormActivate(Sender: TObject);
var
  old: Boolean;
begin
  if LastActive<>Self then begin
   FillAllControls;
   LastActive:=Self;
  end;
  if Assigned(pndesign) then begin
     old:=reg.Designing;
     pndesign.Invalidate;
     reg.Designing:=old;
  end;
end;

procedure TfmNewForm.AlignLeft;
var
  i: Integer;
  Count: Integer;
  ct: TControl;
  defx: Integer;
begin
  if not Assigned(pnDesign) then exit;
  defx:=0;
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      defx:=ct.Left;
    end else begin
      ct.Left:=defx;
    end;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignRight;
var
  i: Integer;
  Count: Integer;
  ct: TControl;
  defx: Integer;
begin
  if not Assigned(pnDesign) then exit;
  defx:=0;
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      defx:=ct.Left+ct.Width;
    end else begin
      ct.Left:=defx-ct.Width;
    end;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignTop;
var
  i: Integer;
  Count: Integer;
  ct: TControl;
  defy: Integer;
begin
  if not Assigned(pnDesign) then exit;
  defy:=0;
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      defy:=ct.Top;
    end else begin
      ct.Top:=defy;
    end;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignBottom;
var
  i: Integer;
  Count: Integer;
  ct: TControl;
  defy: Integer;
begin
  if not Assigned(pnDesign) then exit;
  defy:=0;
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      defy:=ct.Top+ct.Height;
    end else begin
      ct.Top:=defy-ct.Height;
    end;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignHCenter;
var
  i: Integer;
  Count: Integer;
  ct: TControl;
  defx: Integer;
begin
  if not Assigned(pnDesign) then exit;
  defx:=0;
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      defx:=ct.Left+ct.Width div 2;
    end else begin
      ct.Left:=defx-ct.Width div 2;
    end;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignVCenter;
var
  i: Integer;
  Count: Integer;
  ct: TControl;
  defy: Integer;
begin
  if not Assigned(pnDesign) then exit;
  defy:=0;
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      defy:=ct.Top+ct.Height div 2;
    end else begin
      ct.Top:=defy-ct.Height div 2;
    end;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignWinHCenter;

  function GetdefLeft: Integer;
  var
   Count,i: Integer;
   ct: TControl;
  begin
   Result:=0;
   Count:=pnDesign.TargetsCount;
   for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      Result:=ct.Left;
    end else begin
     if Result<ct.Left then
       Result:=ct.Left;
    end;
   end;
  end;

  function GetdefRight: Integer;
  var
    Count,i: Integer;
    ct: TControl;
  begin
   Result:=0;
   Count:=pnDesign.TargetsCount;
   for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      Result:=ct.Left+ct.Width;
    end else begin
     if Result>(ct.Left+ct.Width) then
       Result:=ct.Left+ct.Width;
    end;
   end;
  end;

var
  i: Integer;
  Count: Integer;
  ct: TControl;
  defl,defr: Integer;
  wtdefx: Integer;
  wt: TWinControl;
  ldef: Integer;
begin
  if not Assigned(pnDesign) then exit;
  defl:=GetdefLeft;
  defr:=GetdefRight;
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    wt:=ct.Parent;
    ldef:=ct.Left-defl;
    wtdefx:=wt.Width div 2 - (defr-defl)div 2;
    ct.left:=wtdefx+ldef;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignWinVCenter;

  function GetdefTop: Integer;
  var
   Count,i: Integer;
   ct: TControl;
  begin
   Result:=0;
   Count:=pnDesign.TargetsCount;
   for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      Result:=ct.Top;
    end else begin
     if Result<ct.Top then
       Result:=ct.Top;
    end;
   end;
  end;

  function GetdefBottom: Integer;
  var
    Count,i: Integer;
    ct: TControl;
  begin
   Result:=0;
   Count:=pnDesign.TargetsCount;
   for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if i=0 then begin
      Result:=ct.Top+ct.Height;
    end else begin
     if Result>(ct.Top+ct.Height) then
       Result:=ct.Top+ct.Height;
    end;
   end;
  end;

var
  i: Integer;
  Count: Integer;
  ct: TControl;
  deft,defb: Integer;
  wtdefy: Integer;
  wt: TWinControl;
  tdef: Integer;
begin
  if not Assigned(pnDesign) then exit;
  deft:=GetdefTop;
  defb:=GetdefBottom;
  Count:=pnDesign.TargetsCount;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    wt:=ct.Parent;
    tdef:=ct.Top-deft;
    wtdefy:=wt.Height div 2 - (defb-deft)div 2;
    ct.Top:=wtdefy+tdef;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignVSpace;
var
  i: Integer;
  Count: Integer;
  ct,ctold: TControl;
  dh: Integer;
begin
  if not Assigned(pnDesign) then exit;
  Count:=pnDesign.TargetsCount;
  ctOld:=nil;
  dh:=0;
  if Count<=2 then exit;
  for i:=0 to Count-1 do begin
    ct:=pnDesign.Targets[i];
    if (i>0)and(i<2) then begin
      if ctOld<>nil then begin
        dh:=Abs((ctOld.Top+ctOld.Height div 2)-(ct.Top+ct.Height div 2));
      end;
    end else begin
      if i>=2 then begin
       if (ct.Top+ct.Height div 2)<=(ctOld.Top+ctOld.Height div 2) then begin
         ct.Top:=ctOld.Top+ctOld.Height div 2 -dh-ct.Height div 2;
       end else begin
         ct.Top:=ctOld.Top+ctOld.Height div 2 +dh+ct.Height div 2;
       end;
      end;
    end;
    ctold:=ct;
  end;
  pnDesign.UpdateControl;
end;

procedure TfmNewForm.AlignHSpace;
begin

end;

procedure TfmNewForm.miNewTabClick(Sender: TObject);
var
  tbs: TTabSheet;
  pg: TPageControl;
begin
  if pnDesign.Targets[0] is TPageControl then begin
   tbs:=TTabSheet.Create(Self);
   tbs.Name:=DsnCheckNameNew(Self,tbs,GetNewName(tbs));
   pg:=TPageControl(pnDesign.Targets[0]);
   tbs.PageControl:=pg;
   AddToObjectInspector(tbs,false);
   reg.Designing:=false;
   reg.Designing:=true;
   sel.Select(tbs);
  end;
end;

procedure TfmNewForm.LocateFirstFocusedControl;

  procedure LocateFocusedControl(ctin: TWinControl; var FlagBreak: Boolean);
  var
    i: Integer;
    ct: TControl;
  begin
    for i:=0 to ctin.ControlCount-1 do begin
      ct:=ctin.Controls[i];
      if ct is TWinControl then begin
        LocateFocusedControl(TWinControl(ct),FlagBreak);
        if TWinControl(ct).CanFocus then begin
          if (TWinControl(ct).Visible)and(TWinControl(ct).Enabled) then begin
//            TWinControl(ct).SetFocus;
            Self.ActiveControl:=TWinControl(ct);
            FlagBreak:=true;
            exit;
          end;
        end;
      end;
      if FlagBreak then
        Exit;
    end;
  end;

  function LocateTabOrderControl(wt: TWinControl): Boolean;
  var
    list: TList;
    i: Integer;
    ct: TWinControl;
  begin
    list:=TList.Create;
    try
      Result:=false;
      wt.GetTabOrderList(list);
      for i:=0 to lIst.Count-1 do begin
        ct:=TWinControl(lIst.items[i]);
        if ct.Visible and ct.Enabled and ct.TabStop then begin
          if Self.Visible then
           Self.ActiveControl:=ct;
          Result:=true;
          exit;
        end;
      end;

    finally
      List.Free;
    end;
  end;

begin
  if Not Assigned(pnDesign) then exit;
  if not Assigned(pnTop) then exit;
  if not LocateTabOrderControl(pnTop) then
   if not LocateTabOrderControl(Self) then
    LocateTabOrderControl(pnDesign);

end;

procedure TfmNewForm.bibCancelClickAppend(Sender: TObject);
begin
  Close;
end;

procedure TfmNewForm.edNumReestrKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (Char(Key) in ['0'..'9']))and(Integer(Key)<>VK_Back) then begin
    Key:=Char(nil);
  end;
end;

procedure TfmNewForm.ClearTypeReestrCombo;
var
  i: Integer;
  P: PInfoTypeReestr;
begin
  if Assigned(cbCurReestr) then begin
    for i:=0 to cbCurReestr.Items.Count-1 do begin
      P:=PInfoTypeReestr(cbCurReestr.Items.Objects[i]);
      Dispose(P);
    end;
    cbCurReestr.Items.Clear;
  end;
end;

procedure TfmNewForm.FillTypeReestrComboAndSetIndex(TypeReestrID: Integer);
var
  qr: TIBQuery;
  sqls: string;
  namestr: string;
  typeresstr_id: Integer;
  Index: Integer;
  newInc: Integer;
  tr: TIBTransaction;
  P: PInfoTypeReestr;
begin
  Screen.Cursor:=crHourGlass;
  cbCurReestr.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   ClearTypeReestrCombo;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select typereestr_id,name,prefix,sufix from '+TableTypeReestr+' order by sortnum';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   newInc:=0;
   Index:=0;
   qr.First;
   while not qr.Eof do begin
     New(P);
     FillChar(P^,SizeOf(TInfoTypeReestr),0);
     namestr:=Trim(qr.FieldByName('name').AsString);
     typeresstr_id:=qr.FieldByName('typereestr_id').AsInteger;
     if typeresstr_id=TypeReestrID then begin
       Index:=newInc;
       prefix:=Trim(qr.FieldByName('prefix').AsString);
       sufix:=Trim(qr.FieldByName('sufix').AsString);
     end;
     P.typereestr_id:=typeresstr_id;
     P.prefix:=Trim(qr.FieldByName('prefix').AsString);
     P.sufix:=Trim(qr.FieldByName('sufix').AsString);

     cbCurReestr.Items.AddObject(namestr,TObject(P));
     inc(newInc);
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cbCurReestr.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cbCurReestr.Items.Count>0 then begin
    cbCurReestr.ItemIndex:=Index;
  end;
end;

procedure TfmNewForm.cbBlankChange(Sender: TObject);
begin
  if Assigned(edBlank) then
    edBlank.Enabled:=not VarIsNull(GetBlankId);
end;

procedure TfmNewForm.cbCurReestrChange(Sender: TObject);
begin
 if cbCurReestr.ItemIndex<>-1 then begin
   LastTypeReestrID:=PInfoTypeReestr(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex])).typereestr_id;
   FillAllNeedFieldForAppend;
 end; 
end;

procedure TfmNewForm.FillNumLicenseCombo(LicenseID: Integer);
var
  qr: TIBQuery;
  sqls: string;
  ind: Integer;
  tmpind: Integer;
  tr: TIBTransaction;
begin
  Screen.Cursor:=crHourGlass;
  cbNumLic.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try

   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select tl.num, tl.license_id from '+TableTypeReestr+' ttr join '+
         TableLicense+' tl on ttr.not_id=tl.not_id '+
         ' where ttr.typereestr_id='+inttostr(LastTypeReestrID);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cbNumLic.Clear;
   ind:=0;
   tmpind:=0;
   while not qr.Eof do begin
     if qr.FieldByname('license_id').AsInteger=LicenseID then begin
       tmpind:=Ind;
     end;
     inc(ind);
     cbNumLic.Items.AddObject(qr.FieldByname('num').AsString,
                              TObject(Pointer(qr.FieldByname('license_id').AsInteger)));
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cbNumLic.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cbNumLic.Items.Count>0 then begin
    cbNumLic.ItemIndex:=tmpind;
  end;
end;

procedure TfmNewForm.FillNotarialActions(isUseForUpdate: Boolean);
var
  qr: TIBQuery;
  sqls: string;
  ind: Integer;
  tmpind: Integer;
  tr: TIBTransaction;
  na_id: Integer;
begin
  Screen.Cursor:=crHourGlass;
  cmbMotion.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select * from '+TableNotarialAction+' where viewinform=1 order by fieldsort';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cmbMotion.Clear;
   ind:=0;
   tmpind:=0;
   if not isUseForUpdate then
    na_id:=GetNotarialActionIdByDocId(LastDocId)
   else na_id:=LastNotarialActionId;

   while not qr.Eof do begin
{     if qr.FieldByname('notarialaction_id').AsInteger=LastNotarialActionID then begin
       tmpind:=Ind;
     end;}
     if qr.FieldByname('notarialaction_id').AsInteger=na_id then begin
       tmpind:=Ind;
     end;

     inc(ind);
     cmbMotion.Items.AddObject(qr.FieldByname('name').AsString,
                              TObject(Pointer(qr.FieldByname('notarialaction_id').AsInteger)));
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cmbMotion.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cmbMotion.Items.Count>0 then begin
    cmbMotion.ItemIndex:=tmpind;
    cmbMotion.OnChange(nil);
  end;
end;

procedure TfmNewForm.FillAllNeedFieldForAppend;
begin
  SetDefaultNotarius(true);
  edNumReestr.Text:='';
  FillTypeReestrComboAndSetIndex(LastTypeReestrID);
  FillNotarialActions(false);
  isAreadyFillFio:=false;
  if cbCurReestr.ItemIndex<>-1 then begin
    LastTypeReestrID:=PInfoTypeReestr(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex])).typereestr_id;
    FillNumLicenseCombo(0);
  end;
  FillBlanks;
end;

procedure TfmNewForm.FillAllNeedFieldForUpdate(NewNumReestr: Integer;
   newTypeReestrID: Integer; newFio: String; newSumm: Extended;
   newReestrID, newLicenseID: Integer;
   newBlankId, newBlankNum: Variant);
begin
  SetDefaultNotarius(false);
  if not isInsert then
   edNumReestr.Text:=inttostr(NewNumReestr)
  else edNumReestr.Text:='';
  FillTypeReestrComboAndSetIndex(newTypeReestrID);
  FillNotarialActions(true);
  isAreadyFillFio:=false;
  FillNumLicenseCombo(newLicenseID);
  cbFio.Text:=Trim(newFio);
  SummEdit.Value:=newSumm;
  FillBlanks;
  SetBlank(newBlankId);
  if not VarIsNull(newBlankNum) and Assigned(edBlank) then begin
    edBlank.Text:=VarToStrDef(newBlankNum,'');
  end;
  LastReestrID:=newReestrID;
end;

procedure TfmNewForm.ClearAllNeedField;
begin
//  cbCurReestr.Clear;
end;

procedure TfmNewForm.edNumReestrChange(Sender: TObject);
begin
end;

procedure TfmNewForm.bibOkClickAppend(Sender: TObject);
var
  BreakF: Boolean;
  Obj: TInfoBlank;
  NumFrom: Integer;
  NumTo: Integer;
  BlankNum: Variant;
  Num: Integer;
  Flag: Boolean;
  S: String;
begin
//  if not SetEmptyPadegControls then exit;
  if isCheckFieldsFill then
   if isEmptySelfControls(pnDesign,BreakF) then begin
    ShowError(Application.Handle,'���� �� ����� ����� �� ���������.');
    exit;
   end;
  if cbCurReestr.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������.');
   cbCurReestr.SetFocus;
   exit;
  end;
  if cbNumLic.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ��������.');
   cbNumLic.SetFocus;
   exit;
  end;
  if cmbMotion.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������������ ��������.');
   cmbMotion.SetFocus;
   exit;
  end;
  if Trim(cbFio.Text)='' then begin
   ShowError(Application.Handle,'�������� ��� ������� ������� �.�.');
   cbFio.SetFocus;
   exit;
  end;
  if Trim(edDocName.Text)='' then begin
   ShowError(Application.Handle,'������� ������������ ���������.');
   edDocName.SetFocus;
   exit;
  end;
  if isCheckEmptySumm then
    if (Trim(edNumReestr.Text)<>'') and (SummEdit.Value=0.0) then begin
     ShowError(Application.Handle,'����� ��� �������� �� ����� ���� ����� 0.');
     SummEdit.SetFocus;
     exit;
    end;

  BlankNum:=GetBlankNum;
  if Assigned(cbBlank) and Assigned(edBlank) and not VarIsNull(BlankNum) then begin
    if cbBlank.ItemIndex<>-1 then begin
      Obj:=TInfoBlank(cbBlank.Items.Objects[cbBlank.ItemIndex]);
      if Assigned(Obj) then begin
        NumFrom:=VarToIntDef(Obj.num_from,0);
        S:='1'+DupeString('0',MaxBlankNumLength);
        NumTo:=VarToIntDef(Obj.num_to,StrToInt(S)-1);
        Num:=VarToIntDef(BlankNum,0);
        Flag:=(NumFrom>Num) or (NumTo<Num);
        if Flag then begin
          ShowError(Application.Handle,'����� ������ �� ������ � �������� �����.');
          edBlank.SetFocus;
          exit;
        end;
      end;
    end;
  end;

  SetHereditaryByNotarialAction(true);

  IsOtlogen:=false;
  AddPeople;
  if AppendToReestr then begin
    IsAlready:=true;
    Close;
  end; 
end;

procedure TfmNewForm.FillFioCombo;
var
  qr: TIBQuery;
  sqls: string;
  namestr,s: string;
  tr: TIBTransaction;
begin
  if isAreadyFillFio then exit;
  Screen.Cursor:=crHourGlass;
  cbFio.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   s:=cbFio.Text;
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select Distinct(fio) as fio from '+TableReestr+
         ' where typereestr_id='+inttostr(LastTypeReestrID)+
         ' and isdel is null '+
         ' order by fio';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cbFio.Clear;
   qr.First;
   while not qr.Eof do begin
     namestr:=Trim(qr.FieldByName('fio').AsString);
     cbFio.Items.Add(namestr);
     qr.Next;
   end;
  finally
   cbFio.Text:=s;
   isAreadyFillFio:=true;
   qr.Free;
   tr.Free;
   cbFio.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmNewForm.ClearBlanks;
var
  i: Integer;
  Obj: TInfoBlank;
begin
  if Assigned(cbBlank) then begin
    for i:=0 to cbBlank.Items.Count-1 do begin
      Obj:=TInfoBlank(cbBlank.Items.Objects[i]);
      if Assigned(Obj) then
        Obj.Free;
    end;
    cbBlank.Items.Clear;
  end;
end;

procedure TfmNewForm.FillBlanks;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  Obj: TInfoBlank;
begin
  if Assigned(cbBlank) then begin
    Screen.Cursor:=crHourGlass;
    cbBlank.Items.BeginUpdate;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select blank_id, series, num_from, num_to from '+TableBlanks+
           ' where visible=1 '+
           ' order by series ';
     qr.SQL.Add(sqls);
     qr.Active:=true;
     cbBlank.Clear;
     cbBlank.Items.AddObject('---------',nil);
     qr.First;
     while not qr.Eof do begin
       Obj:=TInfoBlank.Create;
       Obj.blank_id:=qr.FieldByName('blank_id').AsInteger;
       Obj.num_from:=qr.FieldByName('num_from').Value;
       Obj.num_to:=qr.FieldByName('num_to').Value;
       cbBlank.Items.AddObject(qr.FieldByName('series').AsString,Obj);
       qr.Next;
     end;
     cbBlank.ItemIndex:=0;
     cbBlankChange(nil);
    finally
     qr.Free;
     tr.Free;
     cbBlank.Items.EndUpdate;
     Screen.Cursor:=crDefault;
    end;
  end;
end;

function TfmNewForm.FindBlank(BlankId: Integer; var Index: Integer): TInfoBlank;
var
  i: Integer;
  Obj: TInfoBlank;
begin
  Result:=nil;
  if Assigned(cbBlank) then begin
    for i:=0 to cbBlank.Items.Count-1 do begin
      Obj:=TInfoBlank(cbBlank.Items.Objects[i]);
      if Assigned(Obj) and (Obj.blank_id=BlankId) then begin
        Index:=i;
        Result:=Obj;
        break;
      end;
    end;
  end;
end;

procedure TfmNewForm.SetBlank(BlankId: Variant);
var
  Obj: TInfoBlank;
  Index: Integer;
  Val: Integer;
begin
  if Assigned(cbBlank) and not VarIsNull(BlankId) then begin
    Val:=VarToIntDef(BlankId,-1);
    Obj:=FindBlank(Val,Index);
    if Assigned(Obj) then begin
      cbBlank.ItemIndex:=Index;
      cbBlankChange(nil);
    end;
  end;
end;

function TfmNewForm.GetBlankId: Variant;
var
  Obj: TInfoBlank;
begin
  Result:=Null;
  if Assigned(cbBlank) then begin
    if cbBlank.ItemIndex<>-1 then begin
      Obj:=TInfoBlank(cbBlank.Items.Objects[cbBlank.ItemIndex]);
      if Assigned(Obj) then
        Result:=Obj.blank_id;
    end;
  end;
end;

function TfmNewForm.GetBlankNum: Variant;
var
  S: String;
  Val: Integer;
begin
  Result:=Null;
  if Assigned(edBlank) then begin
    S:=Trim(edBlank.Text);
    if TryStrToInt(S,Val) then begin
      Result:=Val;
    end;
  end;
end;

function TfmNewForm.GetBlankSeries: Variant;
var
  Obj: TInfoBlank;
begin
  Result:=Null;
  if Assigned(cbBlank) then begin
    if cbBlank.ItemIndex<>-1 then begin
      Obj:=TInfoBlank(cbBlank.Items.Objects[cbBlank.ItemIndex]);
      if Assigned(Obj) then
        Result:=cbBlank.Items.Strings[cbBlank.ItemIndex];
    end;
  end;
end;

procedure TfmNewForm.bibOkClickTest(Sender: TObject);
var
  BreakF: Boolean;
  AName: String;
  Line,Tab: Integer;
  Error: String;
  List: TList;
begin
//  if not SetEmptyPadegControls then exit;
  List:=TList.Create;
  try
   if isCheckFieldsFill then
    if isEmptySelfControls(pnDesign,BreakF) then begin
     ShowError(Application.Handle,'���� �� ����� ����� �� ���������.');
     exit;
    end;

   AName:=Trim(cbFio.text);
   GetParamListByConsts(List,true);

   ProgramExecute(Line,Tab,Error,false,FScript.Text,List);
   if Trim(Error)<>'' then begin
     ShowError(Handle,Error);
   end;

   GetParamListByControls(List);
   GetParamListByConsts(List,false);

   if ExtractDocFile(LastDocId,AName) then
     if SetFieldsToWord(List,true,false) then begin
       ModalResult:=mrOk;
     end;

  finally
    ClearWordObjectList(List);
    List.Free;
  end;
end;

procedure TfmNewForm.bibCancelClickTest(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

function TfmNewForm.isEmptySelfControls(wt: TWinControl; var BreakF: Boolean): Boolean;
var
  i: Integer;
  ct: TControl;
  List: TList;
begin
  Result:=false;
  if BreakF then begin
    Result:=BreakF;
    exit;
  end;
  List:=TList.Create;
  try
   wt.GetTabOrderList(List);
   for i:=0 to List.Count-1 do begin
      ct:=List.items[i];
      if isNewControl(ct) then  begin
        if isEmptyControl(ct) then begin
          if ct is TWinControl then begin
           if TWinControl(ct).parent<>nil then begin
              if TWinControl(ct).parent is TTabSheet then
                if TTabSheet(TWinControl(ct).parent).PageControl<>nil then
                  TTabSheet(TWinControl(ct).parent).PageControl.ActivePage:=TTabSheet(TWinControl(ct).parent);
           end;
           if TWinControl(ct).CanFocus then begin
            //  if not isControlConsistPropPadegAndEqual(ct,tcIminit) then
              TWinControl(ct).SetFocus;
              Result:=true;
              BreakF:=true;
              break;
           end;
          end;
        end;
      end; ///
      if ct is TWinControl then
       isEmptySelfControls(TWinControl(ct), BreakF);
       
      if BreakF then begin
        Result:=BreakF;
        exit;
      end;

   end;
  finally
    List.Free;
  end;
end;

procedure TfmNewForm.bibOtlogenClickAppend(Sender: TObject);
begin
  if cbCurReestr.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������.');
   cbCurReestr.SetFocus;
   exit;
  end;
  if cbNumLic.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ��������.');
   cbNumLic.SetFocus;
   exit;
  end;
  if cmbMotion.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������������ ��������.');
   cmbMotion.SetFocus;
   exit;
  end;
  if Trim(cbFio.Text)='' then begin
   ShowError(Application.Handle,'�������� ��� ������� ������� �.�.');
   cbFio.SetFocus;
   exit;
  end;
  IsOtlogen:=true;
  if AppendToReestr then begin
    IsAlready:=true;
    Close;
  end;
end;

procedure TfmNewForm.bibOtlogenClickTest(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

function TfmNewForm.AppendToReestr: Boolean;
var
  List: TList;
  msOutForm: TMemoryStream;
  D: Variant;
  Words: TStringList;
  Line,Tab: Integer;
  Error: String;
begin
  Result:=false;
  if Trim(edNumReestr.Text)<>'' then begin
    if isNumReestrAlready(Strtoint(edNumReestr.Text),LastTypeReestrID) then begin
      ShowError(Application.Handle,'����� � ������� <'+edNumReestr.Text+'> ��� ����������.');
      edNumReestr.Text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
      edNumReestr.SetFocus;
      exit;
    end;
    DocumentLock(StrToInt(edNumReestr.Text),LastTypeReestrID);
   end;
   msOutForm:=TMemoryStream.Create;
   List:=TList.Create;
   Words:=TStringList.Create;
   try
      if not ExtractDocFile(LastDocId,Trim(cbFio.text)) then exit;
      KeepFileName:=lastFileDoc;
      if not IsOtlogen then begin

       GetParamListByConsts(List,true);

       ProgramExecute(Line,Tab,Error,false,FScript.Text,List);
       if Trim(Error)<>'' then begin
         ShowError(Handle,Error);
       end;

       GetParamListByControls(List);
       GetParamListByConsts(List,false);


       if SetFieldsToWord(List,false,false) then begin
         if not isKeepDoc then begin
          Result:=fAppend(msOutForm,list,Words);
          if Result then ActiveWord;
         end else begin
           if ActiveWordKeepDoc(KeepFileName,true) then begin
             if isAutoBuildWords then begin
               Screen.Cursor:=crHourGlass;
               try
                 D:=GetDocumentRefByFileName(KeepFileName);
                 GetTextByDocument(D,Words);
               finally
                 Screen.Cursor:=crDefault;
               end;
             end;
             Result:=fAppend(msOutForm,list,Words);
           end;
         end;
       end;
      end else begin

       GetParamListByConsts(List,true);

       ProgramExecute(Line,Tab,Error,false,FScript.Text,List);
       if Trim(Error)<>'' then begin
         ShowError(Handle,Error);
       end;

       GetParamListByControls(List);
       GetParamListByConsts(List,false);

       
       if SetFieldsToWord(List,false,false) then begin
         if not isKeepDoc then begin
          Result:=fAppend(msOutForm,list,Words);
          if Result then ActiveWord;
         end else begin
           if ActiveWordKeepDoc(KeepFileName,true) then begin
             if isAutoBuildWords then begin
               Screen.Cursor:=crHourGlass;
               try
                 D:=GetDocumentRefByFileName(KeepFileName);
                 GetTextByDocument(D,Words);
               finally
                 Screen.Cursor:=crDefault;
               end;
             end;
             Result:=fAppend(msOutForm,list,Words);
           end;
         end;
       end;
      end;
   finally
    Words.Free;
    ClearWordObjectList(List);
    List.Free;
    msOutForm.Free;
    if Trim(edNumReestr.Text)<>'' then
      DocumentUnLock(strtoint(edNumReestr.Text),LastTypeReestrID);
   end;
end;

procedure TfmNewForm.EnableOnControl(wt: TWinControl; isEnabled: Boolean);

   procedure EnabledControl(ct: TControl);
   var
     tmpColor: TColor;
   const
     clEnabled=clWindow;
     clDisabled=clBtnFace;
   begin
     if isEnabled then
      tmpColor:=clEnabled
     else tmpColor:=clDisabled;
     ct.Enabled:=isEnabled;
     if ct is TEdit then begin
      if ct<>edHereditaryDeal then
       TEdit(ct).Color:=tmpColor;
     end; 
     if ct is TComboBox then TComboBox(ct).Color:=tmpColor;
     if ct is TRXCalcEdit then
         TRXCalcEdit(ct).Color:=tmpColor;
     if ct is TGroupBox then TGroupBox(ct).Color:=tmpColor;

   end;

var
  i: Integer;
  ct: TControl;
begin
  if Assigned(wt) then
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.controls[i];
      EnabledControl(ct);
      if ct is TWincontrol then begin
        EnableOnControl(TWincontrol(ct),isEnabled);
      end;
    end;
end;

procedure TfmNewForm.cbFioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key='''' then Key:=#0;
end;

procedure TfmNewForm.bibOkClickUpdate(Sender: TObject);
var
  BreakF: Boolean;
  Obj: TInfoBlank;
  NumFrom: Integer;
  NumTo: Integer;
  BlankNum: Variant;
  Num: Integer;
  Flag: Boolean;
  S: String;
begin
//  if not SetEmptyPadegControls then exit;
  if isCheckFieldsFill then
   if isEmptySelfControls(pnDesign,BreakF) then begin
    ShowError(Application.Handle,'���� �� ����� ����� �� ���������.');
    exit;
   end;
  if cbCurReestr.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������.');
   cbCurReestr.SetFocus;
   exit;
  end;
  if cbNumLic.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ��������.');
   cbNumLic.SetFocus;
   exit;
  end;
  if cmbMotion.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������������ ��������.');
   cmbMotion.SetFocus;
   exit;
  end;
  if Trim(cbFio.Text)='' then begin
   ShowError(Application.Handle,'�������� ��� ������� ������� �.�.');
   cbFio.SetFocus;
   exit;
  end;
  if Trim(edDocName.Text)='' then begin
   ShowError(Application.Handle,'������� ������������ ���������');
   edDocName.SetFocus;
   exit;
  end;

  if isCheckEmptySumm then
    if (Trim(edNumReestr.Text)<>'') and (SummEdit.Value=0.0) then begin
     ShowError(Application.Handle,'����� ��� �������� �� ����� ���� ����� 0.');
     SummEdit.SetFocus;
     exit;
    end;

  BlankNum:=GetBlankNum;
  if Assigned(cbBlank) and Assigned(edBlank) and not VarIsNull(BlankNum) then begin
    if cbBlank.ItemIndex<>-1 then begin
      Obj:=TInfoBlank(cbBlank.Items.Objects[cbBlank.ItemIndex]);
      if Assigned(Obj) then begin
        NumFrom:=VarToIntDef(Obj.num_from,0);
        S:='1'+DupeString('0',MaxBlankNumLength);
        NumTo:=VarToIntDef(Obj.num_to,StrToInt(S)-1);
        Num:=VarToIntDef(BlankNum,0);
        Flag:=(NumFrom>Num) or (NumTo<Num);
        if Flag then begin
          ShowError(Application.Handle,'����� ������ �� ������ � �������� �����.');
          edBlank.SetFocus;
          exit;
        end;
      end;
    end;
  end;



{   ProgramExecute(Line,Tab,Error,false,FScript.Text);
   if Trim(Error)<>'' then begin
     ShowError(Handle,Error);
   end;}
    
  SetHereditaryByNotarialAction(true);

  IsOtlogen:=false;
  ChangePeople;
  if UpdateReestr then begin
   IsAlready:=true;

   Close;
  end;
end;

procedure TfmNewForm.bibCancelClickUpdate(Sender: TObject);
begin
  Close;
end;

procedure TfmNewForm.bibOtlogenClickUpdate(Sender: TObject);
begin
  if cbCurReestr.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������.');
   cbCurReestr.SetFocus;
   exit;
  end;
  if cbNumLic.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ��������.');
   cbNumLic.SetFocus;
   exit;
  end;
  if cmbMotion.ItemIndex=-1 then begin
   ShowError(Application.Handle,'�������� ������������ ��������.');
   cmbMotion.SetFocus;
   exit;
  end;
  if Trim(cbFio.Text)='' then begin
   ShowError(Application.Handle,'�������� ��� ������� ������� �.�.');
   cbFio.SetFocus;
   exit;
  end;
  IsOtlogen:=true;
  if UpdateReestr then begin
    IsAlready:=true;
    Close;
  end;
end;

function TfmNewForm.UpdateReestr: Boolean;

var
  List: TList;
  msOutForm: TMemoryStream;
  Words: TStringList;
  D: Variant;
  Line,Tab: Integer;
  Error: String;
begin
  Result:=false;
  if Not isInsert then
   if not IsReestrIDFound then begin
    ShowError(Application.Handle,'��� ������ � ������� ���� �������, �������� ������.');
    close;
    exit;
   end;

   msOutForm:=TMemoryStream.Create;
   List:=TList.Create;
   Words:=TStringList.Create;
   try

     if ViewDoc then begin
      if not ExtractDocFileFromReestr(LastReestrID,Trim(cbFio.text)) then exit;
      KeepFileName:=lastFileDoc;

      GetParamListByConsts(List,true);

      ProgramExecute(Line,Tab,Error,false,FScript.Text,List);
      if Trim(Error)<>'' then begin
        ShowError(Handle,Error);
      end;

      GetParamListByControls(List);
      GetParamListByConsts(List,false);

      
      if SetFieldsToWord(List,false,false) then begin
        if ActiveWordKeepDoc(KeepFileName,true) then begin
          if isAutoBuildWords then begin
            Screen.Cursor:=crHourGlass;
            try
              D:=GetDocumentRefByFileName(KeepFileName);
              GetTextByDocument(D,Words);
            finally
              Screen.Cursor:=crDefault;
            end;  
          end;
          Result:=fUpdate(msOutForm,list,Words);
        end;
      end;
     end else
       Result:=fUpdate(msOutForm,list,Words);

   finally
    Words.Free;
    ClearWordObjectList(List);
    List.Free;
    msOutForm.Free;
   end;
end;

function TfmNewForm.IsReestrIDFound: Boolean;
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
   sqls:='Select reestr_id from '+TableReestr+
         ' where reestr_id='+inttostr(LastReestrID);
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then
    Result:=true;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function TfmNewForm.fUpdate(msOutForm: TMemoryStream; List: TList; Words: TStringList): Boolean;
  var
    tb: TIBTable;
    LicenseID: Integer;
    plusstr: string;
    tr: TIBTransaction;
    docname,tmpname: string;
    whocertificate_id: Integer;
    whocertificate: string;
    msWords: TMemoryStream;
begin

        IsOtlogen:=Trim(edNumReestr.Text)='';

        Screen.Cursor:=crHourGlass;
        tr:=TIBTransaction.Create(nil);
        tb:=TIBTable.Create(nil);
        msWords:=TMemoryStream.Create;
        try
         Result:=false;
         tr.AddDatabase(dm.IBDbase);
         dm.IBDbase.AddTransaction(tr);
         tr.Params.Text:=DefaultTransactionParamsTwo;
         tb.Database:=dm.IBDbase;
         tb.Transaction:=tr;
         tb.Transaction.Active:=true;

         tb.TableName:=TableReestr;
         tb.Filter:=' reestr_id='+inttostr(LastReestrID);
         tb.Filtered:=true;

         tb.Active:=true;
         tb.Transaction.Active:=true;

        // if not tb.Locate('reestr_id',LastReestrID,[loCaseInsensitive]) then exit;

         tb.edit;
         tb.FieldByName('reestr_id').Asinteger:=LastReestrID;
         docname:=Trim(edDocName.Text);
         tb.FieldByName('doc_id').AsInteger:=LastDocId;

         tb.FieldByName('certificatedate').AsDateTime:=StrToDate(DateToStr(dtpCertificateDate.Date))+Time;

         whocertificate_id:=GetWhoCertificateId(whocertificate);
         tb.FieldByName('whocertificate_id').AsInteger:=whocertificate_id;

         tb.FieldByName('datein').AsDateTime:=tb.FieldByName('datein').AsDateTime;
         tb.FieldByName('whoin').AsInteger:=tb.FieldByName('whoin').AsInteger;
         tb.FieldByName('datechange').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
         tb.FieldByName('whochange').AsInteger:=UserId;
         tb.FieldByName('keepdoc').AsInteger:=Integer(isKeepDoc);
         tb.FieldByName('yearwork').AsInteger:=WorkYear;
         tb.FieldByName('typereestr_id').AsInteger:=LastTypeReestrID;

         tb.FieldByName('notarialaction_id').AsInteger:=LastNotarialActionId;
         tb.FieldByName('noyear').AsInteger:=Integer(chbNoYear.Enabled and chbNoYear.Checked);
         tb.FieldByName('defect').AsInteger:=Integer(chbDefect.Enabled and chbDefect.Checked);
         tb.FieldByName('summpriv').AsFloat:=SummEditPriv.Value;

         if not IsOtlogen then begin
          tb.FieldByName('numreestr').AsInteger:=Strtoint(edNumReestr.Text);
          plusstr:=' �� ������� � '+edNumReestr.Text;
         end else begin
          tb.FieldByName('numreestr').Value:=null;
         end;
         tb.FieldByName('fio').AsString:=Trim(cbFio.text);
         tb.FieldByName('summ').AsFloat:=SummEdit.Value;
         tb.FieldByName('sogl').AsInteger:=Integer(chbOnSogl.Checked);

         LicenseID:=0;
         if cbNumLic.ItemIndex<>-1 then
          LicenseID:=Integer(Pointer(cbNumLic.Items.Objects[cbNumLic.ItemIndex]));
         tb.FieldByName('license_id').AsInteger:=LicenseID;

         tmpname:=docname;
         if Trim(tb.FieldByName('parent_id').AsString)='' then
          tb.FieldByName('tmpname').AsString:=tmpname
         else begin
          tb.FieldByName('tmpname').AsString:='����� ('+
               GetOperName(tb.FieldByName('doc_id').AsInteger)+')'+plusstr;
         end;

         tb.FieldByName('countuse').AsInteger:=tb.FieldByName('countuse').AsInteger+1;

         if OldHereditaryDealId<>0 then
           tb.FieldByName('hereditarydeal_id').AsInteger:=OldHereditaryDealId
         else tb.FieldByName('hereditarydeal_id').Value:=NUll;

         tb.FieldByName('blank_id').Value:=GetBlankId;
         tb.FieldByName('blank_num').Value:=GetBlankNum;

         msOutForm.Clear;
         msOutForm.Position:=0;
         PrepeareControlsBeforeSave(pnDesign);
         SaveControlToStream(self,msOutForm);
         msOutForm.Position:=0;
         CompressAndCrypt(msOutForm);
         msOutForm.Position:=0;
         TBlobField(tb.FieldByName('dataform')).LoadFromStream(msOutForm);

         if ViewDoc then begin
           msOutForm.Clear;
           msOutForm.Position:=0;
           SaveDocumentToStream(KeepFileName,msOutForm);
           msOutForm.Position:=0;
           CompressAndCrypt(msOutForm);
           msOutForm.Position:=0;
           TBlobField(tb.FieldByName('datadoc')).LoadFromStream(msOutForm);
         end;

         msWords.Clear;
         msWords.Write(Pointer(Words.Text)^,Length(Words.Text));
         msWords.Position:=0;
         CompressAndCrypt(msWords);
         msWords.Position:=0;
         TBlobField(tb.FieldByName('words')).LoadFromStream(msWords);

         tb.Post;
         tb.Transaction.CommitRetaining;

         fmDocReestr.NeedCacheUpdate(false,
                                     LastReestrID,true,
                                     Iff(not IsOtlogen,iff(trim(edNumReestr.Text)='',Null,Prefix+trim(edNumReestr.Text)+Sufix),Null),true,
                                     Iff(not IsOtlogen,iff(trim(edNumReestr.Text)='',Null,trim(edNumReestr.Text)),Null),true,
                                     docname,true,
                                     Null,true,
                                     Trim(cbFio.text),true,
                                     SummEdit.Value,true,
                                     Null,false,
                                     Null,false,
                                     LastDocId,true,
                                     Null,true,
                                     LastTypeReestrID,true,
                                     Null,false,
                                     Integer(chbOnSogl.Checked),true,
                                     LicenseID,true,
                                     tmpName,true,
                                     Null,true,
                                     True,true,
                                     UserId,true,
                                     StrToDate(DateToStr(WorkDate))+Time,true,
                                     UserName,true,
                                     Integer(chbNoYear.Enabled and chbNoYear.Checked),true,
                                     Integer(chbDefect.Enabled and chbDefect.Checked),true,
                                     SummEditPriv.Value,true,
                                     LastNotarialActionId,true,
                                     Trim(cmbMotion.Text),true,
                                     Null,false,
                                     Null,false,
                                     Null,false,
                                     iff(OldHereditaryDealId<>0,OldHereditaryDealNum,Null),true,
                                     iff(OldHereditaryDealId<>0,OldHereditaryDealDate,Null),true,
                                     OldHereditaryDealId,true,
                                     StrToDate(DateToStr(dtpCertificateDate.Date))+Time,true,
                                     whocertificate,true,
                                     whocertificate_id,true,
                                     GetBlankId,GetBlankSeries,GetBlankNum);

         Result:=true;
        finally
         msWords.Free;
         tb.Free;
         tr.Free;
       {  fmDocReestr.Mainqr.Active:=false;
         fmDocReestr.Mainqr.Active:=true;
         fmDocReestr.Mainqr.locate('reestr_id',LastReestrID,[loCaseInsensitive]);
         fmDocReestr.ViewCount;}
         Screen.Cursor:=crDefault;
        end;
end;

function TfmNewForm.GetWhoCertificateId(var whocertificate: string): Integer;
var
  PInNot: PInfoNotarius;
  PHelper: PInfoNotarius;
  PITR: PInfoTypeReestr;
  IHI: TInfoHelperItem;

begin
  New(PInNot);
  New(PHelper);
  try
   IHI:=TInfoHelperItem(fmMain.cmbHelper.Items.Objects[fmMain.cmbHelper.ItemIndex]);
   if not Assigned(IHI) then begin
     FillChar(PInNot^,SizeOf(PInNot),0);
     PITR:=Pointer(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex]));
     GetInfoNotarius(PITR.typereestr_id,PInNot,RenovationId);
     whocertificate:=PInNot.FIO;
     Result:=PInNot.not_id;
   end else begin
     FillChar(PHelper^,SizeOf(PHelper),0);
     GetInfoNotariusEx(IHI.NotId,PHelper,RenovationId,true,false,false);
     whocertificate:=PHelper.FIO;
     Result:=PHelper.not_id;
   end;
 finally
   Dispose(PHelper);
   Dispose(PInNot);
 end;
end;

function TfmNewForm.fAppend(msOutForm: TMemoryStream; List: TList; Words: TStringList): Boolean;
var
  tb: TIBTable;
  LicenseID: Integer;
  tr: TIBTransaction;
  reestr_id: Integer;
  docname: string;
  whocertificate_id: Integer;
  whocertificate: string;
  tmpname: string;
  msWords: TMemoryStream;
begin

    IsOtlogen:=iff(Trim(edNumReestr.Text)='',true,false);

    Screen.Cursor:=crHourGlass;
    tr:=TIBTransaction.Create(nil);
    tb:=TIBTable.Create(nil);
    msWords:=TMemoryStream.Create;
    try
     reestr_id:=fmDocReestr.GetMaxReestrID;
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     tb.Database:=dm.IBDbase;
     tb.Transaction:=tr;
     tb.Transaction.Active:=true;
     tb.BufferChunks:=50;
     tb.TableName:=TableReestr;
     tb.Filter:=' reestr_id='+inttostr(reestr_id)+' ';
     tb.Filtered:=true;
     tb.Active:=true;
     tb.Append;

     tb.FieldByName('reestr_id').AsInteger:=reestr_id;
     tb.FieldByName('certificatedate').AsDateTime:=StrToDate(DateToStr(dtpCertificateDate.Date))+Time;
     whocertificate_id:=GetWhoCertificateId(whocertificate);
     tb.FieldByName('whocertificate_id').AsInteger:=whocertificate_id;
     docname:=Trim(edDocName.Text);
     tb.FieldByName('doc_id').AsInteger:=LastDocId;

     tb.FieldByName('datein').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
     tb.FieldByName('whoin').AsInteger:=UserId;
     tb.FieldByName('datechange').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
     tb.FieldByName('whochange').AsInteger:=UserId;
     tb.FieldByName('keepdoc').AsInteger:=Integer(isKeepDoc);
     tb.FieldByName('yearwork').AsInteger:=WorkYear;

     tb.FieldByName('notarialaction_id').AsInteger:=LastNotarialActionId;
     tb.FieldByName('noyear').AsInteger:=Integer(chbNoYear.Enabled and chbNoYear.Checked);
     tb.FieldByName('defect').AsInteger:=Integer(chbDefect.Enabled and chbDefect.Checked);
     tb.FieldByName('summpriv').AsFloat:=SummEditPriv.Value;

     tb.FieldByName('typereestr_id').AsInteger:=LastTypeReestrID;
     if not IsOtlogen then
      tb.FieldByName('numreestr').AsInteger:=Strtoint(edNumReestr.Text);
     tb.FieldByName('fio').AsString:=Trim(cbFio.text);
     tb.FieldByName('summ').AsFloat:=SummEdit.Value;

     tb.FieldByName('sogl').AsInteger:=Integer(chbOnSogl.Checked);

     LicenseID:=0;
     if cbNumLic.ItemIndex<>-1 then
      LicenseID:=Integer(Pointer(cbNumLic.Items.Objects[cbNumLic.ItemIndex]));
     tb.FieldByName('license_id').AsInteger:=LicenseID;

     tmpname:=docname;
     tb.FieldByName('tmpname').AsString:=tmpname;

     tb.FieldByName('countuse').AsInteger:=1;
     if OldHereditaryDealId<>0 then
      tb.FieldByName('hereditarydeal_id').AsInteger:=OldHereditaryDealId;

     tb.FieldByName('blank_id').Value:=GetBlankId;
     tb.FieldByName('blank_num').Value:=GetBlankNum;

     msOutForm.Clear;
     msOutForm.Position:=0;
     PrepeareControlsBeforeSave(pnDesign);
     SaveControlToStream(self,msOutForm);
     msOutForm.Position:=0;
     CompressAndCrypt(msOutForm);
     msOutForm.Position:=0;
     TBlobField(tb.FieldByName('dataform')).LoadFromStream(msOutForm);
     msOutForm.Clear;
     msOutForm.Position:=0;
     SaveDocumentToStream(KeepFileName,msOutForm);
     msOutForm.Position:=0;
     CompressAndCrypt(msOutForm);
     msOutForm.Position:=0;
     TBlobField(tb.FieldByName('datadoc')).LoadFromStream(msOutForm);

     msWords.Clear;
     msWords.Write(Pointer(Words.Text)^,Length(Words.Text));
     msWords.Position:=0;
     CompressAndCrypt(msWords);
     msWords.Position:=0;
     TBlobField(tb.FieldByName('words')).LoadFromStream(msWords);

     tb.Post;
     tb.Transaction.CommitRetaining;

     fmDocReestr.NeedCacheUpdate(true,
                                 reestr_id,true,
                                 Iff(not IsOtlogen,Prefix+trim(edNumReestr.Text)+Sufix,Null),true,
                                 Iff(not IsOtlogen,trim(edNumReestr.Text),Null),true,
                                 docname,true,
                                 Null,true,
                                 Trim(cbFio.text),true,
                                 SummEdit.Value,true,
                                 StrToDate(DateToStr(WorkDate))+Time,true,
                                 UserName,true,
                                 LastDocId,true,
                                 Null,true,
                                 LastTypeReestrID,true,
                                 UserId,true,
                                 Integer(chbOnSogl.Checked),true,
                                 LicenseID,true,
                                 tmpName,true,
                                 Null,true,
                                 True,true,
                                 UserId,true,
                                 StrToDate(DateToStr(WorkDate))+Time,true,
                                 UserName,true,
                                 Integer(chbNoYear.Enabled and chbNoYear.Checked),true,
                                 Integer(chbDefect.Enabled and chbDefect.Checked),true,
                                 SummEditPriv.Value,true,
                                 LastNotarialActionId,true,
                                 Trim(cmbMotion.Text),true,
                                 Null,true,
                                 Null,true,
                                 Null,true,
                                 iff(OldHereditaryDealId<>0,OldHereditaryDealNum,Null),true,
                                 iff(OldHereditaryDealId<>0,OldHereditaryDealDate,Null),true,
                                 OldHereditaryDealId,true,
                                 StrToDate(DateToStr(dtpCertificateDate.Date))+Time,true,
                                 whocertificate,true,
                                 whocertificate_id,true,
                                 GetBlankId,GetBlankSeries,GetBlankNum);


     Result:=true;
    finally
     msWords.Free;
     tb.Free;
     tr.Free;
{     fmDocReestr.Mainqr.locate('reestr_id',fmDocReestr.GetMaxReestrID-1,[loCaseInsensitive]);
     fmDocReestr.RecordCount:=fmDocReestr.RecordCount+1;
     fmDocReestr.Mainqr.Active:=false;
     fmDocReestr.Mainqr.Active:=true;
     fmDocReestr.Mainqr.locate('reestr_id',fmDocReestr.GetMaxReestrID-1,[loCaseInsensitive]);}
     fmDocReestr.ViewCount;
     Screen.Cursor:=crDefault;
   end;
end;

function TfmNewForm.CheckPadeg(ct: TControl; TypeCase: TTypeCase): Boolean;
  const
   propName='TypeCase';
  var
   EnumProp: Integer;
  begin
    Result:=false;
    if IsPublishedProp(ct,propName)then begin
     EnumProp:=GetOrdProp(ct,PropName);
     if TTypeCase(EnumProp)=TypeCase then begin
       Result:=true;
       exit;
     end;
    end;
end;

procedure TfmNewForm.GetListImenitControls(wt: TWinControl; List: TList);
  var
    i: Integer;
    ct: TControl;
  begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      if ct is TWinControl then begin
        GetListImenitControls(TWinControl(ct),List);
      end;
      if CheckPadeg(ct,tcIminit)then
       List.Add(ct);
    end;
end;

function TfmNewForm.GetFieldNameFromTypeCase(TypeCase: TTypeCase): string;
var
  tmpname: String;
begin
   case TypeCase of
     tcIminit:tmpname:='nomin';
     tcRodit: tmpname:='genit';
     tcDatel: tmpname:='dativ';
     tcTvorit:tmpname:='creat';
     tcVinit: tmpname:='vinit';
     tcPredl: tmpname:='predl';
   end;
   Result:=tmpname;
end;

function TfmNewForm.GetPadegFromRBCase(ImenitText: String; TypeCase: TTypeCase): String;
var
  qr: TIBQuery;
  sqls: String;
  tmpname: string;
  f,i,o: string;
  pf,pi,po: string;
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
   tmpname:=GetFieldNameFromTypeCase(TypeCase);
   ExtractWord(IMenitText,f,i,o,' ');

   qr.Active:=false;
   qr.SQL.Clear;
   sqls:='Select '+tmpname+' from '+TableCase+' where '+
         GetFieldNameFromTypeCase(tcIminit)+'='''+f+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount=1 then
    pf:=Trim(qr.fieldbyname(tmpname).AsString);

   qr.Active:=false;
   qr.SQL.Clear;
   sqls:='Select '+tmpname+' from '+TableCase+' where '+
         GetFieldNameFromTypeCase(tcIminit)+'='''+i+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount=1 then
    pi:=Trim(qr.fieldbyname(tmpname).AsString);

   qr.Active:=false;
   qr.SQL.Clear;
   sqls:='Select '+tmpname+' from '+TableCase+' where '+
         GetFieldNameFromTypeCase(tcIminit)+'='''+o+'''';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount=1 then
    po:=Trim(qr.fieldbyname(tmpname).AsString);

   Result:=pf+' '+pi+' '+po;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;


function TfmNewForm.SetEmptyPadegControls(Value: TControl): Boolean;

type

  PinfoPadeg=^TInfoPadeg;
  TInfoPadeg=packed record
    ct: TControl;
    TypeCase: TTypeCase;
  end;

  PInfoPagedAll=^TInfoPagedAll;
  TInfoPagedAll=packed record
    Iminit,Rodit,Datel,Tvorit,Vinit,Predl: string;
  end;


  procedure GetListAllPadegForControl(ct: TControl; NewList: TList);

    procedure AddToNewList(ctNew: TControl; TypeCase: TTypeCase);
    var
      P: PinfoPadeg;
    begin
      New(P);
      P.ct:=ctNew;
      P.TypeCase:=TypeCase;
      NewList.Add(P);
    end;

  var
   i: Integer;
   ctnew: TControl;
  begin
   if ct.Parent=nil then exit;
   for i:=0 to ct.Parent.ControlCount-1 do begin
     ctnew:=ct.Parent.Controls[i];
     if CheckPadeg(ctnew,tcIminit)then AddToNewList(ctnew,tcIminit);
     if CheckPadeg(ctnew,tcRodit)then AddToNewList(ctnew,tcRodit);
     if CheckPadeg(ctnew,tcDatel)then AddToNewList(ctnew,tcDatel);
     if CheckPadeg(ctnew,tcTvorit)then AddToNewList(ctnew,tcTvorit);
     if CheckPadeg(ctnew,tcVinit)then AddToNewList(ctnew,tcVinit);
     if CheckPadeg(ctnew,tcPredl)then AddToNewList(ctnew,tcPredl);
   end;
  end;

  procedure ClearNewList(newList: TList);
  var
    P: PInfoPadeg;
    i: Integer;
  begin
    for i:=0 to newList.Count-1 do begin
      P:=newList.Items[i];
      Dispose(P);
    end;
  end;

  function GetText(ct: TControl): String;
  begin
    Result:='';
    if ct is TNewLabel then Result:=TNewLabel(ct).Caption;
    if ct is TNewEdit then Result:=TNewEdit(ct).Text;
    if ct is TNewComboBox then Result:=TNewComboBox(ct).Text;
    if ct is TNewMemo then Result:=TNewMemo(ct).Lines.Text;
    if ct is TNewCheckBox then Result:=TNewCheckBox(ct).Text;
    if ct is TNewRadioButton then Result:=TNewRadioButton(ct).Text;
    if ct is TNewListBox then begin
     if TNewListBox(ct).Items.Count>0 then
      Result:=TNewListBox(ct).Items.Strings[TNewListBox(ct).itemindex];
    end; 
    if ct is TNewRadioGroup then begin
     if TNewRadioGroup(ct).Items.Count>0 then
      Result:=TNewRadioGroup(ct).Items.Strings[TNewRadioGroup(ct).ItemIndex];
    end;
    if ct is TNewMaskEdit then Result:=TNewMaskEdit(ct).Text;
    if ct is TNewRichEdit then Result:=TNewRichEdit(ct).Lines.Text;
  end;

  procedure SetTextFromPadeg(ct: TControl; PadegStr: String);
  begin
    if ct is TNewLabel then TNewLabel(ct).Caption:=PadegStr;
    if ct is TNewEdit then TNewEdit(ct).Text:=PadegStr;
    if ct is TNewComboBox then TNewComboBox(ct).Text:=PadegStr;
    if ct is TNewMemo then TNewMemo(ct).Lines.Text:=PadegStr;
    if ct is TNewCheckBox then TNewCheckBox(ct).Text:=PadegStr;
    if ct is TNewRadioButton then TNewRadioButton(ct).Text:=PadegStr;
    if ct is TNewListBox then begin
     if TNewListBox(ct).Items.Count>0 then
      TNewListBox(ct).Items.Strings[TNewListBox(ct).itemindex]:=PadegStr;
    end;
    if ct is TNewRadioGroup then begin
     if TNewRadioGroup(ct).Items.Count>0 then
      TNewRadioGroup(ct).Items.Strings[TNewRadioGroup(ct).ItemIndex]:=PadegStr;
    end;
    if ct is TNewMaskEdit then TNewMaskEdit(ct).Text:=PadegStr;
    if ct is TNewRichEdit then TNewRichEdit(ct).Lines.Text:=PadegStr;
  end;

  procedure SetControlsState(fm: TfmEditCase; NewList: TList; ImenitText: String;
                             RText,DText,TText,VText,PText: string);
  var
    i: Integer;
    P: PinfoPadeg;
  begin
    fm.bibOk.OnClick:=fm.AddCaseOkClick;
    fm.Caption:=captionAdd+' ������';

    fm.edNomin.Text:=ImenitText;
    fm.edNomin.ReadOnly:=true;
    fm.edNomin.Color:=clBtnFace;

    fm.edGenit.Text:=RText;
    fm.edGenit.ReadOnly:=true;
    fm.edGenit.Color:=clBtnFace;

    fm.edDativ.Text:=DText;
    fm.edDativ.ReadOnly:=true;
    fm.edDativ.Color:=clBtnFace;

    fm.edCreat.Text:=TText;
    fm.edCreat.ReadOnly:=true;
    fm.edCreat.Color:=clBtnFace;

    fm.edVinit.Text:=VText;
    fm.edVinit.ReadOnly:=true;
    fm.edVinit.Color:=clBtnFace;

    fm.edPredl.Text:=PText;
    fm.edPredl.ReadOnly:=true;
    fm.edPredl.Color:=clBtnFace;

    for i:=0 to NewList.Count-1 do begin
      P:=NewlIst.Items[i];
      case P.TypeCase of
        tcIminit: begin
//         fm.edNomin.Text:='';
         fm.edNomin.ReadOnly:=false;
         fm.edNomin.Color:=clWindow;
        end;
        tcRodit: begin
         fm.edGenit.Text:='';
         fm.edGenit.ReadOnly:=false;
         fm.edGenit.Color:=clWindow;
        end;
        tcDatel: begin
         fm.edDativ.Text:='';
         fm.edDativ.ReadOnly:=false;
         fm.edDativ.Color:=clWindow;
        end;
        tcTvorit: begin
         fm.edCreat.Text:='';
         fm.edCreat.ReadOnly:=false;
         fm.edCreat.Color:=clWindow;
        end;
        tcVinit: begin
         fm.edVinit.Text:='';
         fm.edVinit.ReadOnly:=false;
         fm.edVinit.Color:=clWindow;
        end;
        tcPredl: begin
         fm.edPredl.Text:='';
         fm.edPredl.ReadOnly:=false;
         fm.edPredl.Color:=clWindow;
        end;
      end;

    end;
  end;

  function InsertIntoRBCase(fm: TfmEditCase; Newlist: TList; IMenitText: String): Boolean;

  type
    TFIO=(tfa,tim,tot);

    function GetValueFio(TypeCase: TTypeCase; Typefio: TFio): string;
    var
      j: Integer;
      P: PInfoPadeg;
      tmps: string;
      f,i,o: string;
    begin
      Result:='';
      for j:=0 to Newlist.Count-1 do begin
        P:=Newlist.Items[j];
        if P.TypeCase=TypeCase Then begin
          tmps:=Gettext(P.ct);
          ExtractWord(tmps,f,i,o,' ');
          case TypeFio of
            tfa: Result:=f;
            tim: Result:=i;
            tot: Result:=o;
          end;
          exit;
        end;
      end;

    end;

  var
    qr: TIBQuery;
    sqls: String;
    f,i,o: string;
    P: PInfoPagedAll;
    tr: TIBTransaction;
  begin
    Result:=false;
    if NewList.Count=0 then exit;
    Screen.Cursor:=crHourGlass;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    New(P);
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     ExtractWord(IMenitText,f,i,o,' ');
     if Trim(f)<>'' then begin
//      if not PadegExists(f, P)
      sqls:='Insert into '+TableCase+' (nomin,genit,dativ,creat,vinit,predl) '+
           ' values ('''+f+
           ''','''+GetValueFio(tcRodit,tfa)+
           ''','''+GetValueFio(tcDatel,tfa)+
           ''','''+GetValueFio(tcTvorit,tfa)+
           ''','''+GetValueFio(tcVinit,tfa)+
           ''','''+GetValueFio(tcPredl,tfa)+''')';
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.CommitRetaining;
      qr.SQL.Clear;
     end;
     if Trim(i)<>'' then begin
      sqls:='Insert into '+TableCase+' (nomin,genit,dativ,creat,vinit,predl) '+
           ' values ('''+i+
           ''','''+GetValueFio(tcRodit,tim)+
           ''','''+GetValueFio(tcDatel,tim)+
           ''','''+GetValueFio(tcTvorit,tim)+
           ''','''+GetValueFio(tcVinit,tim)+
           ''','''+GetValueFio(tcPredl,tim)+''')';
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.CommitRetaining;
      qr.SQL.Clear;
     end;
     if Trim(o)<>'' then begin
      sqls:='Insert into '+TableCase+' (nomin,genit,dativ,creat,vinit,predl) '+
           ' values ('''+o+
           ''','''+GetValueFio(tcRodit,tot)+
           ''','''+GetValueFio(tcDatel,tot)+
           ''','''+GetValueFio(tcTvorit,tot)+
           ''','''+GetValueFio(tcVinit,tot)+
           ''','''+GetValueFio(tcPredl,tot)+''')';
      qr.SQL.Add(sqls);
      qr.ExecSQL;
      qr.Transaction.CommitRetaining;
     end;
     Result:=true;
    finally
     dispose(p);
     qr.Free;
     tr.Free;
     Screen.Cursor:=crDefault;
    end;
  end;

  function SetAllPadegControls(ImenitText: String; NewList: TList): Boolean;
  var
    i: Integer;
    P: PInfoPadeg;
    retPadeg: ShortString;
    fm: TfmEditCase;
    RText,DText,TText,VText,PText: string;

    procedure SetPadegCur(Text: string; TypeCase: TTypecase);
    begin
      case TypeCase of
        tcRodit: RText:=Text;
        tcDatel: DText:=Text;
        tcTvorit:TText:=Text;
        tcVinit:VText:=Text;
        tcPredl: PText:=Text;
      end;
    end;

    procedure SetControlFromList(fmNew: TfmEditCase; NewList: TList);
    var
      i: Integer;
      P: PinfoPadeg;
    begin
      for i:=0 to NewList.Count-1 do begin
        P:=NewList.Items[i];
        case p.TypeCase of
          tcIminit: SetTextFromPadeg(P.ct,fmNew.edNomin.Text);
          tcRodit: SetTextFromPadeg(P.ct,fmNew.edGenit.Text);
          tcDatel: SetTextFromPadeg(P.ct,fmNew.edDativ.Text);
          tcTvorit:SetTextFromPadeg(P.ct,fmNew.edCreat.Text);
          tcVinit: SetTextFromPadeg(P.ct,fmNew.edVinit.Text);
          tcPredl: SetTextFromPadeg(P.ct,fmNew.edPredl.Text);

        end;
      end;
    end;

    function TranslatePadeg(IT,padeg: String): string;

      function CheckUpper(ch:char): Boolean;
      begin
        Result:=false;
        if ((Ch >= 'A') and (Ch <= 'Z'))or
           ((Ch >= '�') and (Ch <= '�')) then begin
          Result:=true;
        end;
      end;
       
    var
      ch1,ch2: char;
      f1,f2: Boolean;
    begin
      Result:=padeg;
      if length(IT)>1 then begin
        ch1:=IT[1];
        f1:=CheckUpper(ch1);
        ch2:=IT[2];
        f2:=CheckUpper(ch2);
        if not f1 then begin
          Result:=AnsiLowerCase(padeg);
          exit;
        end;
        if f2 then begin
          Result:=AnsiUpperCase(padeg);
          exit;
        end;
      end;
    end;

  begin
    for i:=NewList.Count-1 downto 0 do begin
      P:=NewList.Items[i];
      if P.TypeCase=tcIminit then begin
       if Trim(ImenitText)='' then begin

       end else begin
        dispose(p);
        NewList.Delete(i);
       end;
      end else begin
       retPadeg:=GetPadegStr(ImenitText,P.TypeCase);
       retPadeg:=TranslatePadeg(ImenitText,retPadeg);
       if AnsiUpperCase(retPadeg)<>AnsiUpperCase(ImenitText) then begin
        SetTextFromPadeg(P.ct,retPadeg);
        SetPadegCur(retPadeg,P.TypeCase);
        dispose(p);
        NewList.Delete(i);
       end else begin
        retPadeg:=Trim(GetPadegFromRBCase(ImenitText,P.TypeCase));
        if retPadeg<>'' then begin
         if AnsiUpperCase(retPadeg)<>AnsiUpperCase(ImenitText) then begin
          SetTextFromPadeg(P.ct,retPadeg);
          SetPadegCur(retPadeg,P.TypeCase);
          dispose(p);
          NewList.Delete(i);
         end;
        end;
       end;
      end;
    end;
    result:=true;
    if (NewList.Count>0)and(Trim(ImenitText)<>'') then begin
     fm:=TfmEditCase.Create(nil);
     try
      SetControlsState(fm,NewList,ImenitText,RText,DText,TText,VText,PText);
      result:=false;
      if fm.ShowModal=mrOk then begin
        SetControlFromList(fm,NewList);
       if InsertIntoRBCase(fm,Newlist,fm.edNomin.Text) then begin
         result:=true;
       end;
      end;
     finally
      fm.Free;
     end;
    end;
  end;

var
  List: TList;
  i: Integer;
  ct: TControl;
  newList: TList;
  ImenitText: String;
begin
  Result:=false;
  if not Assigned(pnDesign) then exit;

  List:=TList.Create;
  newList:=TList.Create;
  try
   Result:=true;
   GetListImenitControls(pnDesign,List);
   for i:=0 to List.Count-1 do begin
     ct:=List.Items[i];
     if ct=Value then begin
      ImenitText:=Trim(toTrimSpaceForOne(GetText(ct)));
      SetTextFromPadeg(ct,ImenitText);
      newList.Clear;
      GetListAllPadegForControl(ct,NewList);
      if not SetAllPadegControls(ImenitText,NewList) then begin
       Result:=false;
       exit;
      end;
     end;
   end;
  finally
   ClearNewList(newList);
   newList.Free;
   List.Free;
  end;
end;

procedure TfmNewForm.SetOnExitForImenitControl;

  procedure SetOnExit(wt: TWinControl);

    procedure SetOnExitProp(ct: TControl);
    begin
     if ct is TNewEdit then TNewEdit(ct).OnExit:=ControlPagedOnExit;
     if ct is TNewComboBox then TNewComboBox(ct).OnExit:=ControlPagedOnExit;
     if ct is TNewMemo then TNewMemo(ct).OnExit:=ControlPagedOnExit;
     if ct is TNewCheckBox then TNewCheckBox(ct).OnExit:=ControlPagedOnExit;
     if ct is TNewRadioButton then TNewRadioButton(ct).OnExit:=ControlPagedOnExit;
     if ct is TNewListBox then  TNewListBox(ct).OnExit:=ControlPagedOnExit;
     if ct is TNewRadioGroup then TNewRadioGroup(ct).OnExit:=ControlPagedOnExit;
     if ct is TNewMaskEdit then TNewMaskEdit(ct).OnExit:=ControlPagedOnExit;
     if ct is TNewRichEdit then TNewRichEdit(ct).OnExit:=ControlPagedOnExit;
    end;

  var
    i: integer;
    ct: TControl;
  begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      if isControlConsistPropPadegAndEqual(ct,tcIminit) then begin
        SetOnExitProp(ct);
      end;
      if ct is TWincontrol then begin
        SetOnExit(TWincontrol(ct));
      end;
    end;
  end;

begin
  if not Assigned(pndesign) then exit;
  SetOnExit(pndesign);
end;

procedure TfmNewForm.SetScript(const Value: TStrings);
begin
  FScript.Assign(Value);
end;

procedure TfmNewForm.ControlPagedOnExit(Sender: TObject);
begin
  if Sender is TControl then
   SetEmptyPadegControls(TControl(sender));
end;

procedure TfmNewForm.PrepeareControlsBeforeSave(wt: TWincontrol);

  procedure PrepControl(ct: TControl);
  begin
    if ct is TNewComboBoxMarkCar then begin
     TNewComboBoxMarkCar(ct).AddMarkCar;
     TNewComboBoxMarkCar(ct).Items.Clear;
    end;
    if ct is TNewComboBoxColor then begin
     TNewComboBoxColor(ct).AddColor;
     TNewComboBoxColor(ct).Items.Clear;
    end;
  end;

var
    i: Integer;
    ct: TControl;
begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      PrepControl(ct);
      if ct is TWincontrol then begin
        PrepeareControlsBeforeSave(TWincontrol(ct));
      end;
    end;
end;

procedure TfmNewForm.PrepeareControlsAfterLoad(wt: TWincontrol);

  procedure PrepControl(ct: TControl);
  begin
    if ct is TNewComboBoxMarkCar then TNewComboBoxMarkCar(ct).FillMarkCar;
    if ct is TNewComboBoxColor then TNewComboBoxColor(ct).FillColor;
    if ct is TNewComboBox then TNewComboBox(ct).FillSubs; 
    if ct is TNewListBox then TNewListBox(ct).FillSubs;
    if ct is TNewRadioGroup then TNewRadioGroup(ct).FillSubs;

  end;

var
    i: Integer;
    ct: TControl;
begin
    for i:=0 to wt.ControlCount-1 do begin
      ct:=wt.Controls[i];
      PrepControl(ct);
      if ct is TWincontrol then begin
        PrepeareControlsAfterLoad(TWincontrol(ct));
      end;
    end;
end;

procedure TfmNewForm.cbNumLicChange(Sender: TObject);
begin

end;

procedure TfmNewForm.CMDialogKey(var Message: TCMDialogKey);
var
 pt: TWinControl;
 nextctl: TWinControl;
 tsOld,tsNew: TTabSheet;
begin
  if GetKeyState(VK_MENU) >= 0 then
    with Message do
      case CharCode of
        VK_TAB:
           if GetKeyState(VK_CONTROL) >= 0 then begin
            if ActiveControl<>nil then begin
             pt:=ActiveControl.Parent;
             nextctl:=FindNextControl(ActiveControl, GetKeyState(VK_SHIFT) >= 0, True, false);
             if (pt<>nil) then begin
               if (nextctl<>nil) then begin
//                 if (nextctl.Parent<>pt) then begin
                   tsOld:=GetParentTabSheet(pt);
                   tsNew:=GetParentTabSheet(nextctl.Parent);
                   if tsOld<>tsNew then begin
                     if tsOld<>nil then begin
                      if tsOld.PageControl<>nil then begin
                       if not (GetKeyState(VK_SHIFT) >= 0) then begin
                         if tsOld.PageControl.ActivePageIndex>0 then begin
                          tsOld.PageControl.SelectNextPage(false);
                          LocateLastControl(tsOld.PageControl.ActivePage);
                          Result:=1;
                          exit;
                         end;
                       end else begin
                         if tsOld.PageControl.ActivePageIndex<
                              tsOld.PageControl.PageCount-1 then begin
                            tsOld.PageControl.SelectNextPage(true);
                            Result:=1;
                            exit;
                         end;
                       end;
                      end;
                   end;
//                  end;
           {       if (pt is TTabSheet) then begin
                   if TTabSheet(pt).PageControl<>nil then begin
                     if not (GetKeyState(VK_SHIFT) >= 0) then begin
                       if TTabSheet(pt).PageControl.ActivePageIndex>0 then begin
                        TTabSheet(pt).PageControl.SelectNextPage(false);
                        LocateLastControl(TTabSheet(pt).PageControl.ActivePage);
                        Result:=1;
                        exit;
                       end;
                     end else begin
                       if TTabSheet(pt).PageControl.ActivePageIndex<
                            TTabSheet(pt).PageControl.PageCount-1 then begin
                          TTabSheet(pt).PageControl.SelectNextPage(true);
                          Result:=1;
                          exit;
                       end;
                     end;
                    end;
                  end else begin
                    if pt is TScrollBox then begin
                      if (pt.Parent<>nil) and (pt.Parent is TTabSheet) then begin
                         if TTabSheet(pt.Parent).PageControl<>nil then begin
                           if not (GetKeyState(VK_SHIFT) >= 0) then begin
                             if TTabSheet(pt.Parent).PageControl.ActivePageIndex>0 then begin
                              TTabSheet(pt.Parent).PageControl.SelectNextPage(false);
                              LocateLastControl(TTabSheet(pt.Parent).PageControl.ActivePage);
                              Result:=1;
                              exit;
                             end;
                           end else begin
                             if TTabSheet(pt.Parent).PageControl.ActivePageIndex<
                                  TTabSheet(pt.Parent).PageControl.PageCount-1 then begin
                                TTabSheet(pt.Parent).PageControl.SelectNextPage(true);
                                Result:=1;
                                exit;
                             end;
                           end;
                          end;
                      end;
                    end;
                  end;  }
                 end;
               end;
             end;
            end;
            SelectNext(ActiveControl, GetKeyState(VK_SHIFT) >= 0, True);
            Result := 1;
            Exit;
          end;
      end;
  inherited;
end;

procedure TfmNewForm.OnShowTest(Sender: TObject);
begin
  LocateFirstFocusedControl;
end;

procedure TfmNewForm.LocateLastControl(wtnew: TWinControl);

  function LocateTabOrderControl(wt: TWinControl): Boolean;
  var
    list: TList;
    i: Integer;
    ct: TWinControl;
  begin
    list:=TList.Create;
    try
      Result:=false;
      wt.GetTabOrderList(list);
      for i:=lIst.Count-1 downto 0 do begin
        ct:=TWinControl(lIst.items[i]);
        if ct.Visible and
           ct.Enabled and
           ct.TabStop and ct.CanFocus then begin
          ct.SetFocus;
          exit;
        end;
      end;

    finally
      List.Free;
    end;
  end;

begin
  LocateTabOrderControl(wtnew);
end;

{procedure TfmNewForm.IncludeComponentsStateForAll(Flag: Boolean; State: TComponentState);
var
  i: Integer;
  cmpt: TComponent;
begin
  for i:=0 to ComponentCount-1 do begin
    cmpt:=Components[i];
    if Flag then
     cmpt.ComponentState:=cmpt.ComponentState+state
    else
     cmpt.ComponentState:=cmpt.ComponentState-state;
  end;
end;}

procedure TfmNewForm.DestroyHeaderAndCreateNew;

   procedure DestroyHeader;
   var
     i: Integer;
     ct: TControl;
   begin
     if FindComponent('SummEdit')<>nil then begin
       ct:=TControl(FindComponent('SummEdit'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free; 
     end;
     if FindComponent('SummEditPriv')<>nil then begin
       ct:=TControl(FindComponent('SummEditPriv'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('lbHereditaryDeal')<>nil then begin
       ct:=TControl(FindComponent('lbHereditaryDeal'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('edHereditaryDeal')<>nil then begin
       ct:=TControl(FindComponent('edHereditaryDeal'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('btHereditaryDeal')<>nil then begin
       ct:=TControl(FindComponent('btHereditaryDeal'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('lbCompanyName')<>nil then begin
       ct:=TControl(FindComponent('lbCompanyName'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('lbNumReestr')<>nil then begin
       ct:=TControl(FindComponent('lbNumReestr'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('edNumReestr')<>nil then begin
       ct:=TControl(FindComponent('edNumReestr'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;
     
     if FindComponent('btNextNumReestr')<>nil then begin
       ct:=TControl(FindComponent('btNextNumReestr'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('lbBlank')<>nil then begin
       ct:=TControl(FindComponent('lbBlank'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('cbBlank')<>nil then begin
       ct:=TControl(FindComponent('cbBlank'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('edBlank')<>nil then begin
       ct:=TControl(FindComponent('edBlank'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('pnReminder')<>nil then begin
       ct:=TControl(FindComponent('pnReminder'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if FindComponent('pnMarquee')<>nil then begin
       ct:=TControl(FindComponent('pnMarquee'));
       if ct.Parent<>nil then
        ct.Parent.RemoveControl(ct);
       ct.Free;
     end;

     if Assigned(grbDoplnit) then
       for i:=grbDoplnit.ControlCount-1 downto 0 do begin
         ct:=grbDoplnit.Controls[i];
         grbDoplnit.RemoveControl(ct);
         ct.Free;
       end;

   end;


   procedure CreateHeader;
   var
     lb: TLabel;
     ed: TEdit;
     se: TRxCalcEdit;
     ch: TCheckBox;
     cb: TComboBox;
     bt: TButton;
     rlb: TantAngleLabel;
     sb: TScrollBox;
     dtp: TDateTimePicker;
     pn: TPanel;
     pnM: TddgMarquee;
     Buffer: string;
   begin
     pnTop.Height:=132;
     sb:=TScrollBox.Create(Self);
     sb.Parent:=grbDoplnit;
     sb.Align:=alClient;
     sb.BorderStyle:=bsNone;
     sb.VertScrollBar.Margin:=5;

     lb:=TLabel.Create(Self);
     lb.Parent:=pnBottom;
     lb.Name:='lbNumReestr';
     lb.Alignment:=taRightJustify;
     lb.Anchors:=[akLeft, akBottom];
     lb.Left:=pnBottom.Left+pnBottom.Width-500;
     lb.Width:=35;
     lb.Top:=15;
     lb.Height:=13;
     lb.Anchors:=[akRight, akBottom];
     lb.Font.Style:=[fsBold];
     lb.Caption:='�����:';
     lbNumReestr:=lb;

     ed:=TEdit.Create(Self);
     ed.parent:=pnBottom;
     ed.Name:='edNumReestr';
     ed.ShowHint:=true;
     ed.Hint:='����� � �������';
     ed.MaxLength:=9;
     ed.Anchors:=[akLeft, akBottom];
     ed.Left:=lbNumReestr.Left+lbNumReestr.Width+5;
     ed.Width:=62;
     ed.Top:=12;
     ed.Height:=21;
     ed.Text:='';
     ed.TabOrder:=1;
     ed.Anchors:=[akRight, akBottom];
     edNumReestr:=ed;
     edNumReestr.OnKeyPress:=edNumReestrKeyPress;
     edNumReestr.OnChange:=edNumReestrChange;

     bt:=TButton.Create(Self);
     bt.parent:=pnBottom;
     bt.Name:='btNextNumReestr';
     bt.ShowHint:=true;
     bt.Caption:='<-';
     bt.Hint:='��������� ����� � �������';
     bt.Anchors:=[akLeft, akBottom];
     bt.Width:=21;
     bt.Left:=edNumReestr.Left+edNumReestr.Width+5;
     bt.Top:=12;
     bt.Height:=21;
     bt.TabOrder:=2;
     bt.Anchors:=[akRight, akBottom];
     btNextNumReestr:=bt;
     btNextNumReestr.OnClick:=btNextNumReestrClick;

     lb:=TLabel.Create(Self);
     lb.Parent:=pnBottom;
     lb.Name:='lbBlank';
     lb.Alignment:=taRightJustify;
     lb.Caption:='�����:';
     lb.Anchors:=[akLeft, akBottom];
     lb.Left:=btNextNumReestr.Left+btNextNumReestr.Width+10;
     lb.Width:=35;
     lb.Top:=15;
     lb.Height:=13;
     lb.Font.Style:=[fsBold];
     lb.Anchors:=[akRight, akBottom];
     lbBlank:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=pnBottom;
     cb.Name:='cbBlank';
     cb.ShowHint:=true;
     cb.Hint:='����� ������';
     cb.Anchors:=[akLeft, akBottom];
     cb.Left:=lbBlank.Left+lbBlank.Width+5;
     cb.Width:=77;
     cb.Top:=12;
     cb.Height:=21;
     cb.Anchors:=[akRight, akBottom];
     cb.Text:='';
     cb.Style:=csDropDownList;
     cb.TabOrder:=3;
     cbBlank:=cb;
     cbBlank.OnChange:=cbBlankChange;

     ed:=TEdit.Create(Self);
     ed.parent:=pnBottom;
     ed.Name:='edBlank';
     ed.ShowHint:=true;
     ed.Hint:='����� ������';
     ed.MaxLength:=MaxBlankNumLength;
     ed.Anchors:=[akLeft, akBottom];
     ed.Left:=cbBlank.Left+cbBlank.Width+5;
     ed.Width:=62;
     ed.Top:=12;
     ed.Height:=21;
     ed.Text:='';
     ed.TabOrder:=4;
     ed.Anchors:=[akRight, akBottom];
     ed.Enabled:=false;
     edBlank:=ed;
     edBlank.OnKeyPress:=edBlankKeyPress;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbSumm';
     lb.Left:=38;
     lb.Width:=47;
     lb.Top:=7;
     lb.Height:=13;
     lb.Caption:='�/�����:';
     lb.Alignment:=taRightJustify;
     lbSumm:=lb;

     se:=TRxCalcEdit.Create(Self);
     se.Parent:=sb;
     se.Name:='SummEdit';
     se.Top:=5;
     se.Left:=91;
     se.Width:=77;
     se.ShowHint:=true;
     se.Hint:='����� �����';
     se.TabOrder:=2;
     SummEdit:=se;
     SummEdit.OnChange:=SummEditChange;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbSummPriv';
     lb.Left:=177;
     lb.Width:=40;
     lb.Top:=7;
     lb.Height:=13;
     lb.Caption:='�/����:';
     lb.Alignment:=taRightJustify;
     lbSummPriv:=lb;

     se:=TRxCalcEdit.Create(Self);
     se.Parent:=sb;
     se.Name:='SummEditPriv';
     se.Top:=5;
     se.Left:=lbSummPriv.Left+lbSummPriv.Width+6;
     se.Width:=77;
     se.ShowHint:=true;
     se.Hint:='����� ����';
     se.TabOrder:=3;
     SummEditPriv:=se;

     ch:=TCheckBox.Create(Self);
     ch.Parent:=sb;
     ch.Name:='chbOnSogl';
     ch.Left:=411;
     ch.Width:=65;
     ch.Top:=11;
     ch.Height:=17;
     ch.Caption:='�� ����.';
     ch.ShowHint:=true;
     ch.Hint:='�� ����������';
     ch.TabOrder:=4;
     ch.Visible:=false;
     chbOnSogl:=ch;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbCurReestr';
     lb.Left:=44;
     lb.Width:=39;
     lb.Top:=32;
     lb.Height:=13;
     lb.Caption:='������:';
     lbCurReestr:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=sb;
     cb.Name:='cbCurReestr';
     cb.ShowHint:=true;
     cb.Hint:='� ����� ������';
     cb.Left:=91;
     cb.Width:=265;
     cb.Top:=30;
     cb.Height:=21;
     cb.Text:='';
     cb.Style:=csDropDownList;
     cb.TabOrder:=5;
     cbCurReestr:=cb;
     cbCurReestr.OnChange:=cbCurReestrChange;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbNumLic';
     lb.Left:=363;
     lb.Width:=53;
     lb.Top:=32;
     lb.Height:=13;
     lb.Caption:='��������:';
     lb.Visible:=false;
     lbNumLic:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=sb;
     cb.Name:='cbNumLic';
     cb.ShowHint:=true;
     cb.Hint:='����� ��������';
     cb.Left:=lbNumLic.Left+lbNumLic.Width+6;
     cb.Width:=265;
     cb.Top:=30;
     cb.Height:=21;
     cb.Text:='';
     cb.Style:=csDropDownList;
     cb.TabOrder:=6;
     cb.Visible:=false;
     cbNumLic:=cb;
     cbNumLic.OnChange:=cbNumLicChange;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbMotion';
     lb.WordWrap:=true;
     lb.Alignment:=taRightJustify;
     lb.Left:=7;
     lb.Width:=76;
     lb.Top:=52;
     lb.Height:=26;
     lb.Caption:='������������ ��������:';
     lbMotion:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=sb;
     cb.Name:='cmbMotion';
     cb.Left:=91;
     cb.Width:=265;
     cb.Top:=55;
     cb.Height:=21;
     cb.Text:='';
     cb.Style:=csDropDownList;
     cb.ShowHint:=true;
     cb.DropDownCount:=20;
     cb.TabOrder:=7;
     cmbMotion:=cb;
     cmbMotion.OnChange:=cmbMotionChange;

     ch:=TCheckBox.Create(Self);
     ch.Parent:=sb;
     ch.Name:='chbNoYear';
     ch.Left:=363;
     ch.Width:=113;
     ch.Top:=57;
     ch.Height:=17;
     ch.Caption:='�/������';
     ch.ShowHint:=true;
     ch.Hint:=' �������� � ������� �������� ���'+#13+
              '����������������� ��������'+#13+
              '������������������';
     ch.TabOrder:=8;
     chbNoYear:=ch;

     ch:=TCheckBox.Create(Self);
     ch.Parent:=sb;
     ch.Name:='chbDefect';
     ch.Left:=461;
     ch.Width:=113;
     ch.Top:=57;
     ch.Height:=17;
     ch.Caption:='���.����������';
     ch.ShowHint:=true;
     ch.Hint:='  �������� �� �������������� �������'+#13+
              '���������� ��-�� ������� ���������� ����������';
     ch.TabOrder:=9;
     chbDefect:=ch;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbFio';
     lb.Left:=7;
     lb.Width:=77;
     lb.Top:=84;
     lb.Height:=13;
     lb.Caption:='������� �.�.:';
     lbFio:=lb;

     cb:=TComboBox.Create(Self);
     cb.Parent:=sb;
     cb.ShowHint:=true;
     cb.Hint:='������� ��� ��������';
     cb.Name:='cbFio';
     cb.Left:=91;
     cb.Width:=265;
     cb.Top:=80;
     cb.Height:=21;
     cb.Style:=csDropDown;
     cb.Text:='';
     cb.TabOrder:=10;
     cbFio:=cb;
     cbFio.OnKeyPress:=cbFioKeyPress;
     cbFio.OnDropDown:=cbFioDropDown;
     cbFio.OnExit:=cbFioExit;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbHereditaryDeal';
     lb.WordWrap:=true;
     lb.Alignment:=taRightJustify;
     lb.Left:=362;
     lb.Width:=53;
     lb.Top:=77;
     lb.Height:=26;
     lb.Caption:='������-�� ����:';
     lbHereditaryDeal:=lb;

     ed:=TEdit.Create(Self);
     ed.ParentColor:=false;
     ed.parent:=sb;
     ed.Name:='edHereditaryDeal';
     ed.ShowHint:=true;
     ed.Hint:='�������������� ����';
     ed.Left:=423;
     ed.Width:=125;
     ed.Top:=80;
     ed.Height:=21;
     ed.Text:='';
     ed.TabStop:=false;
     ed.TabOrder:=11;
     ed.ReadOnly:=true;
     ed.Color:=clBtnFace;
     edHereditaryDeal:=ed;
     edHereditaryDeal.OnKeyDown:=edHereditaryDealKeyDown;

     bt:=TButton.Create(Self);
     bt.parent:=sb;
     bt.Name:='btHereditaryDeal';
     bt.ShowHint:=true;
     bt.Caption:='...';
     bt.Hint:='������� �������������� ����';
     bt.Width:=21;
     bt.Left:=edHereditaryDeal.Left+edHereditaryDeal.Width+3;
     bt.Top:=80;
     bt.Height:=21;
     bt.TabOrder:=12;
     btHereditaryDeal:=bt;
     btHereditaryDeal.OnClick:=btHereditaryDealClick;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbDocName';
     lb.WordWrap:=true;
     lb.Alignment:=taRightJustify;
     lb.Left:=6;
     lb.Width:=76;
     lb.Top:=101;
     lb.Height:=26;
     lb.Caption:='������������ ���������:';
     lbDocName:=lb;

     ed:=TEdit.Create(Self);
     ed.parent:=sb;
     ed.Name:='edDocName';
     ed.ShowHint:=true;
     ed.Hint:='������� �������� �� ������� ������������ ���������';
     ed.MaxLength:=100;
     ed.Left:=91;
     ed.Width:=265;
     ed.Top:=105;
     ed.Height:=21;
     ed.Text:='';
     ed.TabOrder:=13;
     edDocName:=ed;

     lb:=TLabel.Create(Self);
     lb.Parent:=sb;
     lb.Name:='lbCertificateDate';
     lb.WordWrap:=true;
     lb.Alignment:=taRightJustify;
     lb.Left:=363;
     lb.Width:=115;
     lb.Top:=108;
     lb.Height:=13;
     lb.Caption:='���� �������������:';
     lbCertificateDate:=lb;

     dtp:=TDateTimePicker.Create(Self);
     dtp.Parent:=sb;
     dtp.Name:='dtpCertificateDate';
     dtp.Left:=485;
     dtp.Width:=94;
     dtp.Top:=105;
     dtp.Height:=21;
     dtp.TabOrder:=14;
     dtp.Hint:='���� ������������� ���������';
     dtp.ShowHint:=true;
     dtpCertificateDate:=dtp;


     rlb:=TantAngleLabel.Create(Self);
     Buffer:='';
     if LocalDb.ReadParam(SDb_ParamCompany,Buffer) then
       rlb.Caption:=Format(SCompanyName,[Buffer]);
     rlb.Transparent:=true;
     rlb.Parent:=Self;
     rlb.Align:=alRight;
     rlb.Name:='lbCompanyName';
     rlb.Font.Name:='Times New Roman Cyr';
     rlb.Font.Size:=8;
     rlb.Font.Style:=[];
     rlb.Angle:=270;

     pn:=TPanel.Create(Self);
     pn.Parent:=pnBottom;
     pn.Align:=alLeft;
     pn.Width:=lbNumReestr.Left-10;
     pn.Name:='pnMarquee';
     pn.BevelOuter:=bvNone;
     pn.BorderWidth:=6;
     pn.Caption:='';
     pnMarquee:=pn;
                                                                           
     pnM:=TddgMarquee.Create(Self);
     pnM.Parent:=pnMarquee;
     pnM.Align:=alClient;
     pnM.Justify:=tjLeft;
     pnM.Circle:=true;
     pnM.TimerInterval:=100;
     pnM.StopOnLine:=true;
     pnM.ParentColor:=true;
     pnM.ParentFont:=true;
     pnM.Font.Style:=[fsBold];
     pnM.Font.Color:=clBtnShadow;
     pnM.Name:='pnReminder';
     pnM.Caption:='';
     pnM.Items.Clear;
     pnM.BevelOuter:=bvNone;
     pnM.hint:='������ �����������';
     pnM.Active:=isViewReminder;
     pnReminder:=pnM;

     bibOk.Default:=not isDisableDefaultOnForm;

     Constraints.MinHeight:=350;
     Constraints.MinWidth:=620;

   end;

begin
  Self.Enabled:=false;
  if Assigned(grbDoplnit) then begin
    grbDoplnit.Visible:=false;
    grbDoplnit.Enabled:=false;
    DestroyHeader;
    CreateHeader;
    grbDoplnit.Enabled:=true;
    grbDoplnit.Visible:=true;
    bibOtlogen.Visible:=false;
    ActiveControl:=grbDoplnit;
  end;
  Self.Enabled:=true;
end;

procedure TfmNewForm.cmbMotionChange(Sender: TObject);
begin
  SetHereditaryByNotarialAction(false);
end;

procedure TfmNewForm.SummEditChange(Sender: TObject);
begin
  SummEditPriv.Value:=SummEdit.Value;
end;

procedure TfmNewForm.ClearHereditaryDeal;
begin
  OldHereditaryDealId:=0;
  OldHereditaryDealNum:='';
  OldHereditaryDealDate:=Now;
  edHereditaryDeal.Text:='';
end;

procedure TfmNewForm.edBlankKeyPress(Sender: TObject; var Key: Char);
var
  S: String;
  Val: Integer;
begin
  if Integer(Key)<>VK_BACK then begin
    S:=TEdit(Sender).Text+Key;
    if not TryStrToInt(S,Val) then
      Key:=#0;
  end;
end;

procedure TfmNewForm.edHereditaryDealKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key=VK_DELETE) or (Key=VK_BACK) then begin
    ClearHereditaryDeal;
  end;
end;

procedure TfmNewForm.btHereditaryDealClick(Sender: TObject);
var
  fm: TfmHereditaryDeal;
begin
  fm:=TfmHereditaryDeal.Create(nil);
  try
    fm.BorderIcons:=[biSystemMenu, biMaximize];
    fm.bibOk.Visible:=true;
    fm.bibOk.OnClick:=fm.MR;
    fm.Grid.OnDblClick:=fm.MR;
    fm.LoadFilter;
    fm.ActiveQuery;
    if fm.Mainqr.Active then
      fm.Mainqr.Locate('hereditarydeal_id',OldHereditaryDealId,[loCaseInsensitive]);
    if fm.ShowModal=mrOk then begin
      if not fm.Mainqr.IsEmpty then begin
       OldHereditaryDealId:=fm.Mainqr.fieldByName('hereditarydeal_id').AsInteger;
       OldHereditaryDealNum:=fm.Mainqr.fieldByName('numdeal').AsString;
       OldHereditaryDealDate:=fm.Mainqr.fieldByName('datedeal').AsDateTime;
       edHereditaryDeal.Text:=OldHereditaryDealNum+' �� '+DateToStr(OldHereditaryDealDate);

       SetInsertedValuesToAll(fm.Mainqr.fieldByName('numdeal').AsString,tivFromDealNum);
       SetInsertedValuesToAll(fm.Mainqr.fieldByName('fio').AsString,tivFromDealFIO);
       SetInsertedValuesToAll(fm.Mainqr.fieldByName('deathdate').AsDateTime,tivFromDealDeathDate);
      end; 
    end;
  finally
    fm.Free;
  end;
end;

procedure TfmNewForm.SetInsertedValuesToAll(const Value: Variant; TypeInsertedValue: TTypeInsertedValue;
                                            ReplaceFlag: Boolean=true);
var
  i: Integer;
  ct: TComponent;
  S: TIntegerSet;
  txt: string;
const
  ConstProp='InsertedValues';
begin
  for i:=0 to ComponentCount-1 do begin
    ct:=Components[i];
    if IsPublishedProp(ct,ConstProp) then begin
     Integer(S):=GetOrdProp(ct,ConstProp);
     if Integer(TypeInsertedValue) in S then begin
       if ct is TControl then begin
        if ReplaceFlag then
         SetTextToControl(TControl(ct),Value)
        else begin
         txt:=GetTextFromControl(TControl(ct));
         if Trim(txt)='' then
           SetTextToControl(TControl(ct),Value);
        end; 
       end; 
     end;
    end;
  end;
end;

procedure TfmNewForm.SetTextToControl(ct: TControl; const Value: Variant);
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

procedure TfmNewForm.SetNewTextFromUniversal(Control: TControl; isLocate: Boolean; LocateValue: Variant; isFirst: Boolean=true);
begin
  OpenSubs(Control,IsLocate,LocateValue,GetTextFromControl(Control),isFirst);
end;

function TfmNewForm.GetParentTabSheet(wt: TWinControl): TTabSheet;
  begin
    Result:=nil;
    if wt is TTabSheet then begin
      Result:=TTabSheet(wt);
      exit;
    end;
    while wt.Parent<>nil do begin
      if wt.Parent is TTabSheet then begin
        Result:=TTabSheet(wt.Parent);
        exit;
      end;
      wt:=wt.Parent;
    end;
  end;


procedure TfmNewForm.ReFill(Sender: TObject);
Var
   wt :  TWinControl;
   fm: TfmRBPeople;
   tc: TTypeCase;
begin
   wt:=ActiveControl;
   if wt=nil then exit;
   wt:=wt.Parent;
   if wt=nil then exit;
   fm:=TfmRBPeople.Create(nil);
   try
     fm.BorderIcons:=[biSystemMenu, biMaximize];
     fm.bibOk.Visible:=true;
     fm.bibOk.OnClick:=fm.bibReFillClick;
     fm.Grid.OnDblClick:=fm.bibReFillClick;
     if IsPublishedProp(ActiveControl,'TypeCase') then begin
        tc:=TTypeCase(GetOrdProp(ActiveControl,'TypeCase'));
        if tc=tcIminit then begin
          fm.FindNomin:=GetTextFromControl(ActiveControl);
        end;
     end;
     fm.ActiveQuery;
    // fm.LoadFilter;
     fm.InitRBPeople(wt,Self);
{     if IsPublishedProp(ActiveControl,'TypeCase') then begin
        tc:=TTypeCase(GetOrdProp(ActiveControl,'TypeCase'));
        if tc=tcIminit then begin
          fm.edSearch.Text:=GetTextFromControl(ActiveControl);
          fm.MainQr.Locate('nomin',Trim(fm.edSearch.Text),[loPartialKey,loCaseInsensitive]);
        end;
     end;}
     if fm.ShowModal=mrOk then begin
     end;
   finally
     fm.Free;
   end;
end;

procedure TfmNewForm.UpFill(Sender: TObject);
Var
   wt :  TWinControl;
   fm: TfmRBPeople;
begin
   wt:=ActiveControl;
   if wt=nil then exit;
   wt:=wt.Parent;
   if wt=nil then exit;
   fm:=TfmRBPeople.Create(nil);
   try
     fm.BorderIcons:=[biSystemMenu, biMaximize];
     fm.bibOk.Visible:=true;
     fm.bibOk.OnClick:=fm.bibReFillClick;
     fm.Grid.OnDblClick:=fm.bibReFillClick;
     fm.ActiveQuery;
     fm.LoadFilter;
     fm.isUpView:=true;
     fm.InitRBPeople(wt,Self);
     if fm.ShowModal=mrOk then begin
     end;
   finally
     fm.Free;
   end;
end;

procedure TfmNewForm.AddPeople;
begin
  ChangePeople;
end;

procedure AddFromImenitControlToPeople(ct: TControl);
var
 wt: TWinControl;
 List: TList;
 i: Integer;
 sqls: string;
 SqlValues: string;
 SqlFields: string;
 SqlsReFillQuote: string;
 WordName: string;
 tr: TIBTransaction;
 qr: TIBQuery;
 APos: Integer;
 FieldName: string;
 ctNext: TControl;
 Value: Variant;
 isRealyControl: Boolean;
 isFirst: Boolean;
const
 PropName='DocFieldName';
begin
 wt:=ct.Parent;
 if wt=nil then exit;
 List:=TList.Create;
 tr:=TIBTransaction.Create(nil);
 qr:=TIBQuery.Create(nil);
 try
  tr.AddDatabase(dm.IBDbase);
  dm.IBDbase.AddTransaction(tr);
  tr.Params.Text:=DefaultTransactionParamsTwo;
  qr.Database:=dm.IBDbase;
  qr.Transaction:=tr;
  wt.GetTabOrderList(List);
  qr.Transaction.Active:=true;
  SqlsReFillQuote:='Select * from '+TableReFillQuote;
  qr.SQL.Add(SqlsReFillQuote);
  qr.Active:=true;
  sqls:='Insert into '+TablePeople;
  SqlValues:='(';
  SqlFields:='(';
  isFirst:=true;
  for i:=0 to List.Count-1 do begin
    ctNext:=TControl(List.Items[i]);
    if ctNext.Parent=wt then begin
      if IsPublishedProp(ctNext,PropName) then begin
       WordName:=GetStrProp(ctNext,PropName);
       qr.First;
       isRealyControl:=false;
       while not qr.EOF do begin
        APos:=AnsiPos(AnsiUpperCase(qr.FieldByName('docfieldname').AsString),AnsiUpperCase(WordName));
        if APos>0 then begin
          isRealyControl:=true;
          break;
        end;
        qr.Next;
       end;
       if isRealyControl then begin
         FieldName:=qr.FieldByName('fieldname').AsString;
         Value:=GetTextFromControl(ctNext);
         if isFirst then begin
           SqlFields:=SqlFields+FieldName;
           SqlValues:=SqlValues+GetStrFromCondition(Trim(Value)<>'',QuotedStr(Trim(Value)),'null');
         end else begin
           SqlFields:=SqlFields+','+FieldName;
           SqlValues:=SqlValues+','+GetStrFromCondition(Trim(Value)<>'',QuotedStr(Trim(Value)),'null');
         end;
         isFirst:=false;
       end;
      end;
    end;  
  end;
  try
    SqlValues:=SqlValues+')';
    SqlFields:=SqlFields+')';
    sqls:=sqls+' '+SqlFields+' values '+SqlValues;
    ExecSql(dm.IBDbase,Sqls);
  except
  end;
 finally
   qr.Free;
   tr.Free;
   List.Free;
 end;
end;


function GetPeopleID(Imenit: string; Birthdate: TDate; isDateNull: Boolean): Variant;
var
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
begin
  Result:=NULL;
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qr.Database:=dm.IBDbase;
   tran.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tran);
   tran.Params.Text:=DefaultTransactionParamsTwo;
   qr.ParamCheck:=false;
   qr.Transaction:=tran;
   qr.Transaction.Active:=true;
   sqls:='Select people_id from '+TablePeople+
         ' where Upper(nomin)='+QuotedStr(AnsiUpperCase(Imenit))+
         ' and '+GetStrFromCondition(not isDateNull,'birthday='+QuotedStr(DateToStr(BirthDate)),'birthday is null');
   qr.SQL.Text:=sqls;
   qr.Active:=true;
   if not qr.IsEmpty then
    Result:=qr.FieldByName('people_id').AsString;
   qr.Transaction.Commit;
  finally
   qr.Free;
   tran.Free;
   Screen.Cursor:=crDefault;
  end;
end;

function GetBirthDate(ct: TControl;var BirthDate: Tdate): Boolean;
var
   tr: TIBTransaction;
   qr: TIBQuery;
   wt: TWinControl;
   List: TList;
   i: Integer;
   WordName: string;
   ctNext: TControl;
   APos: Integer;
const
   PropName='DocFieldName';   
begin
   Result:=false;
   wt:=ct.Parent;
   if wt=nil then exit;
   Screen.Cursor:=CrHourGlass;
   List:=TList.Create;
   tr:=TIBTransaction.Create(nil);
   qr:=TIBQuery.Create(nil);
   try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    wt.GetTabOrderList(List);
    qr.Transaction.Active:=true;
    qr.SQL.Add('Select * from '+TableReFillQuote+' where Upper(fieldname)='+
               QuotedStr(AnsiUppercase('birthday')));
    qr.Active:=true;
    if not qr.IsEmpty then
     for i:=0 to List.Count-1 do begin
      ctNext:=TControl(List.Items[i]);
      if ctNext.Parent=wt then begin
        if IsPublishedProp(ctNext,PropName) then begin
         WordName:=GetStrProp(ctNext,PropName);
         APos:=AnsiPos(AnsiUpperCase(qr.FieldByName('docfieldname').AsString),AnsiUpperCase(WordName));
         if APos>0 then begin
           if isDate(GetTextFromControl(ctNext)) then begin
            BirthDate:=StrToDate(GetTextFromControl(ctNext));
            Result:=BirthDate<>0;
            break;
           end;
         end;
        end;
      end;  
     end;
   finally
    qr.Free;
    tr.Free;
    List.Free;
    Screen.Cursor:=CrDefault;
   end;
end;

procedure ChangeFromImenitControlToPeople(ct: TControl; PeopleId: Integer);
var
 wt: TWinControl;
 List: TList;
 i: Integer;
 sqls: string;
 SqlValues: string;
 SqlsReFillQuote: string;
 WordName: string;
 tr: TIBTransaction;
 qr: TIBQuery;
 APos: Integer;
 FieldName: string;
 ctNext: TControl;
 Value: Variant;
 isRealyControl: Boolean;
 isFirst: Boolean;
const
 PropName='DocFieldName';
begin
 wt:=ct.Parent;
 if wt=nil then exit;
 List:=TList.Create;
 tr:=TIBTransaction.Create(nil);
 qr:=TIBQuery.Create(nil);
 try
  tr.AddDatabase(dm.IBDbase);
  dm.IBDbase.AddTransaction(tr);
  tr.Params.Text:=DefaultTransactionParamsTwo;
  qr.Database:=dm.IBDbase;
  qr.Transaction:=tr;
  wt.GetTabOrderList(List);
  qr.Transaction.Active:=true;
  SqlsReFillQuote:='Select * from '+TableReFillQuote+' order by '+TableReFillQuote+'_ID DESC';
  qr.SQL.Add(SqlsReFillQuote);
  qr.Active:=true;
  sqls:='Update '+TablePeople+' set ';
  isFirst:=true;
  for i:=0 to List.Count-1 do begin
   ctNext:=TControl(List.Items[i]);
   if ctNext.Parent=wt then begin
    if IsPublishedProp(ctNext,PropName) then begin
     WordName:=GetStrProp(ctNext,PropName);
     qr.First;
     isRealyControl:=false;
     while not qr.EOF do begin
      APos:=AnsiPos(AnsiUpperCase(qr.FieldByName('docfieldname').AsString),AnsiUpperCase(WordName));
      if APos>0 then begin
        isRealyControl:=true;
        break;
      end;
      qr.Next;
     end;
     if isRealyControl then begin
       FieldName:=qr.FieldByName('fieldname').AsString;
       Value:=GetTextFromControl(ctNext);
       if isFirst then begin
         SqlValues:=FieldName+'='+GetStrFromCondition(Trim(Value)<>'',QuotedStr(Trim(Value)),'null');
       end else begin
         SqlValues:=SqlValues+','+FieldName+'='+GetStrFromCondition(Trim(Value)<>'',QuotedStr(Trim(Value)),'null');
       end;
       isFirst:=false;
     end;
    end;
   end;
  end;
  try
    sqls:=sqls+' '+SqlValues+' where people_id='+Inttostr(PeopleId);
    ExecSql(dm.IBDbase,Sqls);
  except
  end;
 finally
   qr.Free;
   tr.Free;
   List.Free;
 end;
end;

procedure TfmNewForm.ChangePeople;
var
  List: TList;
  i: Integer;
  Value: string;
  PeopleId: Variant;
  BirthDate: TDate;
  isDateNull: Boolean;
begin
  List:=TList.Create;
  try
    GetListImenitControls(Self,List);
    for i:=0 to List.Count-1 do begin
      Value:=GetTextFromControl(List.Items[i]);
      if Trim(Value)<>'' then begin
       isDateNull:=not GetBirthDate(List.Items[i],BirthDate);
       PeopleId:=GetPeopleID(Trim(Value),BirthDate,isDateNull);
       if PeopleId=NULL then begin
         AddFromImenitControlToPeople(List.Items[i]);
       end else begin
         ChangeFromImenitControlToPeople(List.Items[i],PeopleId);
       end;
      end; 
    end;
  finally
    LIst.Free;
  end;
end;

procedure TfmNewForm.cbFioExit(Sender: TObject);
begin
  cbFio.Text:=Trim(toTrimSpaceForOne(cbFio.Text));
  SetInsertedValuesToAll(cbFio.Text,tivFromHeaderFIO,false);
end;

procedure TfmNewForm.SetFirstTabSheet;
var
  isBreak: Boolean;

  function GetFirstPageControl(wt: TWinControl): TPageControl;
  var
    i: Integer;
    ct: TControl;
  begin
    Result:=nil;
    if isBreak then exit;
    for i:=0 to wt.ControlCount-1 do begin
     ct:=wt.Controls[i];
     if ct is TPageControl then begin
       Result:=TPageControl(ct);
       isBreak:=true;
       exit;
     end;
     if ct is TWinControl then begin
       Result:=GetFirstPageControl(TWinControl(ct));
       if Result<>nil then begin
        isBreak:=true;
        exit;
       end; 
     end; 
    end;
  end;
  
var
  pc: TPageControl;
begin
  isBreak:=false;
  pc:=GetFirstPageControl(Self);
  if pc<>nil then
    if pc.PageCount>0 then
      pc.ActivePageIndex:=0;
end;

procedure TfmNewForm.Paint;
begin
  inherited Paint;
end;

procedure TfmNewForm.miCtrlBuildClick(Sender: TObject);
var
  ct: TWinControl;
begin
  if pnDesign.TargetsCount<>0 then
   ct:=TWinControl(pnDesign.Targets[0])
  else
   ct:=TWinControl(pnDesign);
   
  reg.Designing:=false;
  try
   ReAlignControls(ct,true,false,true);
   FillAllControls;
   ChangeFlagNewForm:=true;
  finally
    reg.Designing:=true;
  end;
end;

procedure TfmNewForm.SaveControlsToClipBoardAsText;
var
  ms,msOut: TMemoryStream;
  s: string;
begin
  ms:=TMemoryStream.Create;
  msOut:=TMemoryStream.Create;
  try
    pnDesign.SaveToStream(ms);
    ms.Position:=0;
    ObjectBinaryToText(ms,msOut);
    msOut.Position:=0;
    SetLength(s,msOut.Size);
    Move(msOut.Memory^,Pointer(s)^,msOut.Size);
    Clipboard.AsText:=s;
  finally
    msOut.Free;
    ms.Free;
  end;
end;

procedure TfmNewForm.LoadControlsFromClipBoardAsText;
var
  ms,msOut: TMemoryStream;
  s: string;
begin
  ms:=TMemoryStream.Create;
  msOut:=TMemoryStream.Create;
  try
    s:=Clipboard.AsText;
    ms.SetSize(Length(s));
    ms.Write(Pointer(s)^,ms.Size);
    ms.Position:=0;
    ObjectTextToBinary(ms,msOut);
    msOut.Position:=0;
    try
     pnDesign.LoadFromStream(msOut);
    except
    end; 
    reg.Designing:=false;
    reg.Designing:=true;
  finally
    msOut.Free;
    ms.Free;
  end;
end;

procedure TfmNewForm.ViewFieldsInDocumentByControl(Control: TControl);
var
  tmps: string;
begin
  if Control=nil then exit;
  if not IsPublishedProp(Control,ConstPropDocFieldName) then exit;
  tmps:=GetPropValue(Control,ConstPropDocFieldName);
  if Trim(tmps)<>'' then begin
    if not ExtractDocFile(LastDocId,CaptionView) then exit;
    if not ViewFieldsInDocument(tmps) then
      ShowError(Handle,ConstFieldNoLinkInDocument);
  end else ShowError(Handle,ConstFieldNoLinkInDocument);
end;

procedure TfmNewForm.miCtrlAddToRule(Sender: TObject);
var
  ct: TControl;
  fm: TfmRBRuleForElement;
begin
  if pnDesign.TargetsCount=0 then exit;
  ct:=pnDesign.Targets[0];
  if not isNewControl(ct) then exit;
  if not IsPublishedProp(ct,ConstPropDocFieldName) then exit;

  fm:=TfmRBRuleForElement.Create(nil);
  try
    fm.LoadFilter;
    fm.ActiveQuery;
    fm.bibOk.Visible:=false;
    fm.VarAddControl:=ct;
    fm.isAddOnShow:=true;
    fm.ShowModal;
  finally
    fm.Free;
  end;

end;

procedure TfmNewForm.miScriptClick(Sender: TObject);
begin
  FScriptEditor.InitScript;
  FScriptEditor.Show;
end;

procedure TfmNewForm.cbFioDropDown(Sender: TObject);
begin
  FillFioCombo;
end;

procedure TfmNewForm.btNextNumReestrClick(Sender: TObject);
begin
  edNumReestr.Text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
end;

procedure TfmNewForm.ViewHintByControl(Control: TControl);
begin
  ViewHintExByControl(Control);
end;

procedure TfmNewForm.CancelHint;
begin
  CancelHintEx;
end;

procedure TfmNewForm.SetHereditaryByNotarialAction(isClear: Boolean);
var
  id: Integer;
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  ViewHereditary: Boolean;
begin
  if cmbMotion.ItemIndex<>-1 then begin
   id:=Integer(Pointer(cmbMotion.Items.Objects[cmbMotion.ItemIndex]));
   LastNotarialActionId:=id;
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
    sqls:='Select * from '+TableNotarialAction+
         ' where notarialaction_id='+inttostr(id);
    qr.SQL.Add(sqls);
    qr.Active:=true;
    if not qr.isEmpty then begin
     chbNoYear.Visible:=Boolean(qr.FieldByname('usenoyear').AsInteger);
     chbDefect.Visible:=Boolean(qr.FieldByname('usedefect').AsInteger);
     ViewHereditary:=Boolean(qr.FieldByname('viewhereditary').AsInteger);
     lbHereditaryDeal.Visible:=ViewHereditary;
     edHereditaryDeal.Visible:=ViewHereditary;
     btHereditaryDeal.Visible:=ViewHereditary;
     if not isClear then begin
       cmbMotion.Hint:=qr.FieldByname('hint').AsString;
       if qr.FieldByname('percent').AsString<>'' then
        SummEditPriv.Value:=SummEdit.Value*qr.FieldByname('percent').AsFloat/100;
     end else begin
       if not ViewHereditary then
         ClearHereditaryDeal;
     end;   
    end;
   finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
   end;
  end;
end;

procedure TfmNewForm.FillReminders;

   procedure CopyRandom(str1,str2: TStringList);
   var
     list: TList;
     v,val: Integer;
   begin
     list:=TList.Create;
     try
       while str1.Count<>list.Count do begin
         v:=Random(str1.Count);
         val:=List.IndexOf(Pointer(v));
         if val=-1 then begin
           if str2.Count>0 then
             str2.Add('');
           str2.Add(str1.Strings[v]);
           list.Add(Pointer(v));
         end;
       end;
     finally
       list.Free;
     end;
   end;

var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
  CurrPriority: Integer;
  str: TStringList;
begin
   pnReminder.Active:=false;
   Screen.Cursor:=crHourGlass;
   tr:=TIBTransaction.Create(nil);
   qr:=TIBQuery.Create(nil);
   str:=TStringList.Create;
   try
    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    qr.Database:=dm.IBDbase;
    qr.Transaction:=tr;
    qr.Transaction.Active:=true;
    sqls:='Select * from '+TableReminder+' order by priority';
    qr.SQL.Add(sqls);
    qr.Active:=true;
    qr.First;
    CurrPriority:=0;
    while not qr.EOF do begin
      if qr.FieldByname('priority').AsInteger<>CurrPriority then begin
        CopyRandom(str,pnReminder.Items);
        str.Clear;
        str.Add(qr.FieldByname('text').AsString);
      end else begin
        str.Add(qr.FieldByname('text').AsString);
      end;
      CurrPriority:=qr.FieldByname('priority').AsInteger;
      qr.Next;
    end;
    CopyRandom(str,pnReminder.Items);
   finally
    str.Free;
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
    pnReminder.Active:=(Trim(pnReminder.Items.Text)<>'') and isViewReminder;
   end;
end;

end.


