unit uFrmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sEdit, sLabel, sGroupBox, sButton, sSpinEdit,
  uDM, Vcl.ExtCtrls, sPanel, VirtualTrees, IdAllFTPListParsers, System.Generics.Collections;

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
    btnTestConnection: TsButton;
    sPanel1: TsPanel;
    btnCancel: TsButton;
    btnApply: TsButton;
    txtFolder: TsEdit;
    sLabel5: TsLabel;
    lstFiles: TVirtualStringTree;
    procedure btnTestConnectionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure lstFilesGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure lstFilesNodeDblClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtFolderKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FFiles: TStringList;
    FFTPItems: TList<TFTPData>;
    FFolder: string;
    procedure Synchronize;
    function FormatByteSize(const bytes: Longint): string;
    procedure TestConnection;
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

uses
  IdFTPList;

procedure TfrmSettings.btnTestConnectionClick(Sender: TObject);
begin
  TestConnection;
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if dm.ftp.Connected then
    dm.ftp.Disconnect(false);
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  FFiles := TStringList.Create;
  FFTPItems := TList<TFTPData>.Create;
  lstFiles.NodeDataSize := SizeOf(TFTPData);
end;

procedure TfrmSettings.lstFilesGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
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

procedure TfrmSettings.lstFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  Data: PFTPData;
begin
  Data := Sender.GetNodeData(Node);
  case Column of
    0: CellText := Data.Name;
    1:
      begin
        if Data.Size > 0 then
          CellText := FormatByteSize(Data.Size)
        else
          CellText := '';
      end;
    2: CellText := Data.ModifiedDate;
  end;
end;

procedure TfrmSettings.lstFilesNodeDblClick(Sender: TBaseVirtualTree; const HitInfo: THitInfo);
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
          TestConnection;
        end;
      end;
  end;
end;

procedure TfrmSettings.Synchronize;
var
  node: PVirtualNode;
  data: PFTPData;
  i: integer;
begin
  lstFiles.BeginUpdate;
  lstFiles.Clear;

  for i := 0 to FFTPItems.Count-1 do
  begin
    node := lstFiles.AddChild(nil);
    data := lstFiles.GetNodeData(node);
    data^.Name := FFTPItems[i].Name;
    data^.Size := FFTPItems[i].Size;
    data^.Dir := FFTPItems[i].Dir;
    data^.Level := 0;
    data^.ModifiedDate := FFTPItems[i].ModifiedDate;
  end;

  lstFiles.Refresh;
  lstFiles.EndUpdate;
end;

function TfrmSettings.FormatByteSize(const bytes: Longint): string;
const
  B = 1; //byte
  KB = 1024 * B; //kilobyte
  MB = 1024 * KB; //megabyte
  GB = 1024 * MB; //gigabyte
begin
//  if bytes > GB then
//    result := FormatFloat('#.## GB', bytes / GB)
//  else
//    if bytes > MB then
//      result := FormatFloat('#.## MB', bytes / MB)
//    else
//      if bytes > KB then
//        result := FormatFloat('# KB', bytes / KB)
//      else
//        //result := FormatFloat('#.## bytes', bytes);
        result := FormatFloat('#,##0', bytes);
end;

procedure TfrmSettings.TestConnection;
Var
  i: Integer;
  item: TIdFTPListItem;
  ftpData: TFTPData;
begin
  if (txtHost.Text='') or (txtUsername.Text='') or (txtPassword.Text='') then
  begin
    ShowMessage('Enter valid FTP server information, first.');
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
      ftp.Host := txtHost.Text;
      ftp.Username := txtUsername.Text;
      ftp.Password := txtPassword.Text;
      ftp.Port := txtPort.Value;
      if not ftp.Connected then
        ftp.Connect;
      if ftp.Connected then
      begin
        FTP.ChangeDir(FFolder);
        FTP.List(FFiles,'',true);
        FFolder := dm.FTP.RetrieveCurrentDir;
        FFTPItems.Clear;
        for i := 0 to FTP.DirectoryListing.Count-1 do
        begin
          item := FTP.DirectoryListing.Items[i];
          ftpData.Name := item.FileName;
          ftpData.Size := item.Size;
          if item.ItemType = ditDirectory then
            ftpData.Dir := true
          else
            ftpData.Dir := false;
          //ftpData.ModifiedDate := item.ModifiedDate;
          //ftpData.ModifiedDate := strtodatetime(trim(copy(FFiles[i],1,24)));
          ftpData.ModifiedDate := trim(copy(FFiles[i],1,24));
          FFTPItems.Add(ftpData);
        end;
        txtFolder.Text := FFolder;
      end;
      Synchronize;
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

procedure TfrmSettings.txtFolderKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  FFolder := '';
end;

end.
