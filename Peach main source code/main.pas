unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, CheckLst,
  Windows, StdCtrls, ExtCtrls, Menus, Keyboard, LazUTF8, LazUTF16, LCLIntf,
  LCLType, Math, StrUtils, Graph, Types, ClipBrd, Buttons, RichMemo, Process,
  SearchAndReplace, AppearanceOptions, LockdownOptions, Publish, Vocab, SignIn,
  AssignHomework, Internet, Register, StudentClasses, TeacherClasses,
  Assignments, TestResults, InterposerEdit, RichMemoUtils,
  RMInlinePicture, IconUpdater, VersionSupport, CommonStringFunctions,
  AppLanguage, FontInfo, Licenses, PythonFunctions, PyMemo, WMemo;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonQuitAssignment: TButton;
    ButtonPractice: TButton;
    ButtonAssignment: TButton;
    GOut: TEdit;
    MenuCopyright: TMenuItem;
    Wallpaper: TImage;
    MenuAlwaysUpdate: TMenuItem;
    MenuNeverUpdate: TMenuItem;
    MenuAlwaysAsk: TMenuItem;
    Divider: TMenuItem;
    MenuLatestVersion: TMenuItem;
    MenuStableVersion: TMenuItem;
    MenuUpdateOptions: TMenuItem;
    MenuView: TMenuItem;
    MenuMainScreen: TMenuItem;
    MenuEditVcb: TMenuItem;
    MenuEditSettings: TMenuItem;
    MenuEditGrm: TMenuItem;
    WTest: TMenuItem;
    WFind: TMenuItem;
    WReplace: TMenuItem;
    WMenuPopup: TPopupMenu;
    Report: TEdit;
    GrammarPopup: TPopupMenu;
    GMIndent: TMenuItem;
    GMUnindent: TMenuItem;
    GMFind: TMenuItem;
    GMReplace: TMenuItem;
    MenuClassroom: TMenuItem;
    MenuAssignWork: TMenuItem;
    MenuManageClasses: TMenuItem;
    MenuRegister: TMenuItem;
    MenuSignIn: TMenuItem;
    MenuClasses: TMenuItem;
    MenuAssignments: TMenuItem;
    MenuNotifications: TMenuItem;
    MenuGradebook: TMenuItem;
    MenuForgotPassword: TMenuItem;
    MenuChangePassword: TMenuItem;
    MenuChangeEmail: TMenuItem;
    Divider2: TMenuItem;
    MenuDualDivider: TMenuItem;
    MenuTestOptions: TMenuItem;
    MenuDualUser: TMenuItem;
    MenuSignOut: TMenuItem;
    MenuUser: TMenuItem;
    MenuSoloUser: TMenuItem;
    MenuStudent: TMenuItem;
    MenuMultipleStudents: TMenuItem;
    MenuTeacher: TMenuItem;
    MenuPublish: TMenuItem;
    MenuOptions: TMenuItem;
    MenuAppearanceOptions: TMenuItem;
    MenuLockdownOptions: TMenuItem;
    DataEdit: TEdit;
    GRefresh: TButton;
    GKeyGroup: TCheckGroup;
    ColorDialog1: TColorDialog;
    GetDataLabel: TLabel;
    DataLabel: TLabel;
    GOutLabel: TLabel;
    MenuNewGrm: TMenuItem;
    OpenGrmDialog: TOpenDialog;
    GMemo: TPyMemo;
    ReportLabel: TLabel;
    SaveGrmDialog: TSaveDialog;
    TopicCombo: TComboBox;
    Sybil_A: TMemo;
    Sybil_B: TMemo;
    WMemo: TWMemo;
    WordCombo: TComboBox;
    OpenVcbDialog: TOpenDialog;
    TWEdit1: TEdit;
    THeader: TLabel;
    VHeader: TLabel;
    MainMenu: TMainMenu;
    MenuFile: TMenuItem;
    MenuHelp: TMenuItem;
    MenuAboutVcb: TMenuItem;
    MenuKeyboardHelp: TMenuItem;
    MenuAboutThisProgram: TMenuItem;
    MenuClose: TMenuItem;
    MenuNew: TMenuItem;
    MenuExit: TMenuItem;
    MenuNewFileNewSettings: TMenuItem;
    MenuNewFileKeepSettings: TMenuItem;
    MenuOpen: TMenuItem;
    MenuSaveAs: TMenuItem;
    MenuRevert: TMenuItem;
    MenuSave: TMenuItem;
    SaveVcbDialog: TSaveDialog;
    TestButton: TButton;
    TopicBox: TCheckListBox;
    procedure ButtonAssignmentClick(Sender: TObject);
    procedure ButtonPracticeClick(Sender: TObject);
    procedure ButtonQuitAssignmentClick(Sender: TObject);
    procedure DataEditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DataEditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure DividerChangeBounds(Sender: TObject);
    procedure EditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure GKeyGroupItemClick(Sender: TObject; Index: integer);
    procedure GMemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure GMFindClick(Sender: TObject);
    procedure GMIndentClick(Sender: TObject);
    procedure GMReplaceClick(Sender: TObject);
    procedure GMUnindentClick(Sender: TObject);
    procedure GRefreshClick(Sender: TObject);
    procedure GMemoChange(Sender: TObject);
    procedure MenuAboutVcbClick(Sender: TObject);
    procedure MenuAssignmentsClick(Sender: TObject);
    procedure MenuAssignWorkClick(Sender: TObject);
    procedure MenuClassesClick(Sender: TObject);
    procedure MenuChangeEmailClick(Sender: TObject);
    procedure MenuChangePasswordClick(Sender: TObject);
    procedure MenuForgotPasswordClick(Sender: TObject);
    procedure MenuClassroomClick(Sender: TObject);
    procedure MenuManageClassesClick(Sender: TObject);
    procedure MenuNotificationsClick(Sender: TObject);
    procedure MenuCopyrightClick(Sender: TObject);
    procedure MenuSignInClick(Sender: TObject);
    procedure MenuSignOutClick(Sender: TObject);
    procedure MenuGradebookClick(Sender: TObject);
    procedure MenuEditGrmClick(Sender: TObject);
    procedure MenuEditSettingsClick(Sender: TObject);
    procedure MenuEditVcbClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure MenuAboutThisProgramClick(Sender: TObject);
    procedure MenuRegisterClick(Sender: TObject);
    procedure MenuFileClick(Sender: TObject);
    procedure MenuHelpClick(Sender: TObject);
    procedure MenuAlwaysUpdateClick(Sender: TObject);
    procedure MenuNeverUpdateClick(Sender: TObject);
    procedure MenuAlwaysAskClick(Sender: TObject);
    procedure MenuLatestVersionClick(Sender: TObject);
    procedure MenuStableVersionClick(Sender: TObject);
    procedure MenuNewGrmClick(Sender: TObject);
    procedure MenuAppearanceOptionsClick(Sender: TObject);
    procedure MenuLockdownOptionsClick(Sender: TObject);
    procedure MenuOptionsClick(Sender: TObject);
    procedure MenuTestOptionsClick(Sender: TObject);
    procedure MenuPublishClick(Sender: TObject);
    procedure MenuDualUserClick(Sender: TObject);
    procedure MenuMultipleStudentsClick(Sender: TObject);
    procedure MenuStudentClick(Sender: TObject);
    procedure MenuUserClick(Sender: TObject);
    procedure MenuSoloUserClick(Sender: TObject);
    procedure MenuTeacherClick(Sender: TObject);
    procedure MenuViewClick(Sender: TObject);
    procedure TopicBoxClick(Sender: TObject);
    procedure TopicBoxClickCheck(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure MenuMainScreenClick(Sender: TObject);
    procedure MenuKeyboardHelpClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure MenuNewFileKeepSettingsClick(Sender: TObject);
    procedure MenuNewFileNewSettingsClick(Sender: TObject);
    procedure MenuOpenClick(Sender: TObject);
    procedure MenuRevertClick(Sender: TObject);
    procedure MenuSaveAsClick(Sender: TObject);
    procedure MenuSaveClick(Sender: TObject);
    procedure TestButtonClick(Sender: TObject);
    procedure TopicComboChange(Sender: TObject);
    procedure WMemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure WMemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; x, y: integer);
    procedure WMenuPopupPopup(Sender: TObject);
    procedure WordComboChange(Sender: TObject);
    procedure WReplaceClick(Sender: TObject);
    procedure WFindClick(Sender: TObject);
    procedure WTestClick(Sender: TObject);

  private

  public

  end;



// Constants for referring to the lockdown options as stored in the string lockstr [1..lockcount]

const
  lkFileMenu = 1;
  lkRestrictFileMenu = 2;
  lkPublish = 3;
  lkTestOptions = 4;
  lkAppearanceOptions = 5;
  lkUpdateOptions = 6;
  lkLockdownOptions = 7;
  lkEditing = 8;
  lock_user_menu = 9;
  lkClassroomMenu = 10;

  LockdownCount = 10;

  // Constants for referring to the user status.

  USER_SOLO = 0;
  USER_STUDENT = 1;
  USER_MULTIPLE = 2;
  USER_TEACHER = 3;
  USER_DUAL = 4;

  // Constants for saying how the vocab should be displayed;

  DISPLAY_SELECTED = 0;
  DISPLAY_ALL = 1;
  DISPLAY_NONVOCAB = 2;

  // The space the menu bar takes up I guess, I don't like it either, blame Borland.
  Kludge = 20;

// The offset constant is the distance between components, and shouldn't be
// changed as it's also hardwired into their anchoring properties.
const
  Offset = 12;

var
  Form1: TForm1;  // It all happens here.

// Some global variables for keeping track of the state.

// LowerTopic and UpperTopic are the  bounds (i.e. the first and last topics)
// between which the TopicBox will display things when you call MakeTopicBox.
// Can be changed so as to display either vocabulary items or properties, or
// a subset of properties.
var
  LowerTopic, UpperTopic: integer;

  // The vocab entry and topic under consideration.
  SelectedEntry, SelectedTopic: integer;

  // Some variables for keeping track of grammar plugins. Note that they are
  // not quite parallel because Peach assumes that the filename has a .vcb suffix but
  // that the gfilename has no suffix.
  GrmFilename: string;

  //And some booleans for keeping track of what the File menu should be doing.
  GrmFileExists: boolean;
  // True if the data's been saved at least once and so has a filename.
  GrmUnsavedChangesExist: boolean; // True if there are unsaved changes, duh.
// There is no equivalent to dataexists: Close does the same as New in the grammar editor, giving us a blank memo with no title.
// gediting is true if you are using the grammar editor

const
  VIEW_MAIN = 0;
  VIEW_EDIT = 1;
  VIEW_SETTINGS = 2;
  VIEW_GRAMMAR = 3;

var
  ViewMode: integer;

  LockStr: string;
  // The user's saved lockdown preferences in the form of a string of Ys and Ns.

  // The user Status, personal, student, multiple students, teacher.
  Status: integer;

  // Peach doesn't have to be called Peach.
  ProgramName, ProgramVersion, ProgramPublisher: string;

  // Controls if the program autoupdates, and if so from where.
  UpdateSetting, VersionSetting: integer;

  // Records whether the program's just started. So that FormActivate can do things
  // that are illegal for FormCreate.
  JustStarted: boolean;

  //Start on the WMemo of the topic we just picked, or the end of the topic before
  // the one we just deleted.
  ScrollTo: integer;

// Self-explanatory constants.
const
  FROM_DISC = False;
  FROM_MEMO = True;

var
  Scheme: TStrings; // This will hold the contents of the file settings_scheme.rsc,
  // which describes the layout of the settings of a new file and
  // is also used to schlurp the settings after editing them.

  // These record the topic and entry indicated by the cursor when the user selects
  // Test on the WMenuPopUp;
  CurTopic, CurEntry: integer;

  // Used to make clicking on the topic box do what I want it to.
  TopicBoxFlag: boolean;

procedure DisplayVocab(DisplayMode: integer);

implementation

{$R *.lfm}

uses QAUnit;

// **************** USEFUL FUNCTIONS ********************

procedure SetGrmFilename(s: string);
begin
  GrmFilename := s;
  Form1.VHeader.Caption := ' ' + Translate('GRM');
  if GrmFileExists then
    Form1.VHeader.Caption := Form1.VHeader.Caption + ' : ' + GrmFilename;
end;

function BodyStarts(): integer;
begin
  BodyStarts := 0;
  repeat
    BodyStarts := BodyStarts + 1;
  until (BodyStarts = Form1.GMemo.Lines.Count) or
    ((Form1.GMemo.Lines[BodyStarts] <> '') and
      (Form1.GMemo.Lines[BodyStarts][1] <> ' ') and
      (Form1.GMemo.Lines[BodyStarts][1] <> '#') and not
      (IsLeft('def', Form1.GMemo.Lines[BodyStarts])));
end;

function IndexToTopic(i: integer): integer;
begin
  if i = -1 then IndexToTopic := -1
  else
    IndexToTopic := LowerTopic + i;
end;




// *********** FORM HANDLING ***************

procedure UpdateScreen; forward;

procedure MakeTopicBox;
var
  i, j, MaxW: integer;
begin
  with Form1 do
  begin

    //We figure out how large it should be to accommodate the topic/property names
    Canvas.Font := Font;
    MaxW := 0;
    for i := seDatastarts to LastTopic do
      MaxW := Max(MaxW, 60 + TopicBox.Canvas.TextWidth(TrimDirective(TopicName[i])));
    THeader.Width := MaxW;

    TopicBox.Items.Clear;
    SomethingChecked := False;
    for i := LowerTopic to UpperTopic do
    begin
      TopicBox.Items.Add(TrimDirective(TopicName[i]));
      TopicBox.Checked[i - LowerTopic] := TopicsToDisplay[i];
      for j := TopicStart(i) to TopicEnd[i] do
      begin
        InUse[j] := TopicsToDisplay[i] and not IsLeft(VcbEntry[1, j], '¶');
        if InUse[j] then  EntryNumber := EntryNumber + 1;
        SomethingChecked := SomethingChecked or InUse[j];
      end;
    end;
  end;
end;

procedure SetFonts;
var
  i: integer;
  tempflag: boolean;
  bsize: integer;
begin
  with Form1 do

  begin

    tempflag := GrmUnsavedChangesExist;

    // Set all body text elements to mainfont.

    WMemo.Font.Name := MainFont;
    GMemo.Font.Name := MainFont;
    TopicCombo.Font.Name := MainFont;
    WordCombo.Font.Name := MainFont;
    DataEdit.Font.Name := MainFont;
    GOut.Font.Name := MainFont;
    Report.Font.Name := MainFont;
    TopicBox.Font.Name := MainFont;
    Wallpaper.Font.Name := MainFont;

    // Set the sizes.
    WMemo.Font.Size := BaseFontSize;
    GMemo.Font.Size := BaseFontSize;
    TopicBox.Font.Size := BaseFontSize;
    TopicCombo.Font.Size := BaseFontSize;
    WordCombo.Font.Size := BaseFontSize;
    DataEdit.Font.Size := BaseFontSize;
    GOut.Font.Size := BaseFontSize;
    Report.Font.Size := BaseFontSize;
    TopicBox.Font.Size := BaseFontSize;
    Wallpaper.Font.Size := BaseFontSize;

    bsize := Wallpaper.Canvas.TextWidth('• ');
    WMemo.UpdateFonts(MainFont, TitleFont, BaseFontSize, bsize);

    Form1.GMemo.Lines.BeginUpdate;
    for i := 0 to Form1.GMemo.Lines.Count - 1 do Form1.GMemo.TouchLine(i);
    Form1.GMemo.Lines.EndUpdate;
    Form1.GMemo.Visible := (ViewMode = VIEW_GRAMMAR);
    GrmUnsavedChangesExist := tempflag;

  end;

end;

procedure SetUpTabs; forward;

function SmartUtf16Pos(SearchForText, SearchInText: WideString; n: integer): integer;
begin
  SmartUtf16Pos := Utf16Pos(SearchForText, SearchInText, n);
  if SmartUtf16Pos = 0 then SmartUtf16Pos := Utf16Length(SearchInText);
end;

procedure DisplayVocab(DisplayMode: integer);
var
  i, j: integer;
  EmdashPosition: integer;
  UtfStart, UtfPlus: integer;
  StrPlus: WideString;
  PType: integer;
  Pic: TPicture;
  ip: TRichMemoInlinePicture;
  sz: TSize;
  histart, hiend: integer;
  HighlightTag: WideString;
  TaglessLength: integer;
  ThingToAdd: WideString;
begin
  with Form1 do
  begin
    WMemo.Lines.BeginUpdate;
    WMemo.Clear;
    WMemo.ResetPictures;
    WMemo.Lines.Add('');
    WMemo.MarkUp(0, 1, psPadding);
    UtfStart := 1;
    ScrollTo := 0;
    for i := LowerTopic to UpperTopic do
      if (DisplayMode = DISPLAY_ALL) or
        (TopicsToDisplay[i] and ((DisplayMode = DISPLAY_SELECTED) or
        ((DisplayMode = DISPLAY_NONVOCAB) and not HasVocab(i)))) // For closed-book tests.
      then
      begin

        // Show the heading.

        StrPlus := Decode(TopicName[i], '#');
        if (DisplayMode = DISPLAY_SELECTED) then StrPlus := TrimDirective(StrPlus);
        WMemo.Lines.Add(StrPlus);
        UtfPlus := Utf16Length(StrPlus) + 1;
        if i - LowerTopic = TopicBox.ItemIndex then ScrollTo := WMemo.Lines.Count - 1;
        if (0 < i) and (i < VocabStarts) then
          WMemo.MarkUp(UtfStart, UtfPlus, psSetting);
        if i = VocabStarts then WMemo.MarkUp(UtfStart, UtfPlus, psTitle);
        if i = seSettingsHeader then
          WMemo.MarkUp(UtfStart, UtfPlus, psSettingsHeader);
        if i > VocabStarts then WMemo.MarkUp(UtfStart, UtfPlus, psTopic);
        UtfStart := UtfStart + UtfPlus;
        // And the contents.
        for j := TopicStart(i) to TopicEnd[i] do
        begin
          if IsLeft(EntryToString(j), '¶') then
          begin
            StrPlus :=
              Decode(Utf8Copy(EntryToString(j), 2, Length(EntryToString(j)) - 1), '#');
            if IsLeft(StrPlus, 'img : ') and (ViewMode = VIEW_MAIN) then
              try
                WMemo.AddPicture(Split(StrPlus, 'img : ', 2), UtfStart);
                WMemo.Markup(UtfStart, 1, psPicture);
                UtfStart := UtfStart + 2;
              except
                StrPlus := Translate('NOPIC');
                UtfPlus := Utf16Length(StrPlus) + 1;
                WMemo.Lines.Add(StrPlus);
                UtfPlus := Utf16Length(StrPlus) + 1;
              end
            else
            begin
              UtfPlus := Utf16Length(StrPlus) + 1;
              if (i >= VocabStarts) then
              begin
                if ViewMode = VIEW_MAIN then
                begin

                  // We do the bold, italic, etc tags.

                  histart := 1;
                  WMemo.Lines.Add('');
                  TaglessLength := 0;
                  repeat

                    // We get text up until the first tag or EOL.

                    hiend := histart;
                    repeat
                      hiend := SmartUtf16Pos('<', StrPlus, hiend);
                      if not ((hiend + 2 <= Utf16Length(StrPlus)) and
                        (StrPlus[hiend + 2] = Utf8ToUtf16('>'))) then
                        hiend := hiend + 1;
                    until (hiend >
                        Utf16Length(StrPlus)) or
                      ((StrPlus[hiend] = Utf8ToUtf16('<')) and (hiend + 2 <= Utf16Length(StrPlus)) and
                        (StrPlus[hiend + 2] = Utf8ToUtf16('>')));

                    // We add it to the end of the text.
                    ThingToAdd :=
                      Utf16Copy(StrPlus, histart, hiend - histart);
                    WMemo.InDelText(ThingToAdd, UtfStart + TaglessLength, 0);
                    WMemo.Markup(UtfStart + TaglessLength,
                      Utf16Length(ThingToAdd), psPara);
                    TaglessLength := TaglessLength + Utf16Length(ThingToAdd);

                    // If it's not the EOL then we look for a close tag or EOL.

                    if hiend <= Utf16Length(StrPlus) then
                    begin
                      HighlightTag := Utf16Copy(StrPlus, hiend + 1, 1);
                      histart := hiend + 3;         // 3 = Length of tag.
                      hiend :=
                        SmartUtf16Pos('</' + HighlightTag + '>', StrPlus, histart);

                      // We add it to the end of the text.

                      ThingToAdd :=
                        Utf16Copy(StrPlus, histart, hiend - histart);
                      WMemo.InDelText(ThingToAdd, UtfStart +
                        TaglessLength, 0);

                      if HighlightTag = 'i' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psItalic);
                      if HighlightTag = 'b' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psBold);
                      if HighlightTag = 'u' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psUnderline);
                      if HighlightTag = 'y' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psYellow);
                      if HighlightTag = 'g' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psGreen);
                      if HighlightTag = 'p' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psPink);
                      if HighlightTag = 'S' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psSuperscript);
                      if HighlightTag = 's' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psSubscript);
                      if HighlightTag = 'm' then
                        WMemo.Markup(UtfStart + TaglessLength,
                          Utf16Length(ThingToAdd), psMonospace);

                      TaglessLength :=
                        TaglessLength + Utf16Length(ThingToAdd);

                      histart := hiend + 4;   // 4 = Length of close tag.
                      hiend := histart;
                    end;

                    // And loop.

                  until hiend > Utf16Length(StrPlus);


                  UtfPlus := TaglessLength + 1;
                end
                else
                begin
                  WMemo.Lines.Add(StrPlus);
                  WMemo.Markup(UtfStart + 1, UtfPlus, psPara);
                end;
              end
              else
              begin
                WMemo.Lines.Add(StrPlus);
                if (i in [seAboutVlist, seKeysHelp]) then
                  WMemo.Markup(UtfStart, UtfPlus, psPlain);
                if (i in [seLang1Keys, seLang2Keys]) then
                  WMemo.Markup(UtfStart, UtfPlus, psKBody);
                if (i = seQuestionFormats) then
                  WMemo.Markup(UtfStart, UtfPlus, psQBody);
                if not ((i >= VocabStarts) or
                  (i in [seAboutVlist, seKeysHelp, seLang1Keys,
                  seLang2Keys, seQuestionFormats])) then
                  WMemo.Markup(UtfStart, UtfPlus, psFixed);

              end;

              if IsLeftWidestring(StrPlus, Utf8ToUtf16('•')) then
                WMemo.SetParaMetric(UtfStart, UtfPlus, Metrics[psBullet]);

              UtfStart := UtfStart + UtfPlus;

            end;
          end
          else
          begin   // Not paragraph text.
            if (i >= VocabStarts) or
              (i in [seQuestionFormats, seLang1Keys, seLang2Keys]) then
            begin
              if DisplayMode = DISPLAY_ALL then
              begin
                StrPlus := Decode(EntryToString(j), '#');
                WMemo.Lines.Add(StrPlus);
                UtfPlus := Utf16Length(StrPlus) + 1;
              end
              else
              begin
                StrPlus := Decode(EntryToShortString(j), '#');
                WMemo.Lines.Add(StrPlus);
                UtfPlus := Utf16Length(StrPlus) + 1;
              end;
              if i = seQuestionFormats then
                WMemo.MarkUp(UtfStart, UtfPlus, psQForms);
              if (i >= VocabStarts) then WMemo.MarkUp(UtfStart, UtfPlus, psVocab);
              if (i in [seLang1Keys, seLang2Keys]) then
                WMemo.MarkUp(UtfStart, UtfPlus, psKeys);
              // Special handling for the [DEFAULT] question format.
              if VcbEntry[1, j] = '#[DF]' then
              begin
                EmdashPosition := Utf16Pos(Utf8ToUtf16(' — '), StrPlus);
                WMemo.MarkUp(UtfStart, EmdashPosition + 1, psPrompt);
              end;
            end;
            // Otherwise we're in the settings, with an entry with a fixed LHS.
            if not ((i >= VocabStarts) or
              (i in [seQuestionFormats, seLang1Keys, seLang2Keys])) then
            begin
              StrPlus := Decode(EntryToShortString(j), '#');
              WMemo.Lines.Add(StrPlus);
              UtfPlus := Utf16Length(StrPlus) + 1;
              EmdashPosition := Utf16Pos(Utf8ToUtf16(' — '), StrPlus);
              if EmdashPosition = 0 then
              begin
                WMemo.MarkUp(UtfStart, UTFPlus, psPrompt);
                if IsLeft(StrPlus, '■') or
                  IsLeft(StrPlus, '□') or IsLeft(StrPlus, '●') or
                  IsLeft(StrPlus, '○') then
                  WMemo.Markup(UtfStart, 2, psBool);
              end
              else
              begin
                WMemo.MarkUp(UtfStart, EmdashPosition + 1, psPrompt);
                WMemo.MarkUp(UTFStart + EmdashPosition + 1,
                  UtfPlus - EmdashPosition - 1, psEntry);
              end;
            end;

            UtfStart := UtfStart + UtfPlus;
          end;  // of non-paragraph text.
        end; // of loop through topic
      end; // of loop though topics.
    WMemo.MarkUp(UtfStart, 3, psPara);
    if MenuEditVcb.Checked and (UpperTopic = VocabStarts) and
      (TopicSize(VocabStarts) = 0) then
    begin    // ... then we need somewhere for the user to start typing.
      WMemo.Lines.Add('');
      WMemo.Markup(UtfStart - 1, 1, psPara);
    end;
    if i - LowerTopic < TopicBox.ItemIndex then ScrollTo := WMemo.Lines.Count - 1;
    if UpperTopic < VocabStarts then
      WMemo.Markup(WMemo.XYtoX(0, WMemo.Lines.Count - 1), 2, psFixed);
    WMemo.CaretPos := Point(0, 0);
    WMemo.Perform(EM_SCROLLCARET, 0, 0);
    WMemo.Lines.EndUpdate;
  end; // of with Form1.
  SetUpTabs;
end;


procedure HideEverything;
begin
  with Form1 do
  begin
    DataEdit.Hide;
    GMemo.Hide;
    GKeyGroup.Hide;
    GetDataLabel.Hide;
    TopicCombo.Hide;
    WordCombo.Hide;
    DataLabel.Hide;
    GOutLabel.Hide;
    GOut.Hide;
    ReportLabel.Hide;
    Report.Hide;
    GRefresh.Hide;
    THeader.Hide;
    TopicBox.Hide;
    VHeader.Hide;
    ButtonPractice.Hide;
    ButtonAssignment.Hide;
    TestButton.Hide;
    WMemo.Hide;             // The RichMemo components don't like shutting down
    WMemo.Anchors := [];    // sometimes and this helps. IdkY.
    WMemo.Height := 0;
    WMemo.Width := 0;
    WMemo.Anchors := [akTop, akLeft, akBottom, akRight];
    Form1.GMemo.Anchors := [];
    Form1.GMemo.Height := 0;
    Form1.GMemo.Width := 0;
    Form1.GMemo.Anchors := [akTop, akLeft, akBottom, akRight];
  end;
  Application.ProcessMessages;
end;

procedure UpdateScreen;

begin
  with Form1 do
  begin
    if IsHex(GetValue('BCOLOR')) then
      Color := Hex2Dec(GetValue('BCOLOR'))
    else
      Color := clDefault;
    Refresh;

    // Positioning items

    if AssignmentType = 2 then
    begin
      ButtonAssignment.BorderSpacing.Left := 0;
      ButtonAssignment.Width := (Form1.Width - 36) div 2;
      ButtonPractice.Width := 0;
    end
    else
    begin
      ButtonAssignment.BorderSpacing.Left := 12;
      ButtonAssignment.Width := (Form1.Width - 48) div 3;
      ButtonPractice.Width := ButtonAssignment.Width;
    end;

    // Making stuff visible or invisible, other changes of appearance that aren't size or position
    DataEdit.Visible := MenuEditGrm.Checked;
    // If you put this further down it conflicts with making the topic box and word box visible fml.
    GMemo.Visible := MenuEditGrm.Checked;
    GKeyGroup.Visible := MenuEditGrm.Checked;
    GetDataLabel.Visible := MenuEditGrm.Checked;
    TopicCombo.Visible := MenuEditGrm.Checked;
    WordCombo.Visible := MenuEditGrm.Checked;
    DataLabel.Visible := MenuEditGrm.Checked;
    GOutLabel.Visible := MenuEditGrm.Checked;
    GOut.Visible := MenuEditGrm.Checked;
    ReportLabel.Visible := MenuEditGrm.Checked;
    Report.Visible := MenuEditGrm.Checked;
    GRefresh.Visible := MenuEditGrm.Checked;

    if MenuMainScreen.Checked or MenuEditVcb.Checked then
    begin
      THeader.Caption := ' ' + Translate('L5MS');
      if Filename = '' then VHeader.Caption := ' ' + Translate('UNTF')
      else
        VHeader.Caption := ' ' + Split(ExtractFileName(Filename), '.', 1);
    end;
    if MenuEditGrm.Checked then
    begin
      Form1.VHeader.Caption := ' ' + Translate('GRM');
      if GrmFileExists then
        Form1.VHeader.Caption := Form1.VHeader.Caption + ' : ' + GrmFilename;
    end;
    if MenuEditSettings.Checked then
      VHeader.Caption := ' ' + Translate('SETT');

    THeader.Visible := MenuMainScreen.Checked and DataExists;
    TopicBox.Visible := THeader.Visible;
    VHeader.Visible := DataExists or MenuEditGrm.Checked;
    if MenuMainScreen.Checked then
      if Translate('Direction') = '<-' then
      begin
        THeader.Anchors := [akTop, akRight];
        THeader.AnchorParallel(akRight, 12, Form1);
        VHeader.AnchorToNeighbour(akRight, 12, THeader);
        VHeader.AnchorParallel(akLeft, 12, Form1);
      end
      else
      begin
        THeader.Anchors := [akTop, akLeft];
        THeader.AnchorParallel(akLeft, 12, Form1);
        VHeader.AnchorToNeighbour(akLeft, 12, THeader);
        VHeader.AnchorParallel(akRight, 12, Form1);
      end;

    if not MenuMainScreen.Checked then VHeader.AnchorParallel(akLeft, 12, Form1);
    if not MenuMainScreen.Checked then VHeader.AnchorParallel(akRight, 12, Form1);

    if Translate('Direction') = '<-' then
      Form1.BidiMode := bdRightToLeft
    else
      Form1.BidiMode := bdLeftToRight;

    TestButton.Visible := MenuMainScreen.Checked and SomethingChecked and not
      AssignmentExists and not TestStarted;

    ButtonPractice.Visible := MenuMainScreen.Checked and SomethingChecked and
      AssignmentExists and (AssignmentType <> 3) and not TestStarted;
    ButtonAssignment.Visible := MenuMainScreen.Checked and SomethingChecked and
      AssignmentExists and not TestStarted;

    if AssignmentComplete then ButtonAssignment.Caption := Translate('ButAsmR')
    else
      ButtonAssignment.Caption := Translate('ButAsm');

    WMemo.ReadOnly := (ViewMode = VIEW_MAIN);

    if TopicBox.Visible then TopicBox.Enabled := not AssignmentExists;

    WMemo.Visible := (MenuMainScreen.Checked or MenuEditVcb.Checked or
      MenuEditSettings.Checked) and DataExists;

    // Turn the menu items on or off.
    // Subitems are are made visible / enabled when you click on the menu headings.
    MenuFile.Visible := (LockStr[lkFileMenu] = 'N');
    MenuOptions.Visible := (LockStr[lkTestOptions] = 'N') or
      (LockStr[lkAppearanceOptions] = 'N') or
      (LockStr[lkUpdateOptions] = 'N') or
      (LockStr[lkLockdownOptions] = 'N');
    MenuView.Visible := (LockStr[lkEditing] = 'N');
    MenuUser.Visible := (LockStr[lock_user_menu] = 'N');
    MenuClassroom.Visible := (LockStr[lkClassroomMenu] = 'N') or (Status = USER_SOLO);

    if MenuOptions.Visible then MenuOptions.Enabled := not AssignmentExists;
    if MenuView.Visible then MenuView.Enabled := not AssignmentExists;
    if MenuUser.Visible then MenuUser.Enabled := not AssignmentExists;
    if MenuClassroom.Visible then MenuClassroom.Enabled := not AssignmentExists;

  end;
  Application.ProcessMessages;
end;

// We turn bits of the menus on and off, triggered by clicking on the menu bar,
// so the header updates the subitems.

procedure TForm1.MenuFileClick(Sender: TObject);
begin
  MenuOpen.Visible := not (AssignmentExists);
  MenuSave.Visible := not ((LockStr[lkRestrictFileMenu] = 'Y') or AssignmentExists);
  MenuSaveAs.Visible := not ((LockStr[lkRestrictFileMenu] = 'Y') or AssignmentExists);
  MenuRevert.Visible := not ((LockStr[lkRestrictFileMenu] = 'Y') or AssignmentExists);
  MenuPublish.Visible := not ((LockStr[lkRestrictFileMenu] = 'Y') or
    (LockStr[lkPublish] = 'Y') or AssignmentExists);
  MenuNew.Visible := not (MenuEditGrm.Checked or (LockStr[lkRestrictFileMenu] = 'Y') or
    AssignmentExists or TestStarted);
  if MenuOpen.Visible then MenuOpen.Enabled := not TestStarted;
  if MenuSave.Visible then MenuSave.Enabled :=
      (MenuEditGrm.Checked and GrmFileExists and GrmUnsavedChangesExist) or
      ((not MenuEditGrm.Checked) and DataExists and VcbFileExists and UnsavedChangesExist);
  if MenuSaveAs.Visible then MenuSaveAs.Enabled :=
      (MenuEditGrm.Checked) or ((not MenuEditGrm.Checked) and DataExists);
  if MenuRevert.Visible then MenuRevert.Enabled :=
      (MenuEditGrm.Checked and GrmFileExists and GrmUnsavedChangesExist) or
      ((not MenuEditGrm.Checked) and DataExists and VcbFileExists and
      UnsavedChangesExist and not TestStarted);
  if MenuNewFileKeepSettings.Visible then MenuNewFileKeepSettings.Enabled :=
      DataExists and not TestStarted;
  if MenuNewFileNewSettings.Visible then MenuNewFileNewSettings.Enabled := not TestStarted;
  MenuNewGrm.Visible := MenuEditGrm.Checked;
  if MenuClose.Visible then MenuClose.Enabled :=
      (MenuEditGrm.Checked) or ((not MenuEditGrm.Checked) and DataExists);
end;

procedure TForm1.MenuOptionsClick(Sender: TObject);
begin
  MenuTestOptions.Visible := (LockStr[lkTestOptions] = 'N');
  MenuAppearanceOptions.Visible := (LockStr[lkAppearanceOptions] = 'N');
  MenuUpdateOptions.Visible := (LockStr[lkUpdateOptions] = 'N');
  MenuLockdownOptions.Visible := (LockStr[lkLockdownOptions] = 'N');
end;

procedure TForm1.MenuViewClick(Sender: TObject);
begin
  if MenuEditSettings.Visible then MenuEditSettings.Enabled := DataExists;
  if MenuEditVcb.Visible then MenuEditVcb.Enabled := DataExists;
end;


procedure TForm1.MenuUserClick(Sender: TObject);
begin
  // Make this concise now.
  case Status of
    USER_SOLO: begin
      MenuSoloUser.Checked := True;
    end;
    USER_STUDENT: begin
      MenuStudent.Checked := True;
      MenuManageClasses.Visible := False;
      MenuAssignWork.Visible := False;
      MenuGradebook.Visible := False;
      MenuDualDivider.Visible := False;
      MenuClasses.Visible := True;
      MenuAssignments.Visible := True;
      MenuClasses.Enabled := SignedIn;
      MenuAssignments.Enabled := SignedIn;
    end;
    USER_MULTIPLE: begin
      MenuMultipleStudents.Checked := True;
      MenuManageClasses.Visible := False;
      MenuAssignWork.Visible := False;
      MenuGradebook.Visible := False;
      MenuDualDivider.Visible := False;
      MenuClasses.Visible := True;
      MenuAssignments.Visible := True;
      MenuClasses.Enabled := SignedIn;
      MenuAssignments.Enabled := SignedIn;
    end;
    USER_TEACHER: begin
      MenuTeacher.Checked := True;
      MenuManageClasses.Visible := True;
      MenuAssignWork.Visible := True;
      MenuGradebook.Visible := True;
      MenuManageClasses.Enabled := SignedIn;
      MenuAssignWork.Enabled := SignedIn;
      MenuGradebook.Enabled := SignedIn;
      MenuDualDivider.Visible := False;
      MenuClasses.Visible := False;
      MenuAssignments.Visible := False;
    end;
    USER_DUAL: begin
      MenuDualUser.Checked := True;
      MenuManageClasses.Visible := True;
      MenuAssignWork.Visible := True;
      MenuGradebook.Visible := True;
      MenuManageClasses.Enabled := SignedIn;
      MenuAssignWork.Enabled := SignedIn;
      MenuGradebook.Enabled := SignedIn;
      MenuDualDivider.Visible := True;
      MenuClasses.Visible := True;
      MenuAssignments.Visible := True;
      MenuClasses.Enabled := SignedIn;
      MenuAssignments.Enabled := SignedIn;
    end;
  end;
  MenuChangePassword.Enabled := SignedIn;
  MenuChangeEmail.Enabled := SignedIn;
end;

procedure TForm1.MenuClassroomClick(Sender: TObject);
begin
  MenuRegister.Enabled := not SignedIn;
  MenuSignIn.Visible := not SignedIn;
  MenuForgotPassword.Visible := not SignedIn;
  MenuSignOut.Visible := SignedIn;
  MenuNotifications.Enabled := SignedIn;
  MenuUserClick(MenuClassroom);
end;

procedure TForm1.MenuHelpClick(Sender: TObject);
begin
  MenuAboutVcb.Enabled := DataExists and (TopicSize(seAboutVlist) > 0);
  MenuKeyboardHelp.Enabled := DataExists and (TopicSize(seKeysHelp) > 0);
end;

procedure TForm1.MenuAlwaysUpdateClick(Sender: TObject);
begin
  MenuNeverUpdate.Checked := False;
  MenuAlwaysAsk.Checked := False;
  UpdateSetting := 0;
end;

procedure TForm1.MenuNeverUpdateClick(Sender: TObject);
begin
  MenuAlwaysUpdate.Checked := False;
  MenuAlwaysAsk.Checked := False;
  UpdateSetting := 1;
end;

procedure TForm1.MenuAlwaysAskClick(Sender: TObject);
begin
  MenuAlwaysUpdate.Checked := False;
  MenuNeverUpdate.Checked := False;
  UpdateSetting := 2;
end;

procedure TForm1.MenuLatestVersionClick(Sender: TObject);
begin
  MenuStableVersion.Checked := False;
  VersionSetting := 0;
end;

procedure TForm1.MenuStableVersionClick(Sender: TObject);
begin
  MenuLatestVersion.Checked := False;
  VersionSetting := 1;
end;



procedure TForm1.FormChangeBounds(Sender: TObject);
begin
  ButtonPractice.Width := (Form1.Width - 48) div 3;
  ButtonAssignment.Width := ButtonPractice.Width;
end;


procedure TForm1.FormPaint(Sender: TObject);
begin
  if (Form1.MenuMainScreen.Checked and not DataExists) then
  begin
    Form1.Canvas.Brush.BitMap := Wallpaper.Picture.Bitmap;
    Form1.Canvas.FillRect(Rect(0, 0, Form1.Width, Form1.Height));
  end;
end;

procedure TForm1.GKeyGroupItemClick(Sender: TObject; Index: integer);
begin
  GKeyGroup.Checked[1 - Index] := False;
  GMemo.Mode := MM_NORMAL;
  if GKeyGroup.Checked[0] then GMemo.Mode := MM_L1;
  if GKeyGroup.Checked[1] then GMemo.Mode := MM_L2;
end;

// ************* FILE HANDLING AND FORMCREATE *******

procedure OpenRscFile forward;

procedure SaveAll; forward;

procedure Wipe;

// A general cleanser of things. It declares the word list empty
// and resets the state memory from the effects of overrides in the .vcb
// file or of an assignment.

var
  i: integer;
begin
  for i := seDatastarts to LastTopic do TopicsToDisplay[i] := False;
  LastTopic := BASEMENT;
  for i := 1 to 10000 do InUse[i] := False;
  SelectedEntry := 0;
  SelectedTopic := BASEMENT;
  Form1.TopicBox.Items.Clear;
  UnsavedChangesExist := False;
  Form1.Color := clDefault;

  SomethingChecked := False;
  DataExists := False;
  UnsavedChangesExist := False;
  Form1.MenuMainScreen.Checked := True;
  TestStarted := False;
  Form1.TopicBox.ItemIndex := -1;
  TopicBoxFlag := False;

  QOGroup_i := QOGroup_b;
  WOSL1_i := WOSL1_b;
  WOSL2_i := WOSL2_b;
  WOFGroup_i := WOFGroup_b;
  CheckCFBT_i := CheckCFBT_b;
  Scrollbar1_i := Scrollbar1_b;
  MainFont := Mainfont_b;
  TitleFont := TitleFont_b;
  BaseFontSize := Fontsize3_b;
  SetFonts;
  LockStr := LockdownBackup;
  Form1.DataEdit.Text := '';
  Form1.TopicCombo.Text := Translate('TP');
  Form1.WordCombo.Text := Translate('VC');
  Form1.MenuMainScreen.Checked := True;

  if AssignmentExists then
    with Form1 do
    begin
      AssignmentExists := False;
      OpenRscFile;              // We saved this before loading the assignment.
    end;

end;

procedure GrammarCheck(PythonName: string; var E: string; var Enumber: integer);
var
  f: TextFile;
  Pr: TProcess;
begin
  ;
  AssignFile(f, HomeDirectory + 'Resources\File transfer\patogc.rsc');
  Rewrite(f);
  WriteLn(f, PythonName);
  CloseFile(f);

  Pr := TProcess.Create(nil);
  Pr.Executable := HomeDirectory + 'Resources\Python\python.exe';
  Pr.Parameters.Add(HomeDirectory + 'Resources\Syntax checker\gcheck.py');
  Pr.Options := Pr.Options + [poWaitOnExit];
  Pr.ShowWindow := swoHide;
  Pr.Execute;
  Pr.Free;

  AssignFile(f, HomeDirectory + 'Resources\File transfer\gctopa.rsc');
  Reset(f);
  ReadLn(f, E);
  ReadLn(f, Enumber);
  CloseFile(f);
end;

procedure ValidateAudio;
var
  Pr: TProcess;
  i: integer;
begin
  for i := 1 to 2 do
  begin
    IsAudio[i] := False;
    if AudioID(i) <> '' then  // This check is here because otherwise the test
    begin                   // of Balabolka would fail hard.
      if IsLeft(AudioID(i), 'eS#') then IsAudio[i] := True
      else
      begin
        Pr := TProcess.Create(nil);
        Pr.Executable := HomeDirectory + 'Resources\Balabolka\balcon.exe';
        Pr.Parameters.Add('-t " - "');
        Pr.Parameters.Add('-id "' + AudioID(i) + '"');
        Pr.ShowWindow := swoHide;
        Pr.Options := Pr.Options + [poWaitOnExit];
        Pr.Execute;
        IsAudio[i] := (Pr.ExitCode = 0);
        Pr.Free;
      end;
    end;
  end;
  if not IsAudio[1] then WOSL1_i := 0;
  if not IsAudio[2] then WOSL2_i := 0;
end;

procedure GrmToPy(GrmName: string; Source: boolean);
var
  f, g: TextFile;
  i: integer;
  s: string;
  // Does what it says, converts a .grm file in the Grammar folder to a .py file
  // in the Resources folder.

begin
  AssignFile(f, HomeDirectory + 'Resources\Py files\' + GrmName + '.py');
  Rewrite(f);

  for i := 0 to Form1.Sybil_A.Lines.Count - 1 do
    WriteLn(f, Form1.Sybil_A.Lines[i]);

  if Source = FROM_DISC then
  begin
    AssignFile(g, HomeDirectory + 'Grammar plugins\' + GrmName + '.grm');
    Reset(g);
    while not EOF(g) do
    begin
      ReadLn(g, s);
      WriteLn(f, '    ' + s);
    end;
    CloseFile(g);
  end
  else
    for i := 0 to Form1.GMemo.Lines.Count - 1 do WriteLn(f, '    ' + Form1.GMemo.Lines[i]);

  for i := 0 to Form1.Sybil_B.Lines.Count - 1 do
    WriteLn(f, Form1.Sybil_B.Lines[i]);

  CloseFile(f);
end;

// So. If it just bounced you back to the grammar menu if there was a .grm
// plugin with a syntax error, that would be officious and annoying. Instead it
// replaces the .py translation of the .grm plugin with a syntactically-correct
// .py program which returns default values and a syntax error when called.
procedure ConvertAllGrmToPy;
var
  i, Enumber: integer;
  E: string;
  f: TextFile;
  Converted: TStringList;
begin
  Converted := TStringList.Create;
  for i := VocabStarts to LastTopic do
    if (FileExists(HomeDirectory + 'Grammar plugins\' + TopicNumberToGrmFilename(i) +
      '.grm')) and (Converted.IndexOf(TopicNumberToGrmFilename(i)) = -1) then
    begin
      Converted.Add(TopicNumberToGrmFilename(i));
      GrmToPy(TopicNumberToGrmFilename(i), FROM_DISC);
      GrammarCheck(TopicNumberToGrmFilename(i), E, Enumber);
      if E <> '' then
      begin
        AssignFile(f, HomeDirectory + 'Resources\Py files\' +
          TopicNumberToGrmFilename(i) + '.py');
        Rewrite(f);
        WriteLn(f, 'import os');
        WriteLn(f, 'import io');
        WriteLn(f, 'import sys');
        WriteLn(f, 'current_directory = os.getcwd()');
        WriteLn(f, 'os.chdir(current_directory+"\Resources\File transfer")');
        WriteLn(f, 'with io.open("patopy.rsc", "r", encoding="utf-8") as file:');
        WriteLn(f, '    data_in = file.readlines()');
        WriteLn(f, 'W=[]');
        WriteLn(f, 'W.append(data_in[4].rstrip())');
        WriteLn(f, 'W.append(data_in[5].rstrip())');
        WriteLn(f, 'with io.open("pytopa.rsc", "w", encoding="utf-8") as file:');
        WriteLn(f, '    file.write("\n")');
        WriteLn(f, '    file.write(W[0]+"\n")');
        WriteLn(f, '    file.write(W[1]+"\n")');
        WriteLn(f, '    file.write("' + E + '\n")');
        WriteLn(f, '    file.write("' + IntToStr(Enumber) + '\n")');
        WriteLn(f, '    file.write("\n")');
        CloseFile(f);
      end;
    end;
  Converted.Free;
end;



procedure DoOverrides;
var
  i: integer;
begin

  if (Screen.Fonts.IndexOf(GetValue('POFont')) <> -1) then MainFont := GetValue('POFont');
  if (Screen.Fonts.IndexOf(GetValue('TIFont')) <> -1) then
    TitleFont := GetValue('TIFont');
  if IsDecimal(GetValue('POSize3')) then BaseFontSize := StrToInt(GetValue('POSize3'));
  if IsHex(GetValue('BCOLOR')) then Form1.Color := Hex2Dec(GetValue('BCOLOR'));

  if BooleanValue('01') then QOGroup_i := 0;
  if BooleanValue('02') then QOGroup_i := 1;
  if BooleanValue('03') then QOGroup_i := 2;
  if BooleanValue('04') then QOGroup_i := 3;

  if BooleanValue('WSW1') then WOSL1_i := 0;
  if BooleanValue('WSS1') then WOSL1_i := 1;

  if BooleanValue('WSW2') then WOSL2_i := 0;
  if BooleanValue('WSS2') then WOSL2_i := 1;

  if BooleanValue('WFW') then WOFGroup_i := 0;
  if BooleanValue('WFF') then WOFGroup_i := 1;

  if BooleanValue('TO3Y') then CheckCFBT_i := 1;
  if BooleanValue('TO3N') then CheckCFBT_i := 0;

  if IsDecimal(GetValue('TO4')) and (StrToInt(GetValue('TO4')) in [0..100]) then
    Scrollbar1_i := StrToInt(GetValue('TO4'));

  for i := 2 to LockdownCount do
    if BooleanValue('Lo' + IntToStr(i)) then LockStr[i] := 'Y';

  SetFonts;
  UpdateScreen;

  // A change of fonts destroys the formatting of the rich memos, which must be replaced.
  Form1.GMemo.Lines.BeginUpdate;
  for i := 0 to Form1.GMemo.Lines.Count - 1 do Form1.GMemo.TouchLine(i);
  Form1.GMemo.Lines.EndUpdate;
  Form1.GMemo.Visible := (ViewMode = VIEW_GRAMMAR);
  // Everything else will be fixed when we DisplayVocab from whatever's calling this.

end;

procedure DoOpenVcb(var f: TextFile);
var
  s: string;
  j: integer;
begin
  Form1.Cursor := crHourglass;
  Reset(f);
  LastTopic := BASEMENT;
  j := 0;
  TopicEnd[LastTopic] := j;
  while not EOF(f) do
  begin
    ReadLn(f, s);
    if s <> '' then    //blank lines are ignored
    begin
      if IsLeft(s, '§') then          // then we got ourselves a topic heading
      begin
        LastTopic := LastTopic + 1;
        TopicName[LastTopic] := Split(s, '§', 2);
      end
      else                // otherwise it's an entry to be filed under the present topic
      begin
        j := j + 1;
        StringToEntry(s, j, LastTopic);
      end;
    end;
    TopicEnd[LastTopic] := j;
  end;
  ConvertAllGrmToPy;
  ValidateAudio;
  Form1.MenuMainScreen.Checked := True;
  LowerTopic := VocabStarts;
  UpperTopic := LastTopic;
  MakeTopicBox;
  DoOverrides;
  DisplayVocab(DISPLAY_SELECTED);
  DataExists := True;
  VcbFileExists := True;
  UnsavedChangesExist := False;
  UpdateScreen;
  Form1.Cursor := crArrow;
end;

procedure OpenLanguage;
var
  f: TextFile;
  s: string;
  MaxW: integer;
begin

  // Does the internationalization. Boring.

  // The font metadata is NOT applied here, it only takes effect when the
  // end-user first manually selects an application language.

  GetLanguage(HomeDirectory + 'Internationalization\' + AppLang + '.lng');

  with Form1 do
  begin

    // Make the form right-to-left if necessary.

    if (Translate('Direction') = '<-') then
      BidiMode := bdRightToLeft
    else
      BidiMode := bdLeftToRight;



    // Set the menu bar

    MenuFile.Caption := Translate('MFile');
    MenuOpen.Caption := Translate('MOpen');
    MenuSave.Caption := Translate('MSave');
    MenuSaveAs.Caption := Translate('MSaveAs');
    MenuRevert.Caption := Translate('MRevert');
    MenuNew.Caption := Translate('MNew');
    MenuNewGrm.Caption := Translate('MNew');
    MenuNewFileNewSettings.Caption := Translate('MNFNS');
    MenuPublish.Caption := Translate('MPublish');
    MenuClose.Caption := Translate('MClose');
    MenuExit.Caption := Translate('MExit');

    MenuOptions.Caption := Translate('MOptions');
    MenuTestOptions.Caption := Translate('MTO');
    MenuAppearanceOptions.Caption := Translate('MPO');
    MenuLockdownOptions.Caption := Translate('MLO');
    MenuUpdateOptions.Caption := Translate('UPO');
    MenuNeverUpdate.Caption := Translate('Pref0');
    MenuAlwaysUpdate.Caption := Translate('Pref1');
    MenuAlwaysAsk.Caption := Translate('Pref2');
    MenuLatestVersion.Caption := Translate('Vers0');
    MenuStableVersion.Caption := Translate('Vers1');

    MenuView.Caption := Translate('MView');
    MenuMainScreen.Caption := Translate('MMS');
    MenuEditVcb.Caption := Translate('MEV');
    MenuEditSettings.Caption := Translate('MES');
    MenuEditGrm.Caption := Translate('MEGP');

    MenuHelp.Caption := Translate('MHelp');
    MenuAboutVcb.Caption := Translate('MATVL');
    MenuKeyboardHelp.Caption := Translate('MHKS');
    MenuAboutThisProgram.Caption := Translate('MATP');
    MenuCopyright.Caption := Translate('FLIC');

    MenuUser.Caption := Translate('MUser');
    MenuSoloUser.Caption := Translate('MUSU');
    MenuStudent.Caption := Translate('MUS');
    MenuMultipleStudents.Caption := Translate('MUMS');
    MenuTeacher.Caption := Translate('MUT');
    MenuDualUser.Caption := Translate('MUDU');

    MenuClassroom.Caption := Translate('MClassroom');
    MenuRegister.Caption := Translate('MCR');
    MenuSignIn.Caption := Translate('MCSI');
    MenuSignOut.Caption := Translate('MCSO');
    MenuForgotPassword.Caption := Translate('MCFP');
    MenuChangePassword.Caption := Translate('MCCP');
    MenuChangeEmail.Caption := Translate('MCCE');
    MenuClasses.Caption := Translate('MCC');
    MenuNotifications.Caption := Translate('MCN');
    MenuAssignments.Caption := Translate('MCA');
    MenuManageClasses.Caption := Translate('MCMC');
    MenuAssignWork.Caption := Translate('MCAH');
    MenuGradebook.Caption := Translate('MCTS');

    OpenVcbDialog.Title := Translate('ODT');
    OpenGrmDialog.Title := Translate('GODT');
    SaveVcbDialog.Title := Translate('SDT');
    SaveGrmDialog.Title := Translate('GSDT');
    ColorDialog1.Title := Translate('CDT');



    // Buttons and labels on the main screen.

    TestButton.Caption := Translate('ButtonST');
    ButtonPractice.Caption := Translate('ButPrac');
    ButtonQuitAssignment.Caption := (Translate('ButAsmC'));

    // The grammar editor.

    GMIndent.Caption := Translate('INDENT');
    GMUnindent.Caption := Translate('UNINDENT');
    GMFind.Caption := Translate('FIND');
    GMReplace.Caption := Translate('REPLACE');

    GetDataLabel.Caption := Translate('GDF');
    DataLabel.Caption := Translate('DATA');
    GOutLabel.Caption := Translate('RESULT');
    ReportLabel.Caption := Translate('REPORT');
    GKeyGroup.Caption := Translate('KB');

    TimeAMString := Translate('TimeAMString');
    TimePMString := Translate('TimePMString');

    // Then we may as well set the width of this bit here because it's in the system font, its width just depends on the text.
    MaxW := Max(Form1.Canvas.TextWidth(GetDataLabel.Caption),
      Form1.Canvas.TextWidth(DataLabel.Caption));
    MaxW := Max(MaxW, Form1.Canvas.TextWidth(GOutLabel.Caption));
    MaxW := Max(MaxW, Form1.Canvas.TextWidth(ReportLabel.Caption));

    GetDataLabel.Width := MaxW + Offset;

  end; // Of with Form1

end;

procedure OpenVcbFile;
var
  f: TextFile;
begin
  if not (FileExists(Filename)) then
  begin
    ShowMessage(Translate('CF1') + ' ''' + Filename + ''' ' + Translate('CF2'));
    Exit;
  end;

  AssignFile(f, Filename);
  DoOpenVcb(f);
  CloseFile(f);

  Form1.GMemo.Anchors := [];
  Form1.GMemo.Height := 0;
  Form1.GMemo.Width := 0;
  Form1.GMemo.Anchors := [akTop, akLeft, akBottom, akRight];

end;

procedure GetRscFile(var f: TextFile);
var
  s: string;
  i: integer;
  TopicDisplayStr, Greeting: string;
begin

  // This reads in most of the "state memory" from a file, either .rsc or .asm.

  ReadLn(f, Filename);
  ReadLn(f, QOGroup_i);
  ReadLn(f, WOSL1_i);
  ReadLn(f, WOSL2_i);
  ReadLn(f, WOFGroup_i);
  ReadLn(f, CheckCFBT_i);
  ReadLn(f, Scrollbar1_i);
  ReadLn(f, MainFont);
  ReadLn(f, TitleFont);
  ReadLn(f, BaseFontSize);
  ReadLn(f, LockStr);
  ReadLn(f, TopicDisplayStr);

  QOGroup_b := QOGroup_i;
  WOSL1_b := WOSL1_i;
  WOSL2_b := WOSL2_i;
  WOFGroup_b := WOFGroup_i;
  CheckCFBT_b := CheckCFBT_i;
  Scrollbar1_b := Scrollbar1_i;
  Mainfont_b := MainFont;
  TitleFont_b := TitleFont;
  Fontsize3_b := BaseFontSize;
  LockdownBackup := LockStr;

  for i := 1 to Length(TopicDisplayStr) do
    TopicsToDisplay[i - 1 + seDatastarts] := (TopicDisplayStr[i] = 'Y');

end;

procedure SaveAll;
var
  f: TextFile;
begin
  AssignFile(f, Filename);
  Rewrite(f);
  DoSave(f);
  CloseFile(f);
end;

procedure SchlurpWMemo forward;
procedure SchlurpSettings forward;

function SaveAs(): boolean;
begin
  if Form1.SaveVcbDialog.Execute then
  begin
    Filename := Form1.SaveVcbDialog.Filename;
    if ViewMode = VIEW_EDIT then SchlurpWMemo;
    TopicName[VocabStarts] := Split(ExtractFilename(Filename), '.', 1);
    MakeTopicBox;
    if ViewMode = VIEW_SETTINGS then SchlurpSettings;
    SaveAll;
    VcbFileExists := True;
    UnsavedChangesExist := False;
    UpdateScreen;
    SaveAs := True;
    if (Form1.MenuMainScreen.Checked and TopicsToDisplay[VocabStarts]) or
      Form1.MenuEditVcb.Checked then
    begin
      Form1.WMemo.Lines.BeginUpdate;
      Form1.WMemo.Lines[1] := TopicName[VocabStarts];
      Form1.WMemo.MarkUp(Form1.WMemo.XYtoX(0, 1),
        Utf16Length(Form1.WMemo.Lines[1]), psTitle);
      Form1.WMemo.Lines.EndUpdate;
    end;
  end
  else
    SaveAs := False;
end;

procedure SaveGrm;
var
  f: TextFile;
  i: integer;
begin
  AssignFile(f, HomeDirectory + 'Grammar plugins\' + GrmFilename + '.grm');
  Rewrite(f);
  for i := 0 to Form1.GMemo.Lines.Count - 1 do
    WriteLn(f, Form1.GMemo.Lines[i]);
  CloseFile(f);
  GrmFileExists := True;
  GrmUnsavedChangesExist := False;
  UpdateScreen;
end;

function SaveGrmAs(): boolean;
begin
  if Form1.SaveGrmDialog.Execute then
  begin
    GrmFileExists := True;
    SetGrmFilename(Split(ExtractFilename(Form1.SaveGrmDialog.Filename), '.grm', 1));
    SaveGrm();
    SaveGrmAs := True;
  end
  else
    SaveGrmAs := False;
end;

procedure SaveRsc(a, b, c: string);
var
  f: TextFile;
  i: integer;
begin

  AssignFile(f, HomeDirectory + 'Resources\Rsc files\data0.rsc');
  Rewrite(f);
  WriteLn(f, a);
  WriteLn(f, b);
  WriteLn(f, c);
  CloseFile(f);

  AssignFile(f, PChar(HomeDirectory + 'Resources\Rsc files\update settings.rsc'));
  Rewrite(f);
  WriteLn(f, UpdateSetting);
  WriteLn(f, VersionSetting);
  Close(f);

  AssignFile(f, HomeDirectory + 'Resources\Rsc files\data1.rsc');
  Rewrite(f);
  WriteLn(f, Form1.Left);
  WriteLn(f, Form1.Top);
  WriteLn(f, Form1.Width);
  WriteLn(f, Form1.Height);
  WriteLn(f, AppLang);
  WriteLn(f, Status);
  case Status of
    USER_SOLO,
    USER_MULTIPLE: begin
      // At present, we don't need to do anything.
    end;
    USER_STUDENT,
    USER_TEACHER,
    USER_DUAL: begin
      WriteLn(f, Username);
      WriteLn(f, Password);
    end;
  end;
  CloseFile(f);

  AssignFile(f, HomeDirectory + 'Resources\Rsc files\data2.rsc');
  Rewrite(f);
  PutRsc(f);

  CloseFile(f);

end;

procedure OpenRscFile;
var
  f: TextFile;
  t: string;
  temp: string;
  tempi: integer;
begin

  // The data*.rsc files in the Resources folder control the behavior of the
  // program on startup. Their effects may in some cases then be overridden
  // by the overrides in the .vcb file.

  // First we upload the data about the program itself. This needs to be stored
  // as data because we might have published it under any name.
  AssignFile(f, HomeDirectory + 'Resources\Rsc files\data0.rsc');
  Reset(f);
  ReadLn(f, ProgramName);
  ReadLn(f, ProgramVersion);
  ReadLn(f, ProgramPublisher);
  CloseFile(f);

  temp := ProgramName;
  Replace(temp, ' ', '_');
  Application.Name := temp;

  // Update settings.

  AssignFile(f, HomeDirectory + 'Resources\Rsc files\update settings.rsc');
  Reset(f);
  ReadLn(f, UpdateSetting);
  ReadLn(f, VersionSetting);
  Close(f);

  with Form1 do
  begin
    if UpdateSetting = 0 then MenuAlwaysUpdate.Checked := True;
    if UpdateSetting = 1 then MenuNeverUpdate.Checked := True;
    if UpdateSetting = 2 then MenuAlwaysAsk.Checked := True;

    if VersionSetting = 0 then MenuLatestVersion.Checked := True;
    if VersionSetting = 1 then MenuStableVersion.Checked := True;
  end;

  // Information about the user, are they a personal user, student, teacher?
  AssignFile(f, HomeDirectory + 'Resources\Rsc files\data1.rsc');
  Reset(f);
  ReadLn(f, tempi);
  Form1.Left := tempi;
  ReadLn(f, tempi);
  Form1.Top := tempi;
  ReadLn(f, tempi);
  Form1.Width := tempi;
  ReadLn(f, tempi);
  Form1.Height := tempi;
  ReadLn(f, AppLang);
  ReadLn(f, Status);

  case Status of
    USER_SOLO,
    USER_MULTIPLE: begin
      // At present, we don't need to do anything.
    end;
    USER_STUDENT,
    USER_TEACHER,
    USER_DUAL: begin
      ReadLn(f, Username);
      ReadLn(f, Password);
    end;
  end;

  CloseFile(f);

  // The remaining data is stuff that we might also want to load from
  // an .asm file, so we use the getrsc procedure to re-use the code.
  AssignFile(f, HomeDirectory + 'Resources\Rsc files\data2.rsc');
  Reset(f);
  GetRscFile(f);
  CloseFile(f);

  // Now we act on the contents of the resource files.

  Form1.Caption := ProgramName;
  if Filename <> '' then if Filename[1] = ':' then
      Filename := HomeDirectory + 'Vocab lists\' + Copy(Filename, 2, Length(Filename) - 1);
  OpenLanguage;
  LastTopic := 0;
  DataExists := False;
  Wipe;

  if not (FileExists(Filename)) then Filename := '';

  if Filename = '' then
  begin
    VcbFileExists := False;
    Form1.OpenVcbDialog.InitialDir := HomeDirectory + 'Vocab lists';
    Form1.SaveVcbDialog.InitialDir := HomeDirectory + 'Vocab lists';
  end
  else
  begin
    DataExists := True;
    VcbFileExists := True;
    OpenVcbFile;
    Form1.OpenVcbDialog.InitialDir := ExtractFilePath(Filename);
    Form1.SaveVcbDialog.InitialDir := ExtractFilePath(Filename);
  end;

  if (Username <> '') and (Password <> '') and ValidateUser(Username, Password) then
  begin
    t := Get_names(Password, Username);
    // Retrieves the first and last name of the user from the database.
    FirstName := Split(t, ' : ', 1);
    LastName := Split(t, ' : ', 2);
    SignedIn := True;
  end;

  MakeTopicBox;
  UpdateScreen;

end;

function AreYouSure(): boolean;
begin
  if DataExists and UnsavedChangesExist then
  begin
    case QuestionDlg(Translate('AREYOUSURE'), Translate('UNSAVED'), mtCustom,
        [1, Translate('SAVE'), 2, Translate('DONTSAVE'), 3, Translate('CANCEL')], '') of
      1: if Filename = '' then
        begin
          AreYouSure := SaveAs;
        end
        else
        begin
          SaveAll;
          AreYouSure := True;
          UnsavedChangesExist := False;
          UpdateScreen;
        end;
      2: begin
        AreYouSure := True;
        DataExists := False;
        UnsavedChangesExist := False;
        UpdateScreen;
      end;
      3: AreYouSure := False;
    end;
  end
  else
    AreYouSure := True;
end;

function GrammarCheck(): boolean;
begin
  if (ViewMode = VIEW_GRAMMAR) and GrmUnsavedChangesExist then
  begin
    case QuestionDlg(Translate('AREYOUSURE'), Translate('UNSAVEDG'),
        mtCustom, [1, Translate('SAVE'), 2, Translate('DONTSAVE'), 3,
        Translate('CANCEL')], '') of
      1: if Filename = '' then
          GrammarCheck := SaveGrmAs
        else
        begin
          SaveGrm;
          GrammarCheck := True;
        end;
      2: GrammarCheck := True;
      3: GrammarCheck := False;
    end;
  end
  else
    GrammarCheck := True;
  if not GrammarCheck then Form1.MenuEditGrm.Checked := True;
end;

procedure OpenGrmFile;
var
  f: TextFile;
  s: string;
  t: string;
  i: integer;
begin
  Form1.Cursor := crHourglass;
  AssignFile(f, HomeDirectory + 'Grammar plugins\' + GrmFilename + '.grm');
  Form1.GMemo.Lines.BeginUpdate;
  Form1.GMemo.Lines.Clear;
  Reset(f);
  i := 0;
  while not EOF(f) do
  begin
    ReadLn(f, s);
    t := t + s;
    Form1.GMemo.Lines.Add(s);
    Form1.GMemo.TouchLine(i);
    i := i + 1;
  end;
  CloseFile(f);
  GrmFileExists := True;
  GrmUnsavedChangesExist := False;
  UpdateScreen;
  Form1.GMemo.CaretPos := Point(0, 0);
  Form1.GMemo.Perform(EM_SCROLLCARET, 0, 0);
  Form1.GMemo.Lines.EndUpdate;
  Form1.Cursor := crArrow;
end;

procedure SetUpTabs;
var
  SL: TTabStopList;
  L: array [0 ..32] of double;
  i: integer;
const
  tsz = 12;
  wsz = 40;
  WrittenAnswersOrMultipleChoice = 40;
begin
  for i := 0 to 32 do       // Check if limit still exists per outdated docs.
    L[i] := (1 + i) * tsz;

  InitTabStopList(SL, L);
  Form1.GMemo.SetParaTabs(0, Utf16Length(Form1.GMemo.Text), SL);

  for i := 0 to 32 do       // Check if limit still exists per outdated docs.
    L[i] := WrittenAnswersOrMultipleChoice + (i * wsz);

  InitTabStopList(SL, L);
  Form1.WMemo.SetParaTabs(0, Utf16Length(Form1.WMemo.Text), SL);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
  t: string;
  f: TextFile;

begin

  Form1.DoubleBuffered := True;

  THeader.Left := Offset;

  Randomize;

  SignedIn := False;
  Filename := '';
  Username := '';
  Password := '';
  AssignmentExists := False;

  DataExists := False;

  HomeDirectory := ExtractFilePath(ParamStr(0));

  Form1.Icon.LoadFromFile(HomeDirectory + 'Resources\Icon\icon.ico');

  OpenGrmDialog.InitialDir := HomeDirectory + 'Grammar plugins';
  SaveGrmDialog.InitialDir := HomeDirectory + 'Grammar plugins';
  GrmFilename := '';
  GrmFileExists := False;
  GrmUnsavedChangesExist := False;
  ViewMode := VIEW_MAIN;
  WMemo.Visible := False;
  Form1.WMemo.Anchors := [];
  Form1.WMemo.Height := 0;
  Form1.WMemo.Width := 0;
  Form1.WMemo.Anchors := [akTop, akLeft, akBottom, akRight];

  OpenRscFile; // This opens the resource files, causing Peach to open up the .lng file
  // named in the .rsc files (which it then applies) and the .vcb file if
  // there is one, the vocab of which it then displays.

  JustStarted := True;
  DataEdit.Mode := ED_SPLIT;

  SetUpTabs;

  Scheme := TStringList.Create;
  AssignFile(f, HomeDirectory + 'Resources\Settings scheme\settings_scheme.rsc');
  Reset(f);
  while not EOF(f) do
  begin
    ReadLn(f, t);
    Scheme.Add(t);
  end;
  CloseFile(f);

  WMemo.Anchors := [akTop, akLeft, akBottom, akRight];

  CurTopic := -1;
  CurEntry := 0;
  if not DataExists then
    WMemo.Visible := False;

  UpdateScreen;

  DeleteFile(PChar(HomeDirectory + 'Resources\File transfer\launchertomain.rsc'));

end;


// ******************* SEARCH AND REPLACE ************

procedure DoFind(Memo: TRichMemo);
var
  temp: integer;
  tempfind: string;
begin
  with Form1 do
  begin
    tempfind := FormFind.EditFind.Text;
    temp := FindText(Memo.Text, FormFind.EditFind.Text, Memo.SelStart +
      Memo.SelLength + 1, FormFind.CheckCase.Checked) - 1;
    if temp < 0 then
    begin
      if QuestionDlg(Translate('NO FIND'), Translate('RESEARCH'),
        mtCustom, [1, Translate('REYES'), 2, Translate('RENO')], '') = 1 then
      begin
        temp := FindText(Memo.Text, tempfind, 1, FormFind.CheckCase.Checked) - 1;
        if temp < 0 then Alert('NO FIND')
        else
        begin
          Memo.SelStart := CurPos(Memo.Text, temp);
          Memo.SelLength := Utf16Length(FormFind.EditFind.Text);
          Memo.SetFocus;
        end;
      end;
    end
    else
    begin
      Memo.SelStart := CurPos(Memo.Text, temp);
      Memo.SelLength := Utf16Length(FormFind.EditFind.Text);
      Memo.SetFocus;
    end;
    FormFind.EditFind.Text := tempfind;
  end;
end;

procedure StartFind(Memo: TRichMemo);
begin
  FormFind.Caption := Translate('FIND');
  FormFind.FindButton.Caption := Translate('FIND');
  FormFind.CheckCase.Caption := Translate('MATCH CASE');
  FormFind.EditFind.Font.Name := MainFont;
  FormFind.EditFind.Font.Size := BaseFontSize;
  FormFind.EditReplace.Visible := False;
  FormFind.Height := FormFind.EditFind.Height + FormFind.FindButton.Height + 4 * Offset;
  if Memo.SelText <> '' then FormFind.EditFind.Text := Memo.SelText;
  FormFind.ShowModal;
  if FormFind.ModalResult = mrOk then DoFind(Memo);
end;

procedure StartReplace(Memo: TRichMemo; n: integer);
var
  temp: integer;
begin
  FormFind.Caption := Translate('REPLACE');
  FormFind.FindButton.Caption := Translate('REPLACE');
  FormFind.CheckCase.Caption := Translate('MATCH CASE');
  FormFind.EditFind.Font.Name := MainFont;
  FormFind.EditFind.Font.Size := BaseFontSize;
  FormFind.EditReplace.Font.Name := MainFont;
  FormFind.EditReplace.Font.Size := BaseFontSize;
  FormFind.EditReplace.Visible := True;
  FormFind.Height := FormFind.EditFind.Height + 2 * FormFind.FindButton.Height + 5 * Offset;
  if Memo.SelText <> '' then FormFind.EditFind.Text := Memo.SelText;
  FormFind.ShowModal;
  if FormFind.ModalResult = mrOk then
  begin
    Memo.Lines.BeginUpdate;
    temp := FindText(Memo.Text, FormFind.EditFind.Text, 1,
      FormFind.CheckCase.Checked) - 1;
    if temp < 0 then Alert('NO FIND')
    else
    begin
      UnsavedChangesExist := True;
      repeat
        Memo.SelStart := CurPos(Memo.Text, temp);
        Memo.SelLength := Utf16Length(FormFind.EditFind.Text);
        Memo.SelText := FormFind.EditReplace.Text;
        temp := FindText(Memo.Text, FormFind.EditFind.Text, temp +
          Length(FormFind.EditReplace.Text) - Length(FormFind.EditFind.Text) +
          2, FormFind.CheckCase.Checked) - 1;
      until temp < 0;
    end;
    Memo.Lines.EndUpdate;
    Memo.SetFocus;
  end;
end;

// ******************** THE VOCABULARY EDITOR ******************

// Most of the workings of WMemo go on inside the TWMemo class, and WMemoKeyDown
// will eventually be integrated inside this too.

procedure DoStartTest forward;

procedure TForm1.WMemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  ch: integer;
  s: string;
  x, y, olen, Utf8x: integer;
  TF: TFontParams;
  TP: TParametric;
  Pre: string;
  temp, i: integer;

begin
  if (not (Key in [37..40])) and (not MenuMainScreen.Checked) then
    UnsavedChangesExist := True;

  x := WMemo.CaretPos.x;
  y := WMemo.CaretPos.y;

  Utf8x := Utf8Cur(x, WMemo.Lines[y]);

  WMemo.GetTextAttributes(WMemo.SelStart, TF);
  WMemo.GetParaMetric(WMemo.SelStart, TP);

  if (Key = Ord('V')) and (Shift = [ssCtrl]) or
    // This makes sure pasted text assumes the format of whatever it's pasted into.
    (Key = VK_INSERT) and (Shift = [ssShift]) then
  begin
    WMemo.InDelText(Clipboard.AsText, WMemo.SelStart, WMemo.SelLength);
    WMemo.SelStart := WMemo.SelStart + Utf16Length(Clipboard.AsText);
    Key := 0;
    // And now we automatically mark up anything with an emdash in it.
    for i := y to WMemo.CaretPos.y do
      if Utf16Pos(Utf8ToUtf16(' — '), WMemo.Lines[i]) > 0 then
      begin
        if (TF.Color = clPara) or (TF.Color = clVocab) then
          WMemo.MarkUp(WMemo.XYtoX(0, i), Utf16Length(WMemo.Lines[i]) + 1, psVocab);
        if (TF.Color = clQBody) or (TF.Color = clQForms) then
          WMemo.MarkUp(WMemo.XYtoX(0, i), Utf16Length(WMemo.Lines[i]) + 1, psQForms);
        if (TF.Color = clKBody) or (TF.Color = clKeys) then
          WMemo.MarkUp(WMemo.XYtoX(0, i), Utf16Length(WMemo.Lines[i]) + 1, psKeys);
      end;
    Exit;
  end;

  // This is replicated from GMemoKeyDown, only the conditions under which it operates are different.

  if (TF.Color = clVocab) or (TF.Color = clKeys) and not
    ((Key = Ord('Z')) and (Shift = [ssCtrl])) then
  begin
    s := '';
    olen := Utf16Length(WMemo.Lines[y]);
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
        if [ssCtrl, ssAlt] * Shift <> [] then Key := 0;
      end;
    if s <> '' then
    begin
      WMemo.InDelText(s, WMemo.SelStart, 0);
      WMemo.SelStart := WMemo.SelStart + Utf16Length(s);
    end;
  end;
end;

procedure TForm1.WMemoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; x, y: integer);
begin
  if WMemo.Cursor = crArrow then Windows.SetFocus(0);
end;


procedure TForm1.WMenuPopupPopup(Sender: TObject);
begin
  WReplace.Visible := MenuEditVcb.Checked;
  WTest.Visible := MenuEditVcb.Checked;
end;

procedure TForm1.WReplaceClick(Sender: TObject);
begin
  StartReplace(WMemo, WMemo.XYtoX(0, 2) + 1);
end;

procedure TForm1.WFindClick(Sender: TObject);
begin
  StartFind(WMemo);
end;

procedure TForm1.WTestClick(Sender: TObject);
var
  i: integer;
begin
  SchlurpWMemo;
  // The side-effect of which is that CurTopic and CurEntry
  // now refer to the entry the user right-clicked on.
  for i := LowerTopic to UpperTopic do
    TopicsToDisplay[i] := (i = CurTopic);
  AssignmentInProgress := False;
  DoStartTest;
end;


// ******************** THE GRAMMAR EDITOR ****************************

procedure TForm1.GMemoKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  ch: integer;
  CurP, EndP: PChar;
  Len: integer;
  ACodePoint: string;
  q1, q2, Found: boolean;
  s: string;
  i, x, y, olen, Utf8x: integer;
begin

  x := GMemo.CaretPos.x;
  y := GMemo.CaretPos.y;

  if GKeyGroup.Checked[0] or GKeyGroup.Checked[1] then
  begin

    // We convert the x value to utf8;
    Utf8x := Utf8Cur(x, GMemo.Lines[y]);

    // We find out if we're in quotes
    q1 := False;
    q2 := False;
    Found := False;
    i := 0;
    CurP := PChar(GMemo.Lines[y]);
    // if S='' then PChar(S) returns a pointer to #0
    EndP := CurP + Length(GMemo.Lines[y]);
    while (CurP < EndP) and not (Found and (not q1) and (not q2)) do
    begin
      i := i + 1;
      Len := UTF8CodepointSize(CurP);
      SetLength(ACodePoint, Len);
      Move(CurP^, ACodePoint[1], Len);
      if (ACodePoint = '"') and not q1 then q2 := not q2;
      if (ACodePoint = '''') and not q2 then q1 := not q1;
      if (i = Utf8x) and (q1 or q2) then Found := True;
      Inc(CurP, Len);
    end;

    // if we are then
    if Found then
    begin
      s := '';
      olen := Utf16Length(GMemo.Lines[y]);
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
          if [ssCtrl, ssAlt] * Shift <> [] then Key := 0;
        end;
      if s <> '' then
      begin
        GMemo.Lines[y] := Utf8Copy(GMemo.Lines[y], 1, Utf8x) + s +
          Utf8Copy(GMemo.Lines[y], Utf8x + 1, Utf8Length(GMemo.Lines[y]) - Utf8x);
        GMemo.CaretPos := TPoint.Create(x + Utf16Length(GMemo.Lines[y]) - olen, y);
      end;
    end;
  end;
end;

procedure TForm1.GMFindClick(Sender: TObject);
begin
  StartFind(GMemo);
end;

procedure TForm1.GMIndentClick(Sender: TObject);
var
  y1, y2, t, i: integer;
begin
  y2 := GMemo.CaretPos.y;
  GMemo.SelLength := 0;
  y1 := GMemo.CaretPos.y;
  for i := y1 to y2 do
  begin
    GMemo.Lines[i] := #9 + GMemo.Lines[i];
    GMemo.TouchLine(i);
  end;
  GMemo.CaretPos := TPoint.Create(Utf16Length(GMemo.Lines[y2]), y2);
  t := GMemo.SelStart;
  GMemo.CaretPos := TPoint.Create(0, y1);
  GMemo.SelLength := t - GMemo.SelStart;
end;

procedure TForm1.GMReplaceClick(Sender: TObject);
var
  i: integer;
begin
  ;
  StartReplace(GMemo, 1);
end;

procedure TForm1.GMUnindentClick(Sender: TObject);
var
  y1, y2, t, i: integer;
begin
  y2 := GMemo.CaretPos.y;
  GMemo.SelLength := 0;
  y1 := GMemo.CaretPos.y;
  for i := y1 to y2 do
    if GMemo.Lines[i][1] = #9 then
    begin
      GMemo.Lines[i] := Utf8Copy(GMemo.Lines[i], 2, Length(GMemo.Lines[i]) - 1);
      GMemo.TouchLine(i);
    end;
  GMemo.CaretPos := TPoint.Create(Utf16Length(GMemo.Lines[y2]), y2);
  t := GMemo.SelStart;
  GMemo.CaretPos := TPoint.Create(0, y1);
  GMemo.SelLength := t - GMemo.SelStart;

end;

procedure TForm1.GMemoChange(Sender: TObject);
begin
  GrmUnsavedChangesExist := True;
end;



procedure TForm1.EditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  UpdateScreen;
  // This bit fasttracks the student to registering an account.
{if JustStarted and (username='')
   and (Status in [user_student, user_teacher, user_dual])
       then MenuCRClick(Sender);
JustStarted:=false;   }
end;

procedure TForm1.TopicComboChange(Sender: TObject);
var
  i: integer;
begin
  WordCombo.Items.Clear;
  WordCombo.Text := Translate('VC');
  if TopicCombo.ItemIndex <> -1 then
    for i := TopicStart(VocabStarts + TopicCombo.ItemIndex)
      to TopicEnd[VocabStarts + TopicCombo.ItemIndex] do
      if not IsLeft(VcbEntry[1, i], '¶') then WordCombo.Items.Add(EntryToString(i));
  WordCombo.SetFocus;
end;

procedure MakeError(var E: string; var Enumber: integer; Notes: string);
var
  Dummy: integer;
begin

  with Form1 do
  begin

    Report.Font.Color := clRed;

    E := Split(E, '(', 1); // removes erroneous line numbers from some syntax errors.

    if Enumber < Sybil_A.Lines.Count then
    begin
      E := E + ' at line ' + IntToStr(Enumber) + ' of Sybil A.';
      Enumber := -1;
    end;

    if Enumber >= Sybil_A.Lines.Count then
      if Enumber < Sybil_A.Lines.Count + GMemo.Lines.Count then
        Enumber := Enumber - Sybil_A.Lines.Count
      else
      begin
        E := E + ' at line ' + IntToStr(Enumber - Sybil_A.Lines.Count -
          GMemo.Lines.Count + 1) + ' of Sybil B.';
        Enumber := -1;
      end;

    E := Translate('ERR') + ': ' + E;
    if Notes <> '' then E := Notes + '|   ' + E;

    Report.Caption := E;
    GMemo.SetFocus;
    if Enumber <> -1 then
    begin
      GMemo.CaretPos := TPoint.Create(0, ENumber - 1);
      GMemo.SelLength := Utf16Length(GMemo.Lines[ENumber - 1]);
      GMemo.Perform(EM_SCROLLCARET, 0, ENumber - 1);
    end;
  end;
end;

procedure TForm1.GRefreshClick(Sender: TObject);
var
  f: TextFile;
  Qf, w1, w2, E, Notes, s: string;
  Enumber, ix: integer;
begin

  with Form1 do
  begin

    Report.Caption := '';
    GOut.Caption := '';
    GrmToPy(GrmFilename, FROM_MEMO);
    GrammarCheck(GrmFilename, E, Enumber);
    if E = '' then                                                 // Out
    begin
      if TopicCombo.ItemIndex = -1 then
        SelectedTopic := -1
      else
        SelectedTopic := TopicCombo.ItemIndex + VocabStarts;
      ix := WordCombo.ItemIndex;
      if (ix <> -1) and (DataEdit.Text <> WordCombo.Items[ix]) then ix := -1;
      DoThePython(GrmFilename, DataEdit.Text, SelectedTopic, ix);

      AssignFile(f, HomeDirectory + 'Resources\File transfer\pytopa.rsc');
      // In
      Reset(f);
      ReadLn(f, Qf);
      ReadLn(f, w1);
      ReadLn(f, w2);
      ReadLn(f, E);
      ReadLn(f, s);
      ENumber := FindErrorLine(s, Form1.Sybil_A.Lines.Count);
      ReadLn(f, Notes);
      CloseFile(f);
      if Qf <> '' then Qf := Qf + ' ';
      GOut.Caption := Qf + w1 + ' — ' + w2;
    end; {of if no syntax error}

    if E <> '' then
    begin
      MakeError(E, Enumber, Notes);
      UpdateScreen;
    end
    else
    begin
      Report.Font.Color := clBlack;
      Report.Caption := Notes;
    end;

  end; // of with Form1
end;

procedure TForm1.WordComboChange(Sender: TObject);
begin
  if WordCombo.ItemIndex <> -1 then
  begin
    GRefresh.SetFocus;
    DataEdit.Text := WordCombo.Items[WordCombo.ItemIndex];
    GRefreshClick(Sender);
  end;
end;

procedure TForm1.DataEditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  EditKeyDown(Sender, Key, Shift);
end;

procedure TForm1.DataEditKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
var
  Utf8x: integer;
begin
  EditKeyUp(Sender, Key, Shift);
  if Key = 13 then
  begin
    GRefreshClick(Sender);
  end;
  Utf8x := Utf8Cur(DataEdit.SelStart, DataEdit.Text);
  if Utf8Copy(DataEdit.Text, Utf8x, 3) = ' — ' then
    DataEdit.SelStart := DataEdit.SelStart + 2;
  if Utf8Copy(DataEdit.Text, Utf8x - 1, 3) = ' — ' then
    DataEdit.SelStart := DataEdit.SelStart - 2;
end;

procedure TForm1.DividerChangeBounds(Sender: TObject);
begin

end;


// ****************** FILE MENU*******************

procedure TForm1.MenuCloseClick(Sender: TObject);
begin
  FormQA.Hide;
  if MenuEditGrm.Checked then
  begin
    if GrammarCheck() then
    begin
      GrmFileExists := False;
      SetGrmFilename('');
      GMemo.Lines.Clear;
      GrmUnsavedChangesExist := False;
      UpdateScreen;
    end;
  end
  else if AreYouSure() then
  begin
    Filename := '';
    VcbFileExists := False;
    Wipe;
    UpdateScreen;
    Form1.WMemo.Anchors := [];
    // This kludge stops WMemo from being visible when it shouldn't be. Idk why.
    Form1.WMemo.Height := 0;
    Form1.WMemo.Width := 0;
    Form1.WMemo.Anchors := [akTop, akLeft, akBottom, akRight];
  end;
end;

procedure TForm1.MenuNewFileKeepSettingsClick(Sender: TObject);
begin
  if AreYouSure() then
  begin
    Wipe;
    Filename := '';
    VcbFileExists := False;
    DataExists := True;
    {This bit works because wipe doesn't wipe anything, it just forgets that it's there}
    LastTopic := VocabStarts;
    TopicName[VocabStarts] := Translate('UNTF');
    TopicsToDisplay[VocabStarts] := True;
    TopicEnd[VocabStarts] := TopicEnd[seLastSetting];
    LowerTopic := VocabStarts;
    UpperTopic := VocabStarts;
    DoOverrides;
    UpdateScreen;
    MakeTopicBox;
    DisplayVocab(DISPLAY_SELECTED);
  end;
end;

procedure TForm1.MenuNewFileNewSettingsClick(Sender: TObject);
var
  c, j: integer;
  s: string;
begin
  if not AreYouSure() then Exit;

  for j := 0 to LastTopic do TopicsToDisplay[j] := False;
  c := 0;
  LastTopic := BASEMENT;
  j := 0;
  TopicEnd[LastTopic] := j;
  while c < Scheme.Count do
  begin
    s := Scheme.Strings[c];
    if IsLeft(s, '§') then          // then we got ourselves a topic heading
    begin
      LastTopic := LastTopic + 1;
      TopicName[LastTopic] := Split(s, '§', 2);
    end
    else                // otherwise it's an entry to be filed under the present topic
    begin
      j := j + 1;
      if IsLeft(s, '+') then s := Copy(s, 2, Length(s) - 1);
      StringToEntry(Decode(s, '@'), j, LastTopic);
    end;
    TopicEnd[LastTopic] := j;
    c := c + 1;
  end;

  LastTopic := VocabStarts;
  TopicEnd[LastTopic] := TopicEnd[LastTopic - 1];
  TopicName[LastTopic] := Translate('UNTF');
  TopicsToDisplay[VocabStarts] := True;

  DataExists := True;
  VcbFileExists := False;
  Filename := '';
  UnsavedChangesExist := False;
  DoOverrides;
  if Form1.MenuMainScreen.Checked then
  begin
    LowerTopic := VocabStarts;
    UpperTopic := LastTopic;
    DisplayVocab(DISPLAY_SELECTED);
  end;
  if Form1.MenuEditVcb.Checked then
  begin
    LowerTopic := VocabStarts;
    UpperTopic := LastTopic;
    DisplayVocab(DISPLAY_ALL);
  end;
  if Form1.MenuEditSettings.Checked then
  begin
    LowerTopic := seDatastarts;
    UpperTopic := seLastSetting;
    DisplayVocab(DISPLAY_ALL);
  end;

  UpdateScreen;
  MakeTopicBox;
end;

procedure TForm1.MenuNewGrmClick(Sender: TObject);
begin
  if GrammarCheck() then
  begin
    GrmFileExists := False;
    SetGrmFilename('');
    GMemo.Lines.Clear;
    GrmUnsavedChangesExist := False;
    UpdateScreen;
  end;
end;

procedure TForm1.MenuOpenClick(Sender: TObject);
begin
  if MenuEditGrm.Checked then
  begin
    if GrammarCheck() and OpenGrmDialog.Execute then
    begin
      GrmFileExists := True;
      SetGrmFilename(Split(ExtractFilename(OpenGrmDialog.Filename), '.grm', 1));
      OpenGrmFile;
      GrmUnsavedChangesExist := False;
      UpdateScreen;
    end;
  end
  else if AreYouSure() and OpenVcbDialog.Execute then
  begin
    Filename := OpenVcbDialog.Filename;
    Wipe;
    MenuMainScreenClick(MenuOpen);
    OpenVcbFile;
    DataExists := True;
    VcbFileExists := True;
    UpdateScreen;
  end;
end;

procedure TForm1.MenuRevertClick(Sender: TObject);
begin
  if MenuEditGrm.Checked then
  begin
    if GrammarCheck() then
    begin
      OpenGrmFile;
      GrmUnsavedChangesExist := False;
      UpdateScreen;
    end;
  end
  else if AreYouSure() then
  begin
    Wipe;
    OpenVcbFile;
    DataExists := True;
    VcbFileExists := True;
    UpdateScreen;
    MakeTopicBox;
    DisplayVocab(DISPLAY_SELECTED);
  end;
end;

procedure TForm1.MenuSaveClick(Sender: TObject);
begin
  if MenuEditGrm.Checked then
  begin
    SaveGrm;
    GrmUnsavedChangesExist := False;
    Exit;
  end;
  if MenuEditVcb.Checked then SchlurpWMemo;
  if MenuEditSettings.Checked then SchlurpSettings;
  SaveAll;
  UnsavedChangesExist := False;
end;

procedure TForm1.MenuSaveAsClick(Sender: TObject);
begin
  if MenuEditGrm.Checked then SaveGrmAs
  else
    SaveAs;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := GrammarCheck and AreYouSure;
  if CanClose and not AssignmentExists then
    SaveRsc(ProgramName, ProgramVersion, ProgramPublisher);
end;

procedure TForm1.MenuExitClick(Sender: TObject);
begin
  Form1.Close;
end;

procedure TForm1.MenuPublishClick(Sender: TObject);
var
  f: TextFile;
  Pr: TProcess;
  GUID: TGUID;
  i, j: integer;
  temp: string;
  flag: boolean;
  Dirs: TStringList;
  LauncherDirectory: string;
  FontInfo: string;

begin

  LauncherDirectory := Copy(HomeDirectory, 1, Length(HomeDirectory) - 6);
  // Trims 'Peach\' off the end.

  Dirs := FindAllDirectories(HomeDirectory, False);
  flag := (Dirs.IndexOf(HomeDirectory + 'Workspace') = -1);
  Dirs.Free;
  if flag then
  begin
    Alert('NOWS');
    Exit;
  end;

  with FormPublish do
  begin
    LockdownGroup.Caption := Translate('MLO');
    for i := 0 to LockdownCount - 1 do
      LockdownGroup.Items[i] := TranslateList('Lo1', i);
    Image1.Picture.LoadFromFile(HomeDirectory + 'Resources\Icon\icon.ico');
    Caption := Translate('MPublish');
    ButtonChangeIcon.Caption := Translate('PubNI');
    LabelPN.Caption := Translate('PubPN');
    EditPN.Text := ProgramName;
    LabelVN.Caption := Translate('PubVN');
    if ProgramVersion <> '' then
      EditVN.Text := ProgramVersion
    else
      EditVN.Text := GetFileVersion;
    LabelP.Caption := Translate('PubP');
    EditP.Text := ProgramPublisher;
    LabelF.Caption := Translate('PubF');
    ComboBox1.Text := '';
    ComboBox1.Items := FindAllFiles('C:\Windows\Fonts');
    for i := 1 to ComboBox1.Items.Count do
      ComboBox1.Items[i - 1] := Split(ComboBox1.Items[i - 1], 'C:\Windows\Fonts\', 2);
    for i := 1 to ComboBox1.Items.Count do
    begin
      FontInfo := FindTrueTypeFontName('C:\Windows\Fonts\' + ComboBox1.Items[i - 1]);
      if (FontInfo <> '') and ((FontInfo = Translate('Default title font')) or
        (FontInfo = Translate('Default body font')) or
        (FontInfo = TitleFont) or (FontInfo = MainFont)) then
        ListBox1.Items.Add(ComboBox1.Items[i - 1]);
    end;
    Button1.Caption := Translate('OK');

    ShowModal;

    if ModalResult <> mrOk then Exit;

    if not IsValidFileName(EditPN.Text) then
    begin
      Alert('INCH');
      Exit;
    end;
    if not ((Filename = '') or (IsLeft(Filename, HomeDirectory + 'Vocab lists\'))) then
    begin
      Alert('BADPATH');
      Exit;
    end;

    Form1.Cursor := crHourglass;
    AssignFile(f, HomeDirectory + 'Resources\Rsc files\version.rsc');
    Rewrite(f);
    WriteLn(f, GetFileVersion);
    CloseFile(f);
    CopyFile(PChar(HomeDirectory + ProgramName + '.exe'),
      PChar(HomeDirectory + 'Workspace\' + EditPN.Text + '.exe'), False);
    // Copy the program.
    CopyFile(PChar(LauncherDirectory + ProgramName + '.exe'),
      PChar(HomeDirectory + 'Workspace 2\' + EditPN.Text + '.exe'), False);
    // Copy the launcher.
    if FileExists(OpenPictureDialog1.Filename) then
    begin
      CopyFile(PChar(HomeDirectory + 'Resources\Icon\icon.ico'),
        PChar(HomeDirectory + 'Workspace\icon.ico'), False);
      CopyFile(PChar(OpenPictureDialog1.Filename), PChar(HomeDirectory +
        'Resources\Icon\icon.ico'), False);
      UpdateIcon(HomeDirectory + 'Workspace\' + EditPN.Text + '.exe',
        HomeDirectory + 'Resources\Icon\icon.ico');      // Update the program icon.
      UpdateIcon(HomeDirectory + 'Workspace 2\' + EditPN.Text + '.exe',
        HomeDirectory + 'Resources\Icon\icon.ico');      // Update the launcher icon.
    end;    // Of if we're changing an icon.

    CreateGUID(GUID);
    AssignFile(f, HomeDirectory + 'Resources\File transfer\inno_script.iss');
    Rewrite(f);
    WriteLn(f, '#define MyAppName "' + EditPN.Text + '"');
    if EditVN.Text = '' then
      // For some reason an empty version name causes a fault; this crudely prevents it.
      WriteLn(f, '#define MyAppVersion "0.0.0.0"')
    else
      WriteLn(f, '#define MyAppVersion "' + EditVN.Text + '"');
    WriteLn(f, '#define MyAppPublisher "' + EditP.Text + '"');
    WriteLn(f, '#define MyAppExeName "' + EditPN.Text + '.exe"');
    WriteLn(f, '#define MyAppAssocName "Vocabulary file"');
    WriteLn(f, '#define MyAppAssocExt ".vcb"');
    WriteLn(f, '#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt');
    WriteLn(f, '[Setup]');
    WriteLn(f, 'AppId={' + GUIDToString(GUID));
    WriteLn(f, 'AppName={#MyAppName}');
    WriteLn(f, 'AppVersion={#MyAppVersion}');
    WriteLn(f, ';AppVerName={#MyAppName} {#MyAppVersion}');
    WriteLn(f, 'AppPublisher={#MyAppPublisher}');
    WriteLn(f, 'UsePreviousAppDir=no');
    WriteLn(f, 'DefaultDirName={autopf}\{#MyAppName}');
    WriteLn(f, 'ChangesAssociations=yes');
    WriteLn(f, 'DisableProgramGroupPage=yes');
    WriteLn(f, 'PrivilegesRequired=lowest');
    WriteLn(f, 'OutputDir=' + HomeDirectory + 'Installation');
    WriteLn(f, 'OutputBaseFilename=' + EditPN.Text + ' setup');
    WriteLn(f, 'SetupIconFile=' + HomeDirectory + 'Resources\Icon\icon.ico');
    WriteLn(f, 'Compression=lzma');
    WriteLn(f, 'SolidCompression=yes');
    WriteLn(f, 'WizardStyle=modern');
    WriteLn(f, '[Languages]');
    WriteLn(f, 'Name: "english"; MessagesFile: "compiler:Default.isl"');
    WriteLn(f, 'Name: "armenian"; MessagesFile: "compiler:Languages\Armenian.isl"');
    WriteLn(f, 'Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"');
    WriteLn(f, 'Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"');
    WriteLn(f, 'Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"');
    WriteLn(f, 'Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"');
    WriteLn(f, 'Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"');
    WriteLn(f, 'Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"');
    WriteLn(f, 'Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"');
    WriteLn(f, 'Name: "french"; MessagesFile: "compiler:Languages\French.isl"');
    WriteLn(f, 'Name: "german"; MessagesFile: "compiler:Languages\German.isl"');
    WriteLn(f, 'Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"');
    WriteLn(f, 'Name: "icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"');
    WriteLn(f, 'Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"');
    WriteLn(f, 'Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"');
    WriteLn(f, 'Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"');
    WriteLn(f, 'Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"');
    WriteLn(f, 'Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"');
    WriteLn(f, 'Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"');
    WriteLn(f, 'Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"');
    WriteLn(f, 'Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"');
    WriteLn(f, 'Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"');
    WriteLn(f, 'Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"');
    WriteLn(f, 'Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"');
    WriteLn(f, '[Tasks]');
    WriteLn(f, 'Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked');
    WriteLn(f, '[Dirs]');
    WriteLn(f, 'Name: "{app}\Peach"; Permissions: users-full;');
    WriteLn(f, 'Name: "{app}\Peach\Grammar plugins"; Permissions: users-full;');
    WriteLn(f, 'Name: "{app}\Peach\Internationalization"; Permissions: users-full;');
    WriteLn(f, 'Name: "{app}\Peach\Licenses"; Permissions: users-full;');
    WriteLn(f, 'Name: "{app}\Peach\Resources"; Permissions: users-full; Attribs: hidden;');
    WriteLn(f, 'Name: "{app}\Peach\Vocab lists"; Permissions: users-full;');
    WriteLn(f, 'Name: "{app}\Peach\Installation"; Permissions: users-full;');
    WriteLn(f, 'Name: "{app}\Peach\Workspace"; Permissions: users-full; Attribs: hidden;');
    WriteLn(f, 'Name: "{app}\Peach\Workspace 2"; Permissions: users-full; Attribs: hidden;');
    WriteLn(f, '[Files]');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'Workspace 2\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion;');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'Workspace\{#MyAppExeName}"; DestDir: "{app}\Peach"; Flags: ignoreversion;');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'Grammar plugins\*"; DestDir: "{app}\Peach\Grammar plugins"; Flags: ignoreversion; Permissions: users-full;');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'Internationalization\*"; DestDir: "{app}\Peach\Internationalization"; Flags: ignoreversion; Permissions: users-full; ');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'Licenses\*"; DestDir: "{app}\Peach\Licenses"; Flags: ignoreversion recursesubdirs createallsubdirs; Permissions: users-full;');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'Resources\*"; DestDir: "{app}\Peach\Resources"; Flags: ignoreversion recursesubdirs createallsubdirs; Permissions: users-full;');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'Vocab lists\*"; DestDir: "{app}\Peach\Vocab lists"; Flags: ignoreversion; Permissions: users-full; ');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'libeay32.dll"; DestDir: "{app}\Peach"; Flags: ignoreversion;');
    WriteLn(f, 'Source: "' + HomeDirectory +
      'ssleay32.dll"; DestDir: "{app}\Peach"; Flags: ignoreversion;');
    WriteLn(f, 'Source: "' + LauncherDirectory +
      '\libeay32.dll"; DestDir: "{app}"; Flags: ignoreversion;');
    WriteLn(f, 'Source: "' + LauncherDirectory +
      '\ssleay32.dll"; DestDir: "{app}"; Flags: ignoreversion;');
    for i := 1 to ListBox1.Items.Count do
      WriteLn(f, 'Source: "C:\Windows\Fonts\' + ListBox1.Items[i - 1] +
        '"; DestDir: "{autofonts}"; FontInstall: "' + Split(ListBox1.Items[i - 1], '.', 1) +
        '"; Flags: onlyifdoesntexist uninsneveruninstall');
    WriteLn(f, '[Registry]');
    WriteLn(f, 'Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue');
    WriteLn(f, 'Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey');
    WriteLn(f, 'Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"');
    WriteLn(f, 'Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""');
    WriteLn(f, 'Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".myp"; ValueData: ""');
    WriteLn(f, '[Icons]');
    WriteLn(f, 'Name: "{autoprograms}\{#MyAppName}"; FileName: "{app}\{#MyAppExeName}"');
    WriteLn(f, 'Name: "{autodesktop}\{#MyAppName}"; FileName: "{app}\{#MyAppExeName}"; Tasks: desktopicon');
    WriteLn(f, '[Run]');
    WriteLn(f, 'FileName: "{app}\' + EditPN.Text +
      '.exe"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, ''&'', ''&&'')}}"; Flags: nowait postinstall skipifsilent');
    CloseFile(f);

    temp := LockdownBackup;
    for i := 1 to LockdownCount do
      if LockdownGroup.Checked[i - 1] then
        LockdownBackup[i] := 'Y';
    SaveRsc(EditPN.Text, EditVN.Text, EditP.Text);
    Pr := TProcess.Create(nil);
    Pr.Executable := HomeDirectory + 'Resources\Inno setup\iscc.exe';
    Pr.Parameters.Add(HomeDirectory + 'Resources\File transfer\inno_script.iss');
    Pr.Options := Pr.Options + [poWaitOnExit];
    Pr.ShowWindow := swoHide;
    Pr.Execute;
    if (Pr.ExitCode = 0) then
    begin
      Pr.Free;
      Pr := TProcess.Create(nil);
      Pr.Executable := 'explorer.exe';
      Pr.Parameters.Add(HomeDirectory + 'Installation');
      Pr.Execute;
    end
    else
      Alert('PubFail');
    Pr.Free;
    LockdownBackup := temp;
    SaveRsc(ProgramName, ProgramVersion, ProgramPublisher);
    if FileExists(OpenPictureDialog1.Filename) then
    begin
      DeleteFile(PChar(HomeDirectory + 'Resources\Icon\icon.ico'));
      CopyFile(PChar(HomeDirectory + 'Workspace\icon.ico'),
        PChar(HomeDirectory + 'Resources\Icon\icon.ico'), False);
      DeleteFile(PChar(HomeDirectory + 'Workspace\icon.ico'));
    end;
    DeleteFile(PChar(HomeDirectory + 'Workspace\' + EditPN.Text + '.exe'));
    DeleteFile(PChar(HomeDirectory + 'Workspace 2\' + EditPN.Text + '.exe'));
    Form1.Cursor := crArrow;
  end;
end;


// **************** THE CLASSROOM MENU *****************

procedure TForm1.MenuSignInClick(Sender: TObject);
var
  t: string;
begin
  with FormSignIn do
  begin
    Caption := Translate('SSI');
    LabelUsername.Caption := Translate('RegUN');
    EditUsername.Text := '';
    LabelPassword.Caption := Translate('SIP');
    EditPassword.Text := '';
    ButtonOK.Caption := Translate('OK');
    ButtonCancel.Caption := Translate('CANCEL');
    ShowModal;
    if (ModalResult = mrOk) and ValidateUser(EditUsername.Text, EditPassword.Text) then
    begin
      SignedIn := True;
      UpdateScreen;
      Username := EditUsername.Text;
      Password := EditPassword.Text;
      t := Get_names(Password, Username);
      FirstName := Split(t, ' : ', 1);
      LastName := Split(t, ' : ', 2);
    end;
  end;
  MenuClassroomClick(Form1);
end;

// Signing out should close everything down, you would never want to
// sign out unless you had privacy concerns.
procedure TForm1.MenuSignOutClick(Sender: TObject);
begin
  MenuCloseClick(Sender);
  if ViewMode = VIEW_GRAMMAR then
  begin
    MenuMainScreen.Checked := True;
    ViewMode := VIEW_MAIN;
    MenuCloseClick(Sender);
  end
  else
  begin
    MenuMainScreen.Checked := True;
    ViewMode := VIEW_MAIN;
  end;
  SignedIn := False;
  Username := '';
  Password := '';
  SaveRsc(ProgramName, ProgramVersion, ProgramPublisher);
  MenuClassroomClick(Form1);
  UpdateScreen;
end;

procedure TForm1.MenuGradebookClick(Sender: TObject);
begin
  FormResults.ShowModal;
end;

function Valid(s: string): boolean;
begin
  Valid := True;
  if s = '' then
  begin
    Alert('INV1');
    Valid := False;
    Exit;
  end;
  if (s[1] = ' ') or (s[Length(s)] = ' ') then
  begin
    Alert('INV2');
    Valid := False;
    Exit;
  end;
  if (Pos(':', s) > 0) then
  begin
    Alert('INV3');
    Valid := False;
    Exit;
  end;

end;

procedure TForm1.MenuRegisterClick(Sender: TObject);
begin
  with FormRegister do
  begin
    Label2.Visible := True;
    Label3.Visible := True;
    Label5.Visible := True;
    EditFN.Visible := True;
    EditLN.Visible := True;
    EditPW.Visible := True;
    Caption := Translate('Reg');
    Label1.Caption := Translate('RegIntro');
    Label2.Caption := Translate('RegFN');
    Label3.Caption := Translate('RegLN');
    Label4.Caption := Translate('RegUN');
    Label5.Caption := Translate('RegPW');
    Label6.Caption := Translate('RegEM');
    ButtonOK.Caption := Translate('OK');
    ButtonCancel.Caption := Translate('CANCEL');
    EditFN.Text := '';
    EditLN.Text := '';
    EditUN.Text := '';
    EditPW.Text := '';
    EditEM.Text := '';
    ShowModal;
    if (ModalResult = mrOk) and Valid(EditFN.Text) and Valid(EditLN.Text) and
      Valid(EditUN.Text) and Valid(EditPW.Text) and Valid(EditEM.Text) and
      Add_user(EditUN.Text, EditFN.Text, EditLN.Text, EditPW.Text, EditEM.Text) then
    begin
      Username := EditUN.Text;
      FirstName := EditFN.Text;
      LastName := EditLN.Text;
      Password := EditPW.Text;
      Email := EditEM.Text;
      SignedIn := True;
      UpdateScreen;
      FormSClasses.ShowModal;
    end;
  end;
  MenuClassroomClick(Form1);
end;

procedure TForm1.MenuForgotPasswordClick(Sender: TObject);
var
  i: integer;
  s: string;
  j: integer;
begin
  s := '';
  for i := 1 to 16 do
  begin
    j := Random(62);
    if j in [0..9] then s := s + chr(48 + j);
    if j in [10..35] then s := s + chr(55 + j);
    if j in [36..61] then s := s + chr(61 + j);
  end;
  with FormRegister do
  begin
    Caption := Translate('RNP');
    Label1.Caption := Translate('RNPIntro');
    Label2.Visible := False;
    Label3.Visible := False;
    Label4.Caption := Translate('RegUN');
    Label5.Visible := False;
    Label6.Caption := Translate('RegEM');
    ButtonOK.Caption := Translate('OK');
    ButtonCancel.Caption := Translate('CANCEL');
    EditFN.Visible := False;
    EditLN.Visible := False;
    EditUN.Text := '';
    EditPW.Visible := False;
    EditEM.Text := '';
    ShowModal;
    if (ModalResult = mrOk) and MailNewPassword(EditUN.Text, EditEM.Text, s) then
      Alert('PSENT');
  end;
end;

procedure TForm1.MenuClassesClick(Sender: TObject);
begin
  FormSClasses.ShowModal;
end;

procedure TForm1.MenuChangeEmailClick(Sender: TObject);
begin
  with FormRegister do
  begin
    Caption := Translate('MCCE');
    Label1.Caption := Translate('CEMIntro');
    Label2.Visible := False;
    Label3.Visible := False;
    Label4.Caption := Translate('RegPW');
    Label5.Visible := False;
    Label6.Caption := Translate('NewEM');
    ButtonOK.Caption := Translate('OK');
    ButtonCancel.Caption := Translate('CANCEL');
    EditFN.Visible := False;
    EditLN.Visible := False;
    EditUN.Text := '';
    EditPW.Visible := False;
    EditEM.Text := '';
    EditUN.EchoMode := emPassword;
    ShowModal;
    EditUN.EchoMode := emNormal;
    if (ModalResult = mrOk) and UpdateEmail(Username, EditUN.Caption,
      EditEM.Caption) then
    begin
      Alert('EUPD');
    end;
  end;
end;

procedure TForm1.MenuChangePasswordClick(Sender: TObject);
begin
  with FormRegister do
  begin
    Caption := Translate('MCCP');
    Label1.Caption := Translate('CPIntro');
    Label2.Visible := False;
    Label3.Visible := False;
    Label4.Caption := Translate('RegCP');
    Label5.Visible := False;
    Label6.Caption := Translate('RegNP');
    ButtonOK.Caption := Translate('OK');
    ButtonCancel.Caption := Translate('CANCEL');
    EditFN.Visible := False;
    EditLN.Visible := False;
    EditUN.Text := '';
    EditPW.Visible := False;
    EditEM.Text := '';
    EditUN.EchoMode := emPassword;
    EditEM.EchoMode := emPassword;
    ShowModal;
    EditUN.EchoMode := emNormal;
    EditEM.EchoMode := emNormal;
    if (ModalResult = mrOk) and UpdatePassword(Username,
      EditUN.Caption, EditEM.Caption) then
    begin
      Alert('PUPD');
      Password := EditEM.Caption;
    end;
  end;
end;

procedure TForm1.MenuManageClassesClick(Sender: TObject);
begin
  FormStudents.ShowModal;
end;

procedure TForm1.MenuNotificationsClick(Sender: TObject);
var
  Nts: TStrings;
  i: integer;
  Result: integer;
  c: char;
begin
  Nts := Get_notifications(Password, Username);
  for i := 0 to Nts.Count - 1 do
  begin
    c := GetItem(Nts.Strings[i], ' : ', 6)[1]; // It's only ever one character anyway.
    case c of
      'r': begin
        Result := QuestionDlg(Translate(''), GetItem(Nts.Strings[i], ' : ', 2) +
          ' (' + GetItem(Nts.Strings[i], ' : ', 1) + ') ' +
          Translate('NApp1') + GetItem(Nts.Strings[i], ' : ', 4) + Translate('NApp2'),
          mtCustom, [1, Translate('ButAccept'), 2,
          Translate('ButDecline')], '');
        if Result = 1 then
          AddStudentToClass(Password, Username, Username,
            GetItem(Nts.Strings[i], ' : ', 1), GetItem(Nts.Strings[i], ' : ', 3));
        if Result = 2 then
          SendNotification(Password, Username, GetItem(Nts.Strings[i], ' : ', 1),
            GetItem(Nts.Strings[i], ' : ', 3), '', 'D');
      end;
      'x': ShowMessage(GetItem(Nts.Strings[i], ' : ', 2) + ' (' +
          GetItem(Nts.Strings[i], ' : ', 1) + ') ' + Translate('NLeft') + ' ' +
          GetItem(Nts.Strings[i], ' : ', 4) + '.');
      'A': ShowMessage(Translate('NAcc') + ' ' + GetItem(Nts.Strings[i], ' : ', 4));
      'D': ShowMessage(Translate('NDec') + ' ' + GetItem(Nts.Strings[i], ' : ', 4));
      'X': ShowMessage(Translate('NRem') + ' ' + GetItem(Nts.Strings[i], ' : ', 4));
    end;
  end;

  Nts.Free;
end;

procedure TForm1.MenuAssignmentsClick(Sender: TObject);
var
  i, n: integer;
  A: TStrings;
  f: TextFile;
  s: string;
begin
  AssignmentList.Free;
  AssignmentList := Get_assignments(Password, Username);
  if AssignmentList.Count > 0 then
    FormAssignments.ShowModal
  else
  begin
    Alert('NOASS');
    Exit;
  end;

  if (FormAssignments.ModalResult = mrOk) and AreYouSure then
  begin
    for i := 1 to FormAssignments.AGrid.RowCount - 1 do
      if FormAssignments.AGrid.Cells[0, i] = '1' then n := i - 1;
    AssignmentID := GetItem(AssignmentList.Strings[n], ' : ', 1);
    A := Get_assignment(Password, Username, AssignmentID);
    if IsDecimal(GetItem(AssignmentList.Strings[n], ' : ', 4)) then
    begin
      AssignmentScore := StrToInt(GetItem(AssignmentList.Strings[n], ' : ', 4));
      AssignmentComplete := True;
    end
    else
    begin
      AssignmentScore := -1;
      // To ensure that a score of 0 will beat it and be uploaded.
      AssignmentComplete := False;
    end;

    if A.Count > 0 then // otherwise the download failed
    begin
      // We save the user's state memory, since we're going to overwrite it.
      SaveRsc(ProgramName, ProgramVersion, ProgramPublisher);
      // A bit of a kludge, since we could just put the data where it ought to
      // go. But we already have routines for loading the data from disc, so let's
      // save it to disc and then use them.
      AssignFile(f, HomeDirectory + 'Resources\File transfer\Assignment.asm');
      Rewrite(f);
      for i := 0 to A.Count - 1 do
        WriteLn(f, A.Strings[i]);
      Reset(f);
      ReadLn(f, AssignmentType);
      ReadLn(f, s);
      AssignmentHasResits := (s = 'Y');
      ReadLn(f, AssignmentQuestionLimit);
      MenuMainScreen.Checked := True;
      Wipe;
      GetRscFile(f);
      DataExists := True;
      UnsavedChangesExist := False;
      AssignmentExists := True;
      DoOpenVcb(f);
      CloseFile(f);


      if Filename <> '' then    // The student gets a copy of the .vcb file for revision.
      begin
        if IsLeft(Filename, ':') then Filename := Split(Filename, ':', 2);
        Filename := HomeDirectory + 'Vocab lists\' + ExtractFileName(Filename);
        SaveAll;
        VcbFileExists := True;
      end;

      MakeTopicBox;

      if AssignmentType = 2 then
        DisplayVocab(DISPLAY_NONVOCAB)
      else
        DisplayVocab(DISPLAY_SELECTED);
      UpdateScreen;

    end;
  end;

end;

procedure TForm1.MenuAssignWorkClick(Sender: TObject);
begin
  FormAssignHomework.EditAssignmentName.Text := Split(ExtractFileName(Filename), '.', 1);
  FormAssignHomework.ShowModal;
end;


// ************* THE USER MENU *********************

procedure TForm1.MenuSoloUserClick(Sender: TObject);
begin
  Status := USER_SOLO;
  UpdateScreen;
end;

procedure TForm1.MenuTeacherClick(Sender: TObject);
begin
  Status := USER_TEACHER;
  UpdateScreen;
  if (Username = '') or (Password = '') then MenuSignInClick(Sender);
end;

procedure TForm1.MenuStudentClick(Sender: TObject);
begin
  Status := USER_STUDENT;
  UpdateScreen;
  if (Username = '') or (Password = '') then MenuSignInClick(Sender);
end;

procedure TForm1.MenuMultipleStudentsClick(Sender: TObject);
begin
  Status := USER_MULTIPLE;
  UpdateScreen;
  MenuSignInClick(Sender);
end;

procedure TForm1.MenuDualUserClick(Sender: TObject);
begin
  Status := USER_DUAL;
  UpdateScreen;
  if (Username = '') or (Password = '') then MenuSignInClick(Sender);
end;

// **************** THE OPTIONS MENU *******************

procedure TForm1.MenuTestOptionsClick(Sender: TObject);
begin
  if not TestStarted then
  begin
    FormQA.QOGroup.ItemIndex := QOGroup_i;
    FormQA.WOFGroup.ItemIndex := WOFGroup_i;
    FormQA.CheckCFBT.Checked[0] := (CheckCFBT_i = 1);
    FormQA.Scrollbar1.Position := Scrollbar1_i;
    FormQA.Caption := Translate('MTO');
    FormQA.Color := Form1.Color;
    OptionsOnly := True;
    FormQA.ShowModal;
  end;
end;

procedure TForm1.MenuAppearanceOptionsClick(Sender: TObject);
var
  i: integer;
  AvailableLngFiles: TStringList;
begin
  with FormAO do
  begin
    Caption := Translate('MPO');
    FontLabel.Caption := Translate('POFont');
    TitleFontLabel.Caption := Translate('TIFont');
    FontsizeLabel3.Caption := Translate('POSize3');
    ApplicationLanguageLabel.Caption := Translate('POAL');
    FontBox.Text := MainFont;
    FontBox.Items := Screen.Fonts;
    TitleFontBox.Text := TitleFont;
    TitleFontBox.Items := Screen.Fonts;
    FontSizeBox3.Text := IntToStr(BaseFontSize);
    ApplicationLanguageBox.Text := AppLang;
    AvailableLngFiles := FindAllFiles(HomeDirectory + 'Internationalization',
      '*.lng', True);
    ApplicationLanguageBox.Items.Clear;
    for i := 0 to AvailableLngFiles.Count - 1 do
      ApplicationLanguageBox.Items.Add(
        Split(ExtractFileName(AvailableLngFiles[i]), '.', 1));
    AvailableLngFiles.Free;
    Button1.Caption := Translate('OK');
    Button2.Caption := Translate('CANCEL');
    ShowModal;
    if ModalResult = mrOk then
    begin
      if (FontBox.ItemIndex <> -1) and (MainFont <> FontBox.Text) then
      begin
        MainFont := FontBox.Text;
        Mainfont_b := FontBox.Text;
      end;
      if (TitleFontBox.ItemIndex <> -1) and (TitleFont <> TitleFontBox.Text) then
      begin
        TitleFont := TitleFontBox.Text;
        TitleFont_b := TitleFontBox.Text;
      end;
      if (FontSizeBox3.ItemIndex <> -1) and (BaseFontSize <>
        StrToInt(FontSizeBox3.Text)) then
      begin
        BaseFontSize := StrToInt(FontSizeBox3.Text);
        Fontsize3_b := StrToInt(FontSizeBox3.Text);
      end;
      if (ApplicationLanguageBox.ItemIndex <> -1) and
        (ApplicationLanguageBox.Text <> AppLang) then
      begin
        AppLang := ApplicationLanguageBox.Text;
        OpenLanguage;
        MainFont := Translate('Default body font');
        TitleFont := Translate('Default title font');
        BaseFontSize := StrToInt(Translate('Default base font size'));
        Mainfont_b := MainFont;
        TitleFont_b := TitleFont;
        Fontsize3_b := BaseFontSize;
      end;
      SetFonts;
      if MenuEditSettings.Checked or MenuEditVcb.Checked then DisplayVocab(DISPLAY_ALL);
      if MenuMainScreen.Checked then DisplayVocab(DISPLAY_SELECTED);
      MakeTopicBox;
      UpdateScreen;
    end;
  end;
end;

procedure TForm1.MenuLockdownOptionsClick(Sender: TObject);
var
  i: integer;
begin
  with FormLO do
  begin
    Caption := Translate('MLO');
    LockdownGroup.Caption := Translate('MLO');
    for i := 0 to LockdownCount - 1 do LockdownGroup.Items[i] := TranslateList('Lo1', i);
    for i := 0 to LockdownCount - 1 do LockdownGroup.Checked[i] := (LockStr[i + 1] = 'Y');
    Button1.Caption := Translate('OK');
    Button2.Caption := Translate('CANCEL');
    ShowModal;
    if ModalResult = mrOk then
    begin
      for i := 0 to LockdownCount - 1 do if LockdownGroup.Checked[i] then
          LockStr[i + 1] := 'Y'
        else
          LockStr[i + 1] := 'N';
      LockdownBackup := LockStr;
      UpdateScreen;
    end;
  end;
end;

// ***************** VIEW MENU ***********************

procedure SchlurpSettings;
var
  TF: TFontParams;
  i, j: integer;
  Par: string;
  Translate, nd: integer;
  Count: integer;
  Diff: integer;
  SchemeLine: integer;
  EmdashPosition: integer;
begin

  // I'm going to leave all the instrumentation in this because it is hideously
  // brittle and I expect to have to debug it again.

  // First we count the lines to be entered, because we're going to have to
  // move all the vocab, because I put 'em all in the same dumb and cumbersome
  // data structure. One day I'll refactor it. Not today.

  Translate := 1;
  Count := 0;
  with Form1.WMemo do
  begin
    repeat
      nd := Utf16Pos(#13, Text, Translate + 1);
      if nd = 0 then nd := Utf16Length(Text);
      GetTextAttributes(Translate, TF);
      if TF.Size = BaseFontSize then
        Count := Count + 1;
      Translate := nd;
    until (nd = Utf16Length(Text));
  end;

  // Now we move everything.

  Diff := Count - TopicEnd[seLastSetting];
  if Diff < 0 then
    for i := TopicStart(VocabStarts) to TopicEnd[LastTopic] do
    begin
      Qtype[i + Diff] := Qtype[i];
      VcbEntry[1, i + Diff] := VcbEntry[1, i];
      VcbEntry[2, i + Diff] := VcbEntry[2, i];
    end;

  if Diff > 0 then
    for j := TopicStart(VocabStarts) to TopicEnd[LastTopic] do
    begin
      i := TopicStart(VocabStarts) + TopicEnd[LastTopic] - j;
      Qtype[i + Diff] := Qtype[i];
      VcbEntry[1, i + Diff] := VcbEntry[1, i];
      VcbEntry[2, i + Diff] := VcbEntry[2, i];
    end;

  for i := VocabStarts to LastTopic do
    TopicEnd[i] := TopicEnd[i] + Diff;

  // Now we schlurp

  Translate := 1;
  SchemeLine := 0;
  j := 0;
  with Form1.WMemo do
  begin
    for i := seDatastarts to seLastSetting do
    begin
      // We start the loop when we're looking at the topic heading in both lists.
      // We already know what this says, so we can discard it.
      nd := Utf16Pos(#13, Text, Translate + 1);
      if nd = 0 then nd := Utf16Length(Text);
      Par := Utf16Copy(Text, Translate + 1, nd - Translate - 1);
      Translate := nd;

      GetTextAttributes(Translate, TF);

      //     showmessage('Discarding scheme heading '+Scheme.Strings[SchemeLine]+#13
      //                 +'Discarding memo heading '+par);
      SchemeLine := SchemeLine + 1;
      if (SchemeLine < Scheme.Count) and IsLeft(Scheme.Strings[SchemeLine], '+') then

      begin

        // In that case we can skip this section of the scheme, since it allows
        // for  variable, user-editable lines.

        repeat
          //        showmessage('Discard scheme line: '+Scheme.Strings[SchemeLine]);
          SchemeLine := SchemeLine + 1;
        until not IsLeft(Scheme.Strings[SchemeLine], '+');

        // Now we schlurp the variable lines in.
        while TF.Size = BaseFontSize do
        begin
          nd := Utf16Pos(#13, Text, Translate + 1);
          if nd = 0 then nd := Utf16Length(Text);
          Par := Utf16Copy(Text, Translate + 1, nd - Translate - 1);
          j := j + 1;
          if (TF.Color = clPlain) or (TF.Color = clKBody) or
            (TF.Color = clQBody) then
          begin
            Qtype[j] := '';
            VcbEntry[1, j] := '¶' + Par;
            VcbEntry[2, j] := '';
          end
          else
          begin
            EmdashPosition := Utf16Pos(Utf8ToUtf16(' — '), Par);
            VcbEntry[1, j] := Utf16Copy(Par, 1, EmdashPosition - 1);
            VcbEntry[2, j] :=
              Utf16Copy(Par, EmdashPosition + 3, Utf16Length(Par) - EmdashPosition - 1);
            // We protect the token from being turned into a literal [DEFAULT].
            if (i = seQuestionFormats) and
              (j = TopicStart(seQuestionFormats) + 1) then
              VcbEntry[1, j] := '#[DF]';
          end;
          //             showmessage('Schlurping: '+par);
          Translate := nd;
          GetTextAttributes(Translate, TF);
        end;
      end

      // Otherwise we're in a fixed-format section of the settings.
      else
      begin

        while (SchemeLine < Scheme.Count) and (TF.Size = BaseFontSize) do
        begin
          nd := Utf16Pos(#13, Text, Translate + 1);
          if nd = 0 then nd := Utf16Length(Text);
          Par := Utf16Copy(Text, Translate + 1, nd - Translate - 1);
          j := j + 1;
          //           showmessage('Scheme line: '+ Scheme.Strings[SchemeLine]+#13
          //                      +'Schlurping: '+ par);
          // If it's a Boolean setting ...

          if IsLeftWideString(Par, Utf8ToUtf16('■')) or
            IsLeftWideString(Par, Utf8ToUtf16('□')) or IsLeftWideString(Par,
            Utf8ToUtf16('●')) or IsLeftWideString(Par, Utf8ToUtf16('○')) then
          begin
            VcbEntry[1, j] :=
              Utf16Copy(Par, 1, 1) + Utf8Copy(Scheme.Strings[SchemeLine], 2,
              Length(Scheme.Strings[SchemeLine]) - 1);
          end
          else
          begin
            if TF.Color = clPrompt then
            begin
              EmdashPosition := Utf16Pos(Utf8ToUtf16(' — '), Par);
              VcbEntry[1, j] := Split(Scheme.Strings[SchemeLine], ' — ', 1);
              VcbEntry[2, j] :=
                Utf16Copy(Par, EmdashPosition + 3, Utf16Length(Par) - EmdashPosition - 1);
            end
            else
            begin
              VcbEntry[1, j] := Split(Scheme.Strings[SchemeLine], ' — ', 1);
              VcbEntry[2, j] := '';
            end;
          end;
          Translate := nd;
          SchemeLine := SchemeLine + 1;
          GetTextAttributes(Translate, TF);
        end;    // end of while loop; we have reached the end of a section.
      end;// end of reading fixed-format section.
      TopicEnd[i] := j;
    end;   // of the for loop, we have read a section.
  end;  // of "with Form1.WMemo".
  DoOverrides;
  ValidateAudio;
end;


procedure SchlurpWMemo;
var
  TF: TFontParams;
  Par: string;
  Translate, nd: integer;
  StUtf16: integer;
  j: integer;
begin
  // We take the data out of the WMemo and put it into .vcb format.

  // First we prepare the data.

  LastTopic := LowerTopic - 1;
  j := TopicEnd[LowerTopic - 1];

  // Now we schlurp.
  Translate := 1;            // 1 because of the blank line at the top.
  StUtf16 := 1;              // Ditto.

  // While we're schlurping we'll make a note of the topic and
  // entry the cursor's on.
  CurTopic := -1;
  CurEntry := 0;

  with Form1.WMemo do
  begin
    repeat
      nd := PosEx(#13, Text, Translate + 1);
      if nd = 0 then nd := Length(Text) + 1;
      Par := Copy(Text, Translate + 1, nd - Translate - 1);
      GetTextAttributes(StUtf16, TF);
      if TF.Size > BaseFontSize then
      begin
        LastTopic := LastTopic + 1;
        TopicName[LastTopic] := Par;
        if (StUtf16 <= SelStart) and (SelStart <= StUtf16 + Utf16Length(Par)) then
          CurTopic := LastTopic;
      end
      else
      begin
        j := j + 1;
        if TF.Color = clPara then
        begin
          Qtype[j] := '';
          VcbEntry[1, j] := '¶' + Par;
          VcbEntry[2, j] := '';
        end
        else
          StringToEntry(Par, j, LastTopic);
        if (StUtf16 <= SelStart) and (SelStart <= StUtf16 + Utf16Length(Par)) then
        begin
          CurTopic := LastTopic;
          CurEntry := j;
        end;
      end;
      Translate := nd;
      StUtf16 := StUtf16 + Utf16Length(Par) + 1;
      TopicEnd[LastTopic] := j;
    until (nd >= Length(Text));
  end;

  LowerTopic := VocabStarts;
  UpperTopic := LastTopic;
  MakeTopicBox;
end;

procedure TForm1.MenuMainScreenClick(Sender: TObject);
begin
  if ViewMode = VIEW_MAIN then Exit;
  Cursor := crHourglass;
  HideEverything;
  if (ViewMode = VIEW_GRAMMAR) and GrmFileExists and GrmUnsavedChangesExist then
  begin
    SaveGrm;
    ConvertAllGrmToPy;
  end;
  if (ViewMode = VIEW_EDIT) then SchlurpWMemo;
  if (ViewMode = VIEW_SETTINGS) then SchlurpSettings;
  ViewMode := VIEW_MAIN;
  LowerTopic := VocabStarts;
  UpperTopic := LastTopic;
  SelectedTopic := -1;
  MakeTopicBox;
  if DataExists then
  begin
    DisplayVocab(DISPLAY_SELECTED);
  end;
  UpdateScreen;
  Cursor := crArrow;
  WMemo.Cursor := crArrow;
end;


procedure TForm1.MenuEditSettingsClick(Sender: TObject);
begin
  if ViewMode = VIEW_SETTINGS then Exit;
  Cursor := crHourglass;
  HideEverything;
  if (ViewMode = VIEW_GRAMMAR) and GrmFileExists and GrmUnsavedChangesExist then
  begin
    SaveGrm;
    ConvertAllGrmToPy;
  end;
  if (ViewMode = VIEW_EDIT) then SchlurpWMemo;

  ViewMode := VIEW_SETTINGS;
  LowerTopic := seDatastarts;
  UpperTopic := seLastSetting;
  if DataExists then DisplayVocab(DISPLAY_ALL);
  UpdateScreen;
  Cursor := crArrow;
  WMemo.Cursor := crDefault;
end;

procedure TForm1.MenuEditVcbClick(Sender: TObject);
begin
  if ViewMode = VIEW_EDIT then Exit;
  Cursor := crHourglass;
  HideEverything;
  if (ViewMode = VIEW_GRAMMAR) and GrmFileExists and GrmUnsavedChangesExist then
  begin
    SaveGrm;
    ConvertAllGrmToPy;
  end;
  if (ViewMode = VIEW_SETTINGS) then SchlurpSettings;
  ViewMode := VIEW_EDIT;
  LowerTopic := VocabStarts;
  UpperTopic := LastTopic;
  if DataExists then DisplayVocab(DISPLAY_ALL);
  UpdateScreen;
  Cursor := crArrow;
  WMemo.Cursor := crDefault;
end;

procedure TForm1.MenuEditGrmClick(Sender: TObject);
var
  i, MaxW: integer;
begin
  if ViewMode = VIEW_GRAMMAR then Exit;
  Cursor := crHourglass;
  HideEverything;
  if ViewMode = VIEW_EDIT then SchlurpWMemo;
  if (ViewMode = VIEW_SETTINGS) then SchlurpSettings;
  ViewMode := VIEW_GRAMMAR;


  if DataExists then
  begin
    GKeyGroup.Items[0] := Language(1);
    GKeyGroup.Items[1] := Language(2);
  end
  else
  begin
    GKeyGroup.Items[0] := '';
    GKeyGroup.Items[1] := '';
  end;

  TopicCombo.Items.Clear;
  for i := VocabStarts to LastTopic do
    TopicCombo.Items.Add(TopicName[i]);

  MaxW := 50;
  for i := 0 to TopicCombo.Items.Count - 1 do
    MaxW := Max(MaxW, TopicBox.Canvas.TextWidth(TopicCombo.Items[i]));
  TopicCombo.Width := MaxW + 30;
  WordCombo.Items.Clear;

  // The topic referred to in the TopicCombo.Text, if there is one, may since
  // have been deleted or may now ocupy a different position on the topics list,
  // its vocab may have been edited, etc.

  TopicCombo.ItemIndex := TopicCombo.Items.IndexOf(TopicCombo.Text);
  if TopicCombo.ItemIndex = -1 then
    TopicCombo.Text := Translate('TP')
  else
  begin
    for i := TopicStart(VocabStarts + TopicCombo.ItemIndex)
      to TopicEnd[VocabStarts + TopicCombo.ItemIndex] do
      if not IsLeft(VcbEntry[1, i], '¶') then WordCombo.Items.Add(EntryToString(i));
    if (TopicStart(SelectedTopic) <= SelectedEntry) and
      (TopicStart(SelectedTopic) <= TopicEnd[SelectedTopic]) then
      WordCombo.Text := EntryToString(SelectedEntry);
  end;

  Form1.GMemo.Anchors := [akTop, akLeft, akBottom, akRight];
  UpdateScreen;
  Cursor := crArrow;
  WMemo.Cursor := crDefault;
end;


// ******************* HELP MENU ************************

procedure TForm1.MenuAboutVcbClick(Sender: TObject);
var
  s: string;
  i: integer;
begin
  s := '';
  for i := TopicStart(seAboutVlist) to TopicEnd[seAboutVlist] do
    s := s + #13 + Split(VcbEntry[1, i], '¶', 2);
  ShowMessage(s);
end;

procedure TForm1.MenuKeyboardHelpClick(Sender: TObject);
var
  s: string;
  i: integer;
begin
  s := '';
  for i := TopicStart(seKeysHelp) to TopicEnd[seKeysHelp] do
    s := s + sLineBreak + #13 + Split(VcbEntry[1, i], '¶', 2);
  ShowMessage(s);
end;

procedure TForm1.MenuAboutThisProgramClick(Sender: TObject);
var
  HelpMessage: string;
begin
  HelpMessage := '';
  if ProgramName <> 'Peach' then
    HelpMessage := ProgramName + ' ' + ' ' + ProgramVersion + Translate('PB') + ' ';
  HelpMessage := HelpMessage + 'Peach ' + GetFileVersion + '.' + #13 +
    #13 + Translate('CR1') + #13 + #13 + Translate('CR2') + #13 + #13 +
    Translate('CR3') + #13 + #13 + 'Viva Las Vegas!' + #13 + #13;
  ShowMessage(HelpMessage);
end;

procedure TForm1.MenuCopyrightClick(Sender: TObject);
begin
  FormLicenses.ShowModal;
end;

// ****************** THE TEST BUTTONS ****************

procedure DoStartTest;
var
  i: integer;
begin
  if ValidateSelection then
  begin
    if AssignmentInProgress and not AssignmentHasResits then
      UploadResult(Password, Username, AssignmentID, 0);
    // This is so students can't cheat the "no resits" option
    with FormQA do
      // by restarting the program.
    begin
      Color := Form1.Color;
      Icon := Form1.Icon;

      QOGroup.ItemIndex := QOGroup_i;
      WOFGroup.ItemIndex := WOFGroup_i;
      CheckCFBT.Checked[0] := (CheckCFBT_i = 1);
      Scrollbar1.Position := Scrollbar1_i;
      if AssignmentInProgress then
      begin
        Caption := Translate('TEST');
        if AssignmentType = 1 then DisplayVocab(DISPLAY_NONVOCAB);
        // It's a half-closed test, we're closing the book.
      end
      else
      begin
        Caption := Translate('PRAC');
        QuitButton.Caption := Translate('QUIT');
        RestartButton.Caption := Translate('REST');
      end;

      AEdit.Font.Name := MainFont;
      QText.Font.Name := MainFont;
      for i := 0 to 3 do Card(i).Font.Name := MainFont;
      for i := 0 to 3 do Card(i).Height := 2 * Card(i).Canvas.TextHeight('Hey');
      for i := 0 to 3 do Card(i).Font.Size := Round(BaseFontSize * 1.33);
      HText.Font.Name := MainFont;
      AEdit.Font.Size := Round(BaseFontSize * 1.33);
      QText.Font.Size := Round(BaseFontSize * 1.33);
      HText.Font.Size := BaseFontSize;
      ShowOptions := False;
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
      OptionsOnly := False;
      UpdateScreen;
      QAUpdateScreen;
      FormChangeBounds(FormQA);
      Show;
      AskQuestion;
    end;

    Form1.TestButton.Visible := False;
    Form1.ButtonPractice.Visible := False;
    Form1.ButtonAssignment.Visible := False;

    // This is what we do if a grammar error has occurred during a test
    // and the grammar editor isn't locked down.

    if (FormQA.ModalResult = mrAbort) and (LockStr[lkEditing] = 'N') then
      with Form1 do
      begin
        SelectedEntry := nm;
        MenuEditGrm.Checked := True;
        MenuEditGrmClick(Form1);
        GrmFileExists := True;
        GrmUnsavedChangesExist := False;
        SetGrmFilename(PythonName);
        OpenGrmFile;
        TopicCombo.ItemIndex := SelectedTopic - VocabStarts;
        WordCombo.Items.Clear;
        for i := TopicStart(SelectedTopic) to TopicEnd[SelectedTopic] do
          if not IsLeft(VcbEntry[1, i], '¶') then WordCombo.Items.Add(EntryToString(i));
        WordCombo.Text := EntryToString(SelectedEntry);
        DataEdit.Text := EntryToString(SelectedEntry);
        if QAqf <> '' then QAqf := QAqf + ' ';
        GOut.Caption := QAqf + W[1] + ' — ' + W[2];
        MakeError(QAE, QAEnumber, '');
        UpdateScreen;
      end;
  end;
end;

procedure TForm1.TestButtonClick(Sender: TObject);
begin
  AssignmentInProgress := False;
  DoStartTest;
end;

procedure TForm1.ButtonPracticeClick(Sender: TObject);
begin
  AssignmentInProgress := False;
  DoStartTest;
end;

procedure TForm1.ButtonQuitAssignmentClick(Sender: TObject);
begin
  MenuCloseClick(Sender);
end;

procedure TForm1.ButtonAssignmentClick(Sender: TObject);
begin
  AssignmentInProgress := True;
  DoStartTest;
end;


//******* TOPIC BOX *******

procedure TForm1.TopicBoxClickCheck(Sender: TObject);
var
  i, j: integer;
begin
  ;
  TopicBoxFlag := True;
  if not AssignmentExists then
  begin
    SomethingChecked := False;
    for i := 0 to TopicBox.Items.Count - 1 do
    begin
      TopicsToDisplay[IndexToTopic(i)] := TopicBox.Checked[i];
      for j := TopicStart(IndexToTopic(i)) to TopicEnd[IndexToTopic(i)] do
      begin
        InUse[j] := TopicsToDisplay[IndexToTopic(i)] and not
          IsLeft(VcbEntry[1, j], '¶');
        if InUse[j] then  EntryNumber := EntryNumber + 1;
        SomethingChecked := SomethingChecked or InUse[j];
      end;
    end;
    if not SomethingChecked then
    begin
      FormQA.Hide;
      TestStarted := False;
    end;
    UpdateScreen;
    if DataExists then DisplayVocab(DISPLAY_SELECTED);
    WMemo.Lines.BeginUpdate;
    WMemo.CaretPos := Point(0, WMemo.Lines.Count - 1);
    WMemo.Perform(EM_SCROLLCARET, 0, 0);
    WMemo.CaretPos := Point(0, ScrollTo - 1);
    WMemo.Perform(EM_SCROLLCARET, 0, 0);
    WMemo.Lines.EndUpdate;
  end
  else
    for i := 0 to TopicBox.Items.Count - 1 do TopicBox.Checked[i] :=
        TopicsToDisplay[IndexToTopic(i)];

  TopicBox.ItemIndex := -1;

end;

procedure TForm1.TopicBoxClick(Sender: TObject);
begin
  if not TopicBoxFlag then
  begin
    TopicBox.Checked[TopicBox.ItemIndex] := not TopicBox.Checked[TopicBox.ItemIndex];
    TopicBoxClickCheck(Form1);
  end;
  TopicBox.ItemIndex := -1;
  TopicBoxFlag := False;
end;

end.
