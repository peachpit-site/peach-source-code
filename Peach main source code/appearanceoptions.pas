unit AppearanceOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Math;

type

  { TFormAO }

  TFormAO = class(TForm)
    ApplicationLanguageBox: TComboBox;
    ApplicationLanguageLabel: TLabel;
    Button1: TButton;
    Button2: TButton;
    FontBox: TComboBox;
    FontLabel: TLabel;
    TitleFontBox: TComboBox;
    FontSizeBox3: TComboBox;
    TitleFontLabel: TLabel;
    FontSizeLabel3: TLabel;
    Shape1: TShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormAO: TFormAO;

implementation

{$R *.lfm}

{ TFormAO }

const
  Offset = 12;

procedure TFormAO.FormActivate(Sender: TObject);
var
  i, MaxW, bigw: integer;
begin
  Canvas.Font := Font;
  MaxW := 0;
  for i := 0 to Screen.Fonts.Count - 1 do
    MaxW := Max(MaxW, Canvas.TextWidth(Screen.Fonts[i]));
  FontBox.Width := MaxW + 30;
  bigw := Offset + FontBox.Width + Offset + FontLabel.Width;
  MaxW := 0;
  for i := 0 to TitleFontBox.Items.Count - 1 do
    MaxW := Max(MaxW, Canvas.TextWidth(TitleFontBox.Items[i]));
  TitleFontBox.Width := MaxW + 30;
  FontSizeBox3.Width := MaxW + 30;
  bigw := Max(bigw, Offset + TitleFontLabel.Width + Offset + TitleFontBox.Width);
  bigw := Max(bigw, Offset + FontSizeLabel3.Width + Offset + FontSizeBox3.Width);
  MaxW := 0;
  for i := 0 to ApplicationLanguageBox.Items.Count - 1 do
    MaxW := Max(MaxW, Canvas.TextWidth(ApplicationLanguageBox.Items[i]));
  ApplicationLanguageBox.Width := MaxW + 30;
  bigw := Max(bigw, Offset + ApplicationLanguageLabel.Width + Offset +
    ApplicationLanguageBox.Width);
  Width := bigw + Offset;
  FontBox.Left := bigw - FontBox.Width;
end;

procedure TFormAO.Button1Click(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TFormAO.Button2Click(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

end.
