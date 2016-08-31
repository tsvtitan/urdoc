unit UFind;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, comctrls;

type
  TfmFind = class(TForm)
    pnR: TPanel;
    bibFind: TBitBtn;
    bibCancel: TBitBtn;
    gbFindStr: TGroupBox;
    cbFindStr: TComboBox;
    rbWhere: TRadioGroup;
    cbCharCase: TCheckBox;
    cbWholeWord: TCheckBox;
    cbMulti: TCheckBox;
    procedure bibCancelClick(Sender: TObject);
    procedure bibFindClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    LVIndex: Integer;
    FPosInTreeView: Integer;
    procedure FindInListView;
    procedure FindInTreeView;
    procedure InsertIntoCombo;
  public
    OldLVMultiSelect: Boolean;
    TV: TTreeView;
    LV: TListView;
    fmTV: TForm;
    isInListView: Boolean;
    procedure CreateParams(var Params: TCreateParams);override;
  end;

var
  fmFind: TfmFind;

implementation

uses UMain, UDocTree, UDm;

{$R *.DFM}

procedure TfmFind.bibCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmFind.bibFindClick(Sender: TObject);
begin
  if isInListView then begin
    cbMulti.Enabled:=true;
    FindInListView;
  end else begin
    cbMulti.Enabled:=false;
    FindInTreeView;
  end;
end;

procedure TfmFind.InsertIntoCombo;
var
  str: string;
  Index: Integer;
begin
 if cbFindStr.Items.Count<ConstFindCount then begin
  str:=cbFindStr.Text;
  Index:=cbFindStr.Items.IndexOf(str);
  if Index=-1 then begin
//    cbFindStr.Items.Add(str);
   cbFindStr.Items.Insert(0,str);
  end;
 end else begin
  str:=cbFindStr.Text;
  Index:=cbFindStr.Items.IndexOf(str);
  if Index=-1 then begin
   cbFindStr.Items.Delete(cbFindStr.Items.Count-1);
   cbFindStr.Items.Insert(0,str);
  end;
 end;
end;

procedure TfmFind.FindInListView;

  procedure ViewListItem(LI: TListItem);
  begin
   Li.Selected:=true;
   Li.MakeVisible(false);
   if Lv<>nil then begin
     if cbMulti.Checked then begin
     end else begin

     end;
   end;
  end;

var
  i: Integer;
  li: TlistItem;
  newli: TListItem;
  APos: Integer;
  str: string;
begin
 if LV=nil then exit;
 try
  li:=LV.selected;
  if LV.Items.Count=0 then exit;
  if li=nil then begin
    li:=LV.Items.Item[0];
    LVIndex:=-1;
  end;
  if li.Index=LV.Items.Count-1 then begin
    LVIndex:=-1;
  end;
  if LVIndex>=LV.Items.Count-1 then LVIndex:=-1;
  if lv.Columns.Count=1 then exit;
  str:=cbFindStr.Text;
  inc(LVIndex);
  for i:=LVIndex to LV.Items.Count-1 do begin
   newLi:=Lv.Items.Item[i];
   case rbWhere.ItemIndex of
     0: begin
      if cbCharCase.Checked then begin
        if cbWholeWord.Checked then begin
          if str=newLi.Caption then begin
            ViewListItem(newLi);
            exit;
          end;
        end else begin
          Apos:=Pos(str,newLi.Caption);
          if Apos<>0 then begin
            ViewListItem(newLi);
            exit;
          end;
        end;
      end else begin
        if cbWholeWord.Checked then begin
          if AnsiUpperCase(str)=AnsiUpperCase(newLi.Caption) then begin
            ViewListItem(newLi);
            exit;
          end;
        end else begin
          Apos:=Pos(AnsiUpperCase(str),AnsiUpperCase(newLi.Caption));
          if Apos<>0 then begin
            ViewListItem(newLi);
            exit;
          end;
        end;
      end;
     end;
     1: begin
      if cbCharCase.Checked then begin
        if cbWholeWord.Checked then begin
          if str=newLi.SubItems.Strings[0] then begin
            ViewListItem(newLi);
            exit;
          end;
        end else begin
          Apos:=Pos(str,newLi.SubItems.Strings[0]);
          if Apos<>0 then begin
            ViewListItem(newLi);
            exit;
          end;
        end;
      end else begin
        if cbWholeWord.Checked then begin
          if AnsiUpperCase(str)=AnsiUpperCase(newLi.SubItems.Strings[0]) then begin
            ViewListItem(newLi);
            exit;
          end;
        end else begin
          Apos:=Pos(AnsiUpperCase(str),AnsiUpperCase(newLi.SubItems.Strings[0]));
          if Apos<>0 then begin
            ViewListItem(newLi);
            exit;
          end;
        end;
      end;
     end;

   end;
   inc(LVIndex);
  end;
 finally
   InsertIntoCombo;
 end;
end;

procedure TfmFind.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then begin
    bibFind.Click;
  end;
  if Key=VK_ESCAPE then begin
    Close;
  end;
  fmMain.OnKeyDown(Sender,Key,Shift);
end;

procedure TfmFind.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  fmMain.OnKeyUp(Sender,Key,Shift);
end;

procedure TfmFind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if isInListView then begin
    if LV<>nil then begin
    end;
   end else begin
   end;
end;

procedure TfmFind.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
//  Params.ExStyle:=Params.ExStyle and WS_EX_TRANSPARENT	;

end;

procedure TfmFind.FormShow(Sender: TObject);
begin
  cbFindStr.SetFocus;
end;

procedure TfmFind.FindInTreeView;

   function GetNodeFromText(Text: string; fdDown,fdCase,fdWholeWord: Boolean): TTreeNode;
   var
     i: Integer;
     nd: TTreeNode;
     APos: Integer;
     P: PInfoNode;
   begin
    result:=nil;
    if fdDown then begin
     if FPosInTreeView>Tv.Items.Count-1 then begin
      FPosInTreeView:=0;
     end;
     for i:=FPosInTreeView to Tv.Items.Count-1 do begin
      nd:=Tv.Items[i];
      Apos:=0;
      case rbWhere.ItemIndex of
       0: begin
        if fdCase then begin
         if fdWholeWord then begin
          if Length(Text)=Length(nd.Text) then
           Apos:=Pos(Text,nd.Text)
          else APos:=0;
         end else Apos:=Pos(Text,nd.Text);
        end else begin
         if fdWholeWord then begin
          if Length(Text)=Length(nd.Text) then
           Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(nd.Text))
          else APos:=0;
         end else Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(nd.Text));
        end;
       end;
       1: begin
        P:=nd.data;
        if P<>nil then begin
         if fdCase then begin
          if fdWholeWord then begin
           if Length(Text)=Length(P.Hint) then
            Apos:=Pos(Text,P.Hint)
           else APos:=0;
          end else Apos:=Pos(Text,P.Hint);
         end else begin
          if fdWholeWord then begin
           if Length(Text)=Length(P.Hint) then
            Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(P.Hint))
           else APos:=0;
          end else Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(P.Hint));
         end;
        end;
       end;
      end;
      if Apos<>0 then begin
        FPosInTreeView:=i+1;
        result:=nd;
        exit;
      end;
     end;
    end else begin
     if FPosInTreeView<=0 then FPosInTreeView:=Tv.Items.Count-1;
     for i:=FPosInTreeView downto 0 do begin
       nd:=Tv.Items[i];
       if fdCase then begin
        if fdWholeWord then begin
         if Length(Text)=Length(nd.Text) then
          Apos:=Pos(Text,nd.Text)
         else APos:=0;
        end else Apos:=Pos(Text,nd.Text);
       end else begin
        if fdWholeWord then begin
         if Length(Text)=Length(nd.Text) then
          Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(nd.Text))
         else APos:=0;
        end else Apos:=Pos(AnsiUpperCase(Text),AnsiUpperCase(nd.Text));
       end;
       if Apos<>0 then begin
         FPosInTreeView:=i-1;
         result:=nd;
         exit;
       end;
     end;
    end;
   end;

var
  nd: TTreeNode;
  fdDown,fdCase,fdWholeWord: Boolean;
begin
 try
  if TV=nil then exit;
  fdDown:=true;
  fdCase:=cbCharCase.Checked;
  fdWholeWord:=cbWholeWord.Checked;
  nd:=GetNodeFromText(cbFindStr.Text,fdDown,fdCase,fdWholeWord);
  if nd<>nil then begin
   nd.MakeVisible;
   nd.Expand(false);
   tv.Selected:=nd;
   if fmTV<>nil then begin
     if fmTV is TfmDocTree then begin
       TfmDocTree(fmTV).ViewNodeNew(nd,false);
     end;
   end;
  end else
   FPosInTreeView:=0;
 finally
   InsertIntoCombo;
 end;
end;

procedure TfmFind.FormCreate(Sender: TObject);
begin
  LoadFromIniSearchParams;
end;

end.
