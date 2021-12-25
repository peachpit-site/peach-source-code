unit TeacherClasses;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Internet, Vocab, CommonStringFunctions, AppLanguage;

type

  { TFormStudents }

  TFormStudents = class(TForm)
    ButtonDeleteAssignment: TButton;
    ButtonAC: TButton;
    ButtonDC: TButton;
    ButtonDS: TButton;
    ButtonRMS: TButton;
    LabelAssignments: TLabel;
    LabelIntro: TLabel;
    LabelC: TLabel;
    LabelS: TLabel;
    ClassBox: TListBox;
    ApplicationGroup: TRadioGroup;
    AssignmentBox: TListBox;
    StudentBox: TListBox;
    Divider: TShape;
    procedure ApplicationGroupClick(Sender: TObject);
    procedure ButtonACClick(Sender: TObject);
    procedure ButtonDCClick(Sender: TObject);
    procedure ButtonDeleteAssignmentClick(Sender: TObject);
    procedure ButtonDSClick(Sender: TObject);
    procedure ButtonRMSClick(Sender: TObject);
    procedure ClassBoxSelectionChange(Sender: TObject; User: boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private

  public

  end;

var
  FormStudents: TFormStudents;

implementation

{$R *.lfm}

{ TFormStudents }

var
  TeachersClasses, TeachersStudents, ClassAssignments: TStrings;

procedure DoGetClasses;
var
  i: integer;
begin
  TeachersClasses.Free;
  TeachersClasses := Teacher_get_classes(Password, Username);
  FormStudents.ClassBox.Items.Clear;
  for i := 0 to TeachersClasses.Count - 1 do
    FormStudents.ClassBox.Items.Add(GetItem(TeachersClasses.Strings[i], ' : ', 2));
  if TeachersClasses.Count = 0 then FormStudents.LabelIntro.Caption :=
      Translate('SIntro1a')
  else
    FormStudents.LabelIntro.Caption := Translate('SIntro1b');
end;

procedure TFormStudents.FormActivate(Sender: TObject);
var
  i: integer;
begin
  Caption := Translate('Students');
  LabelC.Caption := Translate('Classes');
  LabelS.Caption := Translate('Students');
  ButtonAC.Caption := Translate('ButAC');
  ButtonDC.Caption := Translate('ButDC');
  ButtonDS.Caption := Translate('ButDS');
  ButtonRMS.Caption := Translate('ButRMS');
  ApplicationGroup.Caption := Translate('AppCap');
  LabelAssignments.Caption := Translate('Assignments');
  ButtonDeleteAssignment.Caption := Translate('DELASS');
  for i := 0 to 2 do ApplicationGroup.Items[i] := TranslateList('Ad1', i);
  ApplicationGroup.ItemIndex := -1;
  Height := ButtonRMS.Top + ButtonRMS.Height + 12;
  DoGetClasses;
end;

procedure TFormStudents.FormResize(Sender: TObject);
begin
  ButtonDS.Top :=
    LabelS.Top + ((FormStudents.Height - LabelS.Top -
    ButtonRMS.Height - 12) div 2) - ButtonDS.Height - 12;
end;

procedure TFormStudents.ButtonACClick(Sender: TObject);
var
  CN: string;
begin
  CN := InputBox(Translate('ButAC'), Translate('LabCN'), '');
  if CN = '' then
    ShowMessage(Translate('NOBC'))
  else
  begin
    AddClass(Password, Username, FirstName, LastName, CN);
    DoGetClasses;
    StudentBox.Clear;
  end;
end;

procedure TFormStudents.ApplicationGroupClick(Sender: TObject);
var
  policy: string;
begin
  case ApplicationGroup.ItemIndex of
    0: policy := 'O';
    1: policy := 'A';
    2: policy := 'C';
  end;
  if ApplicationGroup.ItemIndex = -1 then ApplicationGroup.Enabled := False
  else
  begin
    UpdateAdmissionsPolicy(Password, Username,
      GetItem(TeachersClasses.Strings[ClassBox.ItemIndex], ' : ', 1), policy);
    TeachersClasses.Strings[ClassBox.ItemIndex] :=
      Copy(TeachersClasses.Strings[ClassBox.ItemIndex], 1,
      Length(TeachersClasses.Strings[ClassBox.ItemIndex]) - 1) + policy;
  end;
end;

procedure TFormStudents.ButtonDCClick(Sender: TObject);
begin
  if ClassBox.ItemIndex <> -1 then
  begin
    if DeleteClass(Password, Username,
      GetItem(TeachersClasses.Strings[ClassBox.ItemIndex], ' : ', 1)) then
    begin
      TeachersClasses.Delete(ClassBox.ItemIndex);
      ClassBox.Items.Delete(ClassBox.ItemIndex);
      StudentBox.Clear;
      ApplicationGroup.ItemIndex := -1;
      ApplicationGroup.Enabled := False;
    end;
  end;
end;

procedure TFormStudents.ButtonDeleteAssignmentClick(Sender: TObject);
var
  ix: integer;
begin
  ix := AssignmentBox.ItemIndex;
  if ix = -1 then Exit;

  if not DeleteAssignment(Password, Username,
    GetItem(ClassAssignments.Strings[ix], ' : ', 1)) then Exit;

  AssignmentBox.ItemIndex := -1;
  ClassAssignments.Delete(ix);
  AssignmentBox.Items.Delete(ix);

end;

procedure TFormStudents.ButtonDSClick(Sender: TObject);
begin
  if StudentBox.ItemIndex <> -1 then
  begin
    if Teacher_delete_student_from_class(Password, Username,
      GetItem(TeachersStudents.Strings[StudentBox.ItemIndex], ' : ', 2),
      GetItem(TeachersClasses.Strings[ClassBox.ItemIndex], ' : ', 1)) then
    begin
      TeachersStudents.Delete(StudentBox.ItemIndex);
      StudentBox.Items.Delete(StudentBox.ItemIndex);
    end;
  end;
end;



procedure TFormStudents.ButtonRMSClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TFormStudents.ClassBoxSelectionChange(Sender: TObject; User: boolean);
var
  policy: string;
  i: integer;
  ClassID: string;
  DateStr, TimeStr: string;
begin
  StudentBox.Clear;
  AssignmentBox.Clear;

  if ClassBox.ItemIndex = -1 then
  begin
    ApplicationGroup.ItemIndex := -1;
    ApplicationGroup.Enabled := False;
  end
  else
  begin
    ApplicationGroup.Enabled := True;

    ClassID := GetItem(TeachersClasses.Strings[ClassBox.ItemIndex], ' : ', 1);

    TeachersStudents.Free;
    TeachersStudents := Get_roster(Password, Username, ClassID);
    for i := 0 to TeachersStudents.Count - 1 do
      StudentBox.Items.Add(GetItem(TeachersStudents[i], ' : ', 1) +
        ' (' + GetItem(TeachersStudents[i], ' : ', 2) + ')');

    ClassAssignments.Free;
    ClassAssignments := Get_assignments_by_class(Password, Username, ClassID);
    for i := 0 to ClassAssignments.Count - 1 do
    begin
      ConvertDateTime(GetItem(ClassAssignments[i], ' : ', 2), DateStr, TimeStr);
      AssignmentBox.Items.Add(DateStr + ', ' + TimeStr + ' : ' +
        GetItem(ClassAssignments[i], ' : ', 3));
    end;

    policy := GetItem(TeachersClasses.Strings[ClassBox.ItemIndex], ' : ', 3);
    if policy = 'O' then ApplicationGroup.ItemIndex := 0;
    if policy = 'A' then ApplicationGroup.ItemIndex := 1;
    if policy = 'C' then ApplicationGroup.ItemIndex := 2;
  end;
end;

end.
