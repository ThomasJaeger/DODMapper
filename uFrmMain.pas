unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager, Vcl.StdCtrls, sButton, Vcl.ExtCtrls, sPanel,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Menus, sGroupBox, sLabel, sEdit,
  uDM, sSplitter, VirtualTrees, sMemo, sDialogs, System.Generics.Collections;

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
    dlgOpen: TsOpenDialog;
    sPanel4: TsPanel;
    btnClearList: TsButton;
    procedure btnAddMapFilesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstMAPFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure btnClearListClick(Sender: TObject);
  private
    FMapFiles: TList<TMapFile>;
    procedure Synchronize;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnAddMapFilesClick(Sender: TObject);
var
  i: Integer;
  mf: TMapFile;
begin
  if dlgOpen.Execute() then
  begin
    for i := 0 to dlgOpen.Files.Count-1 do
    begin
      mf.FileName := dlgOpen.Files[i];
      FMapFiles.Add(mf);
    end;
    Synchronize;
  end;
end;

procedure TfrmMain.btnClearListClick(Sender: TObject);
begin
  FMapFiles.Clear;
  Synchronize;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FMapFiles := TList<TMapFile>.Create;
end;

procedure TfrmMain.lstMAPFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  Data: PMapFile;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
    0: CellText := Data.FileName;
//    1:
//      begin
//        if Data.Size > 0 then
//          CellText := FormatByteSize(Data.Size)
//        else
//          CellText := '';
//      end;
//    2: CellText := Data.ModifiedDate;
  end;
end;

procedure TfrmMain.Synchronize;
var
  node: PVirtualNode;
  data: PMapFile;
  i: integer;
begin
  lstMAPFiles.BeginUpdate;
  lstMAPFiles.Clear;

  for i := 0 to FMapFiles.Count-1 do
  begin
    node := lstMAPFiles.AddChild(nil);
    data := lstMAPFiles.GetNodeData(node);
    data^.FileName := FMapFiles[i].FileName;
    //data^.Size := FMapFiles[i].Size;
  end;

  lstMAPFiles.Refresh;
  lstMAPFiles.EndUpdate;
end;

end.
