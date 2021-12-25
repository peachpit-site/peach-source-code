unit TestResults;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  Internet, Vocab, Math, DateUtils, CommonStringFunctions, AppLanguage;

type

  { TFormResults }

  TFormResults = class(TForm)
    ButtonRMS: TButton;
    ClassBox: TComboBox;
    ResultsGrid: TStringGrid;
    procedure ButtonRMSClick(Sender: TObject);
    procedure ClassBoxSelect(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormResults: TFormResults;

implementation

var
  TeachersClasses: TStrings;

{$R *.lfm}

{ TFormResults }

procedure ResizeStringGrid(SG: TStringGrid);     // Delete if not used.
var
  i, c: integer;
begin
  c := 0;
  for i := 0 to SG.ColCount - 1 do
    c := c + SG.ColWidths[i];
  SG.Width := c;
  c := 0;
  for i := 0 to SG.RowCount - 1 do
    c := c + SG.RowHeights[i];
  SG.Height := c;
end;


procedure TFormResults.FormActivate(Sender: TObject);
var
  i: integer;
begin
  Caption := Translate('MCTS');
  ButtonRMS.Caption := Translate('ButRMS');
  ClassBox.Text := Translate('Aclass');
  TeachersClasses := Teacher_get_classes(Password, Username);
  for i := 0 to TeachersClasses.Count - 1 do
    ClassBox.Items[i] := GetItem(TeachersClasses.Strings[i], ' : ', 2);
  ResultsGrid.Clear;
end;

procedure TFormResults.ClassBoxSelect(Sender: TObject);
var
  i, j, x, y: integer;
  ClassAssignments, Results, ClassList: TStrings;
  ClassID: string;
  DateTimeStr, DateStr, TimeStr: string;
  tempdt: TDateTime;
begin
  if ClassBox.ItemIndex <> -1 then
  begin
    ResultsGrid.Clear;
    ClassID := Split(TeachersClasses.Strings[ClassBox.ItemIndex], ' : ', 1);
    // We get the assignments of the class ordered by datetime and label the columns.
    ClassAssignments := ListAssignmentsByClass(Password, Username, ClassID);
    ResultsGrid.ColCount := ClassAssignments.Count + 1;
    ResultsGrid.RowCount := 1;
    for i := 0 to ClassAssignments.Count - 1 do
    begin
      // For each time value we got from MySQL in format yyyy:mm:dd hh:ss we need
      // to convert it into Pascal's TDateTime format so we can convert to local
      // time. Then we reformat it for display using the formatting information
      // in the .lng file.
      DateTimeStr := GetItem(ClassAssignments.Strings[i], ' : ', 2);
      DateStr := Split(DateTimeStr, ' ', 1);
      TimeStr := Split(DateTimeStr, ' ', 2);
      tempdt := EncodeDateTime(StrToInt(GetItem(DateStr, '-', 1)),
        StrToInt(GetItem(DateStr, '-', 2)),
        StrToInt(GetItem(DateStr, '-', 3)),
        StrToInt(GetItem(TimeStr, ':', 1)),
        StrToInt(GetItem(TimeStr, ':', 2)),
        StrToInt(GetItem(TimeStr, ':', 3)),
        0  // MySQL doesn't supply us with milliseconds unless we ask it nicely.
        );
      tempdt := UniversalTimeToLocal(tempdt);
      DateStr := FormatDateTime(Translate('Date format 1'), tempdt);
      ResultsGrid.Cells[i + 1, 0] := DateStr;
    end;
    // We get the students in the class ordered alphabetically by lastname, firstname and label the rows.
    ClassList := Get_roster(Password, Username, ClassID);
    ResultsGrid.RowCount := 1 + ClassList.Count;
    for i := 0 to ClassList.Count - 1 do
    begin
      ResultsGrid.Cells[0, i + 1] := Split(ClassList.Strings[i], ' : ', 1);
    end;
    // We get the results and fill in the cells.
    Results := Get_results(Password, Username, ClassID);
    for i := 0 to Results.Count - 1 do
    begin
      if IsDecimal(GetItem(Results.Strings[i], ' : ', 3)) then
      begin
        for j := 0 to ClassAssignments.Count - 1 do
          if GetItem(ClassAssignments.Strings[j], ' : ', 1) =
            GetItem(Results.Strings[i], ' : ', 1) then
            x := j;
        for j := 0 to ClassList.Count - 1 do
          if GetItem(ClassList.Strings[j], ' : ', 2) =
            GetItem(Results.Strings[i], ' : ', 2) then
            y := j;
        ResultsGrid.Cells[x + 1, y + 1] := GetItem(Results.Strings[i], ' : ', 3) + '%';
      end;
    end;

    ResultsGrid.AutoSizeColumns;
  end;
end;

procedure TFormResults.ButtonRMSClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
