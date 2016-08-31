unit UParentForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Udm;

type
  TfmParentForm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FViewType: TViewType;
  public
    procedure SaveToFile; virtual;
    property ViewType: TViewType read FViewType write FViewType;
  end;

var
  fmParentForm: TfmParentForm;

implementation

{$R *.DFM}

procedure TfmParentForm.SaveToFile;
begin
end;

procedure TfmParentForm.FormCreate(Sender: TObject);
begin
  FViewType:=vtView;
end;

end.
