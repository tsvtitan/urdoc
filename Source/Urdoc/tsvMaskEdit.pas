unit tsvMaskEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Mask, ComCtrls, Menus, ImgList, Db, DBTables;

type

  PInfoMaskEdit=^TInfoMaskEdit;
  TInfoMaskEdit=packed record
    ID: Integer;
    Name: String;
    Mask: String;
    Test: string;
  end; 

  TfmMaskEdit = class(TForm)
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    pn: TPanel;
    gbTest: TGroupBox;
    LV: TListView;
    pmLV: TPopupMenu;
    miLVView: TMenuItem;
    miLVLargeIcon: TMenuItem;
    miLVSmallIcon: TMenuItem;
    miLVList: TMenuItem;
    miLVReport: TMenuItem;
    N4: TMenuItem;
    miLVChangeMask: TMenuItem;
    miLVAddmask: TMenuItem;
    miLVDeleteMask: TMenuItem;
    miLVDeleteAllMask: TMenuItem;
    mskeTest: TMaskEdit;
    ILSmall: TImageList;
    ilLarge: TImageList;
    procedure pmLVPopup(Sender: TObject);
    procedure miLVLargeIconClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure miLVAddmaskClick(Sender: TObject);
    procedure LVChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure bibOkClick(Sender: TObject);
    procedure miLVChangeMaskClick(Sender: TObject);
    procedure miLVDeleteMaskClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LVColumnClick(Sender: TObject; Column: TListColumn);
    procedure miLVDeleteAllMaskClick(Sender: TObject);
  private
    glSortSubItem: Integer;
    glSortForward: Boolean;
    procedure lvCompareStr(Sender: TObject; Item1, Item2: TListItem;
       Data: Integer; var Compare: Integer);
    procedure ClearListView;
    procedure ClearListViewBase;
    procedure DeleteSelectedInListView;
    function isFoundName(NameText: String; var Index: Integer): Boolean;
  public
    procedure ActiveQuery;
    procedure LocateMask(Mask: String);
  end;

var
  fmMaskEdit: TfmMaskEdit;

implementation

uses UDm, UEditMaskEdit, UMain;

{$R *.DFM}

procedure TfmMaskEdit.pmLVPopup(Sender: TObject);
var
  li: TListItem;
begin
  li:=LV.Selected;
  if li=nil then begin
    if LV.Items.Count=0 then begin
      miLVDeleteAllmask.Enabled:=false;
    end else begin
      miLVDeleteAllmask.Enabled:=true;
    end;
    miLVDeleteMask.Enabled:=false;
    miLVChangeMask.Enabled:=false;
  end else begin
    miLVDeleteAllmask.Enabled:=true;
    miLVDeleteMask.Enabled:=true;
    miLVChangeMask.Enabled:=true;
  end;
end;

procedure TfmMaskEdit.miLVLargeIconClick(Sender: TObject);
begin
  TMenuItem(Sender).Checked:=true;
  if Sender=miLVLargeIcon then begin
   LV.ViewStyle:=vsIcon;
  end;
  if Sender=miLVSmallIcon then begin
   LV.ViewStyle:=vsSmallIcon;
  end;
  if Sender=miLVList then begin
   LV.ViewStyle:=vsList;
  end;
  if Sender=miLVReport then begin
   LV.ViewStyle:=vsReport;
  end;
end;

procedure TfmMaskEdit.ActiveQuery;
var
  i: Integer;
  P: PInfoMaskEdit;
  sqls: string;
  li: TListItem;
  qrMain: TQuery;
begin
{  Screen.Cursor:=crHourGlass;
  qrMain:=TQuery.Create(nil);
  LV.Items.BeginUpdate;
  try
    qrMain.DatabaseName:=DataFolder;
    qrMain.Active:=false;
    sqls:='Select * from '+TableMasks+' order by name';
    qrMain.sql.Clear;
    qrMain.sql.Add(sqls);
    qrMain.Active:=true;
    qrMain.First;
    for i:=0 to qrMain.RecordCount-1 do begin
     New(P);
     P.ID:=qrMain.FieldByName('ID').AsInteger;
     P.Name:=Trim(qrMain.FieldByName('name').AsString);
     P.Mask:=Trim(qrMain.FieldByName('mask').AsString);
     P.Test:=Trim(qrMain.FieldByName('test').AsString);
     li:=LV.Items.Add;
     li.Caption:=P.Name;
     li.SubItems.Add(P.Mask);
     li.SubItems.Add(P.Test);
     li.Data:=P;
     qrMain.Next;
    end;
  finally
   LV.Items.EndUpdate;
   qrMain.Free;
   Screen.Cursor:=crDefault;
  end;}
end;

procedure TfmMaskEdit.ClearListView;
var
  i: Integer;
  P: PInfoMaskEdit;
begin
  LV.Items.BeginUpdate;
  try
   for i:=0 to LV.Items.Count-1 do begin
    P:=LV.Items.Item[I].Data;
    Dispose(P);
   end;
   LV.Items.Clear;
  finally
   LV.Items.EndUpdate;
  end;
end;

procedure TfmMaskEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearListView;
end;

procedure TfmMaskEdit.LocateMask(Mask: String);
var
  i: Integer;
  li: TListItem;
begin
  for i:=0 to lv.Items.Count-1 do begin
    li:=lv.Items[i];
    if li.SubItems.Strings[0]=Mask then begin
     li.MakeVisible(true);
     li.Selected:=true;
     exit;
    end;
  end;
end;

procedure TfmMaskEdit.miLVAddmaskClick(Sender: TObject);
var
  qr: TQuery;
  sqls: string;
  fm: TfmEditMaskEdit;
  P: PInfoMaskEdit;
  li: TListItem;
  Index: Integer;
begin
{  fm:=TfmEditMaskEdit.Create(nil);
  try
    fm.Caption:='Добавить';
    fm.bibOk.OnClick:=fm.AddAndChangeOkClick;
    if fm.ShowModal=mrOk then begin
      if not fm.ChangeFlage then exit;
      if isFoundName(Trim(fm.edName.Text),Index) then begin
       if Index<>-1 then begin
        ShowError(Application.Handle,'Наименование <'+Trim(fm.edName.Text)+'> уже существует.');
        exit;
       end;
      end;

      Screen.Cursor:=crHourGlass;
      qr:=TQuery.Create(nil);
      try
        qr.DatabaseName:=DataFolder;
        sqls:='Insert into '+TableMasks+
              ' (name,mask,test) values ('''+
              Trim(fm.edName.Text)+''','''+
              Trim(fm.edMask.Text)+''','''+
              Trim(fm.edTest.Text)+''')';
        qr.sql.Add(sqls);
        qr.ExecSQL;
        qr.sql.Clear;
        sqls:='select max(id) as id from '+TableMasks;
        qr.sql.Add(sqls);
        qr.Active:=true;
        if qr.RecordCount<>1 then exit;
        new(P);
        P.ID:=qr.FieldByName('ID').AsInteger;
        P.Name:=Trim(fm.edName.Text);
        P.Mask:=Trim(fm.edMask.Text);
        P.Test:=Trim(fm.edTest.Text);
        li:=LV.Items.Add;
        li.Caption:=P.Name;
        li.SubItems.Add(P.Mask);
        li.SubItems.Add(P.Test);
        li.Data:=P;
      finally
        qr.Free;
        Screen.Cursor:=crDefault;
      end;

    end;
  finally
    fm.Free;
  end;}
end;

procedure TfmMaskEdit.LVChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  P: PInfoMaskEdit;
begin
  if Item<>LV.Selected then exit;
  P:=Item.Data;
  mskeTest.EditMask:=P.Mask;
end;

procedure TfmMaskEdit.bibOkClick(Sender: TObject);
begin
  if Trim(mskeTest.EditMask)='' then begin
    ShowError(Application.Handle,'Введите маску.');
    LV.SetFocus;
    exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfmMaskEdit.miLVChangeMaskClick(Sender: TObject);
var
  qr: TQuery;
  sqls: string;
  fm: TfmEditMaskEdit;
  P: PInfoMaskEdit;
  li: TListItem;
  Index: Integer;
begin
{  li:=LV.Selected;
  if li=nil then exit;
  P:=li.Data;
  fm:=TfmEditMaskEdit.Create(nil);
  try
    fm.Caption:='Изменить';
    fm.edName.Text:=Trim(P.Name);
    fm.edMask.text:=Trim(P.Mask);
    fm.edTest.text:=Trim(P.Test);
    fm.bibOk.OnClick:=fm.AddAndChangeOkClick;
    if fm.ShowModal=mrOk then begin
      if not fm.ChangeFlage then exit;
      if isFoundName(Trim(fm.edName.Text),Index) then begin
       if (Index<>-1)and(Index<>li.Index) then begin
        ShowError(Application.Handle,'Наименование <'+Trim(fm.edName.Text)+'> уже существует.');
        exit;
       end;
      end;

      Screen.Cursor:=crHourGlass;
      qr:=TQuery.Create(nil);
      try
        qr.DatabaseName:=DataFolder;
        sqls:='Update '+TableMasks+
              ' set name='''+Trim(fm.edName.Text)+
              ''', mask='''+Trim(fm.edMask.Text)+
              ''', test='''+Trim(fm.edTest.Text)+''' where id='+inttostr(P.ID);

        qr.sql.Add(sqls);
        qr.ExecSQL;
        P.Name:=Trim(fm.edName.Text);
        P.Mask:=Trim(fm.edMask.Text);
        P.Test:=Trim(fm.edTest.Text);
        li.Caption:=P.Name;
        li.SubItems.Strings[0]:=P.Mask;
        li.SubItems.Strings[1]:=P.Test;
      finally
        qr.Free;
        Screen.Cursor:=crDefault;
      end;
    end;
  finally
    fm.Free;
  end;}
end;

procedure TfmMaskEdit.miLVDeleteMaskClick(Sender: TObject);
var
  li: TListItem;
  but: Integer;
  mr: TModalResult;
begin
  li:=LV.Selected;
  if li=nil then exit;
  mr:=MessageDlg('Удалить маску <'+li.caption+'> ?',mtConfirmation,[mbYes,mbNo],-1);
  if mr=Yes then DeleteSelectedInListView;
{  but:=MessageBox(Handle,Pchar('Удалить маску <'+li.caption+'> ?'),
                               'Предупреждение',MB_ICONWARNING+MB_YESNO);

  case but of
    IDYES: begin
     DeleteSelectedInListView;
    end;
  end;                                                                   }
end;

procedure TfmMaskEdit.DeleteSelectedInListView;
var
  li: TListItem;
  P: PInfoMaskEdit;
  qr: TQuery;
  sqls: string;
begin
{  li:=LV.Selected;
  if li=nil then exit;
  P:=li.Data;
  Screen.Cursor:=crHourGlass;
  qr:=TQuery.Create(nil);
  try
    qr.DatabaseName:=DataFolder;
    sqls:='Delete from '+TableMasks+' where id='+inttostr(P.ID);
    qr.Sql.Add(sqls);
    qr.ExecSQL;
    dispose(P);
    li.Delete;
  finally
    qr.Free;
    Screen.Cursor:=crDefault;
  end;}
end;

procedure TfmMaskEdit.FormCreate(Sender: TObject);
begin
  OnKeyDown:=fmMain.OnKeyDown;
  OnKeyPress:=fmMain.OnKeyPress;
  OnKeyUp:=fmMain.OnKeyUp;
end;

procedure TfmMaskEdit.LVColumnClick(Sender: TObject; Column: TListColumn);
var
 newSortItem:integer;
begin
 newSortItem:=Column.Index-1;
 if glSortSubItem=newSortItem then glSortForward:=not glSortForward
 else glSortForward:=true;
 glSortSubItem:=newSortItem;
 lv.OnCompare:=lvCompareStr;
 lv.AlphaSort;
end;

procedure TfmMaskEdit.lvCompareStr(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
 if glSortSubItem>=0 then Compare:=CompareText(Item1.SubItems[glSortSubItem],Item2.SubItems[glSortSubItem])
 else Compare:=CompareText(Item1.Caption,Item2.Caption);
 if glSortForward=false then Compare:=-Compare;
end;


procedure TfmMaskEdit.miLVDeleteAllMaskClick(Sender: TObject);
var
  but: Integer;
  mr: TModalResult;
begin
  mr:=MessageDlg('Удалить все маски ?',mtConfirmation,[mbYes,mbNo],-1);
  if mr=MrYes then begin
    ClearListViewBase;
    ClearListView;
  end;
{  but:=MessageBox(Handle,Pchar('Удалить все маски ?'),
                               'Предупреждение',MB_ICONWARNING+MB_YESNO);
  case but of
    IDYES: begin
      ClearListViewBase;
      ClearListView;
    end;
  end;}
end;

procedure TfmMaskEdit.ClearListViewBase;
var
  qr: TQuery;
  sqls: string;
begin
{  Screen.Cursor:=crHourGlass;
  qr:=TQuery.Create(nil);
  try
   qr.DatabaseName:=DataFolder;
   sqls:='Delete from '+TableMasks;
   qr.SQL.Add(sqls);
   qr.ExecSQL;
  finally
   qr.FRee;
   Screen.Cursor:=crDefault;
  end;}
end;

function TfmMaskEdit.isFoundName(NameText: String; var Index: Integer): Boolean;
var
  i: Integer;
  li: TListItem;
begin
  result:=false;
  Index:=-1;
  for i:=0 to Lv.Items.Count-1 do begin
     li:=Lv.Items[i];
     if Li.Caption=NameText then begin
       li.MakeVisible(true);
       li.Selected:=true;
       Index:=i;
       result:=true;
       exit;
     end;
  end;
end;


end.
