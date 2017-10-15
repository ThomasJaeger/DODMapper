unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager, Vcl.StdCtrls, sButton, Vcl.ExtCtrls, sPanel,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Menus, sGroupBox, sLabel, sEdit,
  uDM, sSplitter, VirtualTrees, sMemo;

type
  TfrmMain = class(TForm)
    sSkinManager1: TsSkinManager;
    sSkinProvider1: TsSkinProvider;
    MainMenu1: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    Settings1: TMenuItem;
    N1: TMenuItem;
    H1: TMenuItem;
    A1: TMenuItem;
    sPanel1: TsPanel;
    sGroupBox1: TsGroupBox;
    sSplitter1: TsSplitter;
    sGroupBox2: TsGroupBox;
    lstServer: TVirtualStringTree;
    sPanel2: TsPanel;
    btnConnect: TsButton;
    btnUpload: TsButton;
    btnDisconnect: TsButton;
    btnAddMapFiles: TsButton;
    lstMAPFiles: TVirtualStringTree;
    sPanel3: TsPanel;
    sSplitter2: TsSplitter;
    memStatus: TsMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

end.
