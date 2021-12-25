unit Assignments;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  ExtCtrls, Vocab, Internet, CommonStringFunctions, AppLanguage;

type

  { TFormAssignments }

  TFormAssignments = class(TForm)
    AGrid: TStringGrid;
    ButtonOK: TButton;
    ButtonRMS: TButton;
    LabelIntro: TLabel;
    Shape1: TShape;
    procedure AGridSelectCell(Sender: TObject; ACol, ARow: integer;
      var CanSelect: boolean);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonRMSClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormAssignments: TFormAssignments;
  AssignmentList: TStrings;

implementation

{$R *.lfm}

{ TFormAssignments }

// List of assignments


procedure TFormAssignments.AGridSelectCell(Sender: TObject;
  ACol, ARow: integer; var CanSelect: boolean);
var
  i: integer;
  // We make the checkboxes behave like radio buttons.
begin
  if ACol = 0 then
  begin
    for i := 1 to AGrid.RowCount - 1 do
      AGrid.Cells[ACol, i] := '0';
    AGrid.Cells[ACol, ARow] := '1';
  end;
end;

procedure TFormAssignments.ButtonOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormAssignments.ButtonRMSClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormAssignments.FormActivate(Sender: TObject);
var
  i: integer;
  DateTimeStr, DateStr, TimeStr: string;
  tempsc: string;
begin
  Caption := Translate('Assignments');
  for i := 0 to 4 do
    Agrid.Columns[i + 1].Title.Caption := TranslateList('ACLASS', i);
  ButtonOK.Caption := Translate('DOA');
  ButtonRMS.Caption := Translate('NODOA');
  LabelIntro.Caption := Translate('AIntro');
  while AGrid.RowCount > 1 do AGrid.DeleteRow(1);
  for i := 0 to AssignmentList.Count - 1 do
  begin
    DateTimeStr := GetItem(AssignmentList.Strings[i], ' : ', 3);
    ConvertDateTime(DateTimeStr, DateStr, TimeStr);
    tempsc := GetItem(AssignmentList.Strings[i], ' : ', 4);
    if IsDecimal(tempsc) then tempsc := tempsc + '%'
    else
      tempsc := '';
    AGrid.InsertRowWithValues(i + 1,
      ['0', GetItem(AssignmentList.Strings[i], ' : ', 2),
      GetItem(AssignmentList.Strings[i], ' : ', 5), DateStr,
      TimeStr, tempsc]);
  end;
  if AGrid.RowCount > 1 then AGrid.Cells[0, 1] := '1';
end;


end.
