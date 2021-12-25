unit UpdateOptions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  AppLanguage;

type

  { TFormUpdate }

  TFormUpdate = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TMemo;
    VersionGroup: TRadioGroup;
    UpdateGroup: TRadioGroup;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FormUpdate: TFormUpdate;

implementation

{$R *.lfm}

{ TFormUpdate }

procedure TFormUpdate.Button2Click(Sender: TObject);
begin
  Close;
  ModalResult := mrAbort;
end;

procedure TFormUpdate.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Caption := Translate('Upd');
  Label1.Caption := Translate('UpA');
  Label2.Caption := Translate('Det');
  Button1.Caption := Translate('TO3Y');
  Button2.Caption := Translate('TO3N');
  UpdateGroup.Caption := Translate('PerP');
  for i := 0 to 2 do
    UpdateGroup.Items.Add(TranslateList('Pref0', i));
  UpdateGroup.ItemIndex := 2;
  Top := (Screen.Height - Height) div 2;
  Left := (Screen.Width - Width) div 2;
end;

procedure TFormUpdate.Button1Click(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

end.
