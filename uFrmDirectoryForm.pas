unit uFrmDirectoryForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TDirectoryForm = class(TForm)
    DirListBox: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DirectoryForm: TDirectoryForm;

implementation

{$R *.dfm}

end.
