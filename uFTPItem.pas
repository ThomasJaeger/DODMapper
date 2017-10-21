unit uFTPItem;

interface

uses
  Classes, System.Generics.Collections;

type
  TFTPItem = class
    private
      FFolder: string;
      FName: string;
      FFullPathWithFileName: string;
      FSize: integer;
      FDir: boolean;
      FModifiedDate: string;
      FParent: TFTPItem;
      FChildren: TList<TFTPItem>;
    public
      constructor Create(parent: TFTPItem);
      property Parent: TFTPItem read FParent write FParent;
      property Children: TList<TFTPItem> read FChildren write FChildren;
      property Folder: string read FFolder write FFolder;
      property Name: string read FName write FName;
      property Size: integer read FSize write FSize;
      property Dir: boolean read FDir write FDir;
      property ModifiedDate: string read FModifiedDate write FModifiedDate;
      property FullPathWithFileName: string read FFullPathWithFileName write FFullPathWithFileName;
  end;

implementation

constructor TFTPItem.Create(parent: TFTPItem);
begin
  inherited Create;
  FChildren := TList<TFTPItem>.Create;
  FParent := parent;
end;

end.
