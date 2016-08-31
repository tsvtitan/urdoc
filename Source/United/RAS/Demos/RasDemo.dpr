program RasDemo;

uses
  Forms,
  RasDemoMain in 'RasDemoMain.pas' {MainForm},
  Ras in '..\Pas\ras.pas',
  RasError in '..\Pas\raserror.pas',
  RasUtils in '..\Utils\RasUtils.pas',
  RasHelperClasses in '..\Utils\RasHelperClasses.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
