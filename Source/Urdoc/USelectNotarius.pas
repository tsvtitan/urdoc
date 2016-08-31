unit USelectNotarius;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, IBQuery, ExtCtrls, IBDatabase;

type
  TfmSelectNoarius = class(TForm)
    lbNotarius: TLabel;
    pnBottom: TPanel;
    Panel3: TPanel;
    bibOk: TBitBtn;
    bibCancel: TBitBtn;
    cmbNotarius: TComboBox;
    meInfo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure bibOkClick(Sender: TObject);
    procedure meInfoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    procedure FillNotarius(WithHelper: Boolean=false);
    function GetNotariusName: string;
  end;

var
  fmSelectNoarius: TfmSelectNoarius;

implementation

uses UDm;

{$R *.DFM}

procedure TfmSelectNoarius.FormCreate(Sender: TObject);
begin
  //
end;

function TfmSelectNoarius.GetNotariusName: string;
begin
  Result:='';
  if cmbNotarius.ItemIndex=-1 then exit;
  Result:=GetSmallFIONew(cmbNotarius.Items.Strings[cmbNotarius.ItemIndex]);
end;

procedure TfmSelectNoarius.FillNotarius(WithHelper: Boolean=false);
var
  qr: TIBQuery;
  sqls: String;
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
   sqls:='Select * from '+TableNotarius+' '+iff(WithHelper,'','where ishelper=0 or ishelper is null')+' order by fio';
   qr.SQL.Add(sqls);
   qr.Active:=true;
   qr.First;
   cmbNotarius.Items.Clear;
   while not qr.Eof do begin
     cmbNotarius.Items.AddObject(qr.FieldByName('fio').AsString,
                                 TObject(Pointer(qr.FieldByName('not_id').AsInteger)));
     qr.Next;
   end;
   if cmbNotarius.Items.Count>0 then
      cmbNotarius.ItemIndex:=0;
  finally
   qr.Free;
   tr.Free;
   Screen.Cursor:=crDefault;
  end;
end;

procedure TfmSelectNoarius.bibOkClick(Sender: TObject);
begin
  if cmbNotarius.ItemIndex=-1 then exit; 
  ModalResult:=mrOk;
end;

procedure TfmSelectNoarius.meInfoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_Return then bibOk.Click;
  if Key=VK_Escape then bibCancel.Click;
end;

end.
