unit uFrmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sEdit, sLabel, sGroupBox, sButton, sSpinEdit,
  uDM, Vcl.ExtCtrls, sPanel, System.Generics.Collections, sCheckBox;

type
  TfrmSettings = class(TForm)
    sGroupBox1: TsGroupBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    txtHost: TsEdit;
    txtUsername: TsEdit;
    sLabel3: TsLabel;
    txtPassword: TsEdit;
    txtPort: TsSpinEdit;
    sLabel4: TsLabel;
    sPanel1: TsPanel;
    btnCancel: TsButton;
    btnApply: TsButton;
    txtFolder: TsEdit;
    sLabel5: TsLabel;
    sLabel6: TsLabel;
    chkPassive: TsCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure WriteIniFile;
  private
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

uses
  IdFTPList;

procedure TfrmSettings.btnApplyClick(Sender: TObject);
begin
  WriteIniFile;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  txtHost.Text := dm.Host;
  txtUsername.Text := dm.Username;
  txtPassword.Text := dm.Password;
  txtPort.Value := dm.Port;
  chkPassive.Checked := dm.Passive;
end;

procedure TfrmSettings.WriteIniFile;
begin
  dm.Host := txtHost.Text;
  dm.Username := txtUsername.Text;
  dm.Password := txtPassword.Text;
  dm.Port := txtPort.Value;
  dm.Passive := chkPassive.Checked;
  dm.WriteIniFile;
end;

end.
