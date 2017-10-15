unit uFrmSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, sEdit, sLabel, sGroupBox, sButton, sSpinEdit,
  uDM, Vcl.ExtCtrls, sPanel, VirtualTrees;

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
    sGroupBox2: TsGroupBox;
    sPanel1: TsPanel;
    btnCancel: TsButton;
    btnApply: TsButton;
    lstFiles: TVirtualStringTree;
    procedure btnTestConnectionClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lstFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure lstFilesGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
      Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: TImageIndex);
  private
    FFiles: TStringList;
    procedure Synchronize;
    function FormatByteSize(const bytes: Longint): string;
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
Var
  I: Integer;
begin
  if (txtHost.Text='') or (txtUsername.Text='') or (txtPassword.Text='') then
  begin
    ShowMessage('Enter valid FTP server information, first');
    exit;
  end;

  Screen.Cursor := crHourGlass;
  with dm do
  begin
    try
      ftp.Host := txtHost.Text;
      ftp.Username := txtUsername.Text;
      ftp.Password := txtPassword.Text;
      ftp.Port := txtPort.Value;
      ftp.Connect;
      if ftp.Connected then
      begin
        FTP.ChangeDir('/');
        FTP.List(FFiles,'',false);
      end;
      Synchronize;
    finally
      ftp.Disconnect;
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

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  FFiles := TStringList.Create; 
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
  end;
end;

procedure TfrmSettings.Synchronize;
var
  node: PVirtualNode;
  data: PFTPData;
  i,s: integer;
  foundProject: boolean;
begin
  lstFiles.BeginUpdate;
  lstFiles.Clear;

  for i := 0 to FFiles.Count-1 do
  begin
    node := lstFiles.AddChild(nil);
    lstFiles.Expanded[node] := true;
    data := lstFiles.GetNodeData(node);
    data^.Name := FFiles[i];

    s := dm.FTP.Size(data^.Name);
    if s = -1 then
    begin
      // Directory
      // tvFolders.Items.Add(nil, s);
      data^.Size := 0;
      data^.Dir := true;
    end else
    begin
      // File
      data^.Size := s;
      data^.Dir := false;
    end;
    data^.Level := 0;
  end;

  lstFiles.Refresh;
  lstFiles.FullExpand;
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

end.
