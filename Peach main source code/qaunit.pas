unit QAUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Vocab, Process, Internet, InterposerEdit, CommonStringFunctions,
  AppLanguage, PythonFunctions;

type

  { TFormQA }

  TFormQA = class(TForm)
    AEdit: TEdit;
    BalanceBox: TGroupBox;
    ButtonRMS2: TButton;
    ButtonRedo: TButton;
    ButtonRMS: TButton;
    CheckCFBT: TCheckGroup;
    LabelC: TLabel;
    LabelTime: TLabel;
    LabelScore: TLabel;
    LBLabel: TLabel;
    OptionsButton: TButton;
    QOGroup: TRadioGroup;
    RBLabel: TLabel;
    RestartButton: TButton;
    QuitButton: TButton;
    NextButton: TButton;
    CPanel0: TPanel;
    CPanel1: TPanel;
    CPanel2: TPanel;
    CPanel3: TPanel;
    HText: TLabel;
    QText: TLabel;
    Divider: TShape;
    ScrollBar1: TScrollBar;
    SpeechButton: TBitBtn;
    Timer1: TTimer;
    WOFGroup: TRadioGroup;
    WOSL1Group: TRadioGroup;
    WOSL2Group: TRadioGroup;
    procedure AEditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure ButtonRedoClick(Sender: TObject);
    procedure ButtonRMS2Click(Sender: TObject);
    procedure ButtonRMSClick(Sender: TObject);
    procedure CheckCFBTItemClick(Sender: TObject; Index: integer);
    procedure CPanel0Click(Sender: TObject);
    procedure CPanel1Click(Sender: TObject);
    procedure CPanel2Click(Sender: TObject);
    procedure CPanel3Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure NextButtonClick(Sender: TObject);
    procedure OptionsButtonClick(Sender: TObject);
    procedure QOGroupSelectionChanged(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure RestartButtonClick(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure SpeechButtonClick(Sender: TObject);
    procedure WOFGroupSelectionChanged(Sender: TObject);
    procedure WOSL1GroupSelectionChanged(Sender: TObject);
    procedure WOSL2GroupSelectionChanged(Sender: TObject);
  private

  public



  end;

function Card(i: integer): TPanel;
procedure AskQuestion;
procedure QAUpdateScreen;

var
  FormQA: TFormQA;

  // This is exposed so we can return an error in the unlikely event that there's
  // a grammar error during the course of a test.

  W: array[1..2] of string;
  QAE, PythonName: string;
  nm: integer;
  QAqf: string;
  QAEnumber: integer;

  // Whether we can see the options menu.
  ShowOptions: boolean;

  // These boolean variables record the progress of the test.

  TestStarted: boolean; // The test has been started by pressing the appropriate button.
  TestFinished: boolean;
  // All the questions have been answered. In this state teststarted will still be true.

  // Scorekeeping variables
  Qasked, Qright, Qaim: integer;

  // A flag to say if we're just using the form to set the test options.
  OptionsOnly: boolean;


implementation

uses Main;

var

  //The point to which we wish to peg the bottom of the screen.
  LowScr: integer;

  // rightcard (from 0 to 3) is the card with the right answer on it when a
  // question is asked in flashcard mode.
  RightCard: integer;

  QuestionAnswered: boolean;
  // The user has answered, we're waiting for them to request the next question.

  // The user will be presented with something based on Words[qlan,qword] and on
  // Qtype[qword] and required to give an answer based on Words[(3-qlan),qword]

  Qword: integer;

  // Almost self-explanatory
  Question, Answer: string;

  // The question in its spoken form
  SpokenWord: string;

  // A list of the vocabulary items used in the question, zero-indexed from the
  // start of the topic they're in.
  Fetched: string;

  QAAwake: boolean;

  LastQuestion: integer; // To stop us asking the same thing twice in a row.


{$R *.lfm}

// ************* USEFUL FUNCTIONS ******************


// This is fed a random number i between 1 and the total number of entries in
// the selected vocab topics. It returns the ith entry that is in a selected topic.
function SelectedToEntry(i: integer): integer;
var
  c: integer;
begin
  c := TopicEnd[seLastSetting];
  while i > 0 do
  begin
    c := c + 1;
    if TopicsToDisplay[EntryToTopic(i)] and not IsLeft(VcbEntry[1, i], '¶') then
      i := i - 1;
  end;
  SelectedToEntry := c;
end;

function RandomFromTopic(n: integer): integer;
var
  i, c, k: integer;
begin
  k := 0;
  for i := TopicStart(n) to TopicEnd[n] do
    if not IsLeft(VcbEntry[1, i], '¶') then
      k := k + 1;
  k := 1 + Random(k);
  c := TopicEnd[n - 1];
  while k > 0 do
  begin
    c := c + 1;
    if not IsLeft(VcbEntry[1, c], '¶') then
      k := k - 1;
  end;
  RandomFromTopic := c;
end;

function FirstWord(s: string): string;
begin
  if Length(Split(s, '; ', 1)) < Length(Split(s, ', ', 1)) then
    FirstWord := Split(s, '; ', 1)
  else
    FirstWord := Split(s, ', ', 1);
  FirstWord := Select(FirstWord);
  // We choose a random /-separated variant, if there is one.
end;

function Card(i: integer): TPanel;
begin
  // NB: This is a kludge. Why not just create an array of panels at runtime? Because the code to do that,
  // which fails on my machine, works when I send it to other people, and we can't figure out why. Since I'm
  // the one who has to write and expand and maintain the thing, we have to do it like this. Sucks to be me.
  with FormQA do
  begin
    case i of
      0: Card := CPanel0;
      1: Card := CPanel1;
      2: Card := CPanel2;
      3: Card := CPanel3;
    end;
  end;
end;

function DirectivesToQuestionFormat(j: integer;
  TopicDirective, EntryDirective: string): string;
var
  k: integer;
begin
  DirectivesToQuestionFormat := Split(GetValue('DF'), ' : ', j);
  // Set to default for this .vcb file
  for k := TopicStart(seQuestionFormats) to TopicEnd[seQuestionFormats] do
    if (EntryDirective = VcbEntry[1, k]) or
      (MergeDirectives(TopicDirective, EntryDirective) = VcbEntry[1, k]) or
      (TopicTypeWithWildcard(TopicDirective) = VcbEntry[1, k]) then
      DirectivesToQuestionFormat := Split(VcbEntry[2, k], ' : ', j);
end;

function StripBracketsButCurly(s: string): string;
var
  t: string;
  i: integer;
  sb, rb: integer;
  start, Snippable: boolean;
begin
  // strips out brackets, replaces them with a suitable amount of whitespace
  t := '';
  sb := 0;
  rb := 0;
  start := True;
  Snippable := True;
  for i := 1 to Length(s) do
  begin
    if s[i] = '[' then sb := sb + 1;
    if s[i] = '(' then rb := rb + 1;
    if (sb + rb = 0) and not (s[i] = ' ') then
    begin
      if Snippable and not start then
        t := t + ' ';
      start := False;
      Snippable := False;
      t := t + s[i];
    end
    else
      Snippable := True;
    if (s[i] = ']') and (sb > 0) then sb := sb - 1;
    if (s[i] = ')') and (rb > 0) then rb := rb - 1;
  end;
  Replace(t, '{', '(');
  Replace(t, '}', ')');
  Replace(t, ' ,', ',');
  Replace(t, ' ;', ';');
  Replace(t, ' /', '/');
  Replace(t, ' |', '|');
  StripBracketsButCurly := t;
end;

function StripBrackets(s: string): string;
var
  t: string;
  i: integer;
  sb, rb, cb: integer;
  start, Snippable: boolean;
begin
  // strips out brackets, replaces them with a suitable amount of whitespace
  t := '';
  sb := 0;
  rb := 0;
  cb := 0;
  start := True;
  Snippable := True;
  for i := 1 to Length(s) do
  begin
    if s[i] = '[' then sb := sb + 1;
    if s[i] = '(' then rb := rb + 1;
    if s[i] = '{' then cb := cb + 1;
    if (sb + rb + cb = 0) and not (s[i] = ' ') then
    begin
      if Snippable and not start then
        t := t + ' ';
      start := False;
      Snippable := False;
      t := t + s[i];
    end
    else
      Snippable := True;
    if (s[i] = ']') and (sb > 0) then sb := sb - 1;
    if (s[i] = ')') and (rb > 0) then rb := rb - 1;
    if (s[i] = '}') and (cb > 0) then cb := cb - 1;
  end;
  Replace(t, ' ,', ',');
  Replace(t, ' ;', ';');
  StripBrackets := t;
end;

function RightToLeft(i: integer): boolean;
begin
  RightToLeft := (VcbEntry[2, TopicStart(seLangNames) + 4 * (i - 1) + 1] = '<');
end;

function InUseToEntry(i: integer): integer;
var
  c: integer;
begin
  c := TopicEnd[seLastSetting];
  while i > 0 do
  begin
    c := c + 1;
    if InUse[c] then i := i - 1;
  end;
  InUseToEntry := c;
end;

// ***************** MAIN QA *****************

procedure QAUpdateScreen;
var
  i: integer;
begin
  with FormQA do
  begin
    QuitButton.Visible := not AssignmentInProgress and not OptionsOnly;
    RestartButton.Visible := not AssignmentInProgress and not OptionsOnly;
    OptionsButton.Visible := not AssignmentInProgress and not OptionsOnly;
    ButtonRMS.Visible := TestFinished and not OptionsOnly;
    ButtonRedo.Visible := TestFinished and AssignmentHasResits and not OptionsOnly;
    ButtonRMS2.Visible := OptionsOnly;
    if AssignmentInProgress then LabelC.Caption := Translate('COMT')
    else
      LabelC.Caption := Translate('COMP');
    LabelC.Visible := TestFinished and not OptionsOnly;
    QText.Visible := TestStarted and not OptionsOnly and
      (((Qlan = 1) and (WOSL1_i = 0)) or ((Qlan = 2) and (WOSL2_i = 0)));
    SpeechButton.Visible := (TestStarted and (((Qlan = 1) and (WOSL1_i = 1)) or
      ((Qlan = 2) and (WOSL2_i = 1)))) and not OptionsOnly;
    HText.Visible := QuestionAnswered and not OptionsOnly;
    AEdit.Visible := TestStarted and (WOFGroup_i = 0) and not OptionsOnly;
    for i := 0 to 3 do Card(i).Visible :=
        (WOFGroup_i = 1) and TestStarted and not OptionsOnly;
    NextButton.Visible := QuestionAnswered and not TestFinished and not OptionsOnly;
    if WOFGroup_i = 0 then NextButton.Caption := Translate('NOE')
    else
      NextButton.Caption := Translate('NOC');

    if AssignmentExists then OptionsButton.Caption := Translate('SASM')
    else
    begin
      if ShowOptions then OptionsButton.Caption := Translate('HIDE')
      else
        OptionsButton.Caption := Translate('SHOW');
    end;

    LabelTime.Caption := '';
    if Qaim = 0 then              // We're in non-stop mode
    begin
      if Qasked > 0 then LabelScore.Caption :=
          Translate('SCORE') + ' ' +
          IntToStr(Qright) + '/' +
          IntToStr(Qasked) + ' : ' +
          IntToStr(Round(100 * Qright / Qasked)) + '%'
      else
        LabelScore.Caption := '';
    end
    else
      LabelScore.Caption := Translate('SCORE') + ' ' +
        IntToStr(Qright) + '/' +
        IntToStr(Qaim) + ' : ' +
        IntToStr(Round(100 * Qright / Qaim)) + '%';

    if ShowOptions then
      LowScr := BalanceBox.Top + BalanceBox.Height + 12;
    if OptionsOnly then
      LowScr := ButtonRMS2.Top + ButtonRMS2.Height + 12;
    if not (ShowOptions or OptionsOnly) then
      LowScr := QOGroup.Top - 12;

    Height := LowScr;
  end;

end;


procedure TFormQA.SpeechButtonClick(Sender: TObject);
var
  Pr: TProcess;
begin
  if AudioID(Qlan) = '' then Exit;
  if IsLeft(AudioID(Qlan), 'eS#') then
  begin
    Pr := TProcess.Create(nil);
    Pr.Executable := HomeDirectory + '\Resources\eSpeak NG\espeak-ng.exe';
    Pr.Parameters.Add('-v' + Split(AudioID(Qlan), 'eS#', 2));
    Pr.Parameters.Add('"' + SpokenWord + '"');
    Pr.ShowWindow := swoHide;
    Pr.Execute;
    Pr.Free;
  end
  else
  begin
    Pr := TProcess.Create(nil);
    Pr.Executable := HomeDirectory + '\Resources\Balabolka\balcon.exe';
    Pr.Parameters.Add('-t "' + SpokenWord + '"');
    Pr.Parameters.Add('-id "' + AudioID(Qlan) + '"');
    Pr.ShowWindow := swoHide;
    Pr.Execute;
    Pr.Free;
  end;
end;



procedure GenerateQuestion(var Q, A, FE: string);
var
  s, Notes: string;
  f: TextFile;
  tp, ix, i: integer;
begin
  // We look for the .grm file in the Grammar plugins folder and then if it's there we run the already-prepared
  // .py file in the Resources folder. Why? So that deleting the .grm file has the effect the user thinks it will.
  tp := EntryToTopic(nm);
  PythonName := TopicNumberToGrmFilename(tp);
  if (PythonName <> '') and not FileExists(HomeDirectory + '\Grammar plugins\' +
    PythonName + '.grm') then
  begin
    ShowMessage(Translate('CF1') + ' ' + PythonName + '.grm' + ' ' + Translate('CF2'));
    Exit;
  end;
  if PythonName <> '' then
  begin
    ix := 0;
    i := TopicStart(tp);
    while i < nm do
    begin
      if not IsLeft(VcbEntry[1, i], '¶') then ix := ix + 1;
      i := i + 1;
    end;
    DoThePython(PythonName, 'dummy string', tp, ix);

    AssignFile(f, HomeDirectory + '\Resources\File transfer\pytopa.rsc');
    Reset(f);
    ReadLn(f, QAqf);
    ReadLn(f, W[1]);
    ReadLn(f, W[2]);
    ReadLn(f, QAE);
    ReadLn(f, s);
    QAEnumber := FindErrorLine(s, Form1.Sybil_A.Lines.Count);
    ReadLn(f, Notes);
    ReadLn(f, FE);
    CloseFile(f);
  end
  else          // There's no grammar plugin
  begin
    QAqf := Qtype[nm];
    W[1] := VcbEntry[1, nm];
    W[2] := VcbEntry[2, nm];
    W[1] := TrimHint(W[1]);
    W[2] := TrimHint(W[2]);
    QAE := '';
    QAEnumber := -1;
  end;

  if QAE = '' then
  begin
    SpokenWord := StripBracketsButCurly(FirstWord(W[Qlan]));
    s := DirectivesToQuestionFormat(Qlan, TopicNumberToTopicDirective(tp), QAqf);
    Replace(s, '<L>', Language(3 - Qlan));
    Replace(s, '<W>', SpokenWord);
    Replace(s, '* ', '');
    Q := s;
    A := StripBrackets(W[3 - Qlan]);
  end
  else
  begin
    FormQA.Close;
    FormQA.ModalResult := mrAbort;
  end;
end;

procedure WrittenAnswer;
begin
  with FormQA do
  begin
    AEdit.Text := '';
    if RightToLeft(3 - Qlan) then AEdit.BidiMode := bdRightToLeft
    else
      AEdit.BidiMode := bdLeftToRight;
    if (Qlan = 1) then Aedit.Mode := ED_AL2
    else
      Aedit.Mode := ED_AL1;
    AEdit.Visible := True;
    ActiveControl := AEdit;
  end;
end;

procedure ShowCards;
var
  i, j, k: integer;
  s, DummyQuestion, DummyFetched: string;
  flag: boolean;
  temp: string;
begin
  with FormQA do
  begin
    for j := 0 to 3 do
    begin
      Card(j).Color := ClWhite;
      Card(j).Font.Color := ClBlack;
    end;
    RightCard := Random(4);
    for i := 0 to 3 do Card(i).Caption := '';
    temp := SpokenWord;
    for i := 0 to 3 do
    begin
      if i = RightCard then
        Card(i).Caption := FirstWord(Answer)
      else
      begin
        repeat
          if (CheckCFBT_i = 1) then
            nm := RandomFromTopic(EntryToTopic(Qword))
          else
            nm := SelectedToEntry(1 + Random(onum));
          GenerateQuestion(DummyQuestion, s, DummyFetched);
          s := FirstWord(s);
          flag := True;
          for k := 0 to 3 do if s = Card(k).Caption then flag := False;
          if s = FirstWord(Answer) then flag := False;
        until flag;
        Card(i).Caption := s;
      end;
    end;
    SpokenWord := temp; // a kludge but what ya gonna do?
  end;

end;

procedure AskQuestion;
begin

  Form1.TopicBox.ClearSelection;

  with FormQA do
  begin
    if Random < (Scrollbar1_i / 100) then Qlan := 1
    else
      Qlan := 2;
    if QOGroup_i = 0 then Qword := InUseToEntry(1)
    else
      repeat
        Qword := InUseToEntry(1 + Random(EntryNumber));
      until (EntryNumber <= 1) or (Qword <> LastQuestion);
    // Just to make sure it doesn't use the same word twice.
    if CurEntry > 0 then // We have gotten here from the user clicking Test on
    begin              // the vocab editor, and CurEntry is what they clicked on.
      if not IsLeft(VcbEntry[1, CurEntry], '¶') then Qword := CurEntry;
      //Check it's actual vocab and not text.
      CurEntry := 0;
    end;
    LastQuestion := Qword;
    nm := Qword;

    // Now we act on any hints about which way round the question should be asked.
    // ! means, this should never be a question; * means this shouldn't be a question with a written answer.
    if IsLeft(VcbEntry[Qlan, Qword], '! ') or
      (IsLeft(VcbEntry[Qlan, Qword], '* ') and (WOFGroup_i = 0)) then Qlan := 3 - Qlan;
    // And generate the question.

    GenerateQuestion(Question, Answer, Fetched);

    // The following bit of logic means that if *both* sides of the entry are prefixed with a *
    // then it will force a flashcard answer despite the user's options.
    if (WOFGroup_i = 0) and not IsLeft(VcbEntry[Qlan, Qword], '* ') then WrittenAnswer
    else
      ShowCards;
    HText.Caption := '';
    QuestionAnswered := False;
    QAupdatescreen;
    if SpeechButton.Visible then
      SpeechButtonClick(FormQA)
    else
      QText.Caption := Question;
  end;

end;

procedure RightAnswer(b: boolean);
begin
  Replace(Answer, '_', ' ');
  with FormQA do
  begin
    if b then
    begin
      HText.Caption := Translate('HCorrect');
      Qright := Qright + 1;
    end
    else
    begin
      Answer := Split(Answer, '; ', 1);
      Replace(Answer, '.,', '. / ');
      Replace(Answer, '?,', '? / ');
      Replace(Answer, '!,', '! / ');
      HText.Caption := Translate('HWrong') + ' ' + (Answer);
    end;
    if (QOGroup_i <= 1) or ((QOGroup_i = 2) and b) then
    begin
      InUse[Qword] := False;
      EntryNumber := EntryNumber - 1;
    end;
    if (QOGroup_i = 2) and not b then Qaim := Qaim + 1;
    Qasked := Qasked + 1;
    QuestionAnswered := True;
    if (EntryNumber = 0) or (AssignmentExists and (Qasked = Qaim)) then
      TestFinished := True;
    QAupdatescreen;
  end;

  with Form1 do
  begin
    TopicBox.Selected[EntryToTopic(Qword) - LowerTopic] := True;
    {THIS IS WHERE WE USE "FETCHED"}
  end;

  if TestFinished and AssignmentInProgress and (Round(100 * Qright / Qaim) >
    AssignmentScore) then
  begin
    AssignmentScore := Round(100 * Qright / Qaim);
    repeat
    until UploadResult(Password, Username, AssignmentID, AssignmentScore);
  end;

end;

procedure TFormQA.AEditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  t: string;
begin
  if TestFinished then
  begin
    Key := 0;
    Exit;
  end;
  if (Key = 13) and TestStarted and not (QuestionAnswered) then
  begin
    AEdit.SelStart := Length(AEdit.Text);
    t := Answer;
    Replace(t, ';', ',');
    while (t <> '') and not Match(Split(t, ', ', 1), AEdit.Text) do
      t := Split(t, ', ', 2);
    RightAnswer(t <> '');
  end
  else
  begin
    if QuestionAnswered then
    begin
      Key := 0;
      AskQuestion;
    end // of if questionanswered
    else
      EditKeyDown(Sender, Key, Shift);
  end;
end;

procedure CardClicked(i: integer);
var
  j: integer;
begin
  if TestFinished then Exit;
  if QuestionAnswered then
  begin
    AskQuestion;
    QuestionAnswered := False;
  end
  else
  begin
    RightAnswer(i = RightCard);
    QuestionAnswered := True;
    for j := 0 to 3 do
      if not (j = RightCard) then
      begin
        Card(j).Color := ClBlack;
        Card(j).Font.Color := ClWhite;
      end;
  end;
end;

procedure TFormQA.CPanel0Click(Sender: TObject);
begin
  CardClicked(0);
end;

procedure TFormQA.CPanel1Click(Sender: TObject);
begin
  CardClicked(1);
end;

procedure TFormQA.CPanel2Click(Sender: TObject);
begin
  CardClicked(2);
end;

procedure TFormQA.CPanel3Click(Sender: TObject);
begin
  CardClicked(3);
end;

procedure TFormQA.FormActivate(Sender: TObject);
var
  i: integer;
begin
  QAAwake := False;
  LastQuestion := -1;
  QOGroup.Caption := Translate('TO1');
  WOFGroup.Caption := Translate('TO2');
  CheckCFBT.Caption := Translate('TO3');
  CheckCFBT.Items[0] := Translate('TO3');
  BalanceBox.Caption := Translate('TO4');
  WOSL1Group.Caption := Translate('TOX1') + ' (' + Language(1) + ')';
  WOSL2Group.Caption := Translate('TOX2') + ' (' + Language(2) + ')';
  ;
  WOSL1Group.Enabled := (IsAudio[1]);
  WOSL2Group.Enabled := (IsAudio[2]);
  WOSL1Group.ItemIndex := WOSL1_i;
  WOSL2Group.ItemIndex := WOSL2_i;
  LBLabel.Caption := Language(2) + ' - ' + Language(1);
  RBLabel.Caption := Language(1) + ' - ' + Language(2);
  for i := 0 to 3 do QOGroup.Items[i] := TranslateList('O1', i);
  for i := 0 to 1 do WOFGroup.Items[i] := TranslateList('WFW', i);
  for i := 0 to 1 do WOSL1Group.Items[i] := TranslateList('WSW1', i);
  for i := 0 to 1 do WOSL2Group.Items[i] := TranslateList('WSW2', i);
  ButtonRMS2.Caption := Translate('ButRMS');
  ButtonRedo.Caption := Translate('REDO');
  ButtonRMS.Caption := Translate('ButRMS');
  QAUpdateScreen;
  QAAwake := True;
end;

procedure TFormQA.FormChangeBounds(Sender: TObject);
begin
  QuitButton.Width := (FormQA.Width - 48) div 3;
  RestartButton.Width := QuitButton.Width;
  FormQA.Height := LowScr;
end;

procedure TFormQA.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if AssignmentInProgress and (Round(100 * Qright / Qaim) > AssignmentScore) then
  begin
    AssignmentScore := Round(100 * Qright / Qaim);
    repeat
    until UploadResult(Password, Username, AssignmentID, AssignmentScore);
  end;
  if (AssignmentExists and AssignmentInProgress and
    ((not AssignmentHasResits) or (AssignmentType = 2))) then
    Form1.MenuCloseClick(Sender); // This shuts down the assignment and restores the state.
  TestStarted := False;
  TestFinished := False;
  AssignmentInProgress := False;
  AssignmentComplete := True;
  if AssignmentType = 1 then DisplayVocab(DISPLAY_SELECTED);
  // We've had the actual vocab concealed for a half-closed test.
end;

procedure TFormQA.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if AssignmentInProgress and not AssignmentHasResits and not TestFinished and
    (QuestionDlg(Translate('AREYOUSURE'), Translate('NORESIT'), mtCustom,
    [1, Translate('QUITA'), 2, Translate('CONTA')], '') = 2) then CanClose := False;
end;

procedure TFormQA.NextButtonClick(Sender: TObject);
begin
  AskQuestion;
  QuestionAnswered := False;
end;

procedure TFormQA.OptionsButtonClick(Sender: TObject);
begin
  // This button has two uses, probaby bad practice but meh. If there's an
  // assignment and you're practicing it lets you do the assignment for real.
  // If there's no assignment it shows you the test options.
  if AssignmentExists then
  begin
    if AssignmentType = 1 then DisplayVocab(DISPLAY_NONVOCAB);
    AssignmentInProgress := True;
    RestartButtonClick(Sender);
  end
  else
  begin
    ShowOptions := not ShowOptions;
    QAupdatescreen;
  end;
end;

procedure TFormQA.QuitButtonClick(Sender: TObject);
begin
  Close;
end;

// Some of this logic is replicated in Form1, dostarttest
procedure TFormQA.RestartButtonClick(Sender: TObject);
var
  i, j: integer;
begin
  EntryNumber := 0;
  for i := VocabStarts to LastTopic do
  begin
    for j := TopicStart(i) to TopicEnd[i] do
    begin
      InUse[j] := TopicsToDisplay[i] and not IsLeft(VcbEntry[1, j], '¶');
      if InUse[j] then
      begin
        EntryNumber := EntryNumber + 1;
      end;
    end;
  end;
  onum := EntryNumber;
  Qasked := 0;
  Qright := 0;
  Qaim := EntryNumber;
  if QOGroup_i = 3 then
  begin
    if AssignmentExists then Qaim := AssignmentQuestionLimit
    else
      Qaim := 0;
  end;
  TestStarted := True;
  TestFinished := False;
  QAUpdateScreen;
  AskQuestion;
end;

procedure TFormQA.ButtonRedoClick(Sender: TObject);
begin
  RestartButtonClick(Sender);
end;

procedure TFormQA.ButtonRMS2Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormQA.ButtonRMSClick(Sender: TObject);
begin
  Close;
end;



// ********************* THE TEST OPTIONS *********************

procedure TFormQA.QOGroupSelectionChanged(Sender: TObject);
begin
  QOGroup_i := QOGroup.ItemIndex;
  QOGroup_b := QOGroup.ItemIndex;
  if QAAwake and not OptionsOnly then RestartButtonClick(Sender);
end;

procedure TFormQA.WOFGroupSelectionChanged(Sender: TObject);
begin
  WOFGroup_i := WOFGroup.ItemIndex;
  WOFGroup_b := WOFGroup.ItemIndex;
  if QAAwake and not OptionsOnly then RestartButtonClick(Sender);
end;

procedure TFormQA.WOSL1GroupSelectionChanged(Sender: TObject);
begin
  WOSL1_i := WOSL1Group.ItemIndex;
  WOSL1_b := WOSL1Group.ItemIndex;
  if QAAwake and not OptionsOnly then RestartButtonClick(Sender);
end;

procedure TFormQA.WOSL2GroupSelectionChanged(Sender: TObject);
begin
  WOSL2_i := WOSL2Group.ItemIndex;
  WOSL2_b := WOSL2Group.ItemIndex;
  if QAAwake and not OptionsOnly then RestartButtonClick(Sender);
end;

procedure TFormQA.CheckCFBTItemClick(Sender: TObject; Index: integer);
begin
  if CheckCFBT.Checked[0] then CheckCFBT_i := 1
  else
    CheckCFBT_i := 0;
  CheckCFBT_b := CheckCFBT_i;
end;

procedure TFormQA.ScrollBar1Change(Sender: TObject);
begin
  Scrollbar1_i := Scrollbar1.Position;
  Scrollbar1_b := Scrollbar1.Position;
end;

end.
