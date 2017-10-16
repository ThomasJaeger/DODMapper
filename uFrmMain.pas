unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager, Vcl.StdCtrls, sButton, Vcl.ExtCtrls, sPanel,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Menus, sGroupBox, sLabel, sEdit,
  uDM, sSplitter, VirtualTrees, sMemo, sDialogs, System.Generics.Collections, IdAllFTPListParsers, IdFTPList;

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
    lstFtpFiles: TVirtualStringTree;
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
    sPanel5: TsPanel;
    sLabel5: TsLabel;
    txtFolder: TsEdit;
    procedure btnAddMapFilesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstMAPFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure btnClearListClick(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure lstFtpFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lstFtpFilesGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure lstFtpFilesNodeDblClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
    procedure txtFolderKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lstFtpFilesGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
  private
    FMapFiles: TList<TMapFile>;
    FFiles: TStringList;
    FFTPFiles: TList<TFTPData>;
    FFolder: string;
    procedure SynchronizeMapFiles;
    procedure SynchronizeFtpFiles;
    procedure Connect;
    procedure UpdateUI;
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
    SynchronizeMapFiles;
    UpdateUI;
  end;
end;

procedure TfrmMain.btnClearListClick(Sender: TObject);
begin
  FMapFiles.Clear;
  SynchronizeMapFiles;
  memStatus.Lines.Add('Cleared list');
  UpdateUI;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  Connect;
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  if dm.ftp.Connected then
    dm.ftp.Disconnect(false);
  if not dm.ftp.Connected then
  begin
    UpdateUI;
    memStatus.Lines.Add('Disconnected from '+dm.Host+' on port '+inttostr(dm.Port));
  end;
end;

procedure TfrmMain.btnUploadClick(Sender: TObject);
begin
  ShowMessage('Not available, yet.');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if dm.ftp.Connected then
    dm.ftp.Disconnect(false);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FMapFiles := TList<TMapFile>.Create;
  FFTPFiles := TList<TFTPData>.Create;
  FFiles := TStringList.Create;
end;

procedure TfrmMain.lstFtpFilesGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
var
  Data: PFTPData;
begin
  Data := Sender.GetNodeData(Node);
  if (Kind in [ikNormal, ikSelected]) and (Column = 0) then
  begin
    if Data.Dir then
      ImageIndex := 13;
  end;
end;

procedure TfrmMain.lstFtpFilesGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TFTPData);
end;

procedure TfrmMain.lstFtpFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  Data: PFTPData;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) and (Data<>nil) then
  begin
    case Column of
      0: CellText := Data.Name;
      1:
        begin
          if Data.Size > 0 then
            CellText := dm.FormatByteSize(Data.Size)
          else
            CellText := '';
        end;
      2: CellText := Data.ModifiedDate;
    end;
  end;
end;

procedure TfrmMain.lstFtpFilesNodeDblClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
var
  Data: PFTPData;
begin
  data := Sender.GetNodeData(HitInfo.HitNode);
  case HitInfo.HitColumn of
    0:
      begin
        if Data.Dir then
        begin
          FFolder := FFolder + '/' + Data.Name;
          Connect;
        end;
      end;
  end;
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
//          CellText := dm.FormatByteSize(Data.Size)
//        else
//          CellText := '';
//      end;
//    2: CellText := Data.ModifiedDate;
  end;
end;

procedure TfrmMain.SynchronizeMapFiles;
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
    memStatus.Lines.Add('Added '+FMapFiles[i].FileName);
  end;

  lstMAPFiles.Refresh;
  lstMAPFiles.EndUpdate;
end;

procedure TfrmMain.txtFolderKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  FFolder := '';
end;

procedure TfrmMain.SynchronizeFtpFiles;
var
  node: PVirtualNode;
  data: PFTPData;
  i: integer;
begin
  lstFtpFiles.BeginUpdate;
  lstFtpFiles.Clear;

  for i := 0 to FFTPFiles.Count-1 do
  begin
    if FFTPFiles[i].Name <>'' then
    begin
      node := lstFtpFiles.AddChild(nil);
      data := lstFtpFiles.GetNodeData(node);
      data^.Name := FFTPFiles[i].Name;
      data^.Size := FFTPFiles[i].Size;
      data^.Dir := FFTPFiles[i].Dir;
      data^.Level := 0;
      data^.ModifiedDate := FFTPFiles[i].ModifiedDate;
      //memStatus.Lines.Add('Added '+FFTPFiles[i].Name);
    end;
  end;

  lstFtpFiles.Refresh;
  lstFtpFiles.EndUpdate;
end;

procedure TfrmMain.Connect;
Var
  i: Integer;
  item: TIdFTPListItem;
  ftpData: TFTPData;
begin
  if (dm.Host='') or (dm.Username='') or (dm.Password='') then
  begin
    ShowMessage('Enter valid FTP server information, first.');
    dm.actSettingsExecute(self);
    exit;
  end;

  if FFolder = '' then
  begin
    FFolder := txtFolder.Text;
    if FFolder = '' then
      FFolder := '/';
  end;

  Screen.Cursor := crHourGlass;
  with dm do
  begin
    try
      if not ftp.Connected then
      begin
        ftp.Host := dm.Host;
        ftp.Username := dm.Username;
        ftp.Password := dm.Password;
        ftp.Port := dm.Port;
        ftp.Connect;
        if ftp.Connected then
        begin
          memStatus.Lines.Add('Connected to '+dm.Host+' on port '+inttostr(dm.Port));
          UpdateUI;
        end;
      end;
      if ftp.Connected then
      begin
        FFiles.Clear;
        FTP.ChangeDir(FFolder);
        FTP.List(FFiles,'',true);
        FFolder := dm.FTP.RetrieveCurrentDir;
        memStatus.Lines.Add('Retrieving contents from folder '+FFolder);
        lstFtpFiles.RootNodeCount := FTP.DirectoryListing.Count;
        FFTPFiles.Clear;
        memStatus.Lines.Add('Found '+inttostr(FTP.DirectoryListing.Count)+' item(s)');
        for i := 0 to FTP.DirectoryListing.Count-1 do
        begin
          item := FTP.DirectoryListing.Items[i];
          if item.FileName <> '' then
          begin
            ftpData.Name := item.FileName;
            ftpData.Size := item.Size;
            if item.ItemType = ditDirectory then
              ftpData.Dir := true
            else
              ftpData.Dir := false;
            //ftpData.ModifiedDate := item.ModifiedDate;
            //ftpData.ModifiedDate := strtodatetime(trim(copy(FFiles[i],1,24)));
            ftpData.ModifiedDate := trim(copy(FFiles[i],1,24));
            FFTPFiles.Add(ftpData);
          end;
        end;
        txtFolder.Text := FFolder;
        SynchronizeFtpFiles;
      end;
    finally
      Screen.Cursor := crArrow;
    end;
  end;

//  ALocalFolder := IncludeTrailingPathDelimiter(ALocalFolder);
//  ForceDirectories(ALocalFolder);
//  SubFolders := TStringList.Create;
//  Try
//    FTP.ChangeDir(ARemoteFolder);
//    FTP.List;
//    For I := 0 to FTP.DirectoryListing.Count-1 do
//    Begin
//      If FTP.DirectoryListing[I].ItemType = ditFile then
//      Begin
//        FTP.Get(FTP.DirectoryListing[I].FileName, ALocalFolder + FTP.DirectoryListing[I].FileName);
//      End
//      Else if FTP.DirectoryListing[I].ItemType = ditDirectory then
//      Begin
//        SubFolders.Add(FTP.DirectoryListing[I].FileName);
//      End;
//    End;
//    For I := 0 to SubFolders.Count-1 do
//    Begin
//      DownloadFolder(ARemoteFolder + '/' + SubFolders[I], ALocalFolder + SubFolders[I]);
//    End;
//  Finally
//    SubFolders.Free;
//  End;

end;

procedure TfrmMain.UpdateUI;
begin
  if (FMapFiles.Count > 0) and dm.ftp.Connected then
    btnUpload.Enabled := true
  else
    btnUpload.Enabled := false;

  if dm.ftp.Connected then
    btnDisconnect.Enabled := true
  else
    btnDisconnect.Enabled := false;
end;

end.
