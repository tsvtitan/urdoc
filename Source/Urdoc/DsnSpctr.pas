unit DsnSpctr;

// Runtime Design System Version 2.x   1998/06/08-
// Copyright Kazuhiro Sasaki 1997-1998.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TypInfo, Buttons, ExtCtrls, Grids,
  DsnInfo, DsnProp, DsnFunc, DsnLgMes;

type
  TInspectorFm = class;

  TShowProps = class(TPersistent)
  private
    FaName:Boolean;
    FCaption:Boolean;
    FColor:Boolean;
    FTop:Boolean;
    FLeft:Boolean;
    FWidth:Boolean;
    FHeight:Boolean;
    FFont:Boolean;
    FaNameCp:String;
    FCaptionCp:String;
    FColorCp:String;
    FTopCp:String;
    FLeftCp:String;
    FWidthCp:String;
    FHeightCp:String;
    FFontCp:String;
  published
    property aName:Boolean read FaName write FaName;
    property aCaption:Boolean read FCaption write FCaption;
    property aColor:Boolean read FColor write FColor;
    property aTop:Boolean read FTop write FTop;
    property aLeft:Boolean read FLeft write FLeft;
    property aWidth:Boolean read FWidth write FWidth;
    property aHeight:Boolean read FHeight write FHeight;
    property aFont:Boolean read FFont write FFont;
    property aNameCp:String read FaNameCp write FaNameCp;
    property aCaptionCp:String read FCaptionCp write FCaptionCp;
    property aColorCp:String read FColorCp write FColorCp;
    property aTopCp:String read FTopCp write FTopCp;
    property aLeftCp:String read FLeftCp write FLeftCp;
    property aWidthCp:String read FWidthCp write FWidthCp;
    property aHeightCp:String read FHeightCp write FHeightCp;
    property aFontCp:String read FFontCp write FFontCp;
  end;

  TInspectorPos = class(TPersistent)
  private
    FLeft:Integer;
    FTop:Integer;
    FWidth:Integer;
    FHeight:Integer;
  published
    property Top:Integer read FTop write FTop;
    property Left:Integer read FLeft write FLeft;
    property Width:Integer read FWidth write FWidth;
    property Height:Integer read FHeight write FHeight;
  end;

  TGridCp = class(TPersistent)
  private
    FPropCp:String;
    FValueCp:String;
    FPropWid:Integer;
    FValueWid:Integer;
  published
    property PropCp:String read FPropCp write FPropCp;
    property ValueCp:String read FValueCp write FValueCp;
    property PropWid:Integer read FPropWid write FPropWid;
    property ValueWid:Integer read FValueWid write FValueWid;
  end;

  TInspctHlpBtn = class(TPersistent)
  private
    FVisible:Boolean;
    FHelpContext:Integer;
    FCaption:String;
  published
    property Visible:Boolean read FVisible write FVisible;
    property HelpContext:Integer read FHelpContext write FHelpContext;
    property Caption:String read FCaption write FCaption;
  end;

  TDsnInspector = class(TCustomInspector)
  private
    FShowProps:TShowProps;
    FInspectorFm: TInspectorFm;
    FPosition:TInspectorPos;
    FShowCombo:Boolean;
    FGrid:TGridCp;
    FGlyph: TBitmap;
    FCaption:String;
    FStayOnTop:Boolean;
    FButton: TSpeedButton;
    FStringGrid: TStringGrid;
    FHelpButton: TInspctHlpBtn;
  protected
    function GetGlyph: TBitmap;
    procedure SetShowCombo(Value: Boolean);
    procedure SetGlyph(Value: TBitmap);
    procedure SetUpRectCombo;
    procedure Show; override;
    procedure Hide; override;
    procedure SetPosition; override;
    procedure BtnClick(PropName:String;var Value:String); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure GetPropLists(InspectList,CaptionList:TStrings);override;
    procedure SetComponentList(List:TList);
    procedure SetComponent(Component: TComponent);
    procedure SetBounds(aLeft,aTop,aWidth,aHeight:Integer);virtual;
    property Button: TSpeedButton read FButton;
    property StringGrid: TStringGrid read FStringGrid;
  published
    property SelfProps;
    property BtnProps;
    property OutProps;
    property OnBtnClick;
    property ShowProps:TShowProps read FShowProps write FShowProps;
    property ShowCombo:Boolean read FShowCombo write SetShowCombo;
    property StayOnTop:Boolean read FStayOnTop write FStayOnTop;
    property HelpButton: TInspctHlpBtn read FHelpButton write FHelpButton;
    property Position:TInspectorPos read FPosition write FPosition;
    property BtnGlyph: TBitmap read GetGlyph write SetGlyph;
    property Caption:String read FCaption write FCaption;
    property Grid:TGridCp read FGrid write FGrid;
  end;

  TInspectorFm = class(TForm)
    StringGrid1: TStringGrid;
    Panel3: TPanel;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    ComboBox2: TComboBox;
    Panel1: TPanel;
    HelpBtn: TBitBtn;
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Panel3Resize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure StringGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private êÈåæ }
    FInspector: TDsnInspector;
    LastProp: String;
    procedure SetGrid(RowNum:Integer; Focus:Boolean);
  public
    { Public êÈåæ }
    ShowBtnList:TStrings;
    CpProp,CpValue:String;
  end;

var
  InspectorFm: TInspectorFm;

implementation

{$R *.DFM}

{TDsnInspector}
constructor TDsnInspector.Create(AOwner: TComponent);
begin
  inherited;
  FShowProps:= TShowProps.Create;
  FPosition:= TInspectorPos.Create;
  FHelpButton:= TInspctHlpBtn.Create;
  FGrid:= TGridCp.Create;
  FGlyph:= TBitmap.Create;
  FPosition.Left:=15;
  FPosition.Top:=50;
  FPosition.Width:=230;
  FPosition.Height:=400;
  FGrid.PropWid:=80;
  FGrid.ValueWid:=100;
  FGrid.PropCp:=INS_PROPCP;
  FGrid.ValueCp:=INS_VALUECP;
  FCaption:=INS_CAPTION;
  FHelpButton.Caption:= INS_HELPBUTTON;
end;

destructor TDsnInspector.Destroy;
begin
  FShowProps.Free;
  FPosition.Free;
  FHelpButton.Free;
  FGrid.Free;
  FGlyph.Free;
  if Assigned(FInspectorFm) then
    FInspectorFm.Free;
  inherited;
end;

procedure TDsnInspector.Show;
begin
  FInspectorFm:= TInspectorFm.Create(nil);
  FInspectorFm.ShowBtnList:= BtnProps;

  FButton:= FInspectorFm.SpeedButton1;
  FStringGrid:= FInspectorFm.StringGrid1;

  with Position do
    FInspectorFm.SetBounds(Left,Top,Width,Height);

  FInspectorFm.StringGrid1.ColWidths[1]:=Grid.PropWid;
  FInspectorFm.StringGrid1.ColWidths[2]:=Grid.ValueWid;

  if FStayOnTop then
    FInspectorFm.FormStyle:= fsStayOnTop
  else
    FInspectorFm.FormStyle:= fsNormal;

  FInspectorFm.ShowBtnList.Text:= Self.BtnProps.Text;
  FInspectorFm.FInspector:= Self;

  FStringGrid.Cells[1,0]:= Grid.PropCp;
  FStringGrid.Cells[2,0]:= Grid.ValueCp;
  FStringGrid.RowCount:= 1;

  FInspectorFm.SpeedButton1.Glyph.Assign(BtnGlyph);
  FInspectorFm.Panel3.Visible:= False; //ShowCombo;
  FInspectorFm.Panel1.Visible:= HelpButton.Visible;
  FInspectorFm.HelpBtn.HelpContext:= HelpButton.HelpContext;
  FInspectorFm.HelpBtn.Caption:= HelpButton.Caption;
  FInspectorFm.Caption:=Caption;

  FInspectorFm.Show;
end;

procedure TDsnInspector.Hide;
begin
  FInspectorFm.Free;
  FInspectorFm:= nil;
end;

procedure TDsnInspector.BtnClick(PropName:String;var Value:String);
var
  Targets:TSelectedComponents;
begin
  Targets:=TSelectedComponents.Create;
  Targets.AssignList(MultiProps.List);
  OnBtnClick(Self,Targets,PropName,Value);
  Targets.Free;
end;

procedure TDsnInspector.SetPosition;
var
  i,n:integer;
  PropCap:String;
begin
  if MultiProps.ValueList.Count <> MultiProps.PropList.Count then
    Exit;
  FStringGrid.RowCount:= MultiProps.PropList.Count + 1;
  for i:= 1 to FStringGrid.RowCount -1 do
  begin
    with MultiProps do
      PropCap:= GetPropCaption(PropList[i-1],InspectList,CaptionList);
    FStringGrid.Cells[1,i]:= PropCap;
    FStringGrid.Cells[2,i]:= MultiProps.ValueList[i-1];
    FStringGrid.Cells[0,i]:= MultiProps.PropList[i-1];
  end;

  n:= FStringGrid.Cols[0].IndexOf(FInspectorFm.LastProp);
  if (n > -1) and (FInspectorFm.LastProp <> '') then
  begin
    FInspectorFm.SetGrid(n, False);
    FInspectorFm.StringGrid1.Row:= n;
  end
  else
    FInspectorFm.SetGrid(-1, False);

  if not FInspectorFm.Showing then
    FInspectorFm.Show;
end;

function TDsnInspector.GetGlyph: TBitmap;
begin
  Result := FGlyph;
end;

procedure TDsnInspector.SetGlyph(Value: TBitmap);
begin
  FGlyph.Assign(Value);
end;

procedure TDsnInspector.SetComponent(Component: TComponent);
begin
  ChangeTarget(TControl(Component));
end;

procedure TDsnInspector.SetBounds(aLeft,aTop,aWidth,aHeight:Integer);
begin
  FInspectorFm.SetBounds(aLeft,aTop,aWidth,aHeight);
end;

procedure TDsnInspector.SetUpRectCombo;
begin;
end;

procedure TDsnInspector.SetComponentList(List:TList);
begin;
end;

procedure TDsnInspector.SetShowCombo(Value: Boolean);
begin
  FShowCombo:=Value;
   {if FInspectorFm <> nil then
     FInspectorFm.ComboBox1.Visible:= FShowCombo;  }
end;

procedure TDsnInspector.GetPropLists(InspectList,CaptionList:TStrings);
var
  Strings:TStringlist;
  St:TStringList;
begin
  Strings:= TStringlist.Create;

  with ShowProps do
  begin
    if aCaption then
      if aCaptionCp = '' then
        Strings.Add('Caption')
      else
        Strings.Add('Caption'+'|'+ aCaptionCp);
    if aColor then
      if aColorCp = '' then
        Strings.Add('Color')
      else
        Strings.Add('Color'+'|'+ aColorCp);
    if aFont then
      if aFontCp = '' then
        Strings.Add('Font')
      else
        Strings.Add('Font'+'|'+ aFontCp);
    if aHeight then
      if aHeightCp = '' then
        Strings.Add('Height')
      else
        Strings.Add('Height'+'|'+ aHeightCp);
    if aLeft then
      if aLeftCp = '' then
        Strings.Add('Left')
      else
        Strings.Add('Left'+'|'+ aLeftCp);
    if aName then
      if aNameCp = '' then
        Strings.Add('Name')
      else
        Strings.Add('Name'+'|'+ aNameCp);
    if aTop then
      if aTopCp = '' then
        Strings.Add('Top')
      else
        Strings.Add('Top'+'|'+ aTopCp);
    if aWidth then
      if aWidthCp = '' then
        Strings.Add('Width')
      else
        Strings.Add('Width'+'|'+ aWidthCp);
  end;

  Strings.AddStrings(SelfProps);
  St:=TStringList.Create;
  St.Text:= Strings.Text;
  Strings.Free;

  SepareteStringsByBar(St,InspectList,CaptionList);
end;

{TInspectorFm}
procedure TInspectorFm.ComboBox1Change(Sender: TObject);
var
  Component:TComponent;
begin
  if ComboBox1.Items.Count = 0 then Exit;
  Component :=
    TComponent(ComboBox1.Items.Objects[ComboBox1.ItemIndex]);
  if Component <> nil then
  begin
    FInspector.ChangeTarget(TControl(Component));
    Edit1.Left:=-200;
    Panel2.Visible:=False;
    ComboBox2.Visible:=False;
  end;
end;

procedure TInspectorFm.SetGrid(RowNum:Integer; Focus:Boolean);
var
  x,y,w,h,i,n:integer;
  Button:Boolean;
  PropInfo:PPropInfo;
  TypeInfo: PTypeInfo;
  Control:TControl;
  P: ^ShortString;
  T: PTypeData;
begin
  if RowNum = -1 then
  begin
    Edit1.Enabled:= False;
    Edit1.Left:= -2000;
    Panel2.Visible:=False;
    ComboBox2.Visible:=False;
    Exit;
  end;

  Button:=False;
  with StringGrid1 do
  begin
    x:= CellRect(2,RowNum).Left;
    y:= CellRect(2,RowNum).Top;
    w:= ColWidths[2];
    h:= RowHeights[RowNum];
    if ShowBtnList <> nil then
      for i:=0 to ShowBtnList.Count-1 do
        if ShowBtnList[i]= Cells[0,RowNum] then
        begin
          Button:=True;
          Break;
        end;

    Control:=TControl(FInspector.MultiProps.List[0]);

    if Control = nil then Exit;

    LastProp:= Cells[0,RowNum];

    if not (Control is TComponent) then Exit;

    PropInfo:= GetPropInfo(Control.ClassInfo,LastProp);
    TypeInfo:=PropInfo^.PropType^;

    if TypeInfo.Kind = tkEnumeration then
    begin
      ComboBox2.Items.Clear;
      T := GetTypeData(GetTypeData(TypeInfo)^.BaseType^);
      P := @T^.NameList;
      for n:=T^.MaxValue downto 0 do
      begin
        ComboBox2.Items.Add(P^);
        Inc(Integer(P), Length(P^) + 1);
      end;
      ComboBox2.SetBounds(x+left,y+top+2,w+3,h+3);
      ComboBox2.Text:= Cells[2,RowNum];
      ComboBox2.Visible:=True;
      Edit1.SetBounds(1500,500,10,10);
      Edit1.Visible:=False;
    end
    else
    begin
      ComboBox2.Visible:=False;
      Edit1.Visible:=True;
      Edit1.Enabled:=True;
    end;

    if Button then
    begin
      Edit1.Visible:=True;
      Panel2.SetBounds(x+left+w-23,y+top+2,25,h);
      Panel2.Visible:=True;
      ComboBox2.Visible:=False;
      Edit1.Enabled:=False;
    end
    else
    begin
      Panel2.Visible:=False;
      Edit1.Enabled:=True;
      if (Edit1.Visible) and Focus then
        Edit1.SetFocus;
    end;

    Edit1.SetBounds(x+left,y+top,w+3,h+3);
    Edit1.Text:=Cells[2,RowNum];
    Edit1.SelectAll;
  end;
end;

procedure TInspectorFm.Edit1Exit(Sender: TObject);
var
  PropName:String;
begin
  if Edit1.Left<0 then Exit;

  PropName:=StringGrid1.Cells[0,StringGrid1.Row];

  if PropName = LastProp then
    FInspector.SetProperty(PropName,Edit1.Text);

end;

procedure TInspectorFm.SpeedButton1Click(Sender: TObject);
var
  PropName, Value: String;
begin
  if Assigned(FInspector.OnBtnClick) then
  begin
    PropName:=StringGrid1.Cells[0,StringGrid1.Row];
    Value:= Edit1.Text;

    FInspector.BtnClick(PropName,Value);

    Edit1.Text:=Value;

    FInspector.SetProperty(PropName,Value);
  end;
end;

procedure TInspectorFm.Panel3Resize(Sender: TObject);
begin
  ComboBox1.Width:= Panel3.Width-10;
end;

procedure TInspectorFm.FormCreate(Sender: TObject);
begin
  StringGrid1.ColWidths[0]:=0;
  LastProp:= '';
end;

procedure TInspectorFm.ComboBox2Change(Sender: TObject);
begin
  Edit1.Text:= ComboBox2.Text;
  Edit1Exit(Self);
end;

procedure TInspectorFm.StringGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if StringGrid1.Row < 1 then Exit;
  SetGrid(StringGrid1.Row, True);
end;

end.
