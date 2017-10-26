unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager, Vcl.StdCtrls, sButton, Vcl.ExtCtrls, sPanel,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Menus, sGroupBox, sLabel, sEdit,
  uDM, sSplitter, VirtualTrees, sMemo, sDialogs, System.Generics.Collections, IdAllFTPListParsers, IdFTPList,
  Vcl.ComCtrls, AbComCtrls, AbBase, AbBrowse, AbZBrows, AbZipper, AbZipKit, AbArcTyp, uFTPItem, AnsiStrings,
  acProgressBar;

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
    btnRemove: TsButton;
    zip: TAbZipKit;
    btnBack: TsButton;
    sSplitter3: TsSplitter;
    sPanel6: TsPanel;
    lblUploadProgress: TsLabel;
    sProgressBar1: TsProgressBar;
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
    procedure btnRemoveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    FMapFiles: TList<TMapFile>;
    FCurrentNode: TFTPItem;
    FFoundNode: TFTPItem;
    FRoot: TFTPItem;
    FDOD: TFTPItem; // /dod/ folder
    FLogFileName: string;
    FLogFile: TextFile;
    procedure SynchronizeMapFiles;
    procedure SynchronizeFtpFiles(ftpNode: TFTPItem);
    procedure Connect;
    procedure UpdateUI;
    function CorrectTargetFolder: boolean;
    function DoesFTpFileExist(fn: string): boolean;
    procedure WalkTree(ftpItem: TFTPItem);
    function ChangeFolder(node: TFTPItem; folder: string): TFTPItem;
    function GetRootNode(node: TFTPItem): TFTPItem;
    function SearchTree(node: TFTPItem; fn: string): TFTPItem;
    procedure UpdateNode(folder: string; item: TAbArchiveItem; cleanFileName: string; ToStream: TMemoryStream;
      zipFileName: string; fullPath: string);
    function CleanItem(zipFileName: string; itemFileName: string): string;
    function GetDODFolder: TFTPItem;
    procedure CreateFolders(fullpath: string; currentFolder: string);
    procedure ConnectoToFTPServer;
    procedure Log(status: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

const
  CRLF: string = #13#10;

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

procedure TfrmMain.btnBackClick(Sender: TObject);
begin
  if FCurrentNode.Parent <> nil then
    FCurrentNode := FCurrentNode.Parent;

  UpdateUI;

  if FCurrentNode.Parent = nil then
    btnBack.Enabled := false;
end;

procedure TfrmMain.btnClearListClick(Sender: TObject);
begin
  FMapFiles.Clear;
  SynchronizeMapFiles;
  Log('Cleared list');
  UpdateUI;
end;

procedure TfrmMain.btnConnectClick(Sender: TObject);
begin
  if MessageDlg('DOD Mapper will retrieve listings of all files and folders from the FTP server.'+CRLF+
    'This will take a few moments. Once this is done, the upload and verifictions of maps will be fast.'+CRLF+CRLF+
    'Continue?', mtCustom,[mbYes,mbCancel], 0) = mrYes then
    Connect;
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  if dm.ftp.Connected then
    dm.ftp.Disconnect(false);
  if not dm.ftp.Connected then
  begin
    UpdateUI;
    Log('Disconnected from '+dm.Host+' on port '+inttostr(dm.Port));
  end;
end;

procedure TfrmMain.btnRemoveClick(Sender: TObject);
var
  node: PVirtualNode;
  data: PMapFile;
  newMapFiles: TList<TMapFile>;
  removedMapFiles: TList<string>;
  i: Integer;
  gotMilk: boolean;
  x: Integer;
begin
  if lstMAPFiles.SelectedCount > 0 then
  begin
    newMapFiles := TList<TMapFile>.Create;
    removedMapFiles := TList<string>.Create;

    for node in lstMAPFiles.SelectedNodes do
    begin
      if lstMAPFiles.Selected[node] then
      begin
        data := lstMAPFiles.GetNodeData(node);
        removedMapFiles.Add(data.FileName);
        Log('Removed '+data.FileName);
      end;
    end;

    for i := 0 to FMapFiles.Count-1 do
    begin
      gotMilk := false;
      for x := 0 to removedMapFiles.Count-1 do
      begin
        if FMapFiles[i].FileName = removedMapFiles[x] then
        begin
          gotMilk := true;
          break;
        end;
      end;
      if not gotMilk then
        newMapFiles.Add(FMapFiles[i])
    end;

    FMapFiles := newMapFiles;

    SynchronizeMapFiles;
    UpdateUI;
  end;
end;

procedure TfrmMain.btnUploadClick(Sender: TObject);
var
  i: Integer;
  ToStream : TMemoryStream;
  Item : TAbArchiveItem;
  x,zipPos: Integer;
  folder: string;
  cleanFileName: string;
  fileName,zipFileName,leftDir: string;
  foundZipFileNameInFolder: boolean;
begin
  if FCurrentNode = nil then exit;

  FRoot := GetRootNode(FCurrentNode);
  FDOD := GetDODFolder;
  FCurrentNode := FDOD;

  // Change the folder on ther server to the DOD folder
  ConnectoToFTPServer;
  dm.ftp.ChangeDir(FDOD.Folder);
  UpdateUI;

  if CorrectTargetFolder then
  begin
    Screen.Cursor := crHourGlass;
    folder := FCurrentNode.Folder;
    if folder[length(folder)]<>'/' then
      folder := folder + '/';
    try
      for i := 0 to FMapFiles.Count-1 do
      begin
        Log('***********'+StringOfChar('*',length(FMapFiles[i].Filename)));
        Log('Processing '+FMapFiles[i].Filename);
        zip.OpenArchive(FMapFiles[i].Filename);
        zipFileName := uppercase(ChangeFileExt(ExtractFileName(FMapFiles[i].Filename),''));
        for x := 0 to zip.Count-1 do
        begin
          Item := zip.Items[x];
          cleanFileName := CleanItem(FMapFiles[i].Filename, Item.FileName);
          if length(cleanFileName)>0 then
          begin
            // 'sound/dod_walmart/alliesscoreshort.wav'
            leftDir := zipFileName+'/';
            foundZipFileNameInFolder := false;
            if leftDir = copy(uppercase(Item.FileName),1,length(leftDir)) then
            begin
              foundZipFileNameInFolder := true;
              leftDir := copy(Item.FileName,length(leftDir)+1);
            end;
            //zipPos := pos(leftDir,uppercase(Item.FileName));
            if Item.FileName[length(Item.FileName)] = '/' then
            begin
              // It's a folder, remove '/' at end
              // Also, remove the zip filename from the item filename
              if foundZipFileNameInFolder then
                fileName := folder+copy(Item.FileName,length(leftDir)+1)
              else
                fileName := folder+copy(Item.FileName,1,length(Item.FileName)-1);
            end else
            begin
              if foundZipFileNameInFolder then
                fileName := folder+copy(Item.FileName,length(leftDir)+1)
              else
                fileName := folder+Item.FileName;
            end;
            if fileName[length(fileName)] = '/' then
              fileName := copy(fileName,1,length(fileName)-1);
            if DoesFTpFileExist(fileName) then
            begin
              Log('Skipping '+fileName);
            end else
            begin
              try
                ToStream := TMemoryStream.Create;
                zip.ExtractToStream(Item.FileName, ToStream);
                ToStream.Position := 0;
                UpdateNode(folder, Item, cleanFileName, ToStream, zipFileName, fileName);
              finally
                ToStream.Free;
              end;
            end;
          end;
        end;
      end;
      Log('Done!');
      UpdateUI;
    finally
      Screen.Cursor := crArrow;
    end;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    if dm.ftp.Connected then
      dm.ftp.Disconnect(false);
    CloseFile(FLogFile);
  except

  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FMapFiles := TList<TMapFile>.Create;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  lstMAPFiles.Colors.UnfocusedSelectionColor := frmMain.sSkinManager1.GetGlobalColor;
  lstFtpFiles.Colors.UnfocusedSelectionColor := frmMain.sSkinManager1.GetGlobalColor;
  //lstFtpFiles.Colors.UnfocusedSelectionColor := frmMain.sSkinManager1.GetHighLightColor(true);
  //lblUploadProgress.Font.Color := frmMain.sSkinManager1.GetGlobalColor;

  FLogFileName := ExtractFilePath(Application.ExeName) + 'DODMapperLog.txt';
  AssignFile(FLogFile, FLogFileName);
  if FileExists(FLogFileName) then
    Append(FLogFile)
  else
    Rewrite(FLogFile);
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
  folder: string;
begin
  data := Sender.GetNodeData(HitInfo.HitNode);
  case HitInfo.HitColumn of
    0:
      begin
        if Data.Dir then
        begin
          if FCurrentNode = nil then exit;
          folder := FCurrentNode.Folder;
          if folder[length(folder)]<>'/' then
            folder := folder + '/' + Data.Name
          else
            folder := folder + Data.Name;
          FCurrentNode := ChangeFolder(FCurrentNode,folder);
          if FCurrentNode <> nil then
            UpdateUI;
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
  end;

  lstMAPFiles.Refresh;
  lstMAPFiles.EndUpdate;
end;

procedure TfrmMain.txtFolderKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //FFolder := '';
end;

procedure TfrmMain.SynchronizeFtpFiles(ftpNode: TFTPItem);
var
  node: PVirtualNode;
  data: PFTPData;
  i: integer;
begin
  lstFtpFiles.BeginUpdate;
  lstFtpFiles.Clear;

  for i := 0 to ftpNode.Children.Count-1 do
  begin
    if ftpNode.Children[i].Name <>'' then
    begin
      node := lstFtpFiles.AddChild(nil);
      data := lstFtpFiles.GetNodeData(node);
      data^.Name := ftpNode.Children[i].Name;
      data^.Size := ftpNode.Children[i].Size;
      data^.Dir := ftpNode.Children[i].Dir;
      data^.Level := 0;
      data^.ModifiedDate := ftpNode.Children[i].ModifiedDate;
    end;
  end;

  lstFtpFiles.Refresh;
  lstFtpFiles.EndUpdate;
end;

procedure TfrmMain.Connect;
var
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

  if FCurrentNode = nil then
  begin
    FCurrentNode := TFTPItem.Create(nil);  // create root
    FCurrentNode.Folder := txtFolder.Text;
    if FCurrentNode.Folder = '' then
      FCurrentNode.Folder := '/';
  end;

  Screen.Cursor := crHourGlass;
  try
    ConnectoToFTPServer;
    if dm.ftp.Connected then
    begin
      WalkTree(FCurrentNode);
      UpdateUI;
    end;
  finally
    Screen.Cursor := crArrow;
  end;
end;

procedure TfrmMain.ConnectoToFTPServer;
begin
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
          Log('Connected to '+dm.Host+' on port '+inttostr(dm.Port));
          UpdateUI;
        end;
      end;
    except
      try
        ftp.Disconnect(False);
      except
      end;
      if ftp.IOHandler <> nil then ftp.IOHandler.InputBuffer.Clear;
      Log('Connectivity to the server has been lost.');
    end;
  end;
end;

procedure TfrmMain.UpdateUI;
var
  connected: boolean;
begin
  try
    connected := false;
    connected := dm.ftp.Connected;
  except
  end;

  if (FMapFiles.Count > 0) and connected then
    btnUpload.Enabled := true
  else
    btnUpload.Enabled := false;

  if connected then
    btnDisconnect.Enabled := true
  else
    btnDisconnect.Enabled := false;

  if FCurrentNode <> nil then
  begin
    lstFtpFiles.RootNodeCount := FCurrentNode.Children.Count;
    txtFolder.Text := FCurrentNode.Folder;
    SynchronizeFtpFiles(FCurrentNode);
  end;
end;

function TfrmMain.CorrectTargetFolder: boolean;
var
  i: Integer;
begin
  result := false;
  for i := 0 to FCurrentNode.Children.Count-1 do
  begin
    if uppercase(FCurrentNode.Children[i].Name) = 'VALVE.INF' then
    begin
      result := true;
      exit;
    end;
  end;
end;

function TfrmMain.DoesFTpFileExist(fn: string): boolean;
var
  i: Integer;
  fileName: string;
  FFoundFTPItem: TFTPItem;
begin
  result := false;
  fileName := uppercase(fn);
  FFoundNode := nil;
  FFoundFTPItem := SearchTree(FRoot, fileName);
  if FFoundNode <> nil then
    result := true;
end;

procedure TfrmMain.WalkTree(ftpItem: TFTPItem);
var
  i: Integer;
  item: TIdFTPListItem;
  ftpChild: TFTPItem;
  dl: TList<TIdFTPListItem>;
  col: TIdFTPListItems;
  files: TStringList;
begin
//  FFiles.Clear;

  Log('Retrieving '+ftpItem.Folder);
  dm.FTP.ChangeDir(ftpItem.Folder);
  files := TStringList.Create;
  dm.FTP.List(files,'',true);
  //dm.FTP.List('',true);
  //Log('Found '+inttostr(dm.FTP.DirectoryListing.Count)+' item(s)');

  col := TIdFTPListItems.Create;
  dl := TList<TIdFTPListItem>.Create;
  for i := 0 to dm.FTP.DirectoryListing.Count-1 do
  begin
    item := TIdFTPListItem.Create(col);
    item.FileName := dm.FTP.DirectoryListing.Items[i].FileName;
    item.Size := dm.FTP.DirectoryListing.Items[i].Size;
    item.ItemType := dm.FTP.DirectoryListing.Items[i].ItemType;
    dl.Add(item);
  end;

  if dl.Count > 0 then
  begin
    for i := 0 to dl.Count-1 do
    begin
      item := dl[i];
      ftpChild := TFTPItem.Create(ftpItem);
      ftpChild.Folder := ftpItem.Folder;
      ftpChild.Name := item.FileName;
      ftpChild.Size := item.Size;
      ftpChild.ModifiedDate := trim(copy(files[i],1,24));
      if ftpChild.Folder[length(ftpChild.Folder)]<>'/' then
        ftpChild.FullPathWithFileName := uppercase(ftpItem.Folder + '/' + ftpChild.Name)
      else
        ftpChild.FullPathWithFileName := uppercase(ftpItem.Folder + ftpChild.Name);
      if item.ItemType = ditDirectory then
      begin
        if uppercase(ftpChild.Name) <> 'APPCACHE' then
        begin
          ftpChild.Dir := true;
          if ftpChild.Folder[length(ftpChild.Folder)]<>'/' then
            ftpChild.Folder := ftpChild.Folder + '/';
          ftpChild.Folder := ftpChild.Folder + item.FileName;
          WalkTree(ftpChild);
        end;
      end else
      begin
        ftpChild.Dir := false;
      end;
      //Log(ftpChild.Name);
      ftpItem.Children.Add(ftpChild);
    end;
  end;
end;

function TfrmMain.ChangeFolder(node: TFTPItem; folder: string): TFTPItem;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to node.Children.Count-1 do
  begin
    if (node.Children[i].Dir = true) and (node.Children[i].Folder = folder) then
    begin
      result := node.Children[i];
      btnBack.Enabled := true;
      exit;
    end;
  end;
end;

function TfrmMain.GetRootNode(node: TFTPItem): TFTPItem;
begin
  result := nil;
  if node = nil then exit;

  if node.Parent = nil then
  begin
    result := node;
    exit;
  end;

  if node.Parent <> nil then
    result := GetRootNode(node.Parent);
end;

function TfrmMain.SearchTree(node: TFTPItem; fn: string): TFTPItem;
var
  i: Integer;
  searchFor: string;
begin
  if FFoundNode <> nil then
  begin
    result := FFoundNode;
    exit;
  end;

  result := nil;
  if fn[length(fn)] = '/' then
    fn := copy(fn, 1, length(fn)-1);
  searchFor := uppercase(fn);

  for i := 0 to node.Children.Count-1 do
  begin
    if node.Children[i].FullPathWithFileName = searchFor then
    begin
      result := node.Children[i];
      FFoundNode := result;
      exit;
    end;
    if node.Children[i].Dir then
      result := SearchTree(node.Children[i], searchFor);
  end;
end;

procedure TfrmMain.UpdateNode(folder: string; item: TAbArchiveItem; cleanFileName: string; ToStream: TMemoryStream;
  zipFileName: string; fullPath: string);
var
  ftpItem,existingFtpItem: TFTPItem;
//  fullPath: string;
  delimiterPos: integer;
  parent: TFTPItem;
  i,zipPos: Integer;
begin
  if FDOD = nil then exit;

  // 'sprites/obj_icons/dod_tiger2_b2/icon_obj_custom1_allies.spr'
  // 'sound/dod_walmart/alliesscoreshort.wav'
//  zipPos := pos(zipFileName+'/',uppercase(Item.FileName));
//  if zipPos > 0 then
//    fullPath := copy(Item.FileName,length(zipFileName+'/')+1)
//  else
//    fullPath := item.FileName;

  delimiterPos := pos('/', fullPath);
  if delimiterPos > 0 then
  begin
    // We have at least one folder in there
    for i := length(fullPath)-1 downto 0 do
    begin
      if fullPath[i] = '/' then
      begin
        fullPath := copy(fullPath, 1, i-1);
        break;
      end;
    end;
    CreateFolders(fullPath, '');

    // Get parent for the file/folder
    FFoundNode := nil;
    //parent := SearchTree(FDOD,FDOD.Folder + '/' + fullPath);
    parent := SearchTree(FDOD,fullPath);
    if parent <> nil then
    begin
      // Update our local tree with a new FTPItem
      ftpItem := TFTPItem.Create(parent);
      ftpItem.FullPathWithFileName := uppercase(parent.Folder + '/' + cleanFileName);
      ftpItem.Folder := parent.Folder;
      ftpItem.Name := cleanFileName;
      ftpItem.Size := item.UncompressedSize;
      ftpItem.Dir := false;
      ftpItem.ModifiedDate := datetimetostr(item.LastModTimeAsDateTime);
      parent.Children.Add(ftpItem);

      Log('Changing to folder ' + parent.Folder);
      dm.ftp.ChangeDir(parent.Folder);
      dm.CurrentFileSize := ftpItem.Size;
      Log('Uploading '+cleanFileName);
      try
        dm.ftp.Put(ToStream,cleanFileName,false);
      except
      end;
    end;
  end else
  begin
    // Update our local tree with a new FTPItem
    ftpItem := TFTPItem.Create(FDOD);
    ftpItem.FullPathWithFileName := uppercase(FDOD.Folder + '/' + cleanFileName);
    ftpItem.Folder := FDOD.Folder;
    ftpItem.Name := cleanFileName;
    ftpItem.Size := item.UncompressedSize;
    ftpItem.Dir := false;
    ftpItem.ModifiedDate := datetimetostr(item.LastModTimeAsDateTime);
    FDOD.Children.Add(ftpItem);

    Log('Changing to folder ' + FDOD.Folder);
    dm.ftp.ChangeDir(FDOD.Folder);
    Log('Uploading '+cleanFileName);
    dm.CurrentFileSize := ftpItem.Size;
    try
      dm.ftp.Put(ToStream,cleanFileName,false);
    except
    end;
  end;
end;

procedure TfrmMain.CreateFolders(fullpath: string; currentFolder: string);
var
  ftpItem,existingFtpItem: TFTPItem;
  dir,path,leftDir: string;
  delimiterPos: integer;
  parent: TFTPItem;
begin
  // 'sprites/obj_icons/dod_tiger2_b2/icon_obj_custom1_allies.spr'

  if currentFolder = '' then
  begin
    // Get first folder from full path
    if length(fullpath) > 0 then
    begin
      leftDir := uppercase(copy(fullpath,1,5));
      if leftDir = '/DOD/' then
        fullpath := copy(fullpath,6);
      delimiterPos := pos('/', fullpath);
      if delimiterPos > 0 then
      begin
        dir := copy(fullpath,1,delimiterPos-1);
        FFoundNode := nil;
        existingFtpItem := SearchTree(FDOD,FDOD.Folder + '/' + dir);
        if existingFtpItem = nil then
        begin
          // Folder does not exist, create it on the server
          Log('Creating folder '+FDOD.Folder + '/' + dir);
          dm.ftp.ChangeDir(FDOD.Folder);
          dm.ftp.MakeDir(dir);

          // Update our local tree with a new FTPItem
          ftpItem := TFTPItem.Create(FDOD);
          ftpItem.FullPathWithFileName := uppercase(FDOD.Folder + '/' + dir);
          ftpItem.Folder := FDOD.Folder + '/' + dir;
          ftpItem.Name := dir;
          ftpItem.Size := 0;
          ftpItem.Dir := true;
          ftpItem.ModifiedDate := datetimetostr(now);
          FDOD.Children.Add(ftpItem);
        end;
        CreateFolders(fullpath, dir);
      end;
    end;
  end else
  begin
    // Keep going with the fullpath
    leftDir := copy(fullPath,1,pos(currentFolder,fullPath)+length(currentFolder));
    path := copy(fullPath,pos(currentFolder,fullPath)+length(currentFolder)+1);
    //delimiterPos := pos('/', path);
    //if delimiterPos > 0 then
    if path <> '' then
    begin
      // We have at least one folder in there
      delimiterPos := pos('/', path);
      if delimiterPos > 0 then
        dir := copy(path,1,delimiterPos-1)
      else
        dir := path;
      FFoundNode := nil;
      path := FDOD.Folder + '/' + leftDir + dir;
      existingFtpItem := SearchTree(FDOD,path);
      if existingFtpItem = nil then
      begin
        // Folder does not exist, create it on the server
        Log('Creating folder '+path);
        dm.ftp.ChangeDir(FDOD.Folder + '/' + leftDir);
        dm.ftp.MakeDir(dir);

        FFoundNode := nil;
        parent := SearchTree(FDOD,FDOD.Folder + '/' + leftDir);

        // Update our local tree with a new FTPItem
        // parent should be not nil, of it is nil, it's an error
        if parent <> nil then
        begin
          ftpItem := TFTPItem.Create(parent);
          ftpItem.FullPathWithFileName := uppercase(path);
          ftpItem.Folder := path;
          ftpItem.Name := dir;
          ftpItem.Size := 0;
          ftpItem.Dir := true;
          ftpItem.ModifiedDate := datetimetostr(now);
          parent.Children.Add(ftpItem);
        end else
        begin
          Log('ERROR: Can not find parent folder ' + FDOD.Folder + '/' + leftDir);
        end;
      end;
      CreateFolders(fullpath, dir);
    end else
    begin
      // Stop recursive calls when path = ''
      if path <> '' then
        CreateFolders(fullpath, path);
    end;
  end;
end;

function TfrmMain.CleanItem(zipFileName: string; itemFileName: string): string;
var
  needle: string;
  i: integer;
begin
  result := itemFileName;
  needle := uppercase(ChangeFileExt(ExtractFileName(zipFileName),'')) + '/';
  i := AnsiPos(needle, uppercase(itemFileName));
  if i = 1 then
    result := copy(itemFileName, i+length(needle));
  if result <> '' then
    if result[length(result)] = '/' then
      result := copy(result,1,length(result)-1);
  if pos('/',result) > 0 then
  begin
    for i := length(result)-1 downto 0 do
    begin
      if result[i] = '/' then
      begin
        result := copy(result, i+1);
        break;
      end;
    end;
  end;
end;

function TfrmMain.GetDODFolder: TFTPItem;
var
  i: Integer;
begin
  result := nil;
  for i := 0 to FRoot.Children.Count-1 do
  begin
    if FRoot.Children[i].FullPathWithFileName = '/DOD' then
    begin
      result := FRoot.Children[i];
      exit;
    end;
  end;
end;

procedure TfrmMain.Log(status: string);
begin
  memStatus.Lines.Add(status);

  try
    WriteLn(FLogFile, status);
    Flush(FLogFile);
  except

  end;
end;

end.
