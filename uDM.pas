unit uDM;

interface

uses
  System.SysUtils, System.Classes, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ImgList, Vcl.Controls;

type
  Tdm = class(TDataModule)
    ftp: TIdFTP;
    ActionManager1: TActionManager;
    actExit: TAction;
    actSettings: TAction;
    TreeImages: TImageList;
    procedure actExitExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  PFTPData = ^TFTPData;
  TFTPData = record
    Name: string;
    Size: integer;
    Level: integer;
    Dir: boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  uFrmSettings, uFrmMain;

procedure Tdm.actExitExecute(Sender: TObject);
begin
  frmMain.Close;
end;

procedure Tdm.actSettingsExecute(Sender: TObject);
begin
  frmSettings.ShowModal;
end;

end.
