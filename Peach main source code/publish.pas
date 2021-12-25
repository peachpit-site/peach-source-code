unit Publish;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs;

type

  { TFormPublish }

  TFormPublish = class(TForm)
    Button1: TButton;
    ButtonChangeIcon: TButton;
    LockdownGroup: TCheckGroup;
    ComboBox1: TComboBox;
    EditPN: TEdit;
    EditP: TEdit;
    EditVN: TEdit;
    Image1: TImage;
    LabelF: TLabel;
    LabelPN: TLabel;
    LabelP: TLabel;
    LabelVN: TLabel;
    ListBox1: TListBox;
    OpenPictureDialog1: TOpenPictureDialog;
    procedure Button1Click(Sender: TObject);
    procedure ButtonChangeIconClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private

  public

  end;

var
  FormPublish: TFormPublish;


implementation

{$R *.lfm}

{ TFormPublish }

procedure TFormPublish.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex <> -1 then
  begin
    ListBox1.Items.Add(ComboBox1.Items[ComboBox1.ItemIndex]);
    ComboBox1.Caption := '';
  end;
end;

procedure TFormPublish.ListBox1KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key in [8, 46] then ListBox1.DeleteSelected;
end;

procedure TFormPublish.Button1Click(Sender: TObject);
var
  f: TextFile;
  GUID: TGUID;
  i: integer;
begin
  Close;
  ModalResult := mrOk;
end;

procedure TFormPublish.ButtonChangeIconClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
    Image1.Picture.LoadFromFile(OpenPictureDialog1.Filename);
end;

end.
