unit uFrmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sEdit, sLabel, sGroupBox, sButton, sSpinEdit;

type
  TfrmSettings = class(TForm)
    sGroupBox1: TsGroupBox;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    txtHost: TsEdit;
    txtUsername: TsEdit;
    btnApply: TsButton;
    btnCancel: TsButton;
    sLabel3: TsLabel;
    txtPassword: TsEdit;
    txtPort: TsSpinEdit;
    sLabel4: TsLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

end.
