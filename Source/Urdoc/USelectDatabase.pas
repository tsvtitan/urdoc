unit USelectDatabase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfmSelectDatabase = class(TForm)
    PanelBottom: TPanel;
    PanelTop: TPanel;
    butOk: TButton;
    butCancel: TButton;
    grbTop: TGroupBox;
    cmbBases: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbBasesChange(Sender: TObject);
  private
    FCurrentDataBase: String;
    procedure SetCurrentDataBase(Value: String);
  public
    Values: TStringList;
    property CurrentDataBase: String read FCurrentDataBase write SetCurrentDataBase;
  end;

var
  fmSelectDatabase: TfmSelectDatabase;

implementation

{$R *.dfm}

procedure TfmSelectDatabase.FormCreate(Sender: TObject);
begin
  Values:=TStringList.Create;
end;

procedure TfmSelectDatabase.FormDestroy(Sender: TObject);
begin
  Values.Free;
end;

procedure TfmSelectDatabase.cmbBasesChange(Sender: TObject);
var
  Index: Integer;
  S: String;
begin
  Index:=cmbBases.ItemIndex;
  if Index<>-1 then begin
    S:=Values.ValueFromIndex[Index];
    butOk.Enabled:=not AnsiSameText(S,FCurrentDataBase);
  end;
end;

procedure TfmSelectDatabase.SetCurrentDataBase(Value: String);
begin
  FCurrentDataBase:=Value;
  if Trim(Value)<>'' then
    cmbBasesChange(nil);
end;

end.
