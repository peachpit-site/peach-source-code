unit WMemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, RichMemo, RegExpr, Graphics, Dialogs, Windows,
  LazUTF8, LazUTF16, Keyboard, RMInlinePicture, FGL, Internet, RichMemoUtils, 
  Types, Vocab, CommonStringFunctions, AppLanguage;

const psPadding = 1;
      psPara = 2;
      psVocab = 3;
      psFixed = 4;
      psPrompt = 5;
      psTitle = 6;
      psEntry = 7;
      psKeys = 8;
      psKBody = 9;
      psQBody = 10;
      psQForms = 11;
      psPlain = 12;
      psBool = 13;
      psTopic = 14;
      psSetting = 15;
      psSettingsHeader = 16;
      psPicture = 17;

      psItalic = 18;
      psBold = 19;
      psUnderline = 20;
      psYellow = 21;
      psGreen = 22;
      psPink = 23;
      psMonospace = 24;
      psSuperscript = 25;
      psSubscript = 26;
      psBullet = 27;

const PStyles = 27;

type
  TMemoPic = 
        class
        Pic: TPicture;
        ip: TRichMemoInlinePicture;
	end;

  TMemoPicList = specialize TFPGObjectList < TMemoPic > ;

type
  TWMemo = class(TRichMemo)
  private
    var Pix: TMemoPicList;
    procedure SetFont(AFont: TFont);
    function GetFont: TFont;
  protected
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
    procedure KeyUp(var Key: word; Shift: TShiftState); override;
    procedure Click; override;

  public
    function PStart: integer;
    function XYtoX(x, y: integer): integer;
    property Font: TFont Read GetFont Write SetFont;
    procedure MarkUp(MStart, MLength, MStyle: integer);
    procedure UpdateFonts(F, TF: string; BS, BulletWidth: integer);
    procedure AddPicture(ImageLink: string; Pos: integer);
    procedure ResetPictures();
    Constructor Create(AOwner: TComponent); override;

    var Fonts: array [1 .. PStyles] of TFontParams;
        Metrics: array [1 .. PStyles] of TParaMetric;
        Alignments: array [1 .. PStyles] of TParaAlignment;


end;


var BulletSpace: integer;

// This is kinda dirty. I'm distinguishing between text elements by
// having them be slightly different shades of black and blue.

const  clPara   = $00000000;    // Regular paragraph as in vocab section: can start indent.
       clVocab  = $00000001;    // Vocab entry.
       clFixed  = $00000100;    // Uneditable parts of the Settings.
       clPrompt = $00010000;    // The uneditable LHS of an editable or Boolean setting.
       clTitle  = $00010001;    // The title, duh.
       clEntry  = $00FF0000;    // The editable right-hand side of a setting.
       clKBody  = $00FF0001;    // Body text in keyboard sections.
       clKeys   = $00FF0100;    // A keyboard setting.
       clQBody  = $00FF0101;    // Body text in qforms sections.
       clQForms = $00FE0000;    // The question formats / grammar directives.
       clPlain  = $00FE0001;    // Paragraph text in the settings: cannot start an indent.
       clBool   = $00FE0100;    // Color of the buttons.        }



//More easily distinguishable colors for debugging purposes. Do not delete.

{const clPara   = $00808080;    // Regular paragraph as in vocab section: can start indent.
       clVocab  = $0000FF00;    // Vocab entry.
       clFixed  = $00FF00FF;    // Uneditable parts of the Settings.
       clPrompt = $000000FF;    // The uneditable LHS of an editable or Boolean setting.
       clTitle  = $00800080;    // The title, duh.
       clEntry  = $00FF0000;    // The editable right-hand side of a setting .
       clKeys   = $00008000;    // A keyboard setting.
       clKBody  = $0000FF80;    // Body text in keyboard sections.
       clQBody  = $00008080;    // Body text in qforms sections.
       clQForms = $0000FFFF;    // The question formats / grammar directives.
       clPlain  = $0080FF00;    // Paragraph text in the settings: cannot start an indent.
       clBool   = $00FF0080;    // Color of the buttons.                  }


procedure Register;

implementation

constructor TWMemo.Create(AOwner: TComponent);
begin
Pix := TMemoPicList.Create;
inherited;
end;

procedure TWMemo.AddPicture(ImageLink: string; Pos: integer);
var NewPic: TMemoPic;
begin
NewPic := TMemoPic.Create;
NewPic.Pic := TPicture.Create;
Download_picture(NewPic.Pic, ImageLink);
NewPic.ip := TRichMemoInlinePicture.Create(NewPic.Pic);
InDelInline(NewPic.ip, Pos, 0, Types.Size(Round(NewPic.Pic.Width*72/96), Round(NewPic.Pic.Height*72/96)));
Pix.Add(NewPic);
end;

procedure TWMemo.ResetPictures();
var
  i: integer;
begin
Pix.Destroy;
Pix := TMemoPicList.Create;
end;

procedure TWMemo.UpdateFonts(F, TF: string; BS, BulletWidth: integer);
var i: integer;
begin

for i := 1 to PStyles do
    begin
    InitFontParams(Fonts[i]);
    Fonts[i].Name := F;
    Fonts[i].Size := BS;
    Fonts[i].Style := [];
    InitParaMetric(Metrics[i]);
    if i in [psVocab, psKeys, psQForms, psPrompt, psEntry, psBool] then
      begin
      Metrics[i].FirstLine := 40;
      Metrics[i].HeadIndent := 60;
      Metrics[i].TailIndent := 40;
      end
    else
      begin
      Metrics[i].FirstLine := 20;
      Metrics[i].HeadIndent := 20;
      Metrics[i].TailIndent := 20;
      end;
    Alignments[i] := paJustify
    end;

BulletSpace := 20 + BulletWidth;
Metrics[psBullet].HeadIndent := BulletSpace;

// *********************************

Alignments[psTitle] := paCenter;
Alignments[psSettingsHeader] := paCenter;
Alignments[psPicture] := paCenter;

// *********************************

Fonts[psTitle].Name := TF;
Fonts[psTopic].Name := TF;
Fonts[psSetting].Name := TF;
Fonts[psSettingsHeader].Name := TF;

// *********************************

Fonts[psTitle].Size := BaseFontSize*2;
Fonts[psSettingsHeader].Size := BaseFontSize*2;
Fonts[psTopic].Size := Round(BaseFontSize*1.33);
Fonts[psSetting].Size := Round(BaseFontSize*1.33);

Fonts[psPadding].Color := clFixed;
Fonts[psPara].Color := clPara;
Fonts[psVocab].Color := clVocab;
Fonts[psFixed].Color := clFixed;
Fonts[psPrompt].Color := clPrompt;
Fonts[psTitle].Color := clTitle;
Fonts[psEntry].Color := clEntry;
Fonts[psKeys].Color := clKeys;
Fonts[psKBody].Color := clKBody;
Fonts[psQBody].Color := clQBody;
Fonts[psQForms].Color := clQForms;
Fonts[psPlain].Color := clPlain;
Fonts[psBool].Color := clBool;
Fonts[psTopic].Color := clPara;
Fonts[psSetting].Color := clPara;
Fonts[psSettingsHeader].Color := clFixed;
for i := psItalic to psBullet do
    Fonts[i].Color :=clPara;
for i := psYellow to psPink do
    Fonts[i].HasBkClr := true;
Fonts[psYellow].BkColor := clYellow;
Fonts[psGreen].BkColor := $8DF36A;
Fonts[psPink].BkColor := $6400FF;
Fonts[psItalic].Style := [fsItalic];
Fonts[psBold].Style := [fsBold];
Fonts[psUnderline].Style := [fsUnderline];
Fonts[psSuperscript].VScriptPos := vpSuperscript;
Fonts[psSubscript].VScriptPos := vpSubscript;
Fonts[psMonospace].Name := 'Courier New';

end;

procedure TWMemo.Markup(MStart, MLength, MStyle: integer);
begin
SetTextAttributes(MStart, MLength, Fonts[MStyle]);
SetParaMetric(MStart, MLength, Metrics[MStyle]);
SetParaAlignment(MStart, MLength, Alignments[MStyle]);
end;

procedure TWMemo.SetFont(AFont: TFont);
var i: integer;
begin
inherited Font := AFont;
for i := 1 to PStyles do
    begin
    Fonts[i].Name := Font.Name;
    Fonts[i].Size := Font.Size;
    end;
Fonts[psTitle].Size := Round(1.5*Font.Size);
Fonts[psTopic].Size := Round(1.25*Font.Size);
end;

function TWMemo.GetFont: TFont;
begin
result := inherited Font;
end;

function TWMemo.XYtoX(x, y: integer): integer;
begin
XYtoX := SendMessage(Handle, EM_LINEINDEX, y, x);
end;


function TWMemo.PStart: integer;       // Start of the paragraph the cursor's in.
var i, j: integer;
begin
for i := 0 to CaretPos.y do
    if GetText(XYtoX(0, CaretPos.y - i) - 1, 1) = #13 then break;
PStart := XYtoX(0, CaretPos.y - i)
end;


procedure TWMemo.KeyUp(var Key: Word; Shift: TShiftstate);
var i, j: integer;
    x, y: integer;
    Utf8x: integer;
    CurP, EndP: PChar;
    Len: Integer;
    ACodePoint: string;
    q1, q2, Found: Boolean;
    Quoted, temp: string;
    Qstart: integer;
    olen: integer;
    s: string;
    ts, lhs, rhs: widestring;
    tn: integer;
    TF: TFontParams;
    TF2: TFontParams;
    TP: TParaMetric;
    Par: widestring;
    ps: integer;
    EmdashPosition: integer;
    LineEmdash: integer;
    TabFlag: boolean;
    tempss: integer;
    Pre: string;

begin

if ReadOnly then
  begin
  Key := 0;
  Exit;
  end;

Lines.BeginUpdate;

x := self.CaretPos.x;
y := self.CaretPos.y;
TabFlag := false;

GetTextAttributes(SelStart, TF);
InitParaMetric(TP);

if (Key = 9) and (Shift = [ssShift]) then            // special tab
  begin
  ps := PStart;
  if (SelStart = ps) then
     begin
     TP.FirstLine := 40;
     TP.HeadIndent := 60;
     if TF.Color = clPara then MarkUp(XYtoX(0, y), Utf16Length(Lines[y]) + 1, psVocab);
     if TF.Color = clKBody then MarkUp(XYtoX(0, y), Utf16Length(Lines[y]) + 1, psKeys);
     if TF.Color = clQBody then MarkUp(XYtoX(0, y), Utf16Length(Lines[y]) + 1, psQForms);
     TabFlag := true;
     Key := 13;       // OK I will freely admit that as a way of managing flow of control this may be a bit sus but
     end              // at this point it's like Caligula worrying about using the wrong fork. All the keyboard handling
   else Key := 0;     // is a Lovecraftian horror anyway, let's just get it stable and never speak of it again.
   end;

GetTextAttributes(SelStart, TF);
if Key = 13 then                        // return
   begin
   if ((TF.Color = clVocab) or (TF.Color = clQForms) or (TF.Color = clKeys)) then
     begin
     if (Pos(' — ', Lines[y]) = 0)  then
        InDelText(' — ', XYtoX(Utf16Length(Lines[y]), y), 0);
     GetTextAttributes(SelStart - 1, TF2);
     if ((TF2.Color = clVocab) or (TF2.Color = clQForms) or (TF2.Color = clKeys)) and (Pos(' — ', Lines[y - 1]) = 0) then
        InDelText(' — ', XYtoX(Utf16Length(Lines[y - 1]), y - 1), 0);
     CaretPos := TPoint.Create(0, y);
     TP.FirstLine := 40;
     TP.HeadIndent := 60;
     SetParaMetric(SelStart, Utf16Length(Lines[y]), TP);
     end;
   if TF.Size > BaseFontSize then MarkUp(SelStart, Utf16Length(Lines[y]) - (SelStart - XYtoX(0, y)) + 1, psPara);
   end;

if (Key = 222) and not ((TF.Color = clVocab) or (TF.Color = clKeys)) then // We do smart quotes.
   begin

   if SelStart > 3 then Pre := GetText(SelStart - 2, 1) else Pre := #13;
   if (Pre = ' ') or (Pre = #13) or (Pre = '(') or (Pre = #9) then
     begin
     if Shift = [ssShift] then InDelText('“', SelStart - 1, 1);
     if Shift = [] then InDelText('‘', SelStart - 1, 1);
     end
   else
     begin
     if Shift = [ssShift] then InDelText('”', SelStart - 1, 1);
     if Shift = [] then  InDelText('’', SelStart - 1, 1);
     end;
   Key := 0;
   end;

if (Key = 56) and (Shift = [ssShift]) then // If we're at the start of a paragraph we do a bullet point for a *.
   begin
   if SelStart > 3 then Pre := GetText(SelStart - 2, 1) else Pre := #13;
   if (Pre = #13) then
     begin
     InDelText('• ', SelStart - 1, 1);
     CaretPos := TPoint.Create(2, y);
     MarkUp(SelStart, 1, psBullet);
     Key := 0;
     end;
   end;

GetParaMetric(SelStart, TP);
if (TP.FirstLine = 40) and not (((Key = 0) or (Key = 8)) and not TabFlag) and not ((Key = Ord('Z')) and (Shift = [ssCtrl])) then
  begin
  ps := PStart;
  EmdashPosition := Utf16Pos(Utf8ToUtf16(' — '), Text, ps);
  LineEmdash := Utf16Pos(Utf8ToUtf16(' — '), Lines[y]);
  olen := Utf16Length(Lines[y]);
  lhs := Utf16Copy(Lines[y], 1, LineEmdash - 1);
  rhs := Utf16Copy(Lines[y], LineEmdash + 3, Utf16Length(Lines[y]) - LineEmdash - 1);
  if (TF.Color = clVocab) then
    begin
    if SelStart <= EmdashPosition then
      begin
      if LineEmdash = 0 then
          ts := AddAccent(Lines[y], 1)
      else
          ts := AddAccent(lhs, 1) + Utf8ToUtf16(' — ') + rhs
      end
    else
      begin
      if LineEmdash = 0 then
          ts := AddAccent(Lines[y], 2)
      else
         ts := lhs + Utf8ToUtf16(' — ') + AddAccent(rhs, 2);
      end
    end
  else ts := Lines[y];
  if ts <> Lines[y] then
     begin
     GetParaMetric(SelStart, TP);
     InDelText(ts, XYtoX(0, y), Utf16Length(Lines[y]));
                          // check if this makes some of the following redundant.
     self.CaretPos := TPoint.Create(x + Utf16Length(self.Lines[y]) - olen, y);
     SetTextAttributes(ps, Utf16Length(Lines[y]) + 1, TF);
     SetParaMetric(ps, Utf16Length(Lines[y]) + 1, TP);
     if olen = 0 then SelStart := ps;
     end;
  end;

if (Key = 13) and (TF.Color = clPara) and IsLeft(Lines[y - 1], '•') and (Lines[y] = '') then
  begin
  InDelText('• ', XYtoX(0, y), 0);
  self.CaretPos := TPoint.Create(2, y);
  end;

Lines.EndUpdate;

inherited;

end;

procedure TWMemo.KeyDown(var Key: Word; Shift: TShiftstate);
var x, y: integer;
    cp, EmdashPosition, ps, ls: integer;
    TF: TFontParams;
    BK: TFontParams;
    TP: TParaMetric;
begin

if ReadOnly then
  begin
  Key := 0;
  Exit;
  end;

GetTextAttributes(SelStart, TF);
if (Lines[y] = '') and (TF.Color = clPara) and (Shift = [ssShift]) and (Key = 187) then
    begin
    MarkUp(SelStart, 1, psTopic);
    Key := 0;
    Exit;
    end;

Lines.BeginUpdate;

x := self.CaretPos.x;
y := self.CaretPos.y;
ls := XYtoX(0, y);



GetTextAttributes(SelStart, TF);
GetParaMetric(SelStart, TP);

if (Key = 8) and (TP.FirstLine = 40) then
   begin
   ps := PStart;
   if (ps = SelStart) and (Lines[y] = Utf8ToUtf16(' — ')) then
       begin
       Lines[y] := '';
       CaretPos := TPoint.Create(0, y);
       if TF.Color = clVocab then MarkUp(SelStart, Utf16Length(Lines[y]) + 1, psPara);
       if TF.Color = clKeys then MarkUp(SelStart, Utf16Length(Lines[y]) + 1, psKBody);
       if TF.Color = clQForms then MarkUp(SelStart, Utf16Length(Lines[y]) + 1, psQBody);
       Key := 0;
       end;
   end;

if (Key = 8) and (x = Utf16Length(Utf8ToUtf16('•'))) and (TP.HeadIndent = BulletSpace)
    and IsLeftWideString(Lines[y], Utf8ToUtf16('•')) then MarkUp(PStart, 1, psPara);

// For now I'm just going to turn the delete key off at the ends of paragraphs,
// it's that much trouble.
if (Key = 46) and ((SelStart = Utf16Length(Text)) or (GetUText(SelStart, 1)[1] = #13)) then Key := 0;
// Do better later.


// Shut down deletions of fixed text.
GetTextAttributes(SelStart - 1, BK);
if ((BK.Color = clFixed) or (BK.Color = clPrompt) or (BK.Color = clBool)) and (Key = 8) then Key := 0;

// We provide the usual special treatment for the emdash.
if (TP.FirstLine = 40) then
  begin

  cp := SelStart - ls;
  EmdashPosition := Utf16Pos(Utf8ToUtf16(' — '), Lines[y]);

  if (EmdashPosition <> 0) and (EmdashPosition <= cp) and (cp <= EmdashPosition + 2) then
    begin
    if Key = 37 then SelStart := ls + EmdashPosition - 1;    // Left arrow.
    if Key = 39 then // Right arrow.
      begin
      if cp = EmdashPosition + 2 then
        SelStart := SelStart + 1
      else
        SelStart := ls + EmdashPosition + 2;
      end;
    if not ((Key = 38) or (Key = 40)) and (cp < EmdashPosition + 2) then Key := 0;  // The exceptions being up and down.
    end;

  if (EmdashPosition <> 0) and (Key = 8) and (cp = EmdashPosition + 2) then
    begin
    Key := 0;
    SelStart := SelStart - 3;
    end;

  if (EmdashPosition <> 0) and
     (((Key = 9) and (cp < EmdashPosition ))
         or ((Key = 39) and (cp = EmdashPosition - 1))) then
    begin
    Key := 0;
    SelStart := ls + EmdashPosition + 2;
    end;

  if (EmdashPosition <> 0) and (Key = 46) and (cp = EmdashPosition - 1) then Key := 0;       // Delete

  end;

if ((TF.Color = clFixed) or (TF.Color = clPrompt) or (TF.Color = clBool) or (TF.Color = clTitle))
   and not (Key in [37 .. 40])
      then
        begin
        Key := 0;
        if TF.Color = clTitle then Alert('CANTEDIT');
        end;

if (TF.Color = clEntry) then
  begin
  if Key = 13 then Key := 0;
  if (Key = 46) and (Utf16Pos(#13, Text, SelStart) - SelStart = 1) then Key := 0;
  end;

Lines.EndUpdate;

inherited;
if (Key = 9) and (Shift = [ssShift]) then Key := 0;

end;

procedure TWMemo.Click;
var y, i: integer;
    TF: TFontParams;
begin

Lines.BeginUpdate;

GetTextAttributes(SelStart, TF);
TF.Name := Font.Name;      // Not sure why this is necessary. Possibly isn't any more, check.
y := CaretPos.y;

if IsLeft(Lines[y], '■') then InDelText('□' + Copy(Lines[y], 4, Length(Lines[y]) - 3), XYtoX(0, y), Utf16Length(Lines[y]))
else
if IsLeft(Lines[y], '□') then InDelText('■' + Copy(Lines[y], 4, Length(Lines[y]) - 3), XYtoX(0, y), Utf16Length(Lines[y]))
else
if IsLeft(Lines[y], '●') then InDelText('○' + Copy(Lines[y], 4, Length(Lines[y]) - 3), XYtoX(0, y), Utf16Length(Lines[y]))
else
if IsLeft(Lines[y], '○') then
  begin
  InDelText('●' + Copy(Lines[y], 4, Length(Lines[y]) - 3), XYtoX(0, y), Utf16Length(Lines[y]));
  i := 1;   // We also wish to turn off all the other radio buttons in the group.
  while IsLeft(Lines[y + i], '●') or IsLeft(Lines[y + i], '○') do
        begin
        InDelText('○' + Copy(Lines[y + i], 4, Length(Lines[y + i]) - 3), XYtoX(0, y + 1), Utf16Length(Lines[y + 1]));
        CaretPos := TPoint.Create(0, y + i);
        MarkUp(XYtoX(0, y + i), Utf16Length(Lines[y + i]) + 1, psPrompt);
        MarkUp(XYtoX(0, y + i), 2, psBool);
        i := i + 1;
        end;
  // And now we do it going up. Yes, I should make the code more economical, note to self, do this.
  i := 1;   // We also wish to turn off all the other radio buttons in the group.
  while IsLeft(Lines[y - i], '●') or IsLeft(Lines[y - i], '○') do
        begin
        InDelText('○' + Copy(Lines[y - i], 4, Length(Lines[y - i]) - 3), XYtoX(0, y - 1), Utf16Length(Lines[y - 1]));  ;
        MarkUp(XYtoX(0, y - i), Utf16Length(Lines[y - i]) + 1, psPrompt);
        MarkUp(XYtoX(0, y - i), 2, psBool);
        i := i + 1;
        end;
  end;

if IsLeft(Lines[y], '■') or IsLeft(Lines[y], '□')
or IsLeft(Lines[y], '●') or IsLeft(Lines[y], '○') then
  begin
  UnsavedChangesExist := true;
  CaretPos := TPoint.Create(0, y);
  MarkUp(XYtoX(0, y), Utf16Length(Lines[y]) + 1, psPrompt);
  MarkUp(XYtoX(0, y), 2, psBool);
  end;

Lines.EndUpdate;

inherited;

end;




procedure Register;
begin
  RegisterComponents('Common Controls', [TWMemo]);
end;

end.
