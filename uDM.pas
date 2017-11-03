unit uDM;

interface

uses
  System.SysUtils, System.Classes, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ImgList, Vcl.Controls, inifiles, Vcl.Forms, OverbyteIcsWndControl, OverbyteIcsFtpCli;

type
  PFTPData = ^TFTPData;
  TFTPData = record
    Name: string;
    Size: integer;
    Level: integer;
    Dir: boolean;
    ModifiedDate: string;
    FullPath: string;
  end;

  PMapFile = ^TMapFile;
  TMapFile = record
    FileName: string;
    Size: integer;
    DateTime: string;
  end;

  Tdm = class(TDataModule)
    ActionManager1: TActionManager;
    actExit: TAction;
    actSettings: TAction;
    TreeImages: TImageList;
    actAbout: TAction;
    procedure actExitExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
//    procedure ftpWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
//    procedure ftpWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
//    procedure ftpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
  private
    FIniFile : TIniFile;
    FHost: string;
    FUsername: string;
    FPassword: string;
    FPort: integer;
    FCurrentFileSize: integer;
    FPassive: boolean;
  public
    property Host: string read FHost write FHost;
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property Port: integer read FPort write FPort;
    property Passive: boolean read FPassive write FPassive;
    procedure WriteIniFile;
    function FormatByteSize(const bytes: Longint): string;
    property CurrentFileSize: integer read FCurrentFileSize write FCurrentFileSize;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  uFrmSettings, uFrmMain, uFrmAbout;

procedure Tdm.actAboutExecute(Sender: TObject);
begin
  frmAbout.ShowModal;
end;

procedure Tdm.actExitExecute(Sender: TObject);
begin
  frmMain.Close;
end;

procedure Tdm.actSettingsExecute(Sender: TObject);
begin
  frmSettings.ShowModal;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
var
  section: string;
begin
  FIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  section := 'FTPServer';

  try
    FHost := FIniFile.ReadString(section,'Host','');
    FUsername := FIniFile.ReadString(section,'Username','');
    FPassword := FIniFile.ReadString(section,'Password','');
    FPort := FIniFile.ReadInteger(section,'Port',21);
    FPassive := FIniFile.ReadBool(section,'Passive',false);
  finally
    FIniFile.Free;
  end;
end;

procedure Tdm.WriteIniFile;
var
  section: string;
begin
  FIniFile := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
  section := 'FTPServer';

  try
    FIniFile.WriteString(section,'Host',FHost);
    FIniFile.WriteString(section,'Username',FUsername);
    FIniFile.WriteString(section,'Password',FPassword);
    FIniFile.WriteInteger(section,'Port',FPort);
    FIniFile.WriteBool(section,'Passive',FPassive);
  finally
    FIniFile.Free;
  end;
end;

function Tdm.FormatByteSize(const bytes: Longint): string;
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

//procedure Tdm.ftpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
//begin
//  if frmMain.sProgressBar1.Max > 0 then
//  begin
//    frmMain.sProgressBar1.Position := AWorkCount;
//    frmMain.lblUploadProgress.Caption := IntToStr((frmMain.sProgressBar1.Position * 100) div frmMain.sProgressBar1.Max) + '%';
//  end else
//    frmMain.lblUploadProgress.Caption := IntToStr(AWorkCount) + ' bytes';
//  frmMain.Update;
//end;
//
//procedure Tdm.ftpWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
//begin
//  if AWorkMode = wmWrite then
//    frmMain.sProgressBar1.Max := AWorkCountMax
//  else;
//    frmMain.sProgressBar1.Max := FCurrentFileSize;
//  frmMain.sProgressBar1.Position := 0;
//end;
//
//procedure Tdm.ftpWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
//begin
//  frmMain.sProgressBar1.Position := 0;
//end;

end.
