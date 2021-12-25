unit StudentClasses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, Vocab, Internet, CommonStringFunctions, AppLanguage;

type

  { TFormSClasses }

  TFormSClasses = class(TForm)
    ButtonLC: TButton;
    ButtonAJC: TButton;
    ButtonRMS: TButton;
    EditTN: TEdit;
    EditCN: TEdit;
    LabelIntro1: TLabel;
    ClassGrid: TStringGrid;
    LabelIntro2: TLabel;
    LabelTN: TLabel;
    LabelCN: TLabel;
    LabelIntro3: TLabel;
    Shape1: TShape;
    procedure ButtonAJCClick(Sender: TObject);
    procedure ButtonLCClick(Sender: TObject);
    procedure ButtonRMSClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormSClasses: TFormSClasses;

implementation

{$R *.lfm}

{ TFormSClasses }

var
  cls: TStrings;

procedure DoGetClasses;
var
  i: integer;
begin
  cls.Free;
  while FormSClasses.ClassGrid.RowCount > 1 do FormSClasses.ClassGrid.DeleteRow(1);
  cls := Get_classes(Password, Username);
  for i := 0 to cls.Count - 1 do
    FormSClasses.ClassGrid.InsertRowWithValues(i + 1,
      [GetItem(cls.Strings[i], ' : ', 3), GetItem(cls.Strings[i], ' : ', 2)]);
  if cls.Count = 0 then FormSClasses.LabelIntro1.Caption := Translate('CIntro1a')
  else
    FormSClasses.LabelIntro1.Caption := Translate('CIntro1b');
end;

procedure TFormSClasses.FormActivate(Sender: TObject);
begin
  DoGetClasses;
  LabelIntro2.Caption := Translate('CIntro2');
  LabelIntro3.Caption := Translate('CIntro3');
  Caption := Translate('Classes');
  LabelTN.Caption := Translate('LabTN');
  LabelCN.Caption := Translate('LabCN');
  ButtonLC.Caption := Translate('ButLC');
  ButtonAJC.Caption := Translate('ButAJC');
  ButtonRMS.Caption := Translate('ButRMS');
  EditTN.Text := '';
  EditCN.Text := '';
  Height := ButtonRMS.Top + ButtonRMS.Height + 12;
end;

procedure TFormSClasses.ButtonRMSClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormSClasses.ButtonAJCClick(Sender: TObject);
var
  id, policy: string;
begin
  id := Get_class_id(Password, Username, EditTN.Text, EditCN.Text);
  policy := Get_admissions_policy(Password, Username, id);
  if policy = 'C' then ShowMessage(Translate('ApC'));
  if policy = 'A' then SendNotification(Password, Username, EditTN.Text,
      '', EditCN.Text, 'r');
  if policy = 'O' then
  begin
    AddStudentToClass(Password, Username, EditTN.Text, Username, id);
    ShowMessage(Translate('ApO'));
    DoGetClasses;
  end;
  EditTN.Text := '';
  EditCN.Text := '';
end;

procedure TFormSClasses.ButtonLCClick(Sender: TObject);
begin
  DeleteStudentFromClass(Password, Username,
    GetItem(cls.Strings[ClassGrid.Row - 1], ' : ', 1));
  SendNotification(Password, Username, GetItem(cls.Strings[ClassGrid.Row - 1], ' : ', 4),
    GetItem(cls.Strings[ClassGrid.Row - 1], ' : ', 1),
    GetItem(cls.Strings[ClassGrid.Row - 1], ' : ', 2), 'x');
  DoGetClasses;
end;

end.
