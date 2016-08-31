unit UObjInsp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  tsvgrids, extctrls, StdCtrls, ComCtrls;

type
  TfmObjInsp = class(TForm)
    PanelInfo: TPanel;
    MemoInfo: TMemo;
    Splitter: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormStartDock(Sender: TObject;
      var DragObject: TDragDockObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    LastWidth: Integer;
    DocControl: TControl;
    ObjInsp: TtsvPnlInspector;
  end;

var
  fmObjInsp: TfmObjInsp;

implementation

uses UMain, UDm;

{$R *.DFM}

procedure TfmObjInsp.FormCreate(Sender: TObject);
begin
    ObjInsp:=TtsvPnlInspector.Create(Self);
    ObjInsp.Combo.Clear;
//    ObjInsp.Combo.Visible:=false;
    ObjInsp.Align:=alClient;
    ObjInsp.cmLabel.Visible:=false;
//    ObjInsp.Combo.Visible:=false;
    ObjInsp.TSEven.TabVisible:=false;
    ObjInsp.Filter:=true;
    Left:=Screen.Width-Width-50;
    Top:=Screen.Height div 2 -Height div 2;
    ObjInsp.GridP.ColWidths[0]:=140;
    ObjInsp.MemoInfo:=MemoInfo;
end;

procedure TfmObjInsp.FormDestroy(Sender: TObject);
begin
   ObjInsp.Free;
end;

procedure TfmObjInsp.FormStartDock(Sender: TObject;
  var DragObject: TDragDockObject);
begin
 LastWidth:=Self.Width;
end;

procedure TfmObjInsp.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  fmMain.OnKeyUp(Sender,Key,Shift);
end;

procedure TfmObjInsp.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  fmMain.OnKeyDown(Sender,Key,Shift);
end;

procedure TfmObjInsp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  isViewObjectIns:=false;
end;

end.
