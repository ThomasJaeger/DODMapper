unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager, Vcl.StdCtrls, sButton, Vcl.ExtCtrls, sPanel,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Menus, sGroupBox, sLabel, sEdit;

type
  TfrmMain = class(TForm)
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    btnExit: TsButton;
    sPanel1: TsPanel;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    ActionManager1: TActionManager;
    actExit: TAction;
    sGroupBox1: TsGroupBox;
    txtHost: TsEdit;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    txtPassword: TsEdit;
    procedure btnExitClick(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  actExitExecute(Sender);
end;

end.
