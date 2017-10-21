program DODMapper;

uses
  Vcl.Forms,
  uFrmMain in 'uFrmMain.pas' {frmMain},
  uFrmSettings in 'uFrmSettings.pas' {frmSettings},
  uDM in 'uDM.pas' {dm: TDataModule},
  uFrmAbout in 'uFrmAbout.pas' {frmAbout},
  uFTPItem in 'uFTPItem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'DOD Mapper';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
