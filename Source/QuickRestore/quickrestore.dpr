program quickrestore;

uses
  Forms,
  UMain in 'UMain.pas' {fmMain},
  UserFm in 'UserFm.pas' {UserForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Быстрое восстановление';
  Application.CreateForm(TfmMain, fmMain);
  Application.Run;
end.
