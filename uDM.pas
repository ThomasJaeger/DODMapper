unit uDM;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ImgList, Vcl.Controls, inifiles, Vcl.Forms;

type
  PFTPData = ^TFTPData;
  TFTPData = record
    Name: string;
    Size: integer;
    Level: integer;
    Dir: boolean;
    ModifiedDate: string;
  end;

  PMapFile = ^TMapFile;
  TMapFile = record
    FileName: string;
    Size: integer;
    DateTime: string;
  end;

  Tdm = class(TDataModule)
    ftp: TIdFTP;
    ActionManager1: TActionManager;
    actExit: TAction;
    actSettings: TAction;
    TreeImages: TImageList;
    actAbout: TAction;
    procedure actExitExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    FIniFile : TIniFile;
    FHost: string;
    FUsername: string;
    FPassword: string;
    FPort: integer;
  public
    property Host: string read FHost write FHost;
    property Username: string read FUsername write FUsername;
    property Password: string read FPassword write FPassword;
    property Port: integer read FPort write FPort;
    procedure WriteIniFile;
    function FormatByteSize(const bytes: Longint): string;
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

end.
