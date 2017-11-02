unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinProvider, sSkinManager, Vcl.StdCtrls, sButton, Vcl.ExtCtrls, sPanel,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Menus, sGroupBox, sLabel, sEdit,
  uDM, sSplitter, VirtualTrees, sMemo, sDialogs, System.Generics.Collections,
  Vcl.ComCtrls, AbComCtrls, AbBase, AbBrowse, AbZBrows, AbZipper, AbZipKit, AbArcTyp, uFTPItem, AnsiStrings,
  acProgressBar, acAlphaHints, OverbyteIcsIniFiles, OverbyteIcsWinSock,
  OverByteIcsUtils, OverByteIcsFtpCli, OverbyteIcsFtpSrvT, OverByteIcsWSocket, OverbyteIcsWndControl,
  uFrmDirectoryForm,
  MagentaCopy, MagentaFtp3, MagentaHttp, MagSubs1, OverbyteIcsHttpProt, OverbyteIcsHttpCCodzlib, magclasses,
{$IFDEF USE_SSL} OverbyteIcsSSLEAY,{$ENDIF} OverbyteIcsLogger, AbUnzper, IOUtils, ShellApi;

type
  TSyncCmd   = function : Boolean  of object;
  TAsyncCmd  = procedure of object;

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
    sPanel2: TsPanel;
    btnUpload: TsButton;
    btnAddMapFiles: TsButton;
    lstMAPFiles: TVirtualStringTree;
    sPanel3: TsPanel;
    sSplitter2: TsSplitter;
    memStatus: TsMemo;
    dlgOpen: TsOpenDialog;
    sPanel4: TsPanel;
    btnClearList: TsButton;
    btnRemove: TsButton;
    zip: TAbZipKit;
    sPanel6: TsPanel;
    lblUploadProgress: TsLabel;
    sProgressBar1: TsProgressBar;
    sAlphaHints1: TsAlphaHints;
    sSplitter4: TsSplitter;
    ftp: TFtpClient;
    InfoLabel: TsLabel;
    UnZipper: TAbUnZipper;
    procedure btnAddMapFilesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstMAPFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure btnClearListClick(Sender: TObject);
    procedure btnGetDirectoryClick(Sender: TObject);
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
    procedure btnConnectClick(Sender: TObject);
    procedure ftpRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
    procedure btnRootClick(Sender: TObject);
    procedure UnZipperArchiveProgress(Sender: TObject; Progress: Byte; var Abort: Boolean);
  private
    FMapFiles: TList<TMapFile>;
    FCurrentNode: TFTPItem;
    FFoundNode: TFTPItem;
    FRoot: TFTPItem;
    FDOD: TFTPItem; // /dod/ folder
    FLogFileName: string;
    FLogFile: TextFile;
    FLastProgress  : Int64;
    FProgressCount : TFtpBigInt;
    FDirFiles: TFileRecs;
    FDirFileList: TFindList;
    FTempDirectory: string;
    procedure SynchronizeMapFiles;
    procedure GetFTPDirectories;
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
//    procedure ConnectoToFTPServer;
    procedure Log(status: string);
    procedure ExecuteCmd(SyncCmd : TSyncCmd; ASyncCmd : TAsyncCmd; sync: boolean = false);
    procedure DisplayHandler(Sender : TObject; var Msg : String);
    procedure MkDir(baseDir: string; dirName: string);
    procedure Cwd(dir: string);
    procedure Connect;
    procedure DisplayFile(FileName : String);
    procedure Dir;
    procedure Directory(dir: string);

    procedure ListFiles;
    function SetFTPThreadGen: integer;
    function SetFTPGen: boolean;
    procedure OnThreadEvent(LogLevel: TLogLevel; const Id, Info: String; var Cancel: boolean);
    procedure OnThreadTerminate(Sender: TObject);
    procedure OnCopyEvent(LogLevel: TLogLevel; Info: String; var Cancel: boolean);
    procedure onProgressEvent (Sender: TObject; CopyProgress: TCopyProgress; var Cancel: boolean);
    function GetFTPNodes(folder: string): TFTPItem;
    procedure Upload;
    procedure MoveFiles(ASourcePath, AFileSpec, ATargetPath: string; currentFolderOnly: boolean = false);
    procedure MoveDirectories(ASourcePath, AFileSpec, ATargetPath: string);
    function MoveDir(const fromDir, toDir: string): Boolean;
    function DeleteDir(const Dir: string): Boolean;
  public
    { Public declarations }
  end;

const
  TEMP_FILE_NAME = 'FTPDIR.TXT';
  ROOT = '/dod/';
  MaxThreads = 20 ;
var
  frmMain: TfrmMain;
  MagHTTPClient: TMagHTTP ;
  MagFTPClient: TMagFTP ;
  MagFileCopyClient: TMagFileCopy ;
  IcsLog: TIcsLogger ;
  AbortFlag: boolean ;
  IniFileName: string ;
  MagFtpThreads: array [0..MaxThreads] of TMagFtpThread ;
  CurThreads, NextThread: integer ;

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
  // Connect require HostName and Port which are set in ExecuteCmd
  // Connect is 3 commands in sequence: Open, User and Pass.
  ftp.UserName := dm.UserName;
  ftp.Password := dm.Password;
  ExecuteCmd(ftp.Connect, ftp.ConnectAsync);
end;

procedure TfrmMain.btnGetDirectoryClick(Sender: TObject);
begin
//  if MessageDlg('DOD Mapper will retrieve listings of all files and folders from the FTP server.'+CRLF+
//    'This will take a few moments. Once this is done, the upload and verifictions of maps will be fast.'+CRLF+CRLF+
//    'Continue?', mtCustom,[mbYes,mbCancel], 0) = mrYes then
    GetFTPDirectories;
end;

procedure TfrmMain.btnDisconnectClick(Sender: TObject);
begin
  // Quit doesn't require any parameter
  ExecuteCmd(ftp.Quit, ftp.QuitAsync);
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

procedure TfrmMain.btnRootClick(Sender: TObject);
begin
  FCurrentNode := GetFTPNodes('/');
  UpdateUI;
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
  Upload;
  exit;


  if FCurrentNode = nil then exit;

  FRoot := GetRootNode(FCurrentNode);
  FDOD := GetDODFolder;
  FCurrentNode := FDOD;

  // Change the folder on ther server to the DOD folder
//  ConnectoToFTPServer;
  //dm.ftp.ChangeDir(FDOD.Folder);
  FTP.HostDirName := FDOD.Folder;
  if not FTP.Cwd then
    raise Exception.Create('Failed to change dir: ' + FTP.ErrorMessage);
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
//    if dm.ftp.Connected then
//      dm.ftp.Disconnect(false);
    CloseFile(FLogFile);
  except

  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FMapFiles := TList<TMapFile>.Create;
  FTempDirectory := ExtractFilePath(Application.ExeName) + 'temp\dod\';
  ForceDirectories(FTempDirectory);
end;

procedure TfrmMain.FormShow(Sender: TObject);
var
  Data    : TWSAData;
begin
  lstMAPFiles.Colors.UnfocusedSelectionColor := frmMain.sSkinManager1.GetGlobalColor;
  //lstFtpFiles.Colors.UnfocusedSelectionColor := frmMain.sSkinManager1.GetGlobalColor;
  //lstFtpFiles.Colors.UnfocusedSelectionColor := frmMain.sSkinManager1.GetHighLightColor(true);
  //lblUploadProgress.Font.Color := frmMain.sSkinManager1.GetGlobalColor;

  FLogFileName := ExtractFilePath(Application.ExeName) + 'DODMapperLog.txt';
  AssignFile(FLogFile, FLogFileName);
  if FileExists(FLogFileName) then
    Append(FLogFile)
  else
    Rewrite(FLogFile);

  { Display winsock info }
  Data := WinsockInfo;
  Log('Winsock version ' +
          IntToStr(LOBYTE(Data.wHighVersion)) + '.' +
          IntToStr(HIBYTE(Data.wHighVersion)));
  Log(String(System.SysUtils.StrPas(Data.szDescription)));
  Log(String(System.SysUtils.StrPas(Data.szSystemStatus)));
end;

procedure TfrmMain.ftpRequestDone(Sender: TObject; RqType: TFtpRequest; ErrCode: Word);
var
    Cli : TFtpClient;
begin
    Cli := TFtpClient(Sender);
    Log('Request ' + LookupFTPReq (RqType) + ' Done.');
    Log('StatusCode = ' + IntToStr(Cli.StatusCode));
    Log('LastResponse was : ''' + Cli.LastResponse + '''');
    if ErrCode = 0 then
        Log('No error')
    else
        Log('Error = ' + IntToStr(ErrCode) +
                ' (' + Cli.ErrorMessage + ')');

    { Display last progress value }
    InfoLabel.Caption := IntToStr(FProgressCount);

    if ErrCode = 0 then begin
        case RqType of
            ftpFeatAsync,
            ftpConnectFeatAsync,
            ftpConnectFeatHostAsync :
                { If the server supports rfc 2640 we turn UTF-8 ON.            }
                { see also http://wiki.filezilla-project.org/Character_Set     }
                { For backward compatibility with servers that implement       }
                { the long expired IETF draft                                  }
                { http://tools.ietf.org/html/draft-ietf-ftpext-utf-8-option-00 }
                { it is also required to send the OPTS UTF8 ON command and to  }
                { ignore a possible error response.                            }
                if ftpFeatUtf8 in Cli.SupportedExtensions then begin
                    { Sets property CodePage as well in Edit's OnChange }
//                    CodePageEdit.Text := IntToStr(CP_UTF8);
                    Log('Server seems to support RFC 2640 - UTF-8 turned on');
                end;

            ftpOptsAsync :
                { Opts UTF8 ON is only required for backward compatibility }
                { with servers not implementing rfc 2640 properly.         }
                if Cli.NewOpts = 'UTF8 ON' then
                    //CodePageEdit.Text := IntToStr(CP_UTF8)
                else if Cli.NewOpts = 'UTF8 OFF' then
                    //CodePageEdit.Text := IntToStr(CP_ACP);
                    ;

            ftpDirAsync,
            ftpDirectoryAsync,
            ftpLsAsync,
            ftpListAsync,
            ftpMlsdAsync,
            ftpSiteCmlsdAsync,
            ftpXCmlsdAsync,
            ftpXDmlsdAsync,
            ftpSiteDmlsdAsync,
            ftpSiteIndexAsync :
                DisplayFile(TEMP_FILE_NAME);

            ftpSizeAsync :
                Log('File size is ' + IntToStr(Cli.SizeResult) +
                        ' bytes' );

            ftpPwdAsync,
            ftpMkdAsync,
            ftpCDupAsync,
            ftpCwdAsync :
                Log('Directory is "' + Cli.DirResult + '"');

            ftpGetAsync  :
                InfoLabel.Caption := InfoLabel.Caption + ' [' +
                       IntToStr(IcsGetFileSize(Cli.LocalFileName)) + ']';
        end;
    end;
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
//          folder := FCurrentNode.Folder;
//          if folder[length(folder)]<>'/' then
//            folder := folder + '/' + Data.Name
//          else
//            folder := folder + Data.Name;
          //FCurrentNode := ChangeFolder(FCurrentNode,folder);
          FCurrentNode := GetFTPNodes(Data.FullPath+Data.Name+'/');
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

//procedure TfrmMain.SynchronizeFtpFiles(ftpNode: TFTPItem);
//var
//  node: PVirtualNode;
//  data: PFTPData;
//  i: integer;
//begin
//  lstFtpFiles.BeginUpdate;
//  lstFtpFiles.Clear;
//
//  for i := 0 to ftpNode.Children.Count-1 do
//  begin
//    if ftpNode.Children[i].Name <>'' then
//    begin
//      node := lstFtpFiles.AddChild(nil);
//      data := lstFtpFiles.GetNodeData(node);
//      data^.Name := ftpNode.Children[i].Name;
//      data^.Size := ftpNode.Children[i].Size;
//      data^.Dir := ftpNode.Children[i].Dir;
//      data^.Level := 0;
//      data^.ModifiedDate := ftpNode.Children[i].ModifiedDate;
//      data^.FullPath := ftpNode.Children[i].Folder;
//    end;
//  end;
//
//  lstFtpFiles.Refresh;
//  lstFtpFiles.EndUpdate;
//end;

procedure TfrmMain.GetFTPDirectories;
var
  i: Integer;
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
    if FCurrentNode.Folder = '' then
      FCurrentNode.Folder := '/';
  end;

  Screen.Cursor := crHourGlass;
  try
    //WalkTree(FCurrentNode);
    ListFiles;
    UpdateUI;
  finally
    Screen.Cursor := crArrow;
  end;
end;

//procedure TfrmMain.ConnectoToFTPServer;
//begin
//  with dm do
//  begin
//    try
//      if not ftp.Connected then
//      begin
//        Connect;
//        if ftp.Connected then
//        begin
//          Log('Connected to '+dm.Host+' on port '+inttostr(dm.Port));
//          UpdateUI;
//        end;
//      end;
//    except
////      try
////        ftp.Disconnect(False);
////      except
////      end;
////      if ftp.IOHandler <> nil then ftp.IOHandler.InputBuffer.Clear;
//      Log('Connectivity to the server has been lost.');
//    end;
//  end;
//end;

procedure TfrmMain.UpdateUI;
var
  connected: boolean;
begin
  try
    connected := false;
    connected := ftp.Connected;
  except
  end;

//  if (FMapFiles.Count > 0) and connected then
//    btnUpload.Enabled := true
//  else
//    btnUpload.Enabled := false;

  if FCurrentNode <> nil then
  begin
//    lstFtpFiles.RootNodeCount := FCurrentNode.Children.Count;
//    txtFolder.Text := ROOT + FCurrentNode.Folder;
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
//  item: TIdFTPListItem;
  ftpChild: TFTPItem;
//  dl: TList<TIdFTPListItem>;
//  col: TIdFTPListItems;
  files: TStringList;
begin
  Log('Retrieving '+ftpItem.Folder);
//  Cwd(ftpItem.Folder);
//  Dir;
  Directory(ftpItem.Folder);

//  files := TStringList.Create;
//  dm.FTP.List(files,'',true);
//
//  col := TIdFTPListItems.Create;
//  dl := TList<TIdFTPListItem>.Create;
//  for i := 0 to dm.FTP.DirectoryListing.Count-1 do
//  begin
//    item := TIdFTPListItem.Create(col);
//    item.FileName := dm.FTP.DirectoryListing.Items[i].FileName;
//    item.Size := dm.FTP.DirectoryListing.Items[i].Size;
//    item.ItemType := dm.FTP.DirectoryListing.Items[i].ItemType;
//    dl.Add(item);
//  end;
//
//  if dl.Count > 0 then
//  begin
//    for i := 0 to dl.Count-1 do
//    begin
//      item := dl[i];
//      ftpChild := TFTPItem.Create(ftpItem);
//      ftpChild.Folder := ftpItem.Folder;
//      ftpChild.Name := item.FileName;
//      ftpChild.Size := item.Size;
//      ftpChild.ModifiedDate := trim(copy(files[i],1,24));
//      if ftpChild.Folder[length(ftpChild.Folder)]<>'/' then
//        ftpChild.FullPathWithFileName := uppercase(ftpItem.Folder + '/' + ftpChild.Name)
//      else
//        ftpChild.FullPathWithFileName := uppercase(ftpItem.Folder + ftpChild.Name);
//      if item.ItemType = ditDirectory then
//      begin
//        if uppercase(ftpChild.Name) <> 'APPCACHE' then
//        begin
//          ftpChild.Dir := true;
//          if ftpChild.Folder[length(ftpChild.Folder)]<>'/' then
//            ftpChild.Folder := ftpChild.Folder + '/';
//          ftpChild.Folder := ftpChild.Folder + item.FileName;
//          WalkTree(ftpChild);
//        end;
//      end else
//      begin
//        ftpChild.Dir := false;
//      end;
//      //Log(ftpChild.Name);
//      ftpItem.Children.Add(ftpChild);
//    end;
//  end;
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

procedure TfrmMain.UnZipperArchiveProgress(Sender: TObject; Progress: Byte; var Abort: Boolean);
begin
  frmMain.sProgressBar1.Position := Progress;
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
      FTP.HostDirName := parent.Folder;

      dm.CurrentFileSize := ftpItem.Size;
      Log('Uploading '+cleanFileName);
      try
//        dm.ftp.Put(ToStream,cleanFileName,false);
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
    FTP.HostDirName := FDOD.Folder;

    Log('Uploading '+cleanFileName);
    dm.CurrentFileSize := ftpItem.Size;
    try
//      dm.ftp.Put(ToStream,cleanFileName,false);
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
          MkDir(FDOD.Folder, dir);

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
        MkDir(FDOD.Folder, leftDir);

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
  if Application.Terminated then exit;

  status := FormatDateTime(LongTimeMask, Now) + space + status;
  memStatus.Lines.Add(status);

  try
    WriteLn(FLogFile, status);
    Flush(FLogFile);
  except

  end;
end;

//procedure TfrmMain.Display(const Msg : String);
//var
//    I : Integer;
//begin
//    DisplayMemo.Lines.BeginUpdate;
//    try
//        if DisplayMemo.Lines.Count > 200 then begin
//            { This is much faster than deleting line by line of the memo }
//            { however still slow enough to throttle ICS speed!           }
//            with TStringList.Create do
//            try
//                BeginUpdate;
//                Assign(DisplayMemo.Lines);
//                for I := 1 to 50 do
//                    Delete(0);
//                DisplayMemo.Lines.Text := Text;
//            finally
//                Free;
//            end;
//        end;
//        DisplayMemo.Lines.Add(Msg);
//    finally
//        DisplayMemo.Lines.EndUpdate;
//        SendMessage(DisplayMemo.Handle, EM_SCROLLCARET, 0, 0);
//    end;
//end;

{* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{ This procedure execute either the synchronous command or the asynchronous }
{ command depending on the SyncCheckBox state.                              }
{ All date from UI is copied to FTP component properties.                   }
procedure TfrmMain.ExecuteCmd(SyncCmd : TSyncCmd; ASyncCmd : TAsyncCmd; sync: boolean = false);
var
    bandwidth: integer;
begin
    Log('Executing Requested Command');
    { Initialize progress stuff }
    FLastProgress  := 0;
    FProgressCount := 0;

//    if not FtpClient1.Connected then begin
//    { With proxy connections proxy properties have to be set }
//    { before a connection attempt.                           }
//        FtpClient1.ConnectionType     := TFtpConnectionType(ProxyTypeComboBox.ItemIndex);
//
//        FtpClient1.ProxyServer        := ProxyHostEdit.Text;
//        FtpClient1.ProxyPort          := ProxyPortEdit.Text;
//
//        FtpClient1.SocksServer        := ProxyHostEdit.Text;
//        FtpClient1.SocksPort          := ProxyPortEdit.Text;
//        FtpClient1.SocksUserCode      := ProxyUserEdit.Text;
//        FtpClient1.SocksPassword      := ProxyPasswordEdit.Text;
//
//        FtpClient1.HttpTunnelServer   := ProxyHostEdit.Text;
//        FtpClient1.HttpTunnelPort     := ProxyPortEdit.Text;
//        FtpClient1.HttpTunnelUserCode := ProxyUserEdit.Text;
//        FtpClient1.HttpTunnelPassword := ProxyPasswordEdit.Text;
//        FtpClient1.HttpTunnelAuthType := THttpTunnelAuthType(ProxyHttpAuthTypeComboBox.ItemIndex);
//        { End of proxy settings }
//    end;

    ftp.HostName           := dm.Host;
    ftp.Port               := inttostr(dm.Port);
    ftp.DisplayFileFlag    := true;
    ftp.OnDisplay          := DisplayHandler;
    //bandwidth                 := StrToInt(MaxKB.Text);
    bandwidth                 := 0;
    if bandwidth > 0 then begin
        ftp.BandwidthLimit := bandwidth * 1024;
        ftp.Options := ftp.Options + [ftpBandwidthControl];
    end
    else
        ftp.Options := ftp.Options - [ftpBandwidthControl];
    if sync then begin
        if SyncCmd then
            Log('Command Success')
        else
            Log('Command Failure');
    end
    else
        ASyncCmd;
end;

procedure TfrmMain.DisplayHandler(Sender : TObject; var Msg : String);
begin
  Log(Msg);
end;

procedure TfrmMain.MkDir(baseDir: string; dirName: string);
begin
  // MkDir is an "all-in-one" command. It is equivalent of
  // Open, User, Pass, Cwd, Mkd and Quit commands
  // If you need best error control possible, it is better to use
  // the individual commands yourself.
  ftp.UserName        := dm.UserName;
  ftp.PassWord        := dm.PassWord;
  ftp.HostDirName     := baseDir;   // For base directory
  ftp.HostFileName    := dirName;  // For directory name
  ExecuteCmd(ftp.MkDir, ftp.MkdirAsync);
end;

procedure TfrmMain.Cwd(dir: string);
begin
  ftp.HostDirName     := dir;
  ExecuteCmd(ftp.Cwd, ftp.CwdAsync, true);
end;

procedure TfrmMain.Connect;
begin
  ftp.HostName := dm.Host;
  ftp.Passive := true;
  ftp.Binary := true;
  ftp.Username := dm.Username;
  ftp.Password := dm.Password;
  ftp.Port := inttostr(dm.Port);

  if not FTP.Open then
    raise Exception.Create('Failed to connect: ' + FTP.ErrorMessage);

  if (not FTP.User) or (not FTP.Pass) then
    raise Exception.Create('Failed to login: ' + FTP.ErrorMessage);
end;

procedure TfrmMain.DisplayFile(FileName : String);
var
    Strm : TFileStream;
    S : AnsiString;
    ACodePage: LongWord;
begin
    { When display on the fly, no file is generated }
//    if DisplayCheckBox.Checked then
//        exit;
    try
        Strm := TFileStream.Create(FileName, fmOpenRead);
        try
            SetLength(S, Strm.Size);
            Strm.Read(PAnsiChar(S)^, Length(S));
            { Auto-detect UTF-8 if Option is set }
            if (ftp.CodePage <> CP_UTF8) and
               (ftpAutoDetectCodePage in ftp.Options) and
               (CharsetDetect(S) = cdrUtf8) then
                ACodePage := CP_UTF8
            else
                ACodePage := ftp.CodePage;
            {$IFDEF UNICODE}
                DirectoryForm.DirListBox.Items.Text := AnsiToUnicode(S, ACodePage);
            {$ELSE}
                DirectoryForm.DirListBox.Items.Text := ConvertCodepage(S, ACodePage, CP_ACP)
            {$ENDIF}
        finally
            Strm.Free;
        end;
    except
        DirectoryForm.DirListBox.Clear;
    end;
    DirectoryForm.ShowModal;
end;

procedure TfrmMain.Dir;
begin
  DeleteFile(TEMP_FILE_NAME);
  //ftp.HostFileName    := dir;
  ftp.HostFileName    := '';
  ftp.LocalFileName   := TEMP_FILE_NAME;
  ftp.Passive         := false;
  ExecuteCmd(ftp.Dir, ftp.DirAsync, false);
end;

procedure TfrmMain.Directory(dir: string);
begin
  // Directory is an "all-in-one" command. It is equivalent of
  // Open, User, Pass, Pasv, Cwd, List and Quit commands
  // If you need best error control possible, it is better to use
  // the individual commands yourself.
  DeleteFile(TEMP_FILE_NAME);
  ftp.UserName        := dm.UserName;
  ftp.PassWord        := dm.PassWord;
  ftp.HostDirName     := dir;
  ftp.HostFileName    := '';
  ftp.LocalFileName   := TEMP_FILE_NAME;
  ftp.Passive         := false;
  ExecuteCmd(ftp.Directory, ftp.DirectoryAsync);
end;

procedure TfrmMain.ListFiles;
var
  taskres: TTaskResult ;
  i: Integer;
  TotDirFiles: integer;
  SrcFileRec: PTFileRec;
  ftpChild: TFTPItem;
begin
  FDirFileList := TFindList.Create;
  AbortFlag := false ;
  MagFTPClient := TMagFtp.Create (self) ;
  try
    if SetFTPGen then exit ;
    try
      with MagFTPClient do
      begin
        BulkMode := BulkModeDownload ;
        SrcDir := ROOT;
        SubDirs := true;
        EmptyDirs := true;
        taskres := FtpLogon ;
        if taskres <> TaskResOKNew then exit ;
        taskres := FtpDir (FDirFiles, FDirFileList, true);
        Log('Task Result: ' + GetTaskResName (taskres));
      end;
      FCurrentNode := GetFTPNodes('/');
    except
      Log('FTP Error - ' + GetExceptMess (ExceptObject));
    end ;
  finally
    FreeAndNil (MagFTPClient) ;
    InfoLabel.Caption := 'FTP Completed' ;
  end ;
end;

procedure TfrmMain.OnThreadEvent(LogLevel: TLogLevel; const Id, Info: String; var Cancel: boolean);
begin
  OnCopyEvent(LogLevel, Id + ': ' + Info, Cancel);
end;

procedure TfrmMain.OnThreadTerminate(Sender: TObject);
var
  MagFtpThread: TMagFtpThread ;
  rec: TFileRec;
begin
  MagFtpThread := (Sender as TMagFtpThread) ;
  Log('Terminated FTP: ' + MagFtpThread.ID);
  dec (CurThreads) ;
  //if CurThreads <= 0 then DoFtpAbort.Enabled := false ;
  Log('Task Result: ' + GetTaskResName (MagFtpThread.TaskRes));
  if MagFtpThread.TaskRes = TaskResOKNew then
  begin
    if MagFtpThread.FtpThreadOpt = ftpthdList then
    begin
      Log(MagFtpThread.Dirlisting);
    end;
  end;
end;

procedure TfrmMain.OnCopyEvent(LogLevel: TLogLevel; Info: String; var Cancel: boolean);
begin
  if (LogLevel = LogLevelInfo) or (LogLevel = LogLevelFile) then
  begin
    Log(Info);
    InfoLabel.Caption := Info ;
  end ;
  if (LogLevel = LogLevelProg) then
  begin
    if Info <> '' then
        InfoLabel.Caption := 'Progress: ' + Info
    else
        InfoLabel.Caption := '' ;
  end;
//  if (LogLevel = LogLevelDiag) and (ShowDiagsLow.Checked or
//                           ShowDiagsHigh.Checked) then AddLogText (Info) ;
  if (LogLevel = LogLevelDelimFile) then Log(Info) ;
  if (LogLevel = LogLevelDelimTot) then Log(Info) ;
  if AbortFlag then Cancel := true ;
end;

function TfrmMain.SetFTPThreadGen: integer;
var
    bandwidth: integer ;
begin
    Log(DateTimeToAStr(Now));
    AbortFlag := false ;
    //doFtpAbort.Enabled := true ;
    result := -1 ;
//    if FtpHost.Items.IndexOf (FtpHost.Text) < 0 then
//    begin
//        if FtpHost.Items.Count > 50 then
//                FtpHost.Items.Delete (FtpHost.Items.Count - 1) ;
//        FtpHost.Items.Insert (0, FtpHost.Text) ;
//    end ;
    try
        if CurThreads >= MaxThreads then exit ;
        MagFtpThreads [NextThread] := TMagFtpThread.CreateThread ;
        result := NextThread ;
        inc (CurThreads) ;
        inc (NextThread) ;
        if NextThread >= MaxThreads then NextThread := 0 ;  // assume earlier threads have been freed
        with MagFtpThreads [result] do
        begin
            FThreadEvent := onThreadEvent ;
            OnTerminate := OnThreadTerminate ;
            FreeOnTerminate := true ;
            Tag := result ;
            ID := 'ThreadNr=' + Int2StrZ (result, 3) ;
      //      LogmaskName := '"' + TestingDir + 'logs\' + ID + '-"yyyymmdd".log"' ;
            NoProgress := true ;  // stop progress log events
            LocalHost := String (OverbyteIcsWSocket.LocalHostName) ;
            HostName1 := dm.Host;
            HostName2 := '' ;
            SocketFamily := sfAny ;  // March 2013, change to sfAnyIPv4 if IPV6 not allowed
            SocketErrs := wsErrFriendly;        // Nov 2016
            UserName := dm.Username;
            PassWord := dm.Password;
            //FtpType := TFtpType(FtpServerType.ItemIndex);
            Port := inttostr(dm.Port);
            AttemptDelay := 5 ;
            MaxAttempts := 2 ;  // logon attempts
            FailRepeat := 3 ;   // retries for failed xfers
            DataSocketSndBufSize := 32768; // 8 Aug 2011 increase speed
            DataSocketRcvBufSize := 32768; // 8 Aug 2011 increase speed
            KeepAliveSecs := 30;  // 10 July 2006
            ConnectionType := ftpDirect;  // ConnectionType: ftpDirect, ftpProxy, ftpSocks4, ftpSocks4A, ftpSocks5
            SocksPort := '' ;
            SocksServer := '' ;
            ProxyPort := '' ;
            ProxyServer := '' ;
            SocksUsercode := '' ;
            SocksPassword := '' ;
//            if ConnectionType = ftpProxy then
//            begin
//                ProxyPort := FtpPort.Text ;
//                ProxyServer := '' ;
//            end
//            else if ConnectionType >= ftpSocks4 then
//            begin
//                SocksPort := '1080' ;
//                SocksServer := '192.168.1.66' ;
//                if ConnectionType = ftpSocks5 then
//                begin
//                    SocksUsercode := '' ;
//                    SocksPassword := '' ;
//                end ;
//            end ;
            PassiveX := false;  // must be after connection type
       // HostType: FTPTYPE_NONE, FTPTYPE_UNIX, FTPTYPE_DOS, FTPTYPE_MVS, FTPTYPE_AS400, FTPTYPE_MLSD
            HostType := FTPTYPE_NONE ;
       // TXferMode: XferModeBinary, XferModeAscii
            XferMode := XferModeBinary ;
       // TCaseFile: FileLowerCase, FileMixedCase
            CaseFile := FileLowerCase ;
            DiffStampMins := 62 ;
            Timeout := 600 ;    // 18 Sept 2006, 60 secs was too slow for MD5Sum
            DispLog := true ;
            DispFiles := true ;
            DispRDir:= true ;
            DispLDir:= false ;
            MinResSize := 65535 ;   // also used for resume overlap
//            MinResSize := 0 ;       // test no resume overlap
            UpArchDir := '' ;
            UpArchive := false ;
            ResFailed := true ;
            UseCompression := true ;  // 3 Dec 2005
//            if FtpNoFeatCmd.Checked then // 7 Nov 2007
//                MagFtpOpts := MagFtpOpts + [magftpNoFeat]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoFeat] ;
//            if FtpNoZlib.Checked then // 5 Jan 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoZlib]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoZlib] ;
//            if FtpNoTmpFile.Checked then // 5 Jan 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoTmpFile]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoTmpFile] ;
//            if FtpNoUtf8.Checked then   // 20 Sept 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoUtf8]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoUtf8] ;
//            if ftpNoHost.Checked then   // 20 Sept 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoHost]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoHost] ;
//            if ftpIgnoreUtf8.Checked then   // 20 Sept 2008
//                MagFtpOpts := MagFtpOpts + [magftpIgnoreUtf8]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpIgnoreUtf8] ;
//       // 22 May 2009 disable MD5 or CRC separately for testing
//            if FtpNoMd5.Checked then
//                MagFtpOpts := MagFtpOpts + [magftpNoMd5]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoMd5] ;
//            if FtpNoCrc.Checked then
//                MagFtpOpts := MagFtpOpts + [magftpNoCrc]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoCrc] ;
            ZlibNoCompExt := '.zip;.rar;.7z;.cab;.lzh;.gz;.avi;.wmv;.mpg;.mp3;.jpg;.png;'; // 2 Dec 2007
            ZlibMaxSize := 500000000 ;   // 9 Dec 2007 500 megs
            MaxResumeAttempts := 10 ;    // 31 Dec 2007
            //bandwidth := AscToInt (FtpBandWidth.Text) ;  // 31 Dec 2007
            bandwidth := 0;
            if bandwidth > 0 then
            begin
                BandwidthLimit := bandwidth * KBYTE ;
                Options := Options + [ftpBandwidthControl] ;
            end
            else
                Options := Options - [ftpBandwidthControl] ;
{$IFDEF USE_SSL}
            FtpSslPort := FtpPortSsl.Text ;
            SslSessCache := true ;  // 27 Nov 2005
            FtpSslVerMethod := TFtpSslVerifyMethod (VerifyCertMode.ItemIndex);  // 20 Apr 2015
            FtpSslRevocation := RevokeCheck.Checked ;    // 20 Apr 2015
            FtpSslReportChain := ReportChain.Checked ;   // 20 Apr 2015
{$ENDIF}
        { following properties only available if VCLZip available
            Zipped := false ;
            ZipDownDel := false ;
        // ZipExtFmt: ExtnAdd, ExtnReplace
        // ZipPath: PathNone, PathNew, PathOriginal, PathNewOrig, PathSpecific, PathSpecOrig
        // ZipType: TypeUnzip, TypeSrcAddX, TypeSrcReplX, TypeSrcDirs
            ZipExtFmt := ExtnAdd ;
            ZipPath := PathNone ;
            ZipDir := '' ;   }
            DispRemList := true ;
        end ;
    except
      Log('FTP Error - ' + GetExceptMess (ExceptObject));
    end ;
end;

function TfrmMain.SetFTPGen: boolean ;
var
    bandwidth: integer ;
begin
    Log(DateTimeToAStr(Now));
    AbortFlag := false ;
    result := false ;
    try
        with MagFTPClient do
        begin
            LocalHost := String (OverbyteIcsWSocket.LocalHostName) ;
            HostName1 := dm.Host;
            HostName2 := '' ;
            SocketFamily := sfAny ;  // March 2013, change to sfAnyIPv4 if IPV6 not allowed
            UserName := dm.Username;
            PassWord := dm.Password;
            //FtpType := TFtpType(FtpServerType.ItemIndex) ;
            Port := inttostr(dm.Port);
            AttemptDelay := 5 ;
            MaxAttempts := 2 ;  // logon attempts
            FailRepeat := 3 ;   // retries for failed xfers
            DataSocketSndBufSize := 32768; // 8 Aug 2011 increase speed
            DataSocketRcvBufSize := 32768; // 8 Aug 2011 increase speed
            KeepAliveSecs := 30;  // 10 July 2006
       // ConnectionType: ftpDirect, ftpProxy, ftpSocks4, ftpSocks4A, ftpSocks5
            ConnectionType := ftpDirect ;
       //     ConnectionType := ftpSocks4 ;
            SocksPort := '' ;
            SocksServer := '' ;
            ProxyPort := '' ;
            ProxyServer := '' ;
            SocksUsercode := '' ;
            SocksPassword := '' ;
            SocketErrs := wsErrFriendly;        // Nov 2016
//            if ConnectionType = ftpProxy then
//            begin
//                ProxyPort := FtpPort.Text ;
//                ProxyServer := '' ;
//            end
//            else if ConnectionType >= ftpSocks4 then
//            begin
//                SocksPort := '1080' ;
//                SocksServer := '192.168.1.66' ;
//                if ConnectionType = ftpSocks5 then
//                begin
//                    SocksUsercode := '' ;
//                    SocksPassword := '' ;
//                end ;
//            end ;
            PassiveX := false;  // must be after connection type
       // HostType: FTPTYPE_NONE, FTPTYPE_UNIX, FTPTYPE_DOS, FTPTYPE_MVS, FTPTYPE_AS400, FTPTYPE_MLSD
            HostType := FTPTYPE_NONE ;
       // TXferMode: XferModeBinary, XferModeAscii
            XferMode := XferModeBinary ;
       // TCaseFile: FileLowerCase, FileMixedCase
            CaseFile := FileLowerCase ;
            DiffStampMins := 62 ;
            Timeout := 600 ;    // 18 Sept 2006, 60 secs was too slow for MD5Sum
            DispLog := true ;
            DispFiles := true ;
            DispRDir:= true ;
            DispLDir:= false ;
            MinResSize := 65535 ;   // also used for resume overlap
//            MinResSize := 0 ;       // test no resume overlap
            ProgressEvent := Nil ;
            CopyEvent := Nil ;
//            if ShowXProgesss.Checked then    // 22 May 2013
                ProgressEvent := onProgressEvent;
//            else
//                CopyEvent := onCopyEvent ;
            UpArchDir := '' ;
            UpArchive := false ;
            ResFailed := true ;
            UseCompression := true ;  // 3 Dec 2005
//            if FtpNoFeatCmd.Checked then // 7 Nov 2007
//                MagFtpOpts := MagFtpOpts + [magftpNoFeat]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoFeat] ;
//          { if FtpNoMd5Crc.Checked then // 5 Jan 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoMd5Crc]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoMd5Crc] ;  }
//            if FtpNoZlib.Checked then // 5 Jan 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoZlib]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoZlib] ;
//            if FtpNoTmpFile.Checked then // 5 Jan 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoTmpFile]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoTmpFile] ;
//            if FtpNoUtf8.Checked then   // 20 Sept 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoUtf8]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoUtf8] ;
//            if ftpNoHost.Checked then   // 20 Sept 2008
//                MagFtpOpts := MagFtpOpts + [magftpNoHost]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoHost] ;
//            if ftpIgnoreUtf8.Checked then   // 20 Sept 2008
//                MagFtpOpts := MagFtpOpts + [magftpIgnoreUtf8]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpIgnoreUtf8] ;
//       // 22 May 2009 disable MD5 or CRC separately for testing
//            if FtpNoMd5.Checked then
//                MagFtpOpts := MagFtpOpts + [magftpNoMd5]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoMd5] ;
//            if FtpNoCrc.Checked then
//                MagFtpOpts := MagFtpOpts + [magftpNoCrc]
//            else
//                MagFtpOpts := MagFtpOpts - [magftpNoCrc] ;
        //  MagFtpOpts := MagFtpOpts + [magftpNoCrc] ;
        //  MagFtpOpts := MagFtpOpts + [magftpNoMd5] ;

            ZlibNoCompExt := '.zip;.rar;.7z;.cab;.lzh;.gz;.avi;.wmv;.mpg;.mp3;.jpg;.png;'; // 2 Dec 2007
            ZlibMaxSize := 500000000 ;   // 9 Dec 2007 500 megs
            MaxResumeAttempts := 10 ;    // 31 Dec 2007
            //bandwidth := AscToInt (FtpBandWidth.Text) ;  // 31 Dec 2007
            bandwidth := 0;
            if bandwidth > 0 then
            begin
                BandwidthLimit := bandwidth * KBYTE ;
                Options := Options + [ftpBandwidthControl] ;
            end
            else
                Options := Options - [ftpBandwidthControl] ;
{$IFNDEF NO_DEBUG_LOG}
//            IcsLogger := IcsLog ;
//            IcsLog.LogOptions := [] ;
//            if ShowDiagsLow.Checked then
//                IcsLog.LogOptions := [loDestEvent, loAddStamp] +
//                                                 LogAllOptInfo ; // 7 Jan 2006
{$IFDEF USE_SSL}
//            if ShowDiagsSSL.Checked then
//                    IcsLog.LogOptions := IcsLog.LogOptions + [loSslDump] ;
{$ENDIF}
{$ENDIF}
{$IFDEF USE_SSL}
            FtpSslPort := FtpPortSsl.Text ;
            SslSessCache := true ;  // 27 Nov 2005
            FtpSslVerMethod := TFtpSslVerifyMethod (VerifyCertMode.ItemIndex);  // 20 Apr 2015
            FtpSslRevocation := RevokeCheck.Checked ;    // 20 Apr 2015
            FtpSslReportChain := ReportChain.Checked ;   // 20 Apr 2015
{$ENDIF}
        { following properties only available if VCLZip available
            Zipped := false ;
            ZipDownDel := false ;
        // ZipExtFmt: ExtnAdd, ExtnReplace
        // ZipPath: PathNone, PathNew, PathOriginal, PathNewOrig, PathSpecific, PathSpecOrig
        // ZipType: TypeUnzip, TypeSrcAddX, TypeSrcReplX, TypeSrcDirs
            ZipExtFmt := ExtnAdd ;
            ZipPath := PathNone ;
            ZipDir := '' ;   }
            DispRemList := true ;
        end ;
    except
      Log('FTP Error - ' + GetExceptMess (ExceptObject));
      result := true ;
    end ;
end;

procedure TfrmMain.onProgressEvent(Sender: TObject; CopyProgress: TCopyProgress; var Cancel: boolean);
var
    S: string ;
begin
    with CopyProgress do
    begin
        if (LogLevel = LogLevelInfo) then
        begin
            Log(Info);
            InfoLabel.Caption := Info ;
        end ;
        if (LogLevel = LogLevelFile) then
        begin
            Log(Info);
        end ;
        if (LogLevel = LogLevelProg) then
        begin
            S := Info ;
            if (CurFileBytes > 0) then
            begin
                S := 'Copying File ' + CurSrcName + ' to ' + CurTarName + ', Size ' +
                                    InttoKByte (CurFileBytes) + ', Done ' + IntToStr (CurDonePercent) + '%' ;
                if (CurEstimateTicks > 0) then S := S + ', time left ' +
                                     TimerToStr (SecsToTime ((CurEstimateTicks - CurDoneTicks) div 1000)) ;
            end ;
            if (TotProcBytes > 0) then
            begin
                S := S  + CRLF_ + 'Totals: Copying '  + InttoCStr (TotDoneNr) + ' of ' + InttoCStr (TotProcFiles) +
                         ', Total Size ' + InttoKByte (TotProcBytes) + ', Done ' + IntToStr (SessDonePercent) + '%' ;
                if (SessEstimateTicks > 0) then S := S +
                    ', time left ' + TimerToStr (SecsToTime ((SessEstimateTicks - SessDoneTicks) div 1000)) +
                                                        ', average speed ' + IntToKByte (SessAvSpeed) + '/sec' ;
            end;
            InfoLabel.Caption := S ;
        end ;
//        if (LogLevel = LogLevelDiag) and (ShowDiagsLow.Checked or
//                                 ShowDiagsHigh.Checked) then AddLogText (Info) ;
        if (LogLevel = LogLevelDelimFile) then Log(Info) ;
        if (LogLevel = LogLevelDelimTot) then Log(Info) ;
        if AbortFlag then Cancel := true ;
    end;
end;

function TfrmMain.GetFTPNodes(folder: string): TFTPItem;
var
  i: Integer;
  TotDirFiles: integer;
  SrcFileRec: PTFileRec;
  ftpChild: TFTPItem;
begin
  result := nil;
  TotDirFiles := FDirFileList.Count;
  for i := 0 to Pred(TotDirFiles) do
  begin
    SrcFileRec := FDirFileList[I];
    with SrcFileRec^ do
    begin
      if folder = FrSubDirs then
      begin
        if result = nil then
        begin
          result := TFTPItem.Create(nil);
          result.Folder := folder;
        end;
        ftpChild := TFTPItem.Create(result);
        ftpChild.Folder := FrSubDirs;
        ftpChild.Name := FrFileName;
        ftpChild.Size := FrFileBytes;
        ftpChild.ModifiedDate := DateTimeToStr(FrFileDT);
        ftpChild.FullPathWithFileName := FrFullName;
        if ((FrFileAttr and faDirectory) = faDirectory) then
          ftpChild.Dir := true;
        result.Children.Add(ftpChild);
      end;
    end;
  end;
end;

procedure TFrmMain.Upload;
var
  i: Integer;
//  threadnr: integer;
  taskres: TTaskResult;
  zipFileName: string;
  baseDirectory: string;
begin
//  try
//    TDirectory.Delete(ExtractFilePath(Application.ExeName) + 'temp\', true);
//  except
//  end;
//  ForceDirectories(FTempDirectory);

//  if MessageDlg('Upload ' + inttostr(FMapFiles.Count) + ' map files?', mtCustom,[mbYes,mbCancel], 0) = mrCancel then
//    exit;

  Screen.Cursor := crHourGlass;

  frmMain.sProgressBar1.Position := 0;
  with Unzipper do begin
    ExtractOptions := [eoCreateDirs, eoRestorePath];
    BaseDirectory := FTempDirectory;
  end;

  for i := 0 to FMapFiles.Count-1 do
  begin
    Log('Unzipping '+FMapFiles[i].Filename);
    with Unzipper do begin
      FileName := FMapFiles[i].Filename;
      ExtractFiles( '*.*' );
    end;

    // Check if folder exists as the same name as the zip file name
    zipFileName := uppercase(ChangeFileExt(ExtractFileName(FMapFiles[i].Filename),''));
    if TDirectory.Exists(FTempDirectory+zipFileName) then
    begin
      baseDirectory := FTempDirectory+zipFileName+'\';

      Log('Moving files from '+baseDirectory+' to '+FTempDirectory);
      MoveFiles(baseDirectory,'*.*',FTempDirectory);

      Log('Moving directories from '+baseDirectory+' to '+FTempDirectory);
      MoveDirectories(baseDirectory,'*.*',FTempDirectory);

      Log('Deleting directory '+baseDirectory);
      DeleteDir(baseDirectory);

      frmMain.sProgressBar1.Position := 0;
    end;
  end;

  Log('Moving files from '+FTempDirectory+'*.bsp'+' to '+FTempDirectory+'maps');
  MoveFiles(FTempDirectory,'*.bsp',FTempDirectory+'maps', true);

  try
    MagFTPClient := TMagFtp.Create(self);
    try
      if SetFTPGen then exit;
      try
        Log('Uploading...');
        with MagFTPClient do
        begin
          BulkMode := BulkModeUpload ;
          SrcDir := FTempDirectory;
          TarDir := '/dod/';
          CopyType := FCTypeAllDir;
          DelDone := false;
          DelOldTar := false;
          SubDirs := true;
          EmptyDirs := true;
          IgnorePaths := '';
          SrcFName := '*.*';
          Mask := false;
          Prev := false;
          MaskLocDir := false;
          MaskRemDir := false;
          Repl := FCReplNever;
          Safe := true;
          IgnoreFileExt := 'tmp';
          TimeStamp := false;
          taskres := FtpUpload(false);
          Log('Task Result: ' + GetTaskResName (taskres));
          Log(ReqResponse);
        end;
      except
        Log('FTP Error - ' + GetExceptMess (ExceptObject));
      end ;
    finally
      FreeAndNil(MagFTPClient);
      Log('FTP Completed');
    end ;

    Log('Done!');
    UpdateUI;
  finally
    frmMain.sProgressBar1.Position := 0;
    Screen.Cursor := crArrow;
  end;

//      AbortFlag := false;
//      MagFTPClient := TMagFtp.Create(self);
//      try
//        if SetFTPGen then exit;
//        try
//          with MagFTPClient do
//          begin
//            TarDir := '/dod/';
//            BulkMode := BulkModeUpload ;
//            //DelFile := false;
//            taskres := FtpLogon ;
//            if taskres = TaskResOKNew then
//            begin
//              taskres := FtpUpOneFile(Ftp1UpFile.Text, '/dod/', Ftp1SrcName.Text, FCReplNever);
//            end ;
//            Log('Task Result: ' + GetTaskResName (taskres));
//            Log(ReqResponse);
//          end ;
//        except
//          Log('FTP Error - ' + GetExceptMess (ExceptObject));
//        end ;
//      finally
//        MagFTPClient.FtpLogoff ;
//        FreeAndNil (MagFTPClient) ;
//        Log('FTP Completed');
//      end;


//    AbortFlag := false ;
//    try
//      threadnr := SetFTPThreadGen ;
//      if threadnr < 0 then exit ;
//      with MagFtpThreads[threadnr]do
//      begin
//        BulkMode := BulkModeUpload ;
//        SrcDir := FTempDirectory;
//        TarDir := '/dod/';
//        CopyType := FCTypeAllDir;
//        DelDone := false;
//        DelOldTar := false;
//        SubDirs := true;
//        EmptyDirs := true;
////        IgnorePaths := FtpIgnorePath.Text;
//        SrcFName := '*.*';
//        Mask := false;     // true, allow date/time masked characters and directories in SrcFName
//        Prev := false;     // true, use yesterday's date for Mask
//        MaskLocDir := false; // 8 Apr 2009 - true use masked directories from SrcFName
//        MaskRemDir := false; // 8 Apr 2009 - true use masked directories from SrcFName
//        Repl := FCReplNever;
//        Safe := true;
//        IgnoreFileExt := 'tmp';
//        TimeStamp := false; // update local file time stamp to match remote
//        FtpThreadOpt := ftpthdUpFiles;
//    {$if RTLVersion >= 21}
//        Start;
//    {$else}
//        Resume;   // thread starts
//      {$ifend}
//        AddLogText('Created FTP: ' + ID);
//      end ;
//    except
//      AddLogText ('FTP Error - ' + GetExceptMess (ExceptObject));
//    end;
end;

procedure TFrmMain.MoveFiles(ASourcePath, AFileSpec, ATargetPath: string; currentFolderOnly: boolean = false);
var
  lSearchRec:TSearchRec;
  lPath:string;
  lTargetPath: string;
begin
  lPath := IncludeTrailingPathDelimiter(ASourcePath);
  lTargetPath := IncludeTrailingPathDelimiter(ATargetPath);

  if FindFirst(lPath+AFileSpec,faAnyFile,lSearchRec) = 0 then
  begin
    try
      repeat
        if currentFolderOnly then
        begin
          if (lSearchRec.Attr and faDirectory) <> 0 then
            // item is a directory
          else
            MoveFile(PChar(lPath+lSearchRec.Name), PChar(lTargetPath+lSearchRec.Name));
        end else
        begin
          MoveFile(PChar(lPath+lSearchRec.Name), PChar(lTargetPath+lSearchRec.Name));
        end;
      until FindNext(lSearchRec) <> 0;
    finally
      FindClose(lSearchRec);  // Free resources on successful find
    end;
  end;
end;

procedure TFrmMain.MoveDirectories(ASourcePath, AFileSpec, ATargetPath: string);
var
  lSearchRec:TSearchRec;
  lPath:string;
  lTargetPath: string;
begin
  lPath := IncludeTrailingPathDelimiter(ASourcePath);
  lTargetPath := IncludeTrailingPathDelimiter(ATargetPath);

  if FindFirst(lPath+AFileSpec,faDirectory,lSearchRec) = 0 then
  begin
    try
      repeat
        if (lSearchRec.Name <>'.') and (lSearchRec.Name<>'..') then
          if (lSearchRec.Attr and faDirectory) <> 0 then
            MoveDir(lPath+lSearchRec.Name, lTargetPath);
      until FindNext(lSearchRec) <> 0;
    finally
      FindClose(lSearchRec);  // Free resources on successful find
    end;
  end;
end;

function TFrmMain.MoveDir(const fromDir, toDir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_MOVE;
    fFlags := FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir)
  end;
  Result := (0 = ShFileOperation(fos));
end;

function TFrmMain.DeleteDir(const Dir: string): Boolean;
var
  fos: TSHFileOpStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    Wnd := Self.Handle;
    wFunc := FO_DELETE;
    pFrom := PChar(Dir+#0);
    pTo := nil;
    fFlags := FOF_NOCONFIRMATION or FOF_ALLOWUNDO;
  end;
  Result := (0 = ShFileOperation(fos));
end;

end.

