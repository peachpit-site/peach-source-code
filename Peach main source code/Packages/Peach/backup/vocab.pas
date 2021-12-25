unit Vocab;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LazUTF8, LazUTF16, Process, StdCtrls, Keyboard, Dialogs,
  CommonStringFunctions, AppLanguage;

// This consists of stuff that is shared between the main form, the test form,
// the assignment form, etc.

const
  MaximumEntries = 100000;

var
  // The directory where Peach (the main program, not the launcher) finds itself.
  HomeDirectory: string;

  //And some booleans for keeping track of what the File menu should be doing.
  DataExists: boolean; // True if there's any data at all, if we haven't just closed a file.
  VcbFileExists: boolean;
  // True if the data's been saved at least once and so has a filename.
  UnsavedChangesExist: boolean; // True if there are unsaved changes to the .vcb file.

{When Vocab opens a .vcb file, it reads raw strings and puts the results into
topicname, topicend, last_topic, qtype, and words.

Topicname is an array of the names of the topics under which the
vocab is grouped. topicend gives the position in the words array of the last
entry for that topic. A number of useful functions listed below allow one
to calculate topicsize, topicstart, etc from topicend. last_topic points to the
last topic after they've all been read in.

VcbEntry[i,j] contains the jth entry for language i, and qtype[j] the format of
question appropriate to the words.}
  TopicName: array[0..100] of string;
  LastTopic: integer;
  TopicEnd: array[-1..100] of integer;
  VcbEntry: array[1..2, 1..MaximumEntries] of string;
  Qtype: array[1..MaximumEntries] of string;

// However the first nine topics aren't really topics containing vocabulary, but
// rather contain "settings": the metadata of the .vcb fie that tell it how to
// interact with Peach.

// Keeping them in the same arrays with the rest of the data allows me
// to reuse code, treating properties as topics and settings as vocab entries
// for a number of useful purposes. However, properties are NOT the same as
// vocab entries nor are they homogeneous with one another, and so it is
// neccessary to distinguish between them in ways that have to be hardcoded.

// We use the following constants to refer to the topics containing settings.

const
  BASEMENT = -1;      // basement must always be one less than data_starts
  seDatastarts = 0;   // data_starts is always the number of the first property
  seSettingsHeader = 0;
  seLangNames = 1;
  seAboutVlist = 2;
  seKeysHelp = 3;
  seLang1Keys = 4;        //  These three should be consecutive
  seLang2Keys = 5;
  seQuestionFormats = 6;
  seTestOverrides = 7;
  seAppearanceOverrides = 8;
  seLockdownOverrides = 9;
  seLastSetting = 9;          // Has to be the last setting
  VocabStarts = 10;           // Has to be the first vocab

var
  // tdisp keeps track of which topics have been checked off in the TopicBox
  // and are therefore liable to have their contents displayed in the WordBox
  TopicsToDisplay: array[BASEMENT..100] of boolean;
  SomethingChecked: boolean;
  // True if at least one topic has been checked, so the test can be started.

  // inuse keeps track of which items of vocabulary are liable to be the subject
  // of a question, as a result of being in a selected topic and not having been
  // asked yet (if the QOGroup is set so that that matters).
  InUse: array[1..10000] of boolean;

  // wnum is the number of questions that can still be asked,
  // and onum is the original number there was when the test started.
  EntryNumber, onum: integer;

  // filename is the name of the .vcb file.
  Filename: string;

  // Font settings in the Appearance options.
  MainFont, TitleFont: string;
  BaseFontSize: integer;

  // Backups
  Mainfont_b, TitleFont_b: string;
  Fontsize3_b: integer;

  // The language of the question.
  Qlan: integer;

  // Values for the test options
  QOGroup_i, WOFGroup_i, WOSL1_i, WOSL2_i, CheckCFBT_i, Scrollbar1_i: integer;

  // Backups for the test options
  QOGroup_b, WOFGroup_b, WOSL1_b, WOSL2_b, CheckCFBT_b, ScrollBar1_b: integer;

  //saved copy of lockstr to be restored after closing a vcb file unless the user has manually
  //changed the lockdown settings in the meantime
  LockdownBackup: string;

  // Whether an assignment has been downloaded.
  AssignmentExists: boolean;

  // Whether we doing the assignment or just practicing.
  AssignmentInProgress: boolean;

  // The type of the assignment
  AssignmentType: integer;

  // Limit on the number of questions in the assigmnent
  AssignmentQuestionLimit: integer;

  // Whether resits are allowed
  AssignmentHasResits: boolean;

  // The assignment ID.
  AssignmentID: string;

  // The current best score for the assignment.
  AssignmentScore: integer;

  // Whether the assignment has been done,
  AssignmentComplete: boolean;

  IsAudio: array[1..2] of boolean;

procedure StringToEntry(s: string; i, tn: integer);
function EntryToShortString(j: integer): string;
function StripSquareBrackets(s: string): string;
function TopicSize(i: integer): integer;
function BooleanValue(s: string): boolean;
function GetValue(s: string): string;
function Decode(s, t: string): string;
function IsLeft(s, Substring: string): boolean;
function AudioID(i: integer): string;
function TopicStart(i: integer): integer;
function Language(i: integer): string;
function EntryToString(i: integer): string;
function EntryToTopic(i: integer): integer;
function ValidateSelection: boolean;
function AddAccent(s: string; lg: integer): string;
procedure EditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
procedure DoSave(var f: TextFile);
procedure DoThePython(PythonName, s: string; tp, ix: integer);
procedure PutRsc(var f: TextFile);
function IsLeftWideString(s, t: WideString): boolean;
function Match(Expression, candidate: string): boolean;
function Select(s: string): string;
function HasVocab(j: integer): boolean;
function TrimHint(s: string): string;
function TopicNumberToTopicDirective(i: integer): string;
function TopicNumberToGrmFilename(i: integer): string;
function MergeDirectives(ttype, Qtype: string): string;
function TopicTypeWithWildcard(ttype: string): string;
function TrimDirective(s: string): string;

implementation




function StripSquareBrackets(s: string): string;
var
  t: string;
  i: integer;
  sb: integer;
  start, Snippable: boolean;
begin
  // strips out square brackets, replaces them with a suitable amount of whitespace
  // Converts curly to regular;
  t := '';
  sb := 0;
  start := True;
  Snippable := True;
  for i := 1 to Length(s) do
  begin
    if s[i] = '[' then sb := sb + 1;
    if (sb = 0) and not (s[i] = ' ') then
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
  end;
  Replace(t, '{', '(');
  Replace(t, '}', ')');
  Replace(t, ' ,', ',');
  Replace(t, ' ;', ';');
  Replace(t, ' /', '/');
  Replace(t, ' |', '|');
  StripSquareBrackets := t;
end;



function EntryToShortString(j: integer): string;
var
  temps: array[1..2] of string;
  i: integer;
begin
  if j < TopicStart(VocabStarts) then
  begin
    if (TopicStart(seAboutVlist) <= j) and (j <= TopicEnd[seKeysHelp]) or
      (TopicStart(seTestOverrides) <= j) and (j <= TopicEnd[seTestOverrides] - 2) or
      (TopicStart(seLockdownOverrides) <= j) and (j <= TopicEnd[seLockdownOverrides])
    then EntryToShortString := VcbEntry[1, j]
    else
      EntryToShortString := VcbEntry[1, j] + ' — ' + VcbEntry[2, j];
  end
  else         // This is a regular vocab item ...
  begin
    for i := 1 to 2 do
    begin
      temps[i] := Split(VcbEntry[i, j], '; ', 1);
      // So we remove the hidden synonyms ...
      temps[i] := TrimHint(temps[i]); // And any hints for the question generator.
    end;
    EntryToShortString := temps[1] + ' — ' + temps[2];
  end;
  if (VcbEntry[1, j] = '') and (VcbEntry[2, j] = '') and (Qtype[j] = '') then
    EntryToShortString := '';
  if j >= TopicStart(VocabStarts) then EntryToShortString :=
      StripSquareBrackets(EntryToShortString);
end;



procedure StringToEntry(s: string; i, tn: integer);
begin
  // This code is partly duplicated in the procedure dothepython.
  if IsLeft(s, '[') and (Pos('] ', s) > 0) and (tn >= VocabStarts) then
    // Why not calculate whether we're in vocab from i? Because we might be reading the file.
  begin
    Qtype[i] := Split(s, '] ', 1) + ']';
    s := TrimDirective(s);
    if IsLeft(s, '—') then s := ' ' + s;
  end
  else
    Qtype[i] := '';

  if IsLeft(s, '¶') then VcbEntry[1, i] := s
  else
    VcbEntry[1, i] := Split(s, ' — ', 1);
  VcbEntry[2, i] := Split(s, ' — ', 2);
end;


function TopicNumberToTopicDirective(i: integer): string;
var
  s, t: string;
begin
  if i >= 0 then s := TopicName[i]
  else
    s := '';
  TopicNumberToTopicDirective := '';
  if IsLeft(s, '[') and (Pos('] ', s) > 0) then
  begin
    t := Split(s, '] ', 1);
    if Pos(' : ', t) > 0 then
      TopicNumberToTopicDirective := Split(t, ' : ', 2);
  end;
end;

function TopicNumberToGrmFilename(i: integer): string;
var
  s, t: string;
begin
  if i >= 0 then s := TopicName[i]
  else
    s := '';
  TopicNumberToGrmFilename := '';
  if IsLeft(s, '[') and (Pos('] ', s) > 0) then
  begin
    t := Split(s, '] ', 1);
    t := Split(t, '[', 2);
    t := Split(t, ' : ', 1);
    TopicNumberToGrmFilename := t;
  end;
end;

function MergeDirectives(ttype, Qtype: string): string;
begin
  if (ttype = '') or (Qtype = '') then MergeDirectives := ttype + Qtype
  else
    MergeDirectives := Split(ttype, ']', 1) + ', ' + Split(Qtype, '[', 2);
end;

function TopicTypeWithWildcard(ttype: string): string;
begin
  if ttype = '' then
    TopicTypeWithWildcard := ''
  else
    TopicTypeWithWildcard := Split(ttype, ']', 1) + ', *]';
end;


function TrimHint(s: string): string;
begin
  if IsLeft(s, '* ') or IsLeft(s, '! ') then
    TrimHint := Copy(s, 3, Length(s) - 2)
  else
    TrimHint := s;
end;

function TrimDirective(s: string): string;
begin
  if IsLeft(s, '[') and (Pos('] ', s) > 0) then
    TrimDirective := Split(s, '] ', 2)
  else
    TrimDirective := s;
end;

function CountChar(const s: string; const c: char): integer;
var
  i: integer;
begin
  CountChar := 0;
  for i := 1 to Length(s) do
    if s[i] = c then Inc(CountChar);
end;

function Match(Expression, candidate: string): boolean;
var
  t, u: string;
begin
  t := Split(Expression, ' ', 1);
  Expression := Split(Expression, ' ', 2);
  Match := False;
  while t <> '' do
  begin
    u := Split(t, '/', 1);
    t := Split(t, '/', 2);
    Replace(u, '_', ' ');
    if (u = candidate) and (Expression = '') then Match := True
    else if IsLeft(candidate, u) and (candidate[Length(u) + 1] = ' ') then
      Match := Match(Expression, Copy(candidate, Length(u) + 2,
        Length(candidate) - Length(u) - 1));
  end;
end;

function Select(s: string): string;
var
  t, u: string;
begin
  Select := '';
  while s <> '' do
  begin
    if Select <> '' then Select := Select + ' ';
    t := Split(s, ' ', 1);
    s := Split(s, ' ', 2);
    u := GetItem(t, '/', 1 + Random(1 + CountChar(t, '/')));
    Replace(u, '_', ' ');
    Select := Select + u;
  end;
end;




procedure ReplaceButBrackets(var s: string; t, u: string);
var
  i: integer;
  sb, rb, cb: integer;
begin
  // addaccent mustn't change anything in brackets (except stripping out the
  // control characters, which we do with the regular replace function.
  sb := 0;
  rb := 0;
  cb := 0;
  i := 1;
  repeat
    case s[i] of
      '[': sb := sb + 1;
      ']': if sb > 0 then sb := sb - 1;
      '(': rb := rb + 1;
      ')': if rb > 0 then rb := rb - 1;
      '{': cb := cb + 1;
      '}': if cb > 0 then cb := cb - 1;
    end;
    if (Copy(s, i, Length(t)) = t) and (sb + rb + cb = 0) then
    begin
      s := Copy(s, 1, i - 1) + u + Copy(s, i + Length(t), 1 +
        Length(s) - i - Length(t));
      i := i + Length(u) - Length(t);
    end;
    i := i + 1;
  until i > (Length(s) - Length(t)) + 1;
end;


function KeyCount(i: integer): integer;
begin
  if i = 1 then KeyCount := TopicSize(seLang1Keys)
  else
    KeyCount := TopicSize(seLang2Keys);
end;

function Keys(i, j, k: integer): string;
begin
  if i = 1 then Keys := VcbEntry[k, TopicStart(seLang1Keys) + j - 1]
  else
    Keys := VcbEntry[k, TopicStart(seLang2Keys) + j - 1];
end;


function AddAccent(s: string; lg: integer): string;
var
  j: integer;
begin
  s := ' ' + s + ' ';
  // So that the start and the end of the string look like word boundaries.
  for j := 1 to KeyCount(lg) do
    ReplaceButBrackets(s, Keys(lg, j, 1), Keys(lg, j, 2));
  Replace(s, 'ᵃ', '');
  Replace(s, 'ᵇ', '');
  Replace(s, 'ᶜ', '');
  s := Copy(s, 2, Length(s) - 2);
  AddAccent := s;
end;

function IsVocab(i: integer): boolean;
  // Identifies whether an entry is a testable vocab item.
begin
  IsVocab := not (IsLeft(VcbEntry[1, i], '¶'));
end;

function HasVocab(j: integer): boolean;
var
  i: integer;
begin
  HasVocab := False;
  for i := TopicStart(j) to TopicEnd[j] do HasVocab := HasVocab or IsVocab(i);
end;

function IsLeftWideString(s, t: WideString): boolean;
begin
  IsLeftWideString := (Copy(s, 1, Length(t)) = t);
end;

function IsLeft(s, Substring: string): boolean;
begin
  IsLeft := (Copy(s, 1, Length(Substring)) = Substring);
end;

function TopicStart(i: integer): integer;
begin
  TopicStart := TopicEnd[i - 1] + 1;
end;

function EntryToTopic(i: integer): integer;
var
  k: integer;
begin
  EntryToTopic := -1;
  for k := seDatastarts to LastTopic do
    if (TopicEnd[k - 1] < i) and (i <= TopicEnd[k]) then EntryToTopic := k;
end;

function AudioID(i: integer): string;
begin
  if DataExists then
  begin
    if i = 1 then AudioID := Split(GetValue('Aud1'), ' : ', 1);
    if i = 2 then AudioID := Split(GetValue('Aud2'), ' : ', 1);
  end
  else
    AudioID := '';
end;

function TopicSize(i: integer): integer;
begin
  TopicSize := TopicEnd[i] - TopicEnd[i - 1];
end;


// We do the internationalization for the immutable parts of the settings
// only when we display them..
function Decode(s, t: string): string;
var
  LHS, RHS, K: string;
begin
  repeat
    K := Split(s, t + '[', 2);
    if K = '' then
    begin
      Decode := s;
      Exit;
    end
    else
    begin
      LHS := Split(s, t + '[', 1);
      RHS := Split(K, ']', 2);
      K := Split(K, ']', 1);
      s := LHS + Translate(K) + RHS;
    end;
  until False;
end;

function ValidateSelection: boolean;
var
  i, j: integer;
begin
  ValidateSelection := True;
  EntryNumber := 0;
  for i := VocabStarts to LastTopic do
    if TopicsToDisplay[i] then
      for j := TopicStart(i) to TopicEnd[i] do
      begin
        InUse[j] := not IsLeft(VcbEntry[1, j], '¶');
        if InUse[j] then  EntryNumber := EntryNumber + 1;
      end;
  onum := EntryNumber;
  if EntryNumber = 0 then
  begin
    Alert('NOSELECT');
    ValidateSelection := False;
  end;
  if (EntryNumber < 4) and (WOFGroup_i = 1) then
  begin
    Alert('NO4');
    ValidateSelection := False;
  end;
end;

function GetValue(s: string): string;
var
  i: integer;
begin
  GetValue := 'Unimplemented token ' + s;
  for i := TopicStart(seDatastarts) to TopicEnd[seLastSetting] do
    if Pos('#[' + s + ']', VcbEntry[1, i]) <> 0 then GetValue := VcbEntry[2, i];
end;

function BooleanValue(s: string): boolean;
var
  i: integer;
begin
  BooleanValue := False;
  for i := TopicStart(seDatastarts) to TopicEnd[seLastSetting] do
    if Pos('#[' + s + ']', VcbEntry[1, i]) <> 0 then
      BooleanValue := IsLeft(VcbEntry[1, i], '■') or IsLeft(VcbEntry[1, i], '●');
end;


function Language(i: integer): string;
begin
  if DataExists then
  begin
    if i = 1 then Language := GetValue('Lang1');
    if i = 2 then Language := GetValue('Lang2');
  end
  else
    Language := TranslateList('Lang1', i - 1);
end;


function EntryToString(i: integer): string;
var
  t: string;
begin

  if IsLeft(VcbEntry[1, i], '¶') then
  begin
    EntryToString := VcbEntry[1, i];
    Exit;
  end;

  t := '';
  if Qtype[i] <> '' then t := Qtype[i] + ' ';
  if ((i >= TopicStart(seAboutVlist)) and (i <= TopicEnd[seKeysHelp])) then
    EntryToString := t + VcbEntry[1, i]
  else
    EntryToString := t + VcbEntry[1, i] + ' — ' + VcbEntry[2, i];
  if EntryToString = ' — ' then EntryToString := '';
end;



procedure EditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  s: string;
  olen, ch, x, Utf8x, temp: integer;
begin
  with Sender as TEdit do
  begin

    if (Key = 9) then
    begin
      temp := Utf16Pos(Utf8ToUtf16(' — '), Text);
      if SelStart <= temp then SelStart := temp + 3;
      Key := 0;
      Exit;
    end;

    x := SelStart;
    s := '';
    olen := UTF16Length(Text);
    ch := TranslateKeyEvent(Key);
    if not ((Shift = [ssCtrl]) and ((ch = 67) or (ch = 86) or
      (ch = 88) or (ch = 90))) then
      if (ch in [65..90]) or (ch in [48..57]) then
      begin
        if (ch in [65..90]) and not (ssShift in Shift) then ch := ch + 32;
        if [ssAlt, ssCtrl] <= Shift then s := 'ᵇ' + chr(ch)
        else
        begin
          if ssCtrl in Shift then s := 'ᶜ' + chr(ch);
          if ssAlt in Shift then s := 'ᵃ' + chr(ch);
        end;
        //if [ssCtrl,ssAlt] * Shift <> [] then key:=0;
        if s <> '' then
        begin
          Utf8x := Utf8Cur(x, Text);
          Text := Utf8Copy(Text, 1, Utf8x) + s +
            Utf8Copy(Text, Utf8x + 1, Utf8Length(Text) - Utf8x);
          SelStart := x + Utf16Length(Text) - olen;
          Key := 0;
        end;
      end;
  end;
end;

procedure DoSave(var f: TextFile);
var
  i, j: integer;
begin
  for i := seDatastarts to LastTopic do
  begin
    WriteLn(f, '§' + TopicName[i]);
    for j := TopicStart(i) to TopicEnd[i] do WriteLn(f, EntryToString(j));
  end;
end;

procedure PutRsc(var f: TextFile);
var
  i: integer;
  TopicDisplayStr: string;
begin
  if IsLeft(Filename, HomeDirectory + '\Vocab lists\') then
    WriteLn(f, ':' + ExtractFileName(Filename))
  else
    WriteLn(f, Filename);
  WriteLn(f, QOGroup_b);
  WriteLn(f, WOSL1_b);
  WriteLn(f, WOSL2_b);
  WriteLn(f, WOFGroup_b);
  WriteLn(f, CheckCFBT_b);
  WriteLn(f, ScrollBar1_b);
  WriteLn(f, Mainfont_b);
  WriteLn(f, TitleFont_b);
  WriteLn(f, Fontsize3_b);
  WriteLn(f, LockdownBackup);
  TopicDisplayStr := '';
  for i := seDatastarts to LastTopic do
    if TopicsToDisplay[i] then TopicDisplayStr := TopicDisplayStr + 'Y'
    else
      TopicDisplayStr := TopicDisplayStr + 'N';
  WriteLn(f, TopicDisplayStr);
end;


procedure DoThePython(PythonName, s: string; tp, ix: integer);
var
  Qf, w1, w2: string;
  i: integer;
  f: TextFile;
  Pr: TProcess;
  temp: integer;
begin
  AssignFile(f, HomeDirectory + '\Resources\File transfer\patopy.rsc');
  Rewrite(f);
  WriteLn(f, TopicNumberToTopicDirective(tp));
  WriteLn(f, Language(1));
  WriteLn(f, Language(2));
  WriteLn(f, Qlan - 1);
  if Qlan = 1 then temp := WOSL1_i
  else
    temp := WOSL1_i;
  if temp = 0 then WriteLn(f, 'written')
  else
    WriteLn(f, 'spoken');
  if WOFGroup_i = 0 then WriteLn(f, 'written')
  else
    WriteLn(f, 'multiple choice');
  if ix = -1 then
    // In this case, we are using the IDE and have passed a string not in the vocab.
  begin
    if IsLeft(s, '[') and (Pos('] ', s) > 0) then
    begin
      Qf := Split(s, '] ', 1) + ']';
      s := Split(s, '] ', 2);
      if IsLeft(s, '—') then s := ' ' + s;
    end
    else
      Qf := '';
    w1 := Split(s, ' — ', 1);
    w2 := Split(s, ' — ', 2);
    WriteLn(f, 0);
    WriteLn(f, Qf);
    WriteLn(f, TrimHint(w1));
    WriteLn(f, TrimHint(w2));
  end
  else
  begin
    WriteLn(f, ix);
  end;
  if tp <> -1 then
    for i := TopicStart(tp) to TopicEnd[tp] do
      if not IsLeft(VcbEntry[1, i], '¶') then
      begin
        WriteLn(f, Qtype[i]);
        WriteLn(f, TrimHint(VcbEntry[1, i]));
        WriteLn(f, TrimHint(VcbEntry[2, i]));
      end;
  CloseFile(f);

  Pr := TProcess.Create(nil);
  Pr.Executable := HomeDirectory + '\Resources\Python\python.exe';
  Pr.Parameters.Add(HomeDirectory + '\Resources\Py files\' + PythonName + '.py');
  Pr.Options := Pr.Options + [poWaitOnExit];
  Pr.ShowWindow := swoHide;
  Pr.Execute;
  Pr.Free;
end;

end.
