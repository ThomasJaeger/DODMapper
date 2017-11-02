unit uFrmBrowse;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sButton, sEdit, sLabel, Vcl.ExtCtrls, sPanel, VirtualTrees,
  sGroupBox;

type
  TfrmBrowse = class(TForm)
    sGroupBox2: TsGroupBox;
    lstFtpFiles: TVirtualStringTree;
    sPanel5: TsPanel;
    sLabel5: TsLabel;
    txtFolder: TsEdit;
    btnBack: TsButton;
    btnRoot: TsButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBrowse: TfrmBrowse;

implementation

{$R *.dfm}

end.
