unit uFrmAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, acPNG, Vcl.ExtCtrls, acImage, Vcl.StdCtrls, sButton, sLabel;

type
  TfrmAbout = class(TForm)
    sImage1: TsImage;
    btnClose: TsButton;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

end.
