unit UserFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TUserForm = class(TForm)
    LabeledEditUser: TLabeledEdit;
    LabeledEditPass: TLabeledEdit;
    ButtonOk: TButton;
    ButtonCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserForm: TUserForm;

implementation

{$R *.dfm}

end.
