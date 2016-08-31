unit UDocReestr;

interface

{$I def.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, ImgList, Menus, dbtables, db, StdCtrls, Buttons,
  inifiles, DBCtrls, IBCustomDataSet, IBQuery, UNewDbGrids, DBGrids,
  IBTable,IBDatabase, Grids, IBUpdateSQL, Variants;

type

  TTypeChangeDoc=(tcdDoc,tcdFormDoc,tcdForm);

  TfmDocReestr = class(TForm)
    pnLV: TPanel;
    pmLV: TPopupMenu;
    miAddDoc: TMenuItem;
    miLVDelete: TMenuItem;
    miLVChange: TMenuItem;
    pnR: TPanel;
    bibAdd: TBitBtn;
    bibChange: TBitBtn;
    bibDel: TBitBtn;
    bibFilter: TBitBtn;
    pnGrid: TPanel;
    pnFind: TPanel;
    pnBottom: TPanel;
    lbCount: TLabel;
    DBNav: TDBNavigator;
    ds: TDataSource;
    Mainqr: TIBQuery;
    pgReestr: TPageControl;
    tbsReestr: TTabSheet;
    tbsPrepeare: TTabSheet;
    pncbReestr: TPanel;
    cbCurReestr: TComboBox;
    pnFindNew: TPanel;
    Label1: TLabel;
    edSearch: TEdit;
    lbCurReestr: TLabel;
    miLVFilter: TMenuItem;
    bibRefresh: TBitBtn;
    bibReestrCopy: TBitBtn;
    bibDub: TBitBtn;
    bibAdjust: TBitBtn;
    pmChange: TPopupMenu;
    miChangeWithOutForm: TMenuItem;
    miChangeWithForm: TMenuItem;
    tran: TIBTransaction;
    miChangeOnlyForm: TMenuItem;
    bibCancelAction: TBitBtn;
    il: TImageList;
    upd: TIBUpdateSQL;
    pnBackGrid: TPanel;
    bibPrint: TBitBtn;
    bibCarry: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure miLVFindClick(Sender: TObject);
    procedure miAddDocClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LVKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LVEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure bibAddClick(Sender: TObject);
    procedure bibChangeClick(Sender: TObject);
    procedure bibDelClick(Sender: TObject);
    procedure bibFilterClick(Sender: TObject);
    procedure pgReestrChange(Sender: TObject);
    procedure MainqrAfterScroll(DataSet: TDataSet);
    procedure bibRefreshClick(Sender: TObject);
    procedure cbCurReestrChange(Sender: TObject);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibReestrCopyClick(Sender: TObject);
    procedure bibDubClick(Sender: TObject);
    procedure bibAdjustClick(Sender: TObject);
    procedure miChangeWithOutFormClick(Sender: TObject);
    procedure miChangeWithFormClick(Sender: TObject);
    procedure miChangeOnlyFormClick(Sender: TObject);
    procedure bibCancelActionClick(Sender: TObject);
    procedure edSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bibPrintClick(Sender: TObject);
    procedure bibCarryClick(Sender: TObject);
  private
    Prefix, Sufix: string;
    FRecordCount: Integer;
    LastOrderStr: string;

    isFindNumReestr,isFindNumReestrTo,isFindDocName,isFindOperName,
    isFindFio,isFindSumm,
    isFindDateFrom,isFindDateTo,
    isFindDateChangeFrom,isFindDateChangeTo,
    isFindCertFrom,isFindCertTo,
    isFindCancelAction,isFindNumDeal,
    isFindUserName,isFindNotarialAction: Boolean;

    FindNumReestr,FindNumReestrTo,FindDocName,FindOperName: String;
    FindFio,FindSumm, FindNotarialAction: string;
    FindCancelAction: Integer;
    FindNumDeal: string;
    FindDateFrom,FindDateTo: TDate;
    FindDateChangeFrom,FindDateChangeTo: TDate;
    FindCertFrom,FindCertTo: TDate;

    FindUserName: String;
    FilterReestrId: String;

    FilterString: String;

    FilterInside: Boolean;


//    procedure GridTitleClick(Column: TColumn);
    procedure GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
    procedure GridDblClick(Sender: TObject);

    procedure DocTreeOkClick(Sender: TObject);
    procedure SetImageFilter;
    function GetFilterString: string;
    procedure SaveFilter;

    procedure FillTypeReestrComboAndSetIndex(Index: Integer);
    procedure AddToReestrFromDefault;
    procedure AddToReestrFromOperation;
    procedure ChangeReestrFromDefault(tcd:TTypeChangeDoc);
    procedure ChangeReestrFromOperation;
    procedure GridDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure GridDragOver(Sender, Source: TObject; X, Y: Integer;
              State: TDragState; var Accept: Boolean);
    function GetRecordCountFromReestr: Integer;
    procedure LoadStreamDataForm(msOut: TMemoryStream; Reestr_id: Integer);
    procedure LoadStreamDataDoc(msOut: TMemoryStream; Reestr_id: Integer);
    procedure ChangeCopyReestr;
    procedure LoadGridParams;
    procedure SaveGridParams;
    procedure ChangeReestrWithFlag(tcd:TTypeChangeDoc);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
                                 DataCol: Integer; Column: TColumn;
                                 State: TGridDrawState);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure SetRecordCount(Value: Integer);
    procedure SetBlankNumFormat;
  public
    LastIndex: Integer;
    LastTypeReestrID: Integer;
    LastOperID: Integer;
    Grid: TNewdbGrid;
    procedure LoadFilter;
    procedure ActiveQuery;
    function GetMaxReestrID: Integer;
    function GetMaxReestrIDEx(DB: TIBDatabase): Integer;

    procedure ViewCount;
    procedure NeedCacheUpdate(isInsert: Boolean;
                              reestr_id: Variant; isreestr_id: Boolean;
                              numreestr1: Variant; isnumreestr1: Boolean;
                              numreestr: Variant; isnumreestr: Boolean;
                              typedocname: Variant; istypedocname: Boolean;
                              typeopername: Variant; istypeopername: Boolean;
                              fio: Variant; isfio: Boolean;
                              summ: Variant; issumm: Boolean;
                              datein: Variant; isdatein: Boolean;
                              whoinname: Variant; iswhoinname: Boolean;
                              doc_id: Variant; isdoc_id: Boolean;
                              oper_id: Variant; isoper_id: Boolean;
                              typereestr_id: Variant; istypereestr_id: Boolean;
                              whoin: Variant; iswhoin: Boolean;
                              sogl: Variant; issogl: Boolean;
                              license_id: Variant; islicense_id: Boolean;
                              tmpname: Variant; istmpname: Boolean;
                              parent_id: Variant; isparent_id: Boolean;
                              keepdoc: Variant; iskeepdoc: Boolean;
                              whochange: Variant; iswhochange: Boolean;
                              datechange: Variant; isdatechange: Boolean;
                              whochangename: Variant; iswhochangename: Boolean;
                              noyear: Variant; isnoyear: Boolean;
                              defect: Variant; isdefect: Boolean;
                              summpriv: Variant; issummpriv: Boolean;
                              notarialaction_id: Variant; isnotarialaction_id: Boolean;
                              notarialactionname: Variant; isnotarialactionname: Boolean;
                              isnotcancelaction: Variant; isisnotcancelaction: Boolean;
                              whocancel: Variant; iswhocancel: Boolean;
                              datecancel: Variant; isdatecancel: Boolean;
                              numdeal: Variant; isnumdeal: Boolean;
                              datedeal: Variant; isdatedeal: Boolean;
                              hereditarydeal_id: Variant; ishereditarydeal_id: Boolean;
                              CertificateDate: Variant; isCertificateDate: Boolean;
                              WhoCertificate: Variant; isWhoCertificate: Boolean;
                              WhoCertificate_id: Variant; isWhoCertificate_id: Boolean;
                              BlankId: Variant; BlankSeries, BlankNum: Variant);
    procedure SetCondition(Query: TIbQuery);
    property RecordCount: Integer read FRecordCount write SetRecordCount;
  end;

var
  fmDocReestr: TfmDocReestr;

implementation

uses StrUtils,
  UMain, UDM, UHint, UDocTree, UNewForm, UDocReestrEdit, UCaseReestr,
  UNewOperation, UEditSumm, UAdjust, UProgress, UCheckSum, UInputNumReestr,
  SeoDbConsts;

var
  NewFm: TfmDocTree;
const
  ConstCaption='Реестр документов';
  ConstFilterCaption='(Фильтрация включена)';
  ConstCancelAction='Отменить';
  ConstBackCancelAction='Снять отмену';

{$R *.DFM}

procedure TfmDocReestr.FormCreate(Sender: TObject);
var
  cl: TColumn;
begin
  LastIndex:=0;
  DeleteMenu(GetSystemMenu(Handle, FALSE), SC_CLOSE, MF_BYCOMMAND);

  tran.Params.Text:=DefaultTransactionParamsTwo;
  tran.AddDatabase(dm.IBDbase);
  dm.IBDbase.AddTransaction(tran);

  Mainqr.Transaction:=tran;
  Grid:=TNewdbGrid.Create(self);
  Grid.Parent:=pnBackGrid;
  Grid.Align:=alClient;
  Grid.DataSource:=ds;
   Grid.RowSelected.Visible:=true;
   Grid.RowSelected.Brush.Style:=bsSolid;
   Grid.RowSelected.Brush.Color:=GridRowColor;
   Grid.RowSelected.Font.Color:=clWhite;
   Grid.RowSelected.Pen.Style:=psClear;
   Grid.CellSelected.Visible:=true;
   Grid.CellSelected.Brush.Color:=clHighlight;
   Grid.CellSelected.Font.Color:=clHighlightText;
  Grid.Options:=Grid.Options-[dgEditing]-[dgTabs];
  Grid.ReadOnly:=true;
//  Grid.OnTitleClick:=GridTitleClick;
  Grid.ColumnSortEnabled:=true;
  Grid.OnTitleClickWithSort:=GridTitleClickWithSort;
  Grid.OnDrawColumnCell:=GridDrawColumnCell;
  Grid.OnDblClick:=GridDblClick;
  Grid.OnKeyDown:=FormKeyDown;
  Grid.OnKeyPress:=GridKeyPress;
  Grid.OnDragDrop:=GridDragDrop;
  Grid.OnDragOver:=GridDragOver;
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;

  Mainqr.Database:=dm.IBDbase;

  pgReestr.ActivePageIndex:=0;
  TControl(cbCurReestr).Align:=alclient;

   cl:=Grid.Columns.Add;
   cl.FieldName:='numreestr1';
   cl.Title.Caption:='№ реестра';
   cl.Width:=60;

   cl:=Grid.Columns.Add;
   cl.FieldName:='blank_series';
   cl.Title.Caption:='Серия бланка';
   cl.Width:=60;

   cl:=Grid.Columns.Add;
   cl.FieldName:='blank_num';
   cl.Title.Caption:='№ бланка';
   cl.Width:=60;

   cl:=Grid.Columns.Add;
   cl.FieldName:='tmpname';
   cl.Title.Caption:='Документ';
   cl.Width:=250;

{   cl:=Grid.Columns.Add;
   cl.FieldName:='ttoname';
   cl.Title.Caption:='Операция';
   cl.Width:=100;}

   cl:=Grid.Columns.Add;
   cl.FieldName:='fio';
   cl.Title.Caption:='Фамилия И.О.';
   cl.Width:=170;

   cl:=Grid.Columns.Add;
   cl.FieldName:='summ';
   cl.Title.Caption:='С/норма';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='summpriv';
   cl.Title.Caption:='С/факт';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='certificatedate';
   cl.Title.Caption:='Дата удостоверения';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='whocertificate';
   cl.Title.Caption:='Кто удостоверил';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='datein';
   cl.Title.Caption:='Дата ввода';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='tuname';
   cl.Title.Caption:='Кто ввел';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='datechange';
   cl.Title.Caption:='Дата изменения';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='tu1name';
   cl.Title.Caption:='Кто изменил';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='notarialactionname';
   cl.Title.Caption:='Нот-ое действие';
   cl.Width:=100;

   cl:=Grid.Columns.Add;
   cl.FieldName:='isnotcancelactionplus';
   cl.Title.Caption:='Документ действителен';
   cl.Width:=60;

   cl:=Grid.Columns.Add;
   cl.FieldName:='whocancel';
   cl.Title.Caption:='Кто отменил';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='datecancel';
   cl.Title.Caption:='Когда отменил';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='numdeal';
   cl.Title.Caption:='Наследственное дело';
   cl.Width:=80;

   cl:=Grid.Columns.Add;
   cl.FieldName:='isdelplus';
   cl.Title.Caption:='Статус записи';
   cl.Width:=55;
   cl.Visible:=false;



   LastOrderStr:=' order by tb.numreestr';

   LoadFromIniReestrParams;
   LoadGridParams;
end;

procedure TfmDocReestr.miLVFindClick(Sender: TObject);
begin
// FindOnListView(LV);
end;

procedure TfmDocReestr.miAddDocClick(Sender: TObject);
var
  fm: TfmDocTree;
  Index: Integer;
begin
  fm:=TfmDocTree.Create(nil);
  try
   NewFm:=fm;
   fm.Caption:=DefSelectDocument;
   fm.pnBottom.Visible:=true;
   fm.Hide;
   fm.Position:=poScreenCenter;
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.ViewType:=vtEdit;
   fm.ViewType:=vtView;
   fm.ActiveQuery;
   Index:=-1;
   if fmDocTree<>nil then
    if fmDocTree.TV.Selected<>nil then
     Index:=fmDocTree.TV.Selected.AbsoluteIndex;
   if Index=-1 then exit;
   fm.tv.Items.Item[Index].MakeVisible;
   fm.tv.Items.Item[Index].Selected:=true;
   fm.ViewNodeNew(fm.tv.Items.Item[Index],true);

   fm.bibOk.OnClick:=DocTreeOkClick;
   fm.LV.OnDblClick:=DocTreeOkClick;

   if fm.ShowModal=mrOk then begin
//     DragDropFromDocTree(fm.LV,LV);
   end;
  finally
   fm.Free;
  end;

end;

procedure TfmDocReestr.DocTreeOkClick(Sender: TObject);
begin
  if NewFm=nil then exit;
  if NewFm.LV.SelCount=0 then begin
    ShowError(Application.Handle,DefSelectDocument+'.');
    exit;
  end;
  NewFm.modalResult:=mrOk;
end;

procedure TfmDocReestr.FormDestroy(Sender: TObject);
begin
  SaveGridParams;
  Grid.Free;
end;

procedure TfmDocReestr.LVKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   case Key of
    VK_DELETE: begin
     if ssCtrl in Shift then begin
     end;
    end;
    VK_Return: begin
    end;
   end;
   OnKeyDown(Sender,Key,Shift);
end;

procedure TfmDocReestr.FillTypeReestrComboAndSetIndex(Index: Integer);
var
  qr: TIBQuery;
  sqls: string;
  namestr: string;
  typeresstr_id: Integer;
  tr: TIBTransaction;
  incv: Integer;
begin
  Screen.Cursor:=crHourGlass;
  cbCurReestr.Items.BeginUpdate;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
   tr.AddDatabase(dm.IBDbase);
   dm.IBDbase.AddTransaction(tr);
   tr.Params.Text:=DefaultTransactionParamsTwo;
   qr.Database:=dm.IBDbase;
   qr.Transaction:=tr;
   qr.Transaction.Active:=true;
   sqls:='Select typereestr_id,name,prefix,sufix from '+TableTypeReestr+' order by sortnum';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   cbCurReestr.Clear;
   qr.First;
   incv:=0;
   while not qr.Eof do begin
     namestr:=Trim(qr.FieldByName('name').AsString);
     typeresstr_id:=qr.FieldByName('typereestr_id').AsInteger;
     cbCurReestr.Items.AddObject(namestr,TObject(Pointer(typeresstr_id)));
     if incv=Index then begin
       Prefix:=Trim(qr.FieldByName('prefix').AsString);
       Sufix:=Trim(qr.FieldByName('sufix').AsString);
     end;
     inc(incv);
     qr.Next;
   end;
  finally
   qr.Free;
   tr.Free;
   cbCurReestr.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
  if cbCurReestr.Items.Count>0 then begin
    if (LastIndex>=0)and(LastIndex<=cbCurReestr.Items.Count-1) then begin
     cbCurReestr.ItemIndex:=Index;
     LastTypeReestrID:=Integer(Pointer(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex])));
    end;
  end;
end;

procedure TfmDocReestr.ActiveQuery;
var
 sqls: string;
begin
 FillTypeReestrComboAndSetIndex(LastIndex);
 Screen.Cursor:=crHourGlass;
 try
  Update;

  Mainqr.AfterScroll:=nil;
  FilterString:=GetFilterString;
  Mainqr.Active:=false;
  Mainqr.Transaction.Active:=true;
  sqls:='Select tb.reestr_id, ttr.prefix||tb.numreestr||ttr.sufix as numreestr1, tb.numreestr, td.name as tdname, '+
        ' tto.name as ttoname, tb.fio, tb.summ, tb.datein, tu.name as tuname, '+
        ' tb.doc_id, tb.oper_id, tb.typereestr_id, tb.whoin, tb.sogl,'+
        ' tb.license_id, tb.tmpname, tb.parent_id, tb.keepdoc, '+
        ' tb.whochange, tb.datechange, tu1.name as tu1name, '+
        ' tb.noyear, tb.defect, tb.summpriv, tb.notarialaction_id, '+
        ' na.name as notarialactionname, '+
        ' ca.reestr_id as isnotcancelaction, '+
        ' tu2.name as whocancel, '+
        ' ca.indate as datecancel, '+
        ' thd.numdeal as numdeal, thd.datedeal as datedeal, tb.hereditarydeal_id as hereditarydeal_id, '+
        ' tb.certificatedate, tn.fio as whocertificate, tn.not_id as whocertificate_id, tb.isdel, '+
        ' tl.blank_id, tl.series as blank_series, tb.blank_num '+
        ' from '+
        TableReestr+' tb left join '+TableDoc+' td on tb.doc_id=td.doc_id left join '+
        TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
        TableOperation+' tto on tb.oper_id=tto.oper_id left join '+
        TableUsers+' tu on tb.whoin=tu.user_id join '+
        TableUsers+' tu1 on tb.whochange=tu1.user_id join '+
        TableNotarialAction+' na on tb.notarialaction_id=na.notarialaction_id left join '+
        TableCancelAction+' ca on tb.reestr_id=ca.reestr_id left join '+
        TableUsers+' tu2 on ca.user_id=tu2.user_id left join '+
        TableHereditaryDeal+' thd on tb.hereditarydeal_id=thd.hereditarydeal_id join '+
        TableNotarius+' tn on tn.not_id=tb.whocertificate_id left join '+
        TableBlanks+'  tl on tl.blank_id=tb.blank_id '+
        FilterString+LastOrderStr;

  Mainqr.Sql.Clear;
  Mainqr.Sql.Add(sqls);

  Mainqr.Active:=true;
  SetBlankNumFormat;
  pnBackGrid.Update;
  Update;
//  Mainqr.Last;
//  RecordCount:=GetRecordCount(Mainqr);
  SetImageFilter;
  ViewCount;
  pnBackGrid.Update;
  Update;
 finally
    case pgReestr.ActivePageIndex of
      0:begin
        pnBackGrid.Parent:=pgReestr.ActivePage;
      end;
      1:begin
        pnBackGrid.Parent:=pgReestr.ActivePage;
      end;
    end;
   Mainqr.AfterScroll:=MainqrAfterScroll;
   MainqrAfterScroll(Mainqr);
   Screen.Cursor:=crDefault;
 end;
end;

procedure TfmDocReestr.GridTitleClickWithSort(Column: TColumn; TypeSort: TTypeColumnSort);
var
  fn: string;
  id: integer;
  sqls: string;
  OrderStr: string;
begin
  if not MainQr.Active then exit;
  if MainQr.RecordCount=0 then exit;
  Screen.Cursor:=crHourGlass;
  Mainqr.AfterScroll:=nil;
  try
   fn:=Column.FieldName;
   if UpperCase(fn)=UpperCase('tdname') then fn:='td.name';
   if UpperCase(fn)=UpperCase('ttoname') then fn:='tto.name';
   if UpperCase(fn)=UpperCase('tuname') then fn:='tu.name';
   if UpperCase(fn)=UpperCase('tu1name') then fn:='tu1.name';
   if UpperCase(fn)=UpperCase('notarialactionname') then fn:='na.name';
   if UpperCase(fn)=UpperCase('numreestr1') then fn:='tb.numreestr';
   if UpperCase(fn)=UpperCase('isnotcancelactionplus') then fn:='ca.reestr_id';
   if UpperCase(fn)=UpperCase('whocancel') then fn:='tu2.name';
   if UpperCase(fn)=UpperCase('datecancel') then fn:='ca.indate';
   if UpperCase(fn)=UpperCase('numdeal') then fn:='thd.numdeal';
   if UpperCase(fn)=UpperCase('fio') then fn:='tb.fio';
   if UpperCase(fn)=UpperCase('whocertificate') then fn:='tn.fio';
   if UpperCase(fn)=UpperCase('isdelplus') then fn:='tb.isdel';
   if UpperCase(fn)=UpperCase('summ') then fn:='tb.summ';
   if UpperCase(fn)=UpperCase('blank_series') then fn:='tl.series';


   id:=MainQr.fieldByName('reestr_id').asInteger;
   MainQr.Active:=false;
  sqls:='Select tb.reestr_id, ttr.prefix||tb.numreestr||ttr.sufix as numreestr1, tb.numreestr, td.name as tdname, '+
        ' tto.name as ttoname, tb.fio, tb.summ, tb.datein, tu.name as tuname, '+
        ' tb.doc_id, tb.oper_id, tb.typereestr_id, tb.whoin, tb.sogl,'+
        ' tb.license_id, tb.tmpname, tb.parent_id, tb.keepdoc, '+
        ' tb.whochange, tb.datechange, tu1.name as tu1name, '+
        ' tb.noyear, tb.defect, tb.summpriv, tb.notarialaction_id, '+
        ' na.name as notarialactionname, '+
        ' ca.reestr_id as isnotcancelaction, '+
        ' tu2.name as whocancel, '+
        ' ca.indate as datecancel, '+
        ' thd.numdeal as numdeal, thd.datedeal as datedeal, tb.hereditarydeal_id as hereditarydeal_id, '+
        ' tb.certificatedate, tn.fio as whocertificate, tn.not_id as whocertificate_id, tb.isdel, '+
        ' tl.blank_id, tl.series as blank_series, tb.blank_num '+
        ' from '+
        TableReestr+' tb left join '+TableDoc+' td on tb.doc_id=td.doc_id left join '+
        TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
        TableOperation+' tto on tb.oper_id=tto.oper_id left join '+
        TableUsers+' tu on tb.whoin=tu.user_id join '+
        TableUsers+' tu1 on tb.whochange=tu1.user_id join '+
        TableNotarialAction+' na on tb.notarialaction_id=na.notarialaction_id left join '+
        TableCancelAction+' ca on tb.reestr_id=ca.reestr_id left join '+
        TableUsers+' tu2 on ca.user_id=tu2.user_id left join '+
        TableHereditaryDeal+' thd on tb.hereditarydeal_id=thd.hereditarydeal_id join '+
        TableNotarius+' tn on tn.not_id=tb.whocertificate_id left join '+
        TableBlanks+'  tl on tl.blank_id=tb.blank_id '+
        GetFilterString;
   MainQr.SQL.Clear;
   case TypeSort of
     tcsNone: OrderStr:='';
     tcsAsc: OrderStr:=' asc ';
     tcsDesc: OrderStr:=' desc ';
   end;
   LastOrderStr:=' Order by '+fn+' '+OrderStr;
   sqls:=sqls+LastOrderStr;
   MainQr.SQL.Add(sqls);
   MainQr.Active:=true;
   SetBlankNumFormat;
   MainQr.First;
   MainQr.Locate('reestr_id',id,[loCaseInsensitive]);
   ViewCount;
  finally
    Mainqr.AfterScroll:=MainqrAfterScroll;
    MainqrAfterScroll(Mainqr);
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmDocReestr.GridDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  if fmDocTree=nil then exit;
  if Source=fmDocTree.Lv then begin
    if fmDocTree.Lv.SelCount=1 then
     Accept:=true
    else
     Accept:=false;
  end;
end;

procedure TfmDocReestr.LVEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
   //

end;

procedure TfmDocReestr.GridDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Source<>nil then begin
   if Source is TListView then begin
     BringToFront;
     Show;
     DragDropFromDocTree(TListView(Source));
   end;
  end;
end;


procedure TfmDocReestr.bibAddClick(Sender: TObject);
begin
  {$IFDEF DEMO}
   if GetReestrCount<MaxReestrCount then begin
   end else begin
     ShowError(Application.Handle,'Лимит демо-версии исчерпан. Обратитесь к разработчикам.');
     exit;
   end;
 {$ENDIF}

  fmCaseReestr.chbKeepDoc.Checked:=KeepDoc;
  if fmCaseReestr.ShowModal=mrOk then begin
    KeepDoc:=fmCaseReestr.chbKeepDoc.Checked;
    case fmCaseReestr.rgbTypeRecord.ItemIndex of
     0: AddToReestrFromDefault;
     1: AddToReestrFromOperation;
    end;
  end;
end;


procedure TfmDocReestr.bibDelClick(Sender: TObject);

  procedure DeleteChild(reestr_id: Integer);
  var
    b: TBookmark;
    i: Integer;
  begin
    Mainqr.DisableControls;
    b:=Mainqr.GetBookmark;
    try
      i:=0;
      while not Mainqr.Eof do begin
        if i=100 then break;
        if Mainqr.FieldByName('parent_id').ASInteger=Reestr_id then begin
           Mainqr.Delete;
           RecordCount:=RecordCount-1;
        end else begin
          inc(i);
          Mainqr.Next;
        end;  
      end;
    finally
      Mainqr.GotoBookmark(b);
      Mainqr.EnableControls;
    end;
  end;
  
  function DeleteRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
    tr: TIBTransaction;
    dt: TDateTime;
  begin
   Screen.Cursor:=crHourGlass;
   tr:=TIBTransaction.Create(nil); 
   qr:=TIBQuery.Create(nil);
   Mainqr.AfterScroll:=nil;
   try
    Result:=false;
    try

     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;

     if isDeleteQuiteInReestr then begin
       sqls:='Delete from '+TableReestr+' where reestr_id='+
              Mainqr.FieldByName('reestr_id').asString;
       qr.sql.Add(sqls);
       qr.ExecSQL;
       qr.Transaction.Commit;

       if MainQr.Locate('reestr_id',Mainqr.FieldByName('reestr_id').asString,[loCaseInsensitive]) then begin
         Upd.DeleteSQL.Clear;
         Upd.DeleteSQL.Add(sqls);

         DeleteChild(Mainqr.FieldByName('reestr_id').AsInteger);
         Mainqr.Delete;

         RecordCount:=RecordCount-1;
       end;
     end else begin

       dt:=StrToDate(DateToStr(WorkDate))+Time;
       sqls:='Update '+TableReestr+
             ' set isdel=1'+
             ', whochange='+inttostr(UserId)+
             ', datechange='+QuotedStr(DateTimeToStr(dt))+
             ' where reestr_id='+Mainqr.FieldByName('reestr_id').asString;
       qr.sql.Add(sqls);
       qr.ExecSQL;
       qr.Transaction.Commit;

       if isViewDeleteQuiteInReestr then begin
         Upd.ModifySQL.Clear;
         Upd.ModifySQL.Add(sqls);
         Mainqr.Edit;
         Mainqr.FieldByName('isdel').Value:=1;
         Mainqr.FieldByName('tu1name').Value:=UserName;
         Mainqr.FieldByName('whochange').Value:=UserId;
         Mainqr.FieldByName('datechange').Value:=dt;
         Mainqr.Post;
       end else begin
         Upd.DeleteSQL.Clear;
         Upd.DeleteSQL.Add(sqls);
         Mainqr.Delete;
         RecordCount:=RecordCount-1;
       end;

     end;  

     Result:=true;
    except
    end;
   finally
    qr.Free;
    tr.Free;
    Mainqr.AfterScroll:=MainqrAfterScroll;
    MainqrAfterScroll(Mainqr);
    Screen.Cursor:=crDefault;
   end;

  end;

  function UpdateRecord: Boolean;
  var
    qr: TIBQuery;
    sqls: string;
    tr: TIBTransaction;
  begin
   Screen.Cursor:=crHourGlass;
   tr:=TIBTransaction.Create(nil);
   qr:=TIBQuery.Create(nil);
   Mainqr.AfterScroll:=nil;
   try
    Result:=false;
    try
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Update '+TableReestr+
           ' set yearwork='+inttostr(2000+Random(4000))+
           ' where reestr_id='+Mainqr.FieldByName('reestr_id').asString;
     qr.sql.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.CommitRetaining;
     Result:=true;
    except
    end; 
   finally
    qr.Free;
    tr.Free;
    Mainqr.Active:=false;
    Mainqr.Active:=true;
    SetBlankNumFormat;
//    Mainqr.Last;
    ViewCount;
    Mainqr.AfterScroll:=MainqrAfterScroll;
    MainqrAfterScroll(Mainqr);
    Screen.Cursor:=crDefault;
   end;

  end;

var
  mr: TModalResult;
  tmps: string;
begin
  if Mainqr.RecordCount=0 then exit;
  if Trim(Mainqr.FieldByName('numreestr').AsString)<>'' then begin
    tmps:='под номером №'+Mainqr.FieldByName('numreestr').AsString;
  end else begin
    tmps:='без номера';
  end;
  mr:=MessageDlg('Удалить документ <'+Mainqr.FieldByName('tmpname').AsString+'> в реестре '+tmps+' ?',mtConfirmation,[mbYes,mbNo],-1);
  if mr=mrYes then begin
    {$IFDEF CONF}
     if not deleteRecord then begin
      ShowError(Application.Handle,'Текущая запись в реестре используется.');
     end;
    {$ENDIF}
    {$IFDEF DEMO}
     if GetReestrCount<MaxReestrCount then begin
      if not UpdateRecord then begin
//       ShowError(Application.Handle,'Текущая запись в реестре используется.');
      end;
     end else begin
       ShowError(Application.Handle,'Лимит демо-версии исчерпан. Обратитесь к разработчикам.');
     end; 
    {$ENDIF}
    {$IFDEF PROF}
     if not deleteRecord then begin
      ShowError(Application.Handle,'Текущая запись в реестре используется.');
     end;
    {$ENDIF}
    {$IFDEF LITE}
     if not deleteRecord then begin
      ShowError(Application.Handle,'Текущая запись в реестре используется.');
     end;
    {$ENDIF}
  end;
end;

procedure TfmDocReestr.SetImageFilter;
begin
{ if Assigned(dm) then begin
  bibFilter.Glyph.Assign(nil);
  bibFilter.Glyph.Width:=dm.IlMain.Width;
  bibFilter.Glyph.Height:=dm.IlMain.Height;
  if isFindNumReestr or isFindDocName or isFindOperName or
    isFindFio or isFindSumm or
    isFindDateFrom or isFindDateTo or
    isFindDateChangeFrom or isFindDateChangeTo or
    isFindUserName then begin

    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,0,true);
    Caption:=ConstCaption+' '+ConstFilterCaption;
  end else begin
    dm.IlMain.draw(bibFilter.Glyph.Canvas,0,0,1,true);
    Caption:=ConstCaption;
  end;
  end;}
  if isFindNumReestr or isFindNumReestrTo or isFindDocName or isFindOperName or
    isFindFio or isFindSumm or
    isFindDateFrom or isFindDateTo or
    isFindDateChangeFrom or isFindDateChangeTo or
    isFindCertFrom or isFindCertTo or
    isFindUserName or isFindCancelAction or isFindNumDeal or
    isFindNotarialAction then begin
    bibFilter.Font.Color:=clRed;
    Caption:=ConstCaption+' '+ConstFilterCaption;
  end else begin
    bibFilter.Font.Color:=clWindowText;
    Caption:=ConstCaption;
  end;

end;


procedure TfmDocReestr.bibFilterClick(Sender: TObject);
var
  fm: TfmDocReestrEdit;
begin
  fm:=TfmDocReestrEdit.Create(nil);
  try
   fm.Caption:=CaptionFilter;

   fm.cbInString.Visible:=true;
   fm.cbInString.Checked:=FilterInside;


   if FindNumReestr<>'' then fm.edNumReestr.Text:=FindNumReestr;
   if FindNumReestrTo<>'' then fm.edNumReestrTo.Text:=FindNumReestrTo;
   if FindDocName<>'' then fm.edDocName.Text:=FindDocName;
   if FindNotarialAction<>'' then fm.edNotarialAction.Text:=FindNotarialAction;
   if FindOperName<>'' then fm.edOperName.Text:=FindOperName;
   if FindFio<>'' then fm.edFio.Text:=FindFio;
   if FindSumm<>'' then fm.edSumm.Text:=FindSumm;
   if isFindDateFrom then
    fm.dtpDateFrom.DateTime:=FindDateFrom;
   fm.dtpDateFrom.Checked:=isFindDateFrom;
   if isFindDateTo then
    fm.dtpDateTo.DateTime:=FindDateTo;
   fm.dtpDateTo.Checked:=isFindDateTo;
   if isFindDateChangeFrom then
    fm.dtpDateChangeFrom.DateTime:=FindDateChangeFrom;
   fm.dtpDateChangeFrom.Checked:=isFindDateChangeFrom;
   if isFindDateChangeTo then
    fm.dtpDateChangeTo.DateTime:=FindDateChangeTo;
   fm.dtpDateChangeTo.Checked:=isFindDateChangeTo;

   if isFindCertFrom then
    fm.dtpCertFrom.DateTime:=FindCertFrom;
   fm.dtpCertFrom.Checked:=isFindCertFrom;
   if isFindCertTo then
    fm.dtpCertTo.DateTime:=FindCertTo;
   fm.dtpCertTo.Checked:=isFindCertTo;

   if FindUserName<>'' then fm.edUserName.Text:=FindUserName;
   if FindCancelAction in [0..2] then fm.cmbCancelAction.ItemIndex:=FindCancelAction;
   if FindNumDeal<>'' then fm.edHereditaryDeal.Text:=FindNumDeal;

   if fm.ShowModal=mrOk then begin

    FindNumReestr:=Trim(fm.edNumReestr.Text);
    FindNumReestrTo:=Trim(fm.edNumReestrTo.Text);
    FindDocName:=Trim(fm.edDocName.Text);
    FindNotarialAction:=Trim(fm.edNotarialAction.Text);
    FindOperName:=Trim(fm.edOperName.Text);
    FindFio:=Trim(fm.edFio.Text);
    FindSumm:=Trim(fm.edSumm.Text);
    if fm.dtpDateFrom.Checked then
     FindDateFrom:=fm.dtpDateFrom.DateTime;
    isFindDateFrom:=fm.dtpDateFrom.Checked;
    if fm.dtpDateTo.Checked then
     FindDateTo:=fm.dtpDateTo.DateTime;
    isFindDateTo:=fm.dtpDateTo.Checked;
    if fm.dtpDateChangeFrom.Checked then
     FindDateChangeFrom:=fm.dtpDateChangeFrom.DateTime;
    isFindDateChangeFrom:=fm.dtpDateChangeFrom.Checked;
    if fm.dtpDateChangeTo.Checked then
     FindDateChangeTo:=fm.dtpDateChangeTo.DateTime;
    isFindDateChangeTo:=fm.dtpDateChangeTo.Checked;

    if fm.dtpCertFrom.Checked then
     FindCertFrom:=fm.dtpCertFrom.DateTime;
    isFindCertFrom:=fm.dtpCertFrom.Checked;
    if fm.dtpCertTo.Checked then
     FindCertTo:=fm.dtpCertTo.DateTime;
    isFindCertTo:=fm.dtpCertTo.Checked;

    FindUserName:=Trim(fm.edUserName.Text);
    FindCancelAction:=fm.cmbCancelAction.ItemIndex;
    FindNumDeal:=Trim(fm.edHereditaryDeal.Text);

    FilterInside:=fm.cbInString.Checked;

    SaveFilter;
    ActiveQuery;
   
   end;

  finally
   fm.Free;
  end;
end;

procedure TfmDocReestr.SaveFilter;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try

    fi.WriteString('DocReestr','NumReestr',FindNumReestr);
    fi.WriteString('DocReestr','NumReestrTo',FindNumReestrTo);
    fi.WriteString('DocReestr','DocName',FindDocName);
    fi.WriteString('DocReestr','NotarialAction',FindNotarialAction);
    fi.WriteString('DocReestr','OperName',FindOperName);
    fi.WriteString('DocReestr','Fio',FindFio);
    fi.WriteString('DocReestr','Summ',FindSumm);
    fi.WriteBool('DocReestr','isDateFrom',isFindDateFrom);
    fi.WriteDate('DocReestr','DateFrom',FindDateFrom);
    fi.WriteBool('DocReestr','isDateTo',isFindDateTo);
    fi.WriteDate('DocReestr','DateTo',FindDateTo);

    fi.WriteBool('DocReestr','isDateChangeFrom',isFindDateChangeFrom);
    fi.WriteDate('DocReestr','DateChangeFrom',FindDateChangeFrom);
    fi.WriteBool('DocReestr','isDateChangeTo',isFindDateChangeTo);
    fi.WriteDate('DocReestr','DateChangeTo',FindDateChangeTo);

    fi.WriteBool('DocReestr','isCertFrom',isFindCertFrom);
    fi.WriteDate('DocReestr','CertFrom',FindCertFrom);
    fi.WriteBool('DocReestr','isCertTo',isFindCertTo);
    fi.WriteDate('DocReestr','CertTo',FindCertTo);

    fi.WriteString('DocReestr','UserName',FindUserName);

    fi.WriteInteger('DocReestr','CancelAction',FindCancelAction);
    fi.WriteString('DocReestr','NumDeal',FindNumDeal);

    fi.WriteBool('DocReestr','Inside',FilterInside);

    SaveGridProp(ClassName,fi,TDbGrid(grid));

  finally
   fi.Free;
  end;
 except
 end; 
end;

procedure TfmDocReestr.SaveGridParams;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try

    SaveGridProp(ClassName,fi,TDbGrid(grid));

  finally
   fi.Free;
  end;
 except
 end; 
end;

procedure TfmDocReestr.LoadFilter;
var
  fi: TIniFile;

begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try

    FindNumReestr:=fi.ReadString('DocReestr','NumReestr',FindNumReestr);
    FindNumReestrTo:=fi.ReadString('DocReestr','NumReestrTo',FindNumReestrTo);
    FindDocName:=fi.ReadString('DocReestr','DocName',FindDocName);
    FindNotarialAction:=fi.ReadString('DocReestr','NotarialAction',FindNotarialAction);
    FindOperName:=fi.ReadString('DocReestr','OperName',FindOperName);
    FindFio:=fi.ReadString('DocReestr','Fio',FindFio);
    FindSumm:=fi.ReadString('DocReestr','Summ',FindSumm);

    isFindDateFrom:=fi.ReadBool('DocReestr','isDateFrom',isFindDateFrom);
    FindDateFrom:=fi.ReadDate('DocReestr','DateFrom',FindDateFrom);

    isFindDateTo:=fi.ReadBool('DocReestr','isDateTo',isFindDateTo);
    FindDateTo:=fi.ReadDate('DocReestr','DateTo',FindDateTo);

    isFindDateChangeFrom:=true;
    FindDateChangeFrom:=trunc(WorkDate);

    isFindDateChangeTo:=true;
    FindDateChangeTo:=trunc(WorkDate)+StrToTime('23:59:59');

    isFindCertFrom:=fi.ReadBool('DocReestr','isCertFrom',isFindCertFrom);
    FindCertFrom:=fi.ReadDate('DocReestr','CertFrom',FindCertFrom);

    isFindCertTo:=fi.ReadBool('DocReestr','isCertTo',isFindCertTo);
    FindCertTo:=fi.ReadDate('DocReestr','CertTo',FindCertTo);

    FindUserName:=fi.ReadString('DocReestr','UserName',FindUserName);

    FindCancelAction:=fi.ReadInteger('DocReestr','CancelAction',FindCancelAction);
    FindNumDeal:=fi.ReadString('DocReestr','NumDeal',FindNumDeal);

    FilterInside:=fi.ReadBool('DocReestr','Inside',FilterInside);

    LastIndex:=fi.ReadInteger('DocReestr','LastIndexTypeReestr',LastIndex);

    LoadGridProp(ClassName,fi,TDbGrid(grid));

  finally
   fi.Free;
  end;
 except

 end; 
end;

procedure TfmDocReestr.LoadGridParams;
var
  fi: TIniFile;
begin
 try
  fi:=TIniFile.Create(GetIniFileName);
  try

    LoadGridProp(ClassName,fi,TDbGrid(grid));

  finally
   fi.Free;
  end;
 except
 end;
end;


procedure TfmDocReestr.GridDblClick(Sender: TObject);
begin
  miChangeWithOutForm.Click;
end;

procedure TfmDocReestr.pgReestrChange(Sender: TObject);
begin
  ActiveQuery;
end;

procedure TfmDocReestr.ViewCount;
begin
 if MainQr.Active then begin
   RecordCount:=GetRecordCountFromReestr;
 end;
end;


procedure TfmDocReestr.bibRefreshClick(Sender: TObject);
begin
  ActiveQuery;
end;

procedure TfmDocReestr.cbCurReestrChange(Sender: TObject);
begin
  LastIndex:=cbCurReestr.ItemIndex;
  if LastIndex<>-1 then begin
   LastTypeReestrID:=Integer(Pointer(TObject(cbCurReestr.Items.Objects[cbCurReestr.ItemIndex])));
  end; 
  ActiveQuery;
end;

procedure TfmDocReestr.AddToReestrFromDefault;
var
  fm: TfmDocTree;
  Index: Integer;
begin
  fm:=TfmDocTree.Create(nil);
  try
   NewFm:=fm;
   fm.Caption:=DefSelectDocument;
   fm.pnBottom.Visible:=true;
   fm.Hide;
   fm.Position:=poScreenCenter;
   fm.BorderIcons:=[biSystemMenu, biMaximize];
   fm.ViewType:=vtEdit;
   fm.ViewType:=vtView;
   fm.ActiveQuery;
   Index:=-1;
   if fmDocTree<>nil then
    if fmDocTree.TV.Selected<>nil then
     Index:=fmDocTree.TV.Selected.AbsoluteIndex;
   if Index<>-1 then begin
    fm.tv.Items.Item[Index].MakeVisible;
    fm.tv.Items.Item[Index].Selected:=true;
    fm.ViewNodeNew(fm.tv.Items.Item[Index],true);
   end; 

   fm.bibOk.OnClick:=DocTreeOkClick;
   fm.LV.OnDblClick:=DocTreeOkClick;

   if fm.ShowModal=mrOk then begin
     DragDropFromDocTree(fm.LV);
   end;
  finally
   fm.Free;
  end;

end;

function TfmDocReestr.GetMaxReestrIDEx(DB: TIBDatabase): Integer;
begin
  Result:=GetGenIdEx(DB,TableReestr,1);
end;

function TfmDocReestr.GetMaxReestrID: Integer;
{var
  qr: TIBQuery;
  sqls: String;
  tr: TIBTransaction;}
begin
  Result:=GetGenId(TableReestr,1);
{  Screen.Cursor:=crHourGlass;
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
   sqls:='Select Max(reestr_id) as reestr_id from '+TableReestr;
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then
    Result:=qr.FieldByName('reestr_id').AsInteger+1;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;}
end;

procedure TfmDocReestr.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tmps: string;  
begin
  if not isValidKey(Char(Key))or(Key=VK_BACK) then exit;
  Mainqr.AfterScroll:=nil;
  try
   if MainQr.IsEmpty then exit;
   if grid.SelectedField=nil then exit;
   tmps:=grid.SelectedField.FullName;
   if AnsiUpperCase(tmps)=AnsiUpperCase('isnotcancelactionplus') then exit;
   MainQr.Locate(tmps,Trim(edSearch.Text),
                [loPartialKey,loCaseInsensitive]);
  finally
    Mainqr.AfterScroll:=MainqrAfterScroll;
    MainqrAfterScroll(Mainqr);
  end;
end;

procedure TfmDocReestr.AddToReestrFromOperation;
var
  fm: TfmNewOperation;
begin
  fm:=TfmNewOperation.Create(Application);
  fm.dtpCertificateDate.DateTime:=SysUtils.StrToDate(DateToStr(WorkDate))+SysUtils.Time;
  fm.DefLastTypeReestrID:=LastTypeReestrID;
  fm.LastTypeReestrID:=LastTypeReestrID;
  fm.LastOperID:=LastOperID;
  fm.Caption:=captionAdd+' операцию';
  fm.bibOk.OnClick:=fm.bibOkClickAppend;
  fm.bibCancel.OnClick:=fm.bibCancelClickAppend;
  fm.bibOtlogen.OnClick:=fm.bibOtlogenClickAppend;
  fm.DestroyHeaderAndCreateNew;

  fm.FillAllNeedField;
  fm.FillReminders;
  fm.FormStyle:=fsMDIChild;

end;

procedure TfmDocReestr.bibChangeClick(Sender: TObject);
var
 pt: TPoint;
 CaseDoc: Boolean;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then begin
    ShowError(Application.Handle,'Выберите запись реестра.');
    exit;
  end;
  if Trim(Mainqr.FieldByName('parent_id').AsString)='' then begin
   CaseDoc:=Trim(Mainqr.FieldByName('doc_id').AsString)<>'';
   if CaseDoc then begin
    pt.x:=bibChange.Left+bibChange.Width;
    pt.y:=bibChange.Top+bibChange.Height;
    pt:=pnR.ClientToScreen(pt);
    pmChange.Popup(pt.x,pt.y);
   end else begin
    ChangeReestrFromOperation;
   end;
  end else begin
    ChangeCopyReestr;
  end;
end;

procedure TfmDocReestr.ChangeReestrWithFlag(tcd:TTypeChangeDoc);
var
  CaseDoc: Boolean;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then begin
    ShowError(Application.Handle,'Выберите запись реестра.');
    exit;
  end;
  if Trim(Mainqr.FieldByName('parent_id').AsString)='' then begin
   CaseDoc:=Trim(Mainqr.FieldByName('doc_id').AsString)<>'';
   if CaseDoc then begin
    ChangeReestrFromDefault(tcd);
   end else begin
    ChangeReestrFromOperation;
   end;
  end else begin
    ChangeCopyReestr;
  end;
end;

procedure TfmDocReestr.ChangeReestrFromDefault(tcd:TTypeChangeDoc);
var
  msOutForm, msWords: TMemoryStream;
  fmNew: TfmNewForm;
  qr: TIBQuery;
  sqls: string;
  KeepFileName: string;
  List: Tlist;
  tb: TIBTable;
  lastid: String;
  tr: TIBTransaction;
  IsOtlogen: Boolean;
  ListControls: TList;
  i: Integer;
  CheckSumFileName,CheckSumDoc: LongWord;
  numreestr: Variant;
  fmInput: TfmInputNumber;
  D: Variant;
  Words: TStringList;
  Error: Boolean;
begin
 case tcd of
  tcdFormDoc: begin
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
       sqls:='Select dataform from '+TableReestr+' where reestr_id='+Mainqr.FieldByname('reestr_id').AsString;
       qr.SQL.Add(sqls);
       qr.Active:=true;
       TBlobField(qr.fieldByName('dataform')).SaveToStream(msOutForm);
       msOutForm.Position:=0;
       ExtractObjectFromStream(msOutForm);
       msOutForm.Position:=0;
       FreeAllComponents(fmNew);
       Error:=false;
       LoadControlFromStream(fmNew,msOutForm,Error);
       if not Error then begin
         fmNew.ViewDoc:=true;
         fmNew.DestroyHeaderAndCreateNew;
         fmNew.OnKeyDown:=fmMain.OnKeyDown;
         fmNew.OnKeyPress:=fmMain.OnKeyPress;
         fmNew.OnKeyUp:=fmMain.OnKeyUp;
         fmNew.ViewType:=vtEdit;
         fmNew.ViewType:=vtView;
         fmNew.Caption:=captionChange+' документ <'+
                        Trim(Mainqr.FieldByname('tdname').AsString)+'>';
         fmNew.bibOk.OnClick:=fmNew.bibOkClickUpdate;
         fmNew.bibCancel.OnClick:=fmNew.bibCancelClickUpdate;
         fmNew.bibOtlogen.OnClick:=fmNew.bibOtlogenClickUpdate;
         fmNew.bibOtlogen.Enabled:=true;
         fmNew.isCreateReestr:=true;
         fmNew.DefLastTypeReestrID:=fmDocReestr.LastTypeReestrID;
         fmNew.LastTypeReestrID:=fmDocReestr.LastTypeReestrID;
         fmNew.LastDocId:=Mainqr.FieldByname('doc_id').AsInteger;
         fmNew.isInsert:=Trim(Mainqr.FieldByname('numreestr').AsString)='';
         fmNew.chbNoYear.Checked:=Mainqr.FieldByname('noyear').AsInteger<>0;
         fmNew.chbDefect.Checked:=Mainqr.FieldByname('defect').AsInteger<>0;
         fmNew.SummEdit.Value:=Mainqr.FieldByname('summ').AsFloat;
         fmNew.SummEditPriv.Value:=Mainqr.FieldByname('summpriv').AsFloat;
         fmNew.edDocName.Text:=Mainqr.FieldByname('tmpname').AsString;
         fmNew.dtpCertificateDate.DateTime:=Mainqr.FieldByname('certificatedate').AsDateTime;

         LastNotarialActionId:=Mainqr.FieldByname('notarialaction_id').AsInteger;

         fmNew.chbOnSogl.Checked:=Mainqr.FieldByname('sogl').AsInteger<>0;
         if Trim(Mainqr.FieldByname('numdeal').AsString)<>'' then begin
           fmNew.OldHereditaryDealId:=Mainqr.fieldByName('hereditarydeal_id').AsInteger;
           fmNew.OldHereditaryDealNum:=Mainqr.FieldByname('numdeal').AsString;
           fmNew.OldHereditaryDealDate:=Mainqr.FieldByname('datedeal').AsDateTime;
           fmNew.edHereditaryDeal.Text:=Mainqr.fieldByName('numdeal').AsString+' от '+
                                        Mainqr.fieldByName('datedeal').AsString;
         end;

         fmNew.isKeepDoc:=Mainqr.FieldByname('keepdoc').AsInteger<>0;
         fmNew.RenovationId:=GetRenovationIdByDocId(Mainqr.FieldByname('doc_id').AsInteger);
         fmNew.FillAllNeedFieldForUpdate(Mainqr.FieldByname('numreestr').AsInteger,
                                         Mainqr.FieldByname('typereestr_id').AsInteger,
                                         Mainqr.FieldByname('fio').AsString,
                                         Mainqr.FieldByname('summ').AsFloat,
                                         Mainqr.FieldByname('reestr_id').AsInteger,
                                         Mainqr.FieldByname('license_id').AsInteger,
                                         Mainqr.FieldByname('blank_id').Value,
                                         Mainqr.FieldByname('blank_num').DisplayText);
         fmNew.FillReminders;
         fmNew.SetOnExitForImenitControl;
         fmNew.PrepeareControlsAfterLoad(fmNew.pnDesign);

         ListControls:=TList.Create;
         GetControlByPropValue(fmNew,'Checked',false,ListControls);
         try
           fmNew.WindowState:=wsNormal;
           fmNew.FormStyle:=fsMDIChild;
           fmNew.WindowState:=wsMaximized;
  //         fmNew.PrepeareControlsAfterLoad(fmNew.pnDesign);
           fmNew.Update;
           fmNew.LocateFirstFocusedControl;

         finally
           for i:=0 to ListControls.Count-1 do begin
             if TControl(ListControls.Items[i]) is TDateTimePicker then begin
               TDateTimePicker(ListControls.Items[i]).Checked:=false;
             end;
           end;
           ListControls.Free;
         end;
       end;

        finally
         Screen.Cursor:=crDefault;
        end;
     finally
      msOutForm.Free;
      qr.Free;
      tr.Free;
     end;
    end;
  tcdDoc: begin
   List:=Tlist.Create;
   msOutForm:=TMemoryStream.Create;
   msWords:=TMemoryStream.Create;
   Words:=TStringList.Create;
   try
    if not ExtractDocFileFromReestr(Mainqr.FieldByname('reestr_id').AsInteger,
                                    Trim(Mainqr.FieldByname('fio').AsString)) then exit;
    KeepFileName:=lastFileDoc;
    if SetFieldsToWord(List,false,true) then begin
     if ActiveWordKeepDoc(KeepFileName,true) then begin



        IsOtlogen:=trim(Mainqr.FieldByname('numreestr').AsString)='';

        CompressAndCryptFile(KeepFileName,msOutForm);
        CheckSumFileName:=CalculateCheckSum(msOutForm.Memory,msOutForm.Size);
        CheckSumDoc:=CalculateCheckSumByReestrId(Mainqr.FieldByname('reestr_id').AsInteger);

        if CheckSumFileName=CheckSumDoc then exit;

        if isAutoBuildWords then begin
          Screen.Cursor:=crHourGlass;
          try
            D:=GetDocumentRefByFileName(KeepFileName);
            GetTextByDocument(D,Words);
          finally
            Screen.Cursor:=crDefault;
          end;  
        end;

(*        if QuestionOnAddToReestr and IsOtlogen then begin

           mr:=MessageDlg('Поместить документ в <Активные - да> или в <Отложенные - нет> ?',mtConfirmation,[mbYes,mbNo,mbCancel],-1);
           case mr of
             mrYes: begin
               IsOtlogen:=false;
             end;
             mrNo: begin
               IsOtlogen:=true;
             end;
             mrCancel: begin
               exit;
             end;
            end;

        end else begin
           IsOtlogen:=true;
        end;*)

        numreestr:=Null;
        if IsOtlogen then begin
          fmInput:=TfmInputNumber.Create(nil);
          try
            fmInput.edNumber.Text:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
            fmInput.TypeReestrId:=Mainqr.FieldByname('typereestr_id').AsInteger;
            if fmInput.ShowModal=mrOk then begin
              numreestr:=Trim(fmInput.edNumber.Text);
            end;  
          finally
            fmInput.Free;
          end;
        end else
          numreestr:=Mainqr.FieldByname('numreestr').AsInteger;


           Screen.Cursor:=crHourGlass;
           tr:=TIBTransaction.Create(nil);
           tb:=TIBTable.Create(nil);
           try
             tr.AddDatabase(dm.IBDbase);
             dm.IBDbase.AddTransaction(tr);
             tr.Params.Text:=DefaultTransactionParamsTwo;
             tb.Database:=dm.IBDbase;
             tb.Transaction:=tr;
             tb.Transaction.Active:=true;

             tb.TableName:=TableReestr;
             lastid:=Mainqr.FieldByname('reestr_id').AsString;
             tb.Filter:=' reestr_id='+lastid;
             tb.Filtered:=true;

             tb.Active:=true;

             tb.edit;

             tb.FieldByName('numreestr').Value:=numreestr;

             tb.FieldByName('reestr_id').Asinteger:=Mainqr.FieldByname('reestr_id').AsInteger;
             tb.FieldByName('doc_id').AsInteger:=Mainqr.FieldByname('doc_id').AsInteger;
             tb.FieldByName('datein').AsDateTime:=tb.FieldByName('datein').AsDateTime;
             tb.FieldByName('whoin').AsInteger:=tb.FieldByName('whoin').AsInteger;
             tb.FieldByName('datechange').AsDateTime:=WorkDate;
             tb.FieldByName('whochange').AsInteger:=UserId;
             tb.FieldByName('keepdoc').AsInteger:=tb.FieldByName('keepdoc').AsInteger;
             tb.FieldByName('yearwork').AsInteger:=WorkYear;
             tb.FieldByName('typereestr_id').AsInteger:=Mainqr.FieldByname('typereestr_id').AsInteger;
             tb.FieldByName('notarialaction_id').AsInteger:=Mainqr.FieldByname('notarialaction_id').AsInteger;
             tb.FieldByName('noyear').AsInteger:=Mainqr.FieldByname('noyear').AsInteger;
             tb.FieldByName('defect').AsInteger:=Mainqr.FieldByname('defect').AsInteger;
             tb.FieldByName('summpriv').AsFloat:=tb.FieldByName('summpriv').AsFloat;
             tb.FieldByName('fio').AsString:=tb.FieldByName('fio').AsString;
             tb.FieldByName('summ').AsFloat:=tb.FieldByName('summ').AsFloat;
             tb.FieldByName('sogl').AsInteger:=tb.FieldByName('sogl').AsInteger;

             tb.FieldByName('countuse').AsInteger:=tb.FieldByName('countuse').AsInteger+1;

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

             NeedCacheUpdate(false,
                             lastid,true,
                             Null,false,
                         //    iff(IsOtlogen,numreestr,null),true,
                             numreestr,true,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             LastTypeReestrID,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             UserId,true,
                             StrToDate(DateToStr(WorkDate))+Time,true,
                             UserName,true,
                             Null,false,
                             NUll,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                             Null,false,
                                     Null,False,
                                     Null,Null,null);


           finally
             tb.Free;
             tr.Free;
{             fmDocReestr.Mainqr.Active:=false;
             fmDocReestr.Mainqr.Active:=true;
             fmDocReestr.Mainqr.locate('reestr_id',lastid,[loCaseInsensitive]);
             fmDocReestr.ViewCount;}
             Screen.Cursor:=crDefault;
           end;
        end;
    end;
   finally
    Words.Free;
    msWords.Free;
    msOutForm.free;
    List.Free;
   end;
  end;
  tcdForm: begin
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
       sqls:='Select dataform from '+TableReestr+' where reestr_id='+Mainqr.FieldByname('reestr_id').AsString;
       qr.SQL.Add(sqls);
       qr.Active:=true;
       TBlobField(qr.fieldByName('dataform')).SaveToStream(msOutForm);
       msOutForm.Position:=0;
       ExtractObjectFromStream(msOutForm);
       msOutForm.Position:=0;
       FreeAllComponents(fmNew);
       Error:=false;
       LoadControlFromStream(fmNew,msOutForm,Error);

       if not Error then begin

         fmNew.ViewDoc:=false;
         fmNew.DestroyHeaderAndCreateNew;
         fmNew.OnKeyDown:=fmMain.OnKeyDown;
         fmNew.OnKeyPress:=fmMain.OnKeyPress;
         fmNew.OnKeyUp:=fmMain.OnKeyUp;
         fmNew.ViewType:=vtEdit;
         fmNew.ViewType:=vtView;
         fmNew.Caption:=captionChange+' документ <'+
                        Trim(Mainqr.FieldByname('tdname').AsString)+'>';
         fmNew.bibOk.OnClick:=fmNew.bibOkClickUpdate;
         fmNew.bibCancel.OnClick:=fmNew.bibCancelClickUpdate;
         fmNew.bibOtlogen.OnClick:=fmNew.bibOtlogenClickUpdate;
         fmNew.bibOtlogen.Enabled:=true;
         fmNew.isCreateReestr:=true;
         fmNew.DefLastTypeReestrID:=fmDocReestr.LastTypeReestrID;
         fmNew.LastTypeReestrID:=fmDocReestr.LastTypeReestrID;
         fmNew.LastDocId:=Mainqr.FieldByname('doc_id').AsInteger;
         fmNew.isInsert:=Trim(Mainqr.FieldByname('numreestr').AsString)='';
         fmNew.chbNoYear.Checked:=Mainqr.FieldByname('noyear').AsInteger<>0;
         fmNew.chbDefect.Checked:=Mainqr.FieldByname('defect').AsInteger<>0;
         fmNew.SummEdit.Value:=Mainqr.FieldByname('summ').AsFloat;
         fmNew.SummEditPriv.Value:=Mainqr.FieldByname('summpriv').AsFloat;
         fmNew.edDocName.Text:=Mainqr.FieldByname('tmpname').AsString;
         fmNew.dtpCertificateDate.DateTime:=Mainqr.FieldByname('certificatedate').AsDateTime;
         LastNotarialActionId:=Mainqr.FieldByname('notarialaction_id').AsInteger;

         if Trim(Mainqr.FieldByname('numdeal').AsString)<>'' then begin
           fmNew.OldHereditaryDealId:=Mainqr.fieldByName('hereditarydeal_id').AsInteger;
           fmNew.OldHereditaryDealNum:=Mainqr.FieldByname('numdeal').AsString;
           fmNew.OldHereditaryDealDate:=Mainqr.FieldByname('datedeal').AsDateTime;
           fmNew.edHereditaryDeal.Text:=Mainqr.fieldByName('numdeal').AsString+' от '+
                                        Mainqr.fieldByName('datedeal').AsString;
         end;

         fmNew.chbOnSogl.Checked:=Mainqr.FieldByname('sogl').AsInteger<>0;
         fmNew.isKeepDoc:=Mainqr.FieldByname('keepdoc').AsInteger<>0;
         fmNew.RenovationId:=GetRenovationIdByDocId(Mainqr.FieldByname('doc_id').AsInteger);
         fmNew.FillAllNeedFieldForUpdate(Mainqr.FieldByname('numreestr').AsInteger,
                                         Mainqr.FieldByname('typereestr_id').AsInteger,
                                         Mainqr.FieldByname('fio').AsString,
                                         Mainqr.FieldByname('summ').AsFloat,
                                         Mainqr.FieldByname('reestr_id').AsInteger,
                                         Mainqr.FieldByname('license_id').AsInteger,
                                         Mainqr.FieldByname('blank_id').Value,
                                         Mainqr.FieldByname('blank_num').DisplayText);
         fmNew.FillReminders;
         fmNew.SetOnExitForImenitControl;
         fmNew.PrepeareControlsAfterLoad(fmNew.pnDesign);

         ListControls:=TList.Create;
         GetControlByPropValue(fmNew,'Checked',false,ListControls);
         try
           fmNew.WindowState:=wsNormal;
           fmNew.FormStyle:=fsMDIChild;
           fmNew.WindowState:=wsMaximized;
           fmNew.Update;
  //         fmNew.PrepeareControlsAfterLoad(fmNew.pnDesign);
           fmNew.LocateFirstFocusedControl;

         finally
           for i:=0 to ListControls.Count-1 do begin
             if TControl(ListControls.Items[i]) is TDateTimePicker then begin
               TDateTimePicker(ListControls.Items[i]).Checked:=false;
             end;
           end;
           ListControls.Free;
         end;
       end;

      finally
       Screen.Cursor:=crDefault;
      end;
     finally
      msOutForm.Free;
      qr.Free;
      tr.Free;
     end;
  end;
 end;
end;

procedure TfmDocReestr.ChangeReestrFromOperation;
var
  fm: TfmNewOperation;
begin
  fm:=TfmNewOperation.Create(Application);
  fm.DestroyHeaderAndCreateNew;
  fm.dtpCertificateDate.DateTime:=Mainqr.FieldByname('certificatedate').AsDateTime;
  fm.DefLastTypeReestrID:=LastTypeReestrID;
  fm.LastTypeReestrID:=LastTypeReestrID;
  fm.LastOperID:=LastOperID;
  fm.Caption:=captionChange+' операцию <'+
                      Trim(Mainqr.FieldByname('ttoname').AsString)+'>';
  fm.bibOk.OnClick:=fm.bibOkClickUpdate;
  fm.bibCancel.OnClick:=fm.bibCancelClickUpdate;
  fm.bibOtlogen.OnClick:=fm.bibOtlogenClickUpdate;
  fm.bibOtlogen.Enabled:=false;

  fm.isInsert:=Trim(Mainqr.FieldByname('numreestr').AsString)='';
  fm.LastOperID:=Mainqr.FieldByname('oper_id').AsInteger;

  fm.chbNoYear.Checked:=Mainqr.FieldByname('noyear').AsInteger<>0;
  fm.chbDefect.Checked:=Mainqr.FieldByname('defect').AsInteger<>0;
  fm.SummEdit.Value:=Mainqr.FieldByname('summ').AsFloat;
  fm.SummEditPriv.Value:=Mainqr.FieldByname('summpriv').AsFloat;
  LastNotarialActionId:=Mainqr.FieldByname('notarialaction_id').AsInteger;

  
  fm.FillAllNeedFieldForUpdate(Mainqr.FieldByname('numreestr').AsInteger,
                               Mainqr.FieldByname('typereestr_id').AsInteger,
                               Mainqr.FieldByname('fio').AsString,
                               Mainqr.FieldByname('summ').AsFloat,
                               Mainqr.FieldByname('reestr_id').AsInteger,
                               Mainqr.FieldByname('license_id').AsInteger);
  fm.FillReminders;                             
  fm.FormStyle:=fsMDIChild;

end;

procedure TfmDocReestr.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (not (ssAlt in Shift))and(not(ssCtrl in Shift)) then begin
  case Key of
    VK_F2, VK_INSERT: bibAdd.Click;
    VK_F3, VK_RETURN: bibChange.Click;
    VK_F4,VK_DELETE: bibDel.Click;
    VK_F5: bibRefresh.Click;
    VK_F6: bibFilter.Click;
    VK_F7: bibAdjust.Click;
    VK_F8: bibCancelAction.Click;
    VK_F9: edSearch.SetFocus;
    VK_F10: bibPrint.Click;
  end;
 end;
 if Shift=[ssCtrl] then begin
   case Key of
     byte('1'): begin
       pgReestr.ActivePageIndex:=0;
       pgReestrChange(nil);
     end;
     byte('2'): begin
       pgReestr.ActivePageIndex:=1;
       pgReestrChange(nil);
     end;  
   end;
 end; 
 fmMain.FormKeyDown(Sender,Key,Shift);
end;

{$WARNINGS OFF}
function TfmDocReestr.GetFilterString: string;
var
  FilInSide: string;
  wherestr: string;
  addstr1,addstr2,addstr3,addstr4,addstr5,
  addstr6,addstr7,addstr8,addstr9,addstr10,addstr11,addstr12,addstr13,addstr14,addstr15,addstr16,
  addstr17: string;
  and1,and2,and3,and4,and5,and6,and7,and8,and9,and10,and11,and12,and13,and14,and15,and16: string;
  tmps: string;
//  addstr61,addstr71: string;
begin
   if FilterReestrId='' then begin
    isFindNumreestr:=(trim(FindNumReestr)<>'') and IsInteger(trim(FindNumReestr));
    isFindNumreestrTo:=(trim(FindNumReestrTo)<>'') and IsInteger(trim(FindNumReestrTo));
    isFindDocName:=trim(FindDocName)<>'';
    isFindOperName:=trim(FindOperName)<>'';
    isFindFio:=trim(FindFio)<>'';
    isFindSumm:=trim(FindSumm)<>'';
    isFindUserName:=trim(FindUserName)<>'';
    isFindCancelAction:=(FindCancelAction>=1)and(FindCancelAction<=2);
    isFindNumDeal:=Trim(FindNumDeal)<>'';
    isFindNotarialAction:=Trim(FindNotarialAction)<>'';

    if isFindNumreestr or isFindNumreestrTo or isFindDocName or isFindOperName or isFindFio or isFindUserName or
     isFindSumm or isFindCancelAction or isFindNumDeal or
     isFindDateFrom or isFindDateTo or
     isFindDateChangeFrom or isFindDateChangeTo or
     isFindCertFrom or isFindCertTo or
     isFindNotarialAction or
     isFindUserName or (not isViewDeleteQuiteInReestr) then begin
       wherestr:=' where ';
    end else begin
///       wherestr:=' where ';
    end;

    if FilterInside then FilInSide:='%';

      if isFindNumreestr then begin
        addstr1:=' numreestr>= '+Trim(FindNumreestr)+' ';
      end;
      if isFindDocName then begin
      //  addstr2:=' Upper(td.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDocName+'%'))+' ';
        addstr2:=' Upper(tmpname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindDocName+'%'))+' ';
      end;
      if isFindOperName then begin
//        addstr3:=' Upper(tto.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOperName+'%'))+' ';
        addstr3:=' Upper(tmpname) like '+AnsiUpperCase(QuotedStr(FilInSide+FindOperName+'%'))+' ';
      end;
      if isFindFio then begin
        addstr4:=' Upper(tb.fio) like '+AnsiUpperCase(QuotedStr(FilInSide+FindFio+'%'))+' ';
      end;
      if isFindSumm then begin
        addstr5:=' summ ='+FindSumm+' ';
      end;
      if isFindDateFrom then begin
         addstr6:=' tb.datein >='''+formatdatetime(fmtDateTime,FindDateFrom)+''' ';
      end;

      if isFindDateTo then begin
         addstr7:=' tb.datein <='''+formatdatetime(fmtDateTime,FindDateTo)+''' ';
      end;

      if isFindDateChangeFrom then begin
         addstr8:=' tb.datechange >='''+formatdatetime(fmtDateTime,FindDateChangeFrom)+''' ';
      end;

      if isFindDateChangeTo then begin
         addstr9:=' tb.datechange <='''+formatdatetime(fmtDateTime,FindDateChangeTo)+''' ';
      end;

      if isFindUserName then begin
        addstr10:=' Upper(tu.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindUserName+'%'))+' ';
      end;

      if isFindCancelAction then begin
        case FindCancelAction of
          1: addstr11:=' ca.reestr_id is not null ';
          2: addstr11:=' ca.reestr_id is null ';
        end;
      end;

      if isFindNumDeal then begin
        addstr12:=' Upper(thd.numdeal) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNumDeal+'%'))+' ';
      end;

      if isFindNumreestrTo then begin
        addstr13:=' numreestr<= '+Trim(FindNumreestrTo)+' ';
      end;

      if isFindCertFrom then begin
         addstr14:=' certificatedate >='''+formatdatetime(fmtDateTime,FindCertFrom)+''' ';
      end;

      if isFindCertTo then begin
         addstr15:=' certificatedate <='''+formatdatetime(fmtDateTime,FindCertTo)+''' ';
      end;

      if (not isViewDeleteQuiteInReestr) then begin
         addstr16:=' (isdel is null or isdel=0) ';
      end else begin
         addstr16:='';
      end;

      if isFindNotarialAction then begin
        addstr17:=' Upper(na.name) like '+AnsiUpperCase(QuotedStr(FilInSide+FindNotarialAction+'%'))+' ';
      end;

      if (isFindNumreestr and isFindDocName)or
         (isFindNumreestr and isFindOperName)or
         (isFindNumreestr and isFindFio)or
         (isFindNumreestr and isFindSumm)or
         (isFindNumreestr and isFindDateFrom)or
         (isFindNumreestr and isFindDateTo)or
         (isFindNumreestr and isFindDateChangeFrom)or
         (isFindNumreestr and isFindDateChangeTo)or
         (isFindNumreestr and isFindUserName)or
         (isFindNumreestr and isFindCancelAction)or
         (isFindNumreestr and isFindNumDeal)or
         (isFindNumreestr and isFindNumreestrTo)or
         (isFindNumreestr and  isFindCertFrom)or
         (isFindNumreestr and isFindCertTo)or
         (isFindNumreestr and (not isViewDeleteQuiteInReestr))or
         (isFindNumreestr and isFindNotarialAction)
         then and1:=' and ';

      if (isFindDocName and isFindOperName)or
         (isFindDocName and isFindFio)or
         (isFindDocName and isFindSumm)or
         (isFindDocName and isFindDateFrom)or
         (isFindDocName and isFindDateTo)or
         (isFindDocName and isFindDateChangeFrom)or
         (isFindDocName and isFindDateChangeTo)or
         (isFindDocName and isFindUserName)or
         (isFindDocName and isFindCancelAction)or
         (isFindDocName and isFindNumDeal)or
         (isFindDocName and isFindNumreestrTo)or
         (isFindDocName and  isFindCertFrom)or
         (isFindDocName and isFindCertTo)or
         (isFindDocName and (not isViewDeleteQuiteInReestr))or
         (isFindDocName and isFindNotarialAction)
         then and2:=' and ';

      if (isFindOperName and isFindFio)or
         (isFindOperName and isFindSumm)or
         (isFindOperName and isFindDateFrom)or
         (isFindOperName and isFindDateTo)or
         (isFindOperName and isFindDateChangeFrom)or
         (isFindOperName and isFindDateChangeTo)or
         (isFindOperName and isFindUserName)or
         (isFindOperName and isFindCancelAction)or
         (isFindOperName and isFindNumDeal)or
         (isFindOperName and isFindNumreestrTo)or
         (isFindOperName and  isFindCertFrom)or
         (isFindOperName and isFindCertTo)or
         (isFindOperName and (not isViewDeleteQuiteInReestr))or
         (isFindOperName and isFindNotarialAction)
         then and3:=' and ';

      if (isFindFio and isFindSumm)or
         (isFindFio and isFindDateFrom)or
         (isFindFio and isFindDateTo)or
         (isFindFio and isFindDateChangeFrom)or
         (isFindFio and isFindDateChangeTo)or
         (isFindFio and isFindUserName)or
         (isFindFio and isFindCancelAction)or
         (isFindFio and isFindNumDeal)or
         (isFindFio and isFindNumreestrTo)or
         (isFindFio and  isFindCertFrom)or
         (isFindFio and isFindCertTo)or
         (isFindFio and (not isViewDeleteQuiteInReestr))or
         (isFindFio and isFindNotarialAction)
         then and4:=' and ';

      if (isFindSumm and isFindDateFrom)or
         (isFindSumm and isFindDateTo)or
         (isFindSumm and isFindDateChangeFrom)or
         (isFindSumm and isFindDateChangeTo)or
         (isFindSumm and isFindUserName)or
         (isFindSumm and isFindCancelAction)or
         (isFindSumm and isFindNumDeal)or
         (isFindSumm and isFindNumreestrTo)or
         (isFindSumm and  isFindCertFrom)or
         (isFindSumm and isFindCertTo)or
         (isFindSumm and (not isViewDeleteQuiteInReestr))or
         (isFindSumm and isFindNotarialAction)
         then and5:=' and ';

      if (isFindDateFrom and isFindDateTo)or
         (isFindDateFrom and isFindDateChangeFrom)or
         (isFindDateFrom and isFindDateChangeTo)or
         (isFindDateFrom and isFindUserName)or
         (isFindDateFrom and isFindCancelAction)or
         (isFindDateFrom and isFindNumDeal)or
         (isFindDateFrom and isFindNumreestrTo)or
         (isFindDateFrom and  isFindCertFrom)or
         (isFindDateFrom and isFindCertTo)or
         (isFindDateFrom and (not isViewDeleteQuiteInReestr))or
         (isFindDateFrom and isFindNotarialAction)
         then and6:=' and ';


      if (isFindDateTo and isFindDateChangeFrom)or
         (isFindDateTo and isFindDateChangeTo)or
         (isFindDateTo and isFindUserName)or
         (isFindDateTo and isFindCancelAction)or
         (isFindDateTo and isFindNumDeal)or
         (isFindDateTo and isFindNumreestrTo)or
         (isFindDateTo and  isFindCertFrom)or
         (isFindDateTo and isFindCertTo)or
         (isFindDateTo and (not isViewDeleteQuiteInReestr))or
         (isFindDateTo and isFindNotarialAction)
         then and7:=' and ';

      if (isFindDateChangeFrom and isFindDateChangeTo)or
         (isFindDateChangeFrom and isFindUserName)or
         (isFindDateChangeFrom and isFindCancelAction)or
         (isFindDateChangeFrom and isFindNumDeal)or
         (isFindDateChangeFrom and isFindNumreestrTo)or
         (isFindDateChangeFrom and  isFindCertFrom)or
         (isFindDateChangeFrom and isFindCertTo)or
         (isFindDateChangeFrom and (not isViewDeleteQuiteInReestr))or
         (isFindDateChangeFrom and isFindNotarialAction)
         then and8:=' and ';

      if (isFindDateChangeTo and isFindUserName)or
         (isFindDateChangeTo and isFindCancelAction)or
         (isFindDateChangeTo and isFindNumDeal)or
         (isFindDateChangeTo and isFindNumreestrTo)or
         (isFindDateChangeTo and  isFindCertFrom)or
         (isFindDateChangeTo and isFindCertTo)or
         (isFindDateChangeTo and (not isViewDeleteQuiteInReestr))or
         (isFindDateChangeTo and isFindNotarialAction)
         then and9:=' and ';

      if (isFindUserName and isFindCancelAction)or
         (isFindUserName and isFindNumDeal)or
         (isFindUserName and isFindNumreestrTo)or
         (isFindUserName and  isFindCertFrom)or
         (isFindUserName and isFindCertTo)or
         (isFindUserName and (not isViewDeleteQuiteInReestr))or
         (isFindUserName and isFindNotarialAction)
         then and10:=' and ';

      if (isFindCancelAction and isFindNumDeal)or
         (isFindCancelAction and isFindNumreestrTo)or
         (isFindCancelAction and  isFindCertFrom)or
         (isFindCancelAction and isFindCertTo)or
         (isFindCancelAction and (not isViewDeleteQuiteInReestr))or
         (isFindCancelAction and isFindNotarialAction)
        then and11:=' and ';

      if (isFindNumDeal and isFindNumreestrTo)or
         (isFindNumDeal and  isFindCertFrom)or
         (isFindNumDeal and isFindCertTo)or
         (isFindNumDeal and (not isViewDeleteQuiteInReestr))or
         (isFindNumDeal and isFindNotarialAction)
        then and12:=' and ';

      if (isFindNumreestrTo and  isFindCertFrom)or
         (isFindNumreestrTo and isFindCertTo)or
         (isFindNumreestrTo and (not isViewDeleteQuiteInReestr))or
         (isFindNumreestrTo and isFindNotarialAction)
        then and13:=' and ';

      if (isFindCertFrom and isFindCertTo)or
         (isFindCertFrom and (not isViewDeleteQuiteInReestr))or
         (isFindCertFrom and isFindNotarialAction)
        then and14:=' and ';

      if (isFindCertTo and (not isViewDeleteQuiteInReestr))or
         (isFindCertTo and isFindNotarialAction)
        then and15:=' and ';

     if (not isViewDeleteQuiteInReestr) and isFindNotarialAction
        then and16:=' and ';

      Result:=wherestr+addstr1+and1+addstr2+and2+addstr3+and3+addstr4+and4+addstr5+and5+addstr6+and6+
                       addstr7+and7+addstr8+and8+addstr9+and9+addstr10+and10+addstr11+and11+addstr12+and12+
                       addstr13+and13+addstr14+and14+addstr15+and15+addstr16+and16+addstr17;


     tmps:=' tb.typereestr_id='+inttostr(LastTypeReestrID)+' ';
     {$IFDEF DEMO}
     tmps:=tmps+' and tb.yearwork='+inttostr(WorkYear);
     {$ENDIF}

     case pgReestr.ActivePageIndex of
      0: tmps:=tmps+' and numreestr is not null ';
      1: tmps:=tmps+' and numreestr is null ';
     end;
     if Trim(Result)<>'' then begin
       Result:=Result+' and '+tmps;
     end else begin
       Result:='where '+tmps;
     end;

  end else begin
    Result:='where tb.reestr_id='+FilterReestrId;
  end;   

end;

{$WARNINGS ON}

function TfmDocReestr.GetRecordCountFromReestr: Integer;
var
  qr: TIBQuery;
  sqls: string;
  tr: TIBTransaction;
begin
//  Screen.Cursor:=crHourGlass;
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
   sqls:='Select count(*) as reccount from '+
        TableReestr+' tb left join '+TableDoc+' td on tb.doc_id=td.doc_id left join '+
        TableTypeReestr+' ttr on tb.typereestr_id=ttr.typereestr_id left join '+
        TableOperation+' tto on tb.oper_id=tto.oper_id left join '+
        TableUsers+' tu on tb.whoin=tu.user_id left join '+
        TableNotarialAction+' na on tb.notarialaction_id=na.notarialaction_id left join '+
        TableCancelAction+' ca on tb.reestr_id=ca.reestr_id left join '+
        TableHereditaryDeal+' thd on tb.hereditarydeal_id=thd.hereditarydeal_id '+
        GetFilterString;
   qr.SQL.Add(sqls);
   qr.Active:=true;
   if qr.RecordCount>0 then
    Result:=qr.FieldByName('reccount').AsInteger;
  finally
   qr.Free;
   tr.Free;
//   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmDocReestr.bibReestrCopyClick(Sender: TObject);
var
  tb: TIBTable;
  IsOtlogen: Boolean;
  msOutForm: TMemoryStream;
  lastuserid,lastnumreestr: Integer;
  fm: TfmEditSumm;
  tmpname: string;
  plusstr: string;
  tr: TIBTransaction;

  UseParentId: Integer;
  UseNumreestr: Integer;
  certificatedate: TDateTime;

  procedure CreateOneCopy;
  var
    reestr_id: Integer;
    notarialaction_id: Integer;
    notarialactionname: string;
  begin
    Screen.Cursor:=crHourGlass;
    msOutForm:=TMemoryStream.Create;
    tr:=TIBTransaction.Create(nil);
    tb:=TIBTable.Create(nil);
    try
     reestr_id:=GetMaxReestrID;
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     tb.Database:=dm.IBDbase;
     tb.Transaction:=tr;
     tb.Transaction.Active:=true;
     tb.TableName:=TableReestr;
     tb.Filter:=' reestr_id='+inttostr(reestr_id)+' ';
     tb.Filtered:=true;
     tb.Active:=true;
     tb.Append;

     tb.fieldByName('reestr_id').Value:=Reestr_id;

     certificatedate:=StrToDate(DateToStr(WorkDate))+Time;

     tb.FieldByName('certificatedate').AsDateTime:=certificatedate;
     tb.FieldByName('whocertificate_id').AsInteger:=MainQr.fieldByName('whocertificate_id').AsInteger;

     if Trim(MainQr.fieldByName('numreestr').AsString)<>'' then
      plusstr:=' по реестру № '+inttostr(UseNumreestr);

     if Trim(MainQr.fieldByName('doc_id').AsString)<>'' then begin
      tb.FieldByName('doc_id').AsInteger:=MainQr.fieldByName('doc_id').AsInteger;
      tmpname:='Копия ('+MainQr.fieldByName('tdname').ASString+')'+plusstr;
     end else begin
      tb.FieldByName('oper_id').AsInteger:=MainQr.fieldByName('oper_id').AsInteger;
      tmpname:='Копия ('+MainQr.fieldByName('ttoname').ASstring+')'+plusstr;
     end;
     tb.FieldByName('datein').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
     tb.FieldByName('whoin').AsInteger:=UserId;
     tb.FieldByName('datechange').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
     tb.FieldByName('whochange').AsInteger:=UserId;
     tb.FieldByName('keepdoc').AsInteger:=MainQr.fieldByName('keepdoc').AsInteger;
     tb.FieldByName('yearwork').AsInteger:=WorkYear;

     lastuserid:=MainQr.fieldByName('whochange').AsInteger;
     tb.FieldByName('whochange').AsInteger:=lastuserid;
     tb.FieldByName('typereestr_id').AsInteger:=MainQr.fieldByName('typereestr_id').AsInteger;

     notarialaction_id:=GetNotarialActionId(CopyID,notarialactionname);
     tb.FieldByName('notarialaction_id').AsInteger:=notarialaction_id;
     tb.FieldByName('noyear').AsInteger:=Mainqr.FieldByname('noyear').AsInteger;
     tb.FieldByName('defect').AsInteger:=Mainqr.FieldByname('defect').AsInteger;
     tb.FieldByName('summpriv').AsFloat:=fm.SummEdit.Value;

     if not IsOtlogen then begin
       tb.FieldByName('numreestr').AsInteger:=lastnumreestr;
     end;
     tb.FieldByName('fio').AsString:=MainQr.fieldByName('fio').AsString;
     tb.FieldByName('summ').AsFloat:=fm.SummEdit.Value;
     tb.FieldByName('sogl').AsInteger:=MainQr.fieldByName('sogl').AsInteger;
     tb.FieldByName('license_id').AsString:=MainQr.fieldByName('license_id').AsString;
     tb.FieldByName('countuse').AsInteger:=1;
     tb.FieldByName('tmpname').AsString:=tmpname;
     tb.FieldByName('parent_id').AsInteger:=UseParentId;


     msOutForm.Clear;
     msOutForm.Position:=0;
     LoadStreamDataForm(msOutForm,MainQr.fieldByName('reestr_id').AsInteger);
     msOutForm.Position:=0;
     TBlobField(tb.FieldByName('dataform')).LoadFromStream(msOutForm);

     msOutForm.Clear;
     msOutForm.Position:=0;
     LoadStreamDataDoc(msOutForm,MainQr.fieldByName('reestr_id').AsInteger);
     msOutForm.Position:=0;
     TBlobField(tb.FieldByName('datadoc')).LoadFromStream(msOutForm);

     tb.Post;
     tb.Transaction.CommitRetaining;

    NeedCacheUpdate(true,
                    reestr_id,true,
                    Iff(not IsOtlogen,Prefix+inttostr(lastnumreestr)+Sufix,Null),true,
                    Iff(not IsOtlogen,lastnumreestr,Null),true,
                    MainQr.fieldByName('tdname').Value,true,
                    MainQr.fieldByName('ttoname').Value,true,
                    MainQr.fieldByName('fio').Value,true,
                    fm.SummEdit.Value,true,
                    StrToDate(DateToStr(WorkDate))+Time,true,
                    UserName,true,
                    MainQr.fieldByName('doc_id').Value,true,
                    MainQr.fieldByName('oper_id').Value,true,
                    MainQr.fieldByName('typereestr_id').Value,true,
                    UserId,true,
                    MainQr.fieldByName('sogl').Value,true,
                    MainQr.fieldByName('license_id').Value,true,
                    tmpname,true,
                    UseParentId,true,
                    MainQr.fieldByName('keepdoc').Value,true,
                    UserId,true,
                    StrToDate(DateToStr(WorkDate))+Time,true,
                    UserName,true,
                    MainQr.fieldByName('noyear').Value,true,
                    MainQr.fieldByName('defect').Value,true,
                    fm.SummEdit.Value,true,
                    notarialaction_id,true,
                    notarialactionname,true,
                    MainQr.fieldByName('isnotcancelaction').Value,true,
                    MainQr.fieldByName('whocancel').Value,true,
                    MainQr.fieldByName('datecancel').Value,true,
                    MainQr.fieldByName('numdeal').Value,true,
                    MainQr.fieldByName('datedeal').Value,true,
                    MainQr.fieldByName('hereditarydeal_id').Value,true,
                    certificatedate,true,
                    MainQr.fieldByName('whocertificate').AsString,true,
                    MainQr.fieldByName('whocertificate_id').AsInteger,true,
                    Null,Null,Null);

    finally
     tb.Free;
     tr.Free;
     msOutForm.Free;
     Screen.Cursor:=crDefault;
    end;
  end;

var
  i: Integer;
  counter: Integer;
  TypeReestr_id: Integer;
begin
 if not Mainqr.Active then exit;
 if Mainqr.RecordCount=0 then begin
   ShowError(Application.Handle,'Выберите запись реестра.');
   exit;
 end;
 if Trim(MainQr.FieldByName('parent_id').AsString)<>'' then begin
   ShowError(Application.Handle,'Невозможно сделать копию копии документа.');
   exit;
 end;
 fm:=TfmEditSumm.Create(nil);
 try
  fm.Caption:=bibReestrCopy.Caption;
  fm.SummEdit.Value:=MainQr.fieldByName('summ').AsFloat;
  lastnumreestr:=GetMaxNumReestr(MainQr.fieldByName('typereestr_id').AsInteger,
                                 MainQr.fieldByName('whochange').AsInteger);
  TypeReestr_id:=MainQr.fieldByName('typereestr_id').AsInteger;
  fm.edIntervalNumReestrFrom.Text:=inttostr(lastnumreestr);
  fm.edIntervalNumReestrTo.Text:=inttostr(lastnumreestr);
  fm.edIntervalFrom.Text:=inttostr(lastnumreestr);
  fm.edIntervalTo.Text:=inttostr(1);
  UseParentId:=MainQr.fieldByName('reestr_id').ASInteger;
  UseNumreestr:=MainQr.fieldByName('numreestr').AsInteger;

 if fm.ShowModal=mrOk then begin
  try
   IsOtlogen:=pgReestr.ActivePageIndex=1;


   if fm.rbCountOne.Checked then begin

     lastnumreestr:=GetMaxNumReestr(TypeReestr_id,MainQr.fieldByName('whochange').AsInteger);
     DocumentLock(lastnumreestr,TypeReestr_id);
     try
       CreateOneCopy;
     finally
       DocumentLock(lastnumreestr,TypeReestr_id);
     end;
   end;  

   if fm.rbCountIntervalNumReestr.Checked then begin
     try
      fmProgress.Caption:='Создано копий: 0';
      fmProgress.lbProgress.Caption:='Подготовка:';
      fmProgress.gag.Position:=0;
      fmProgress.Visible:=true;
      fmProgress.gag.Max:=StrToInt(fm.edIntervalNumReestrTo.Text)-
                               StrToInt(fm.edIntervalNumReestrFrom.Text);
      fmProgress.Update;
      counter:=0;

      for i:=StrToInt(fm.edIntervalNumReestrFrom.Text) to
             StrToInt(fm.edIntervalNumReestrTo.Text) do begin
        application.ProcessMessages;
        if BreakAnyProgress then exit;
        lastnumreestr:=i;
        DocumentLock(lastnumreestr,TypeReestr_id);
        try
          CreateOneCopy;
          inc(counter);
           fmProgress.Caption:='Создано копий: '+inttostr(counter);
          SetPositonAndText(counter+1,inttostr(i),'Номер по реестру: ',nil,fmProgress.gag.Max);
        finally
          DocumentUnLock(lastnumreestr,TypeReestr_id);
        end;
      end;
     finally
       fmProgress.Visible:=false;
     end;
   end;

   if fm.rbCountInterval.Checked then begin
     try
      fmProgress.Caption:='Создано копий: 0';
      fmProgress.lbProgress.Caption:='Подготовка:';
      fmProgress.gag.Position:=0;
      fmProgress.Visible:=true;
      fmProgress.gag.Max:=StrToInt(fm.edIntervalTo.Text);
      fmProgress.Update;
      counter:=0;

      for i:=StrToInt(fm.edIntervalFrom.Text) to
             StrToInt(fm.edIntervalFrom.Text)+StrToInt(fm.edIntervalTo.Text)-1 do begin
        application.ProcessMessages;
        if BreakAnyProgress then exit;
        lastnumreestr:=i;
        DocumentLock(lastnumreestr,TypeReestr_id);
        try
          CreateOneCopy;
          inc(counter);
          fmProgress.Caption:='Создано копий: '+inttostr(counter);
          SetPositonAndText(counter+1,inttostr(i),'Номер по реестру: ',nil,fmProgress.gag.Max);
        finally
          DocumentUnLock(lastnumreestr,TypeReestr_id);
        end;
      end;
     finally
       fmProgress.Visible:=false;
     end;
   end;

   finally
{    ActiveQuery;
    Mainqr.Locate('numreestr;whochange',
                   VarArrayOf([lastnumreestr,lastuserid]),[loCaseInsensitive]);}
   end;
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmDocReestr.LoadStreamDataForm(msOut: TMemoryStream; Reestr_id: Integer);
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
     sqls:='Select dataform from '+TableReestr+' where reestr_id='+inttostr(Reestr_id);
     qr.SQL.Add(sqls);
     qr.Active:=true;
     if qr.RecordCount>0 then begin
       TBlobField(qr.FieldByName('dataform')).SaveToStream(msout);
     end;
    finally
     qr.Free;
     tr.Free;
     Screen.Cursor:=crDefault;
    end;
end;

procedure TfmDocReestr.LoadStreamDataDoc(msOut: TMemoryStream; Reestr_id: Integer);
var
    qr: TIBQuery;
    sqls: string;
    tr: TIBTransaction;
begin
    Screen.Cursor:=crHourGlass;
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
     qr.database:=Dm.IBDbase;
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;
     sqls:='Select datadoc from '+TableReestr+' where reestr_id='+inttostr(Reestr_id);
     qr.SQL.Add(sqls);
     qr.Active:=true;
     if qr.RecordCount>0 then begin
       TBlobField(qr.FieldByName('datadoc')).SaveToStream(msout);
     end;
    finally
     qr.Free;
     tr.Free;
     Screen.Cursor:=crDefault;
    end;
end;

procedure TfmDocReestr.ChangeCopyReestr;
var
 fm: TfmEditSumm;
 qr: TIBQuery;
 lastReestrId: Integer;
 sqls: string;
 tr: TIBTransaction;
begin
 fm:=TfmEditSumm.Create(nil);
 try
  fm.Caption:=captionChange+' копию';
  fm.SummEdit.Value:=MainQr.fieldByName('summ').AsFloat;
  fm.btMore.Visible:=false;

  if fm.ShowModal=mrOk then begin

   lastReestrId:=MainQr.fieldByName('reestr_id').AsInteger;
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
    sqls:='Update '+TableReestr+
          ' set summ='+ChangeDecimalSeparator(fm.SummEdit.text,'.')+
          ',summpriv='+ChangeDecimalSeparator(fm.SummEdit.text,'.')+
          ',whochange='+inttostr(UserId)+
          ',datechange='+QuotedStr(DateToStr(WorkDate+Time))+
          ' where reestr_id='+inttostr(LastReestrID);
    qr.SQL.Add(sqls);
    qr.ExecSQL;
    qr.Transaction.CommitRetaining;

    upd.ModifySQL.Clear;
    upd.ModifySQL.Add(sqls);

    Mainqr.Edit;
    Mainqr.FieldByName('summ').Value:=fm.SummEdit.Value;
    Mainqr.FieldByName('summpriv').Value:=fm.SummEdit.Value;
    Mainqr.FieldByName('whochange').Value:=UserId;
    Mainqr.FieldByName('datechange').Value:=StrToDate(DateToStr(WorkDate))+Time;
    Mainqr.FieldByName('tu1name').Value:=UserName;
    Mainqr.Post;

{    ActiveQuery;
    Mainqr.AfterScroll:=nil;
    try
     Mainqr.Locate('reestr_id',lastReestrId,[loCaseInsensitive]);
    finally
      Mainqr.AfterScroll:=MainqrAfterScroll;
      MainqrAfterScroll(Mainqr);
    end;}
   finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
   end;
{
    Mainqr.Locate('numreestr;user_id',
                  VarArrayOf([lastnumreestr,lastuserid]),[loCaseInsensitive]);}
  end;
 finally
  fm.Free;
 end;
end;

procedure TfmDocReestr.bibDubClick(Sender: TObject);
var
  tb: TIBTable;
  IsOtlogen: Boolean;
  msOutForm: TMemoryStream;
  lastuserid,lastnumreestr: Integer;
  tmpname: string;
  tr: TIBTransaction;
  reestr_id: Integer;
  fmInput: TfmInputNumber;
  numreestr: String;
begin
  {$IFDEF DEMO}
   if GetReestrCount<MaxReestrCount then begin
   end else begin
     ShowError(Application.Handle,'Лимит демо-версии исчерпан. Обратитесь к разработчикам.');
     exit;
   end;
 {$ENDIF}
 if not Mainqr.Active then exit;
 if Mainqr.RecordCount=0 then begin
   ShowError(Application.Handle,'Выберите запись реестра.');
   exit;
 end;
 if Trim(MainQr.FieldByName('parent_id').AsString)<>'' then begin
   ShowError(Application.Handle,'Невозможно сделать дубль копии документа.');
   exit;
 end;
 IsOtlogen:=pgReestr.ActivePageIndex=1;
 numreestr:='';
 if not IsOtlogen then begin
  numreestr:=inttostr(GetMaxNumReestr(LastTypeReestrID,UserID));
  fmInput:=TfmInputNumber.Create(nil);
  try
    fmInput.edNumber.Text:=numreestr;
    fmInput.TypeReestrId:=Mainqr.FieldByname('typereestr_id').AsInteger;
    if fmInput.ShowModal=mrOk then begin
      numreestr:=Trim(fmInput.edNumber.Text);
    end else exit;
  finally
    fmInput.Free;
  end;
 end;
 Screen.Cursor:=crHourGlass;
 if Trim(numreestr)<>'' then
   DocumentLock(StrToInt(numreestr),LastTypeReestrID);
 msOutForm:=TMemoryStream.Create;
 tr:=TIBTransaction.Create(nil);
 tb:=TIBTable.Create(nil);
 try
    reestr_id:=GetMaxReestrID;

    tr.AddDatabase(dm.IBDbase);
    dm.IBDbase.AddTransaction(tr);
    tr.Params.Text:=DefaultTransactionParamsTwo;
    tb.Database:=dm.IBDbase;
    tb.Transaction:=tr;
    tb.Transaction.Active:=true;
    tb.TableName:=TableReestr;
    tb.Filter:=' reestr_id='+inttostr(reestr_id)+' ';
    tb.Filtered:=true;
    tb.Active:=true;
    tb.Append;

    tb.FieldByName('reestr_id').AsInteger:=reestr_id;

    tb.FieldByName('certificatedate').AsDateTime:=MainQr.fieldByName('certificatedate').AsDateTime;
    tb.FieldByName('whocertificate_id').AsInteger:=MainQr.fieldByName('whocertificate_id').AsInteger;

    if Trim(MainQr.fieldByName('doc_id').AsString)<>'' then begin
     tb.FieldByName('doc_id').AsInteger:=MainQr.fieldByName('doc_id').AsInteger;
     tmpname:=MainQr.fieldByName('tdname').ASString;
    end else begin
     tb.FieldByName('oper_id').AsInteger:=MainQr.fieldByName('oper_id').AsInteger;
     tmpname:=MainQr.fieldByName('ttoname').ASstring;
    end;

    tb.FieldByName('datein').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
    tb.FieldByName('whoin').AsInteger:=UserID;
    tb.FieldByName('datechange').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
    tb.FieldByName('whochange').AsInteger:=UserId;
    tb.FieldByName('keepdoc').AsInteger:=MainQr.fieldByName('keepdoc').AsInteger;
    tb.FieldByName('yearwork').AsInteger:=WorkYear;

    lastuserid:=MainQr.fieldByName('whochange').AsInteger;
    tb.FieldByName('whochange').AsInteger:=lastuserid;
    tb.FieldByName('typereestr_id').AsInteger:=MainQr.fieldByName('typereestr_id').AsInteger;

    tb.FieldByName('notarialaction_id').AsInteger:=Mainqr.FieldByname('notarialaction_id').AsInteger;
    tb.FieldByName('noyear').AsInteger:=Mainqr.FieldByname('noyear').AsInteger;
    tb.FieldByName('defect').AsInteger:=Mainqr.FieldByname('defect').AsInteger;
    tb.FieldByName('summpriv').AsFloat:=Mainqr.FieldByName('summpriv').AsFloat;

    lastnumreestr:=0;
    if Trim(numreestr)<>'' then begin
{      lastnumreestr:=GetMaxNumReestr(MainQr.fieldByName('typereestr_id').AsInteger,
                        MainQr.fieldByName('whochange').AsInteger);}
      lastnumreestr:=StrToInt(numreestr);
      tb.FieldByName('numreestr').AsInteger:=lastnumreestr;
    end;
    tb.FieldByName('fio').AsString:=MainQr.fieldByName('fio').AsString;
    tb.FieldByName('summ').AsFloat:=MainQr.fieldByName('summ').AsFloat;
    tb.FieldByName('sogl').AsInteger:=MainQr.fieldByName('sogl').AsInteger;
    tb.FieldByName('license_id').AsString:=MainQr.fieldByName('license_id').AsString;
    tb.FieldByName('countuse').AsInteger:=1;

    tb.FieldByName('tmpname').AsString:=MainQr.FieldByName('tmpname').AsString;

    tb.FieldByName('blank_id').Value:=MainQr.FieldByName('blank_id').Value;
    tb.FieldByName('blank_num').Value:=MainQr.FieldByName('blank_num').Value;

    msOutForm.Clear;
    msOutForm.Position:=0;
    LoadStreamDataForm(msOutForm,MainQr.fieldByName('reestr_id').AsInteger);
    msOutForm.Position:=0;
    TBlobField(tb.FieldByName('dataform')).LoadFromStream(msOutForm);

    msOutForm.Clear;
    msOutForm.Position:=0;
    LoadStreamDataDoc(msOutForm,MainQr.fieldByName('reestr_id').AsInteger);
    msOutForm.Position:=0;
    TBlobField(tb.FieldByName('datadoc')).LoadFromStream(msOutForm);

    tb.Post;
    tb.Transaction.CommitRetaining;

    NeedCacheUpdate(true,
                    reestr_id,true,
                    Iff(not IsOtlogen,Prefix+inttostr(lastnumreestr)+Sufix,Null),true,
                    Iff(not IsOtlogen,lastnumreestr,Null),true,
                    MainQr.fieldByName('tdname').Value,true,
                    MainQr.fieldByName('ttoname').Value,true,
                    MainQr.fieldByName('fio').Value,true,
                    MainQr.fieldByName('summ').Value,true,
                    StrToDate(DateToStr(WorkDate))+Time,true,
                    UserName,true,
                    MainQr.fieldByName('doc_id').Value,true,
                    MainQr.fieldByName('oper_id').Value,true,
                    MainQr.fieldByName('typereestr_id').Value,true,
                    UserId,true,
                    MainQr.fieldByName('sogl').Value,true,
                    MainQr.fieldByName('license_id').Value,true,
                    MainQr.FieldByName('tmpname').AsString,true,
                    MainQr.fieldByName('parent_id').Value,true,
                    MainQr.fieldByName('keepdoc').Value,true,
                    UserId,true,
                    StrToDate(DateToStr(WorkDate))+Time,true,
                    UserName,true,
                    MainQr.fieldByName('noyear').Value,true,
                    MainQr.fieldByName('defect').Value,true,
                    MainQr.fieldByName('summpriv').Value,true,
                    MainQr.fieldByName('notarialaction_id').Value,true,
                    MainQr.fieldByName('notarialactionname').Value,true,
                    MainQr.fieldByName('isnotcancelaction').Value,true,
                    MainQr.fieldByName('whocancel').Value,true,
                    MainQr.fieldByName('datecancel').Value,true,
                    MainQr.fieldByName('numdeal').Value,true,
                    MainQr.fieldByName('datedeal').Value,true,
                    MainQr.fieldByName('hereditarydeal_id').Value,true,
                    MainQr.fieldByName('certificatedate').AsDateTime,true,
                    MainQr.fieldByName('whocertificate').AsString,true,
                    MainQr.fieldByName('whocertificate_id').AsInteger,true,
                    MainQr.fieldByName('blank_id').Value,
                    MainQr.fieldByName('blank_series').Value,
                    MainQr.fieldByName('blank_num').Value);

//     miChangeWithForm.Click;

{    ActiveQuery;
    Mainqr.AfterScroll:=nil;
    try
     if Mainqr.Locate('numreestr;whochange',
                   VarArrayOf([lastnumreestr,lastuserid]),[loCaseInsensitive])then begin
      Self.Update;
      miChangeWithForm.Click;
     end;
    finally
      Mainqr.AfterScroll:=MainqrAfterScroll;
      MainqrAfterScroll(Mainqr);
    end;}
  finally

    tb.Free;
    tr.Free;
    msOutForm.Free;
    if Trim(numreestr)<>'' then
      DocumentUnLock(StrToInt(numreestr),LastTypeReestrID);
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmDocReestr.bibAdjustClick(Sender: TObject);
begin
  SetAdjustColumns(Grid.Columns);
end;

procedure TfmDocReestr.miChangeWithOutFormClick(Sender: TObject);
begin
  ChangeReestrWithFlag(tcdDoc);
end;

procedure TfmDocReestr.miChangeWithFormClick(Sender: TObject);
begin
  ChangeReestrWithFlag(tcdFormDoc);
end;

procedure TfmDocReestr.miChangeOnlyFormClick(Sender: TObject);
begin
  ChangeReestrWithFlag(tcdForm);
end;

procedure TfmDocReestr.bibCancelActionClick(Sender: TObject);
var
    qr: TIBQuery;
    sqls: string;
    tr: TIBTransaction;
    isCancel: Boolean;
  //  LastReestr_id: Integer;
    mr: TModalResult;
begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then begin
    ShowError(Application.Handle,'Выберите запись реестра.');
    exit;
  end;
  isCancel:=Trim(MainQr.FieldByName('isnotcancelaction').AsString)='';
  if isCancel then begin
    mr:=MessageDlg('Вы действительно хотите отменить документ <'+MainQr.FieldByName('tmpname').AsString+'>?',
                   mtConfirmation,[mbYes,mbNo],-1);
  end else begin
    mr:=MessageDlg('Вы действительно хотите снять отмену на документ <'+MainQr.FieldByName('tmpname').AsString+'>?',
                   mtConfirmation,[mbYes,mbNo],-1);
  end;

{  but:=MessageBox(Handle,
                  Pchar('Действительно вы хотите '+bibCancelAction.Caption+' ?'),
                 'Предупреждение',MB_YESNO+MB_ICONWARNING);}
  if mr=mrNo then exit;

  Screen.Cursor:=crHourGlass;
  tr:=TIBTransaction.Create(nil);
  qr:=TIBQuery.Create(nil);
  try
     qr.database:=Dm.IBDbase;
     tr.AddDatabase(dm.IBDbase);
     dm.IBDbase.AddTransaction(tr);
     tr.Params.Text:=DefaultTransactionParamsTwo;
     qr.Database:=dm.IBDbase;
     qr.Transaction:=tr;
     qr.Transaction.Active:=true;

     if isCancel then begin
      sqls:='Insert into '+TableCancelAction+' (reestr_id,user_id,indate) '+
            'values ('+MainQr.FieldByName('reestr_id').AsString+
            ','+inttostr(UserId)+
            ','+QuotedStr(DateTimeToStr(StrToDate(DateToStr(WorkDate))+Time))+')';
     end else begin
      sqls:='Delete from '+TableCancelAction+' where reestr_id='+MainQr.FieldByName('reestr_id').AsString;
     end;
     qr.SQL.Add(sqls);
     qr.ExecSQL;
     qr.Transaction.Commit;
//     LastReestr_id:=MainQr.FieldByName('reestr_id').AsInteger;

     upd.ModifySQL.Clear;
     upd.ModifySQL.Add(sqls);
     MainQr.Edit;
     if isCancel then begin
       MainQr.FieldByName('isnotcancelaction').AsInteger:=MainQr.FieldByName('reestr_id').AsInteger;
       MainQr.FieldByName('whocancel').AsString:=UserName;
       MainQr.FieldByName('datecancel').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
     end else begin
       MainQr.FieldByName('isnotcancelaction').Value:=Null;
       MainQr.FieldByName('whocancel').Value:=Null;
       MainQr.FieldByName('datecancel').Value:=Null;
     end;
     MainQr.Post;

     MainqrAfterScroll(Mainqr);

{     ActiveQuery;
     Mainqr.AfterScroll:=nil;
     try
       MainQr.Locate('reestr_id',LastReestr_id,[loCaseInsensitive]);
     finally
      Mainqr.AfterScroll:=MainqrAfterScroll;
      MainqrAfterScroll(Mainqr);
     end;}
  finally
    qr.Free;
    tr.Free;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TfmDocReestr.MainqrAfterScroll(DataSet: TDataSet);
var
  isCancel: Boolean;
begin
  if not Mainqr.Active then exit;
  if Mainqr.IsEmpty then exit;
  isCancel:=Trim(MainQr.FieldByName('isnotcancelaction').AsString)='';
  if isCancel then bibCancelAction.Caption:=ConstCancelAction
  else bibCancelAction.Caption:=ConstBackCancelAction;
end;

procedure TfmDocReestr.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  isCancel: Boolean;
  isDelete: Boolean;

  procedure DrawCancelAction;
  var
    x: Integer;
  begin
    x:=rect.Left+(rect.Right-rect.Left) div 2;
    if not isCancel then Begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,0,true);
    end else begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,1,true);
    end;
  end;

  procedure DrawDeleteRecord;
  var
    x: Integer;
  begin
    x:=rect.Left+(rect.Right-rect.Left) div 2;
    if not isDelete then Begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,1,true);
    end else begin
     il.Draw(grid.Canvas,x-il.Width div 2,rect.Top,0,true);
    end;
  end;

begin
  if not Mainqr.Active then exit;
  if Mainqr.RecordCount=0 then exit;
  isCancel:=Trim(MainQr.FieldByName('isnotcancelaction').AsString)='';
  if column.Title.Caption='Документ действителен' then begin
    DrawCancelAction;
  end;
  isDelete:=Boolean(MainQr.FieldByName('isdel').AsInteger);
  if column.Title.Caption='Статус записи' then begin
    DrawDeleteRecord;
  end;
end;

procedure TfmDocReestr.GridKeyPress(Sender: TObject; var Key: Char);
begin
  if isValidKey(Key) then begin
   edSearch.SetFocus;
   edSearch.Text:=Key;
   edSearch.SelStart:=Length(edSearch.Text);
   if Assigned(edSearch.OnKeyPress) then
    edSearch.OnKeyPress(Sender,Key);
  end;
end;

procedure TfmDocReestr.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP,VK_DOWN: Grid.SetFocus;
  end;
  FormKeyDown(Sender,Key,Shift);
end;

procedure TfmDocReestr.SetRecordCount(Value: Integer);
begin
  if Value<>FRecordCount then begin
    FRecordCount:=Value;
    lbCount.Caption:=ViewCountText+inttostr(FRecordCount);
  end;
end;

procedure TfmDocReestr.NeedCacheUpdate(isInsert: Boolean;
                                        reestr_id: Variant; isreestr_id: Boolean;
                                        numreestr1: Variant; isnumreestr1: Boolean;
                                        numreestr: Variant; isnumreestr: Boolean;
                                        typedocname: Variant; istypedocname: Boolean;
                                        typeopername: Variant; istypeopername: Boolean;
                                        fio: Variant; isfio: Boolean;
                                        summ: Variant; issumm: Boolean;
                                        datein: Variant; isdatein: Boolean;
                                        whoinname: Variant; iswhoinname: Boolean;
                                        doc_id: Variant; isdoc_id: Boolean;
                                        oper_id: Variant; isoper_id: Boolean;
                                        typereestr_id: Variant; istypereestr_id: Boolean;
                                        whoin: Variant; iswhoin: Boolean;
                                        sogl: Variant; issogl: Boolean;
                                        license_id: Variant; islicense_id: Boolean;
                                        tmpname: Variant; istmpname: Boolean;
                                        parent_id: Variant; isparent_id: Boolean;
                                        keepdoc: Variant; iskeepdoc: Boolean;
                                        whochange: Variant; iswhochange: Boolean;
                                        datechange: Variant; isdatechange: Boolean;
                                        whochangename: Variant; iswhochangename: Boolean;
                                        noyear: Variant; isnoyear: Boolean;
                                        defect: Variant; isdefect: Boolean;
                                        summpriv: Variant; issummpriv: Boolean;
                                        notarialaction_id: Variant; isnotarialaction_id: Boolean;
                                        notarialactionname: Variant; isnotarialactionname: Boolean;
                                        isnotcancelaction: Variant; isisnotcancelaction: Boolean;
                                        whocancel: Variant; iswhocancel: Boolean;
                                        datecancel: Variant; isdatecancel: Boolean;
                                        numdeal: Variant; isnumdeal: Boolean;
                                        datedeal: Variant; isdatedeal: Boolean;
                                        hereditarydeal_id: Variant; ishereditarydeal_id: Boolean;
                                        CertificateDate: Variant; isCertificateDate: Boolean;
                                        WhoCertificate: Variant; isWhoCertificate: Boolean;
                                        WhoCertificate_id: Variant; isWhoCertificate_id: Boolean;
                                        BlankId: Variant; BlankSeries, BlankNum: Variant);

var
  b: TBookmark;
  isGotoBookmark: Boolean;
  isUseAll: Boolean;
begin
  Mainqr.DisableControls;
  b:=Mainqr.GetBookmark;
  isGotoBookmark:=true;
  try

    if pgReestr.ActivePage=tbsPrepeare then begin
      if numreestr<>Null then begin
         if MainQr.Locate('reestr_id',reestr_id,[loCaseInsensitive]) then begin
           upd.DeleteSQL.Clear;
           upd.DeleteSQL.Add('Select * from dual');
           Mainqr.Delete;
           isGotoBookmark:=false;
           RecordCount:=RecordCount-1;
           exit;
         end else exit;
      end;
    end else begin
       if numreestr=Null then begin
         if MainQr.Locate('reestr_id',reestr_id,[loCaseInsensitive]) then begin
           upd.DeleteSQL.Clear;
           upd.DeleteSQL.Add('Select * from dual');
           Mainqr.Delete;
           isGotoBookmark:=false;
           RecordCount:=RecordCount-1;
           exit;
         end else exit;
       end;
    end;   

     if (typereestr_id=LastTypeReestrID) then begin
       if isInsert then begin
         upd.InsertSQL.Clear;
         upd.InsertSQL.Add('Select * from dual');
         Mainqr.Insert;
         isGotoBookmark:=false;
       end else begin
         if MainQr.Locate('reestr_id',reestr_id,[loCaseInsensitive]) then begin
           upd.ModifySQL.Clear;
           upd.ModifySQL.Add('Select * from dual');
           Mainqr.Edit;
         end else exit;
       end;
     end else begin
       if isInsert then begin
         exit;
       end else begin
         if not Mainqr.IsEmpty then begin
           if MainQr.Locate('reestr_id',reestr_id,[loCaseInsensitive]) then begin
             upd.DeleteSQL.Clear;
             upd.DeleteSQL.Add('Select * from dual');
             Mainqr.Delete;
             isGotoBookmark:=false;
             RecordCount:=RecordCount-1;
             exit;
           end else exit;
         end;
       end;
     end;



   if isreestr_id then Mainqr.FieldByName('reestr_id').Value:=reestr_id;
   if isnumreestr1 then Mainqr.FieldByName('numreestr1').Value:=numreestr1;
   if isnumreestr then Mainqr.FieldByName('numreestr').Value:=numreestr;
   if istypedocname then Mainqr.FieldByName('tdname').Value:=typedocname;
   if istypeopername then Mainqr.FieldByName('ttoname').Value:=typeopername;
   if isfio then Mainqr.FieldByName('fio').Value:=fio;
   if issumm then Mainqr.FieldByName('summ').Value:=summ;
   if isdatein then Mainqr.FieldByName('datein').Value:=datein;
   if iswhoinname then Mainqr.FieldByName('tuname').Value:=whoinname;
   if isdoc_id then Mainqr.FieldByName('doc_id').Value:=doc_id;
   if isoper_id then Mainqr.FieldByName('oper_id').Value:=oper_id;
   if istypereestr_id then Mainqr.FieldByName('typereestr_id').Value:=typereestr_id;
   if iswhoin then Mainqr.FieldByName('whoin').Value:=whoin;
   if issogl then Mainqr.FieldByName('sogl').Value:=sogl;
   if islicense_id then Mainqr.FieldByName('license_id').Value:=license_id;
   if istmpname then Mainqr.FieldByName('tmpname').Value:=tmpname;
   if isparent_id then Mainqr.FieldByName('parent_id').Value:=parent_id;
   if iskeepdoc then Mainqr.FieldByName('keepdoc').Value:=keepdoc;
   if iswhochange then Mainqr.FieldByName('whochange').Value:=whochange;
   if isdatechange then Mainqr.FieldByName('datechange').Value:=datechange;
   if iswhochangename then Mainqr.FieldByName('tu1name').Value:=whochangename;
   if isnoyear then Mainqr.FieldByName('noyear').Value:=noyear;
   if isdefect then Mainqr.FieldByName('defect').Value:=defect;
   if issummpriv then Mainqr.FieldByName('summpriv').Value:=summpriv;
   if isnotarialaction_id then Mainqr.FieldByName('notarialaction_id').Value:=notarialaction_id;
   if isnotarialactionname then Mainqr.FieldByName('notarialactionname').Value:=notarialactionname;
   if isisnotcancelaction then Mainqr.FieldByName('isnotcancelaction').Value:=isnotcancelaction;
   if iswhocancel then Mainqr.FieldByName('whocancel').Value:=whocancel;
   if isdatecancel then Mainqr.FieldByName('datecancel').Value:=datecancel;
   if isnumdeal then Mainqr.FieldByName('numdeal').Value:=numdeal;
   if isdatedeal then Mainqr.FieldByName('datedeal').Value:=datedeal;
   if ishereditarydeal_id then Mainqr.FieldByName('hereditarydeal_id').Value:=hereditarydeal_id;
   if isCertificateDate then Mainqr.FieldByName('CertificateDate').Value:=CertificateDate;
   if isWhoCertificate then Mainqr.FieldByName('WhoCertificate').Value:=WhoCertificate;
   if isWhoCertificate_id then Mainqr.FieldByName('WhoCertificate_id').Value:=WhoCertificate_id;

   Mainqr.FieldByName('blank_id').Value:=BlankId;
   Mainqr.FieldByName('blank_series').Value:=BlankSeries;
   Mainqr.FieldByName('blank_num').Value:=BlankNum;

   Mainqr.Post;

   if isInsert then begin
     RecordCount:=RecordCount+1;
     MainQr.Locate('reestr_id',reestr_id,[loCaseInsensitive]);
   end;

  finally
    if isGotoBookmark and (RecordCount>0) then
     if Mainqr.BookmarkValid(b) then
         Mainqr.GotoBookmark(b);
    Mainqr.FreeBookmark(b);     
    Mainqr.EnableControls;
  end;
end;

procedure TfmDocReestr.bibPrintClick(Sender: TObject);
begin
  CreateWordTableByGrid(Grid,Caption);
end;

procedure TfmDocReestr.SetBlankNumFormat;
var
  Field: TField;
begin
  Field:=Mainqr.FindField('blank_num');
  if Assigned(Field) and (Field is TNumericField) then begin
    TNumericField(Field).DisplayFormat:=DupeString('0',MaxBlankNumLength-1)+'#';
  end;
end;

procedure TfmDocReestr.SetCondition(Query: TIbQuery);
var
  typeresstr_id: Integer;
  i: Integer;
begin
  if cbCurReestr.ItemIndex<>-1 then begin
    pgReestr.ActivePageIndex:=iff(Trim(Query.FieldByName('numreestr').AsString)<>'',0,1);
    pgReestrChange(nil);
    FilterReestrId:=Query.FieldByname('reestr_id').AsString;
    try
      for i:=0 to cbCurReestr.Items.Count-1 do begin
        typeresstr_id:=Integer(cbCurReestr.Items.Objects[i]);
        if typeresstr_id=Query.FieldByName('typereestr_id').AsInteger then begin
          cbCurReestr.ItemIndex:=i;
          cbCurReestrChange(nil);
          break;
        end;
      end;
    finally
      FilterReestrId:='';
      ShowWindow(Handle,SW_RESTORE);
      Show;
      BringToFront;
    end;
  end;
end;

procedure TfmDocReestr.bibCarryClick(Sender: TObject);
var
  tb: TIBTable;
  msOutForm: TMemoryStream;
  lastuserid,lastnumreestr: Integer;
  tmpname: string;
  tr: TIBTransaction;
  reestr_id: Integer;
  numreestr: String;
  ADataBase: String;
  DBNew: TIBDatabase;
  TRNew: TIBTransaction;
  Buffer: String;
begin
 if not Mainqr.Active then exit;
 if Mainqr.RecordCount=0 then begin
   ShowError(Application.Handle,'Выберите запись реестра.');
   exit;
 end;
 if Trim(MainQr.FieldByName('parent_id').AsString)<>'' then begin
   ShowError(Application.Handle,'Невозможно скопировать копию документа.');
   exit;
 end;
 ADataBase:=DataBaseName;
 if SelectDatabaseEx(ADataBase,true) then begin

   DBNew:=TIBDatabase.Create(nil);
   TRNew:=TIBTransaction.Create(nil);
   try
     DBNew.DefaultTransaction:=TRNew;
     DBNew.LoginPrompt:=false;
     DBNew.IdleTimer:=0;

     TRNew.DefaultDatabase:=DBNew;
     TRNew.Active:=false;
     TRNew.AutoStopAction:=saNone;
     TRNew.DefaultAction:=TACommitRetaining;
     TRNew.Params.Text:=DefaultTransactionParamsTwo;

     DBNew.Connected:=false;
     DBNew.DatabaseName:=ADataBase;
     DBNew.Params.Clear;

     Buffer:='';
     if LocalDb.ReadParam(SDb_ParamUserName,Buffer) then
       DBNew.Params.Add(Format(DataBaseUserName,[Buffer]));

     Buffer:='';
     if LocalDb.ReadParam(SDb_ParamPassword,Buffer) then
       DBNew.Params.Add(Format(DataBaseUserPass,[Buffer]));

     DBNew.Params.Add(DataBaseCodePage);
     DBNew.Connected:=true;

     TRNew.Active:=DBNew.Connected;

     if DBNew.Connected then begin

       msOutForm:=TMemoryStream.Create;
       tr:=TIBTransaction.Create(nil);
       tb:=TIBTable.Create(nil);
       try
         reestr_id:=GetMaxReestrIDEx(DBNew);
         numreestr:='';

         tr.AddDatabase(DBNew);
         DBNew.AddTransaction(tr);
         tr.Params.Text:=DefaultTransactionParamsTwo;
         tb.Database:=DBNew;
         tb.Transaction:=tr;
         tb.Transaction.Active:=true;
         tb.TableName:=TableReestr;
         tb.Filter:=' reestr_id='+inttostr(reestr_id)+' ';
         tb.Filtered:=true;
         tb.Active:=true;
         tb.Append;

         tb.FieldByName('reestr_id').AsInteger:=reestr_id;

         tb.FieldByName('certificatedate').AsDateTime:=MainQr.fieldByName('certificatedate').AsDateTime;
         tb.FieldByName('whocertificate_id').AsInteger:=MainQr.fieldByName('whocertificate_id').AsInteger;

         if Trim(MainQr.fieldByName('doc_id').AsString)<>'' then begin
           tb.FieldByName('doc_id').AsInteger:=MainQr.fieldByName('doc_id').AsInteger;
           tmpname:=MainQr.fieldByName('tdname').ASString;
         end else begin
           tb.FieldByName('oper_id').AsInteger:=MainQr.fieldByName('oper_id').AsInteger;
           tmpname:=MainQr.fieldByName('ttoname').ASstring;
         end;

         tb.FieldByName('datein').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
         tb.FieldByName('whoin').AsInteger:=UserID;
         tb.FieldByName('datechange').AsDateTime:=StrToDate(DateToStr(WorkDate))+Time;
         tb.FieldByName('whochange').AsInteger:=UserId;
         tb.FieldByName('keepdoc').AsInteger:=MainQr.fieldByName('keepdoc').AsInteger;
         tb.FieldByName('yearwork').AsInteger:=WorkYear;

         lastuserid:=MainQr.fieldByName('whochange').AsInteger;
         tb.FieldByName('whochange').AsInteger:=lastuserid;
         tb.FieldByName('typereestr_id').AsInteger:=MainQr.fieldByName('typereestr_id').AsInteger;

         tb.FieldByName('notarialaction_id').AsInteger:=Mainqr.FieldByname('notarialaction_id').AsInteger;
         tb.FieldByName('noyear').AsInteger:=Mainqr.FieldByname('noyear').AsInteger;
         tb.FieldByName('defect').AsInteger:=Mainqr.FieldByname('defect').AsInteger;
         tb.FieldByName('summpriv').AsFloat:=Mainqr.FieldByName('summpriv').AsFloat;

         if Trim(numreestr)<>'' then begin
           lastnumreestr:=StrToInt(numreestr);
           tb.FieldByName('numreestr').AsInteger:=lastnumreestr;
         end;

         tb.FieldByName('fio').AsString:=MainQr.fieldByName('fio').AsString;
         tb.FieldByName('summ').AsFloat:=MainQr.fieldByName('summ').AsFloat;
         tb.FieldByName('sogl').AsInteger:=MainQr.fieldByName('sogl').AsInteger;
         tb.FieldByName('license_id').AsString:=MainQr.fieldByName('license_id').AsString;
         tb.FieldByName('countuse').AsInteger:=1;
         tb.FieldByName('tmpname').AsString:=MainQr.FieldByName('tmpname').AsString;

         if Assigned(tb.FindField('blank_id')) and Assigned(MainQr.FindField('blank_id')) then
           tb.FieldByName('blank_id').Value:=MainQr.FieldByName('blank_id').Value;

         if Assigned(tb.FindField('blank_num')) and Assigned(MainQr.FindField('blank_num')) then
           tb.FieldByName('blank_num').Value:=MainQr.FieldByName('blank_num').Value;

         msOutForm.Clear;
         msOutForm.Position:=0;
         LoadStreamDataForm(msOutForm,MainQr.fieldByName('reestr_id').AsInteger);
         msOutForm.Position:=0;
         TBlobField(tb.FieldByName('dataform')).LoadFromStream(msOutForm);

         msOutForm.Clear;
         msOutForm.Position:=0;
         LoadStreamDataDoc(msOutForm,MainQr.fieldByName('reestr_id').AsInteger);
         msOutForm.Position:=0;
         TBlobField(tb.FieldByName('datadoc')).LoadFromStream(msOutForm);

         tb.Post;
         tb.Transaction.CommitRetaining;

         ShowInfo(Format('Документ <%s> успешно скопирован рабочей датой.',[tmpname]));

       finally
         tb.Free;
         tr.Free;
         msOutForm.Free;
       end;
     end;

   finally
     TRNew.Free;
     DBNew.Free;
   end;
  end;
end;

end.
