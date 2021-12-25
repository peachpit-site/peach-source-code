unit AssignHomework;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, Vocab, Internet, QAUnit, DateUtils, CommonStringFunctions, AppLanguage;

type

  { TFormAssignHomework }

  TFormAssignHomework = class(TForm)
    ButtonAssign: TButton;
    ButtonCancel: TButton;
    CalendarDialog1: TCalendarDialog;
    CheckBox1: TCheckBox;
    ClassBox: TComboBox;
    EditAssignmentName: TEdit;
    EditLimit: TEdit;
    LabelAssignmentName: TLabel;
    LabelLimit: TLabel;
    LabelDue: TLabel;
    Panel1: TPanel;
    OCGroup: TRadioGroup;
    Shape1: TShape;
    Shape2: TShape;
    TimeBox: TComboBox;
    EditDate: TEdit;
    LabelTime: TLabel;
    LabelDate: TLabel;
    LabelClass: TLabel;
    LHeader: TLabel;
    procedure ButtonAssignClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure EditDateChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FormAssignHomework: TFormAssignHomework;

implementation

{$R *.lfm}

{ TFormAssignHomework }

var
  TeachersClasses: TStrings;
  Date: TDate;

procedure TFormAssignHomework.ButtonAssignClick(Sender: TObject);
var
  f: TextFile;
  dt: TDateTime;
begin

  if not ValidateSelection then Exit;

  if ClassBox.ItemIndex = -1 then
  begin
    ShowMessage(Translate('NOCLASS'));
    Exit;
  end;

  if EditDate.Text = Translate('Adate') then
  begin
    ShowMessage(Translate('NODATE'));
    Exit;
  end;

  if TimeBox.ItemIndex = -1 then
  begin
    ShowMessage(Translate('NOTIME'));
    Exit;
  end;

  // We turn the data and time selections into a TDateTime so we can convert it
  // to universal time. Further down we turn it into a format readable by MySQL.
  dt := EncodeDateTime(YearOf(Date), MonthOf(Date), DayOf(Date),
    TimeBox.ItemIndex, 0, 0, 0);
  dt := LocalTimeToUniversal(dt);


  AssignFile(f, HomeDirectory + '\Resources\File transfer\Assignment.asm');
  Rewrite(f);
  WriteLn(f, OCGroup.ItemIndex);
  if CheckBox1.Checked then WriteLn(f, 'Y')
  else
    WriteLn(f, 'N');
  if IsDecimal(EditLimit.Text) then WriteLn(f, EditLimit.Text)
  else
    WriteLn(f, '-1');
  PutRsc(f);
  WriteLn(f, '◆');
  DoSave(f);
  CloseFile(f);
  if UploadAssignment(Password, Username,
    Split(TeachersClasses.Strings[ClassBox.ItemIndex], ' : ', 1),
    FormatDateTime('yyyymmddhhmmss', dt), CheckBox1.Checked, HomeDirectory +
    '\Resources\File transfer\Assignment.asm', EditAssignmentName.Text) then
    ShowMessage(Translate('TWHBA'));
end;

procedure TFormAssignHomework.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormAssignHomework.EditDateChange(Sender: TObject);
begin
  if CalendarDialog1.Execute then
  begin
    Date := CalendarDialog1.Date;
    EditDate.Caption := FormatDateTime(Translate('Date format 1'),
      CalendarDialog1.Date);
    TimeBox.SetFocus;
  end;
end;

procedure TFormAssignHomework.FormActivate(Sender: TObject);
var
  i: integer;
begin
  Caption := Translate('AHead');
  LHeader.Caption := ' ' + Translate('LHead');
  for i := 0 to 2 do OCGroup.Items[i] := TranslateList('CO1', i);
  CheckBox1.Caption := Translate('ChAR');
  LabelLimit.Caption := Translate('NofQ');
  LabelDue.Caption := Translate('ADUE');
  LabelClass.Caption := Translate('ACLASS');
  LabelDate.Caption := Translate('ADATE');
  LabelTime.Caption := Translate('ATIME');
  ClassBox.Text := Translate('Aclass');
  EditDate.Text := Translate('Adate');
  TimeBox.Text := Translate('Atime');
  OCGroup.Caption := Translate('LabOC');
  CheckBox1.Caption := Translate('ChAR');
  ButtonAssign.Caption := Translate('ButA');
  ButtonCancel.Caption := Translate('ButRMS');
  LabelAssignmentName.Caption := Translate('ANAME');
  if QOGroup_i < 3 then
  begin
    EditLimit.Text := Translate('TxNA');
    EditLimit.Enabled := False;
  end
  else
  begin
    EditLimit.Text := '100';
    EditLimit.Enabled := True;
  end;

  TeachersClasses := Teacher_get_classes(Password, Username);
  for i := 0 to TeachersClasses.Count - 1 do
    ClassBox.Items[i] := GetItem(TeachersClasses.Strings[i], ' : ', 2);
end;

procedure TFormAssignHomework.FormCreate(Sender: TObject);
begin
  CalendarDialog1.Date := Now;
end;

end.
