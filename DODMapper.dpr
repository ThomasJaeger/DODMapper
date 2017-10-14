program DODMapper;

uses
  Vcl.Forms,
  uFrmMain in 'uFrmMain.pas' {frmMain},
  uFrmSettings in 'uFrmSettings.pas' {frmSettings};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.Run;
end.
