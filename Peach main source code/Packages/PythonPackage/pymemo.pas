unit PyMemo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, RichMemo, RegExpr, Graphics, Dialogs, Windows,
  LazUTF8, LazUTF16, ClipBrd, Crt, Vocab, CommonStringFunctions;

const
  MM_NORMAL = 0;
  MM_L1 = 1;
  MM_L2 = 2;

type

  TRule = record
    RE: TregExpr;
    RegExp: string;
    Color: TColor;
    Style: TFontstyles;
  end;

  { TPyMemo }

  TPyMemo = class(TRichMemo)
  protected
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
    procedure KeyUp(var Key: word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure Click; override;


  private
  var
    Count: integer;
    FRules: array[1..80] of TRule;
    FMode: byte;
    OldY: integer;
    Toggle: boolean;
    OldBlank: boolean;
  public
    property Mode: byte read FMode write FMode default MM_NORMAL;
    function XYtoX(x, y: integer): integer;
    procedure TouchLine(n: integer);

  const

    LKEYWORDS: TStringArray =
      ('and', 'assert', 'break', 'class', 'continue', 'def',
      'del', 'elif', 'else', 'except', 'exec', 'finally',
      'for', 'from', 'global', 'if', 'import', 'in',
      'is', 'lambda', 'not', 'or', 'pass', 'print',
      'raise', 'return', 'try', 'while', 'yield',
      'None', 'True', 'False');

    LSYMBOLS: TStringArray =
      ('=',
      '==', '!=', '<', '<=', '>', '>=',
      '\+', '-', '\*', '/', '\%',
      '\+=', '-=', '\*=', '/=', '\%=',
      '\^', '\|', '\&', '\~', '>>', '<<',
      '\{', '\}', '\[', '\]', '\(', '\)',
      '\.', ',', ';', ':', '\\', '!', '@', '&');
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

implementation

function TPyMemo.XYtoX(x, y: integer): integer;
begin
  XYtoX := SendMessage(Handle, EM_LINEINDEX, y, x);
end;

constructor TPyMemo.Create(AOwner: TComponent);

  procedure Add(s: string; c: TColor; Fs: TFontStyles);
  begin
    Count := Count + 1;
    FRules[Count].RE := TRegExpr.Create(s);
    FRules[Count].RegExp := s;
    FRules[Count].Color := c;
    FRules[Count].Style := Fs;
  end;

var
  i: integer;

begin
  inherited;
  OldY := 0;
  Count := 0;
  OldBlank := False;
  Toggle := False;

  Add('\band\b|\bassert\b|\bbreak\b|\bclass\b|\bcontinue\b|\bdef\b|\bdel\b|\belif\b|\belse\b|\bexcept\b|\bexec\b|\bfinally\b|\bfor\b|\bfrom\b|\bglobal\b|\bif\b|\bimport\b|\bin\b|\bis\b|\blambda\b|\bnot\b|\bor\b|\bpass\b|\bprint\b|\braise\b|\breturn\b|\btry\b|\bwhile\b|\byield\b|\bNone\b|\bTrue\b|\bFalse', clBlack, [fsBold]);
  Add('=|<|>|\+|-|\*|/|\%|\^|\||\&|\~|\{|\}|\[|\]|\(|\)|\.|,|;|:|\\|!|@|&', clRed, []);
  Add('"[^"\\]*(\\.[^"\\]*)*"|''[^''\\]*(\\.[^''\\]*)*''|\b[+-]?[0-9]+[lL]?\b|\b[+-]?0[xX][0-9A-Fa-f]+[lL]?\b|\b[+-]?[0-9]+(?:\.[0-9]+)?(?:[eE][+-]?[0-9]+)?\b', clBlue, []);
  Add('#[^\n]*', clGreen, [fsItalic]);
end;


procedure TPyMemo.TouchLine(n: integer);
var
  TF: TFont;
  off: integer;
  i: integer;
begin
  if Lines[n] = '' then Exit;
  off := XYtoX(0, n);
  TF := TFont.Create();
  TF.Name := Font.Name;
  TF.Size := Font.Size;
  TF.Color := clBlack;
  TF.Style := [];
  Lines.BeginUpdate;
  SetTextAttributes(off, Utf16Length(Lines[n]) + 1, TF);
  // Make everything plain black including the newlines (hence the +1).
  Lines.EndUpdate;
  for i := 1 to Count do
  begin
    FRules[i].RE.InputString := self.Lines[n];
    if FRules[i].RE.Exec then
      repeat
        TF.Color := FRules[i].Color;
        TF.Style := FRules[i].Style;
        self.SetTextAttributes(off + Utf16Length(Copy(
          (Lines[n]), 1, FRules[i].RE.MatchPos[0] - 1)),
          Utf16Length(FRules[i].RE.Match[0]), TF)
      until not FRules[i].RE.ExecNext;
  end;
  TF.Free;
end;


function FirstNonSpace(s: string): integer;
begin
  // To be more accurate, it returns the number of leading spaces plus one. So the empty string returns 1.
  FirstNonSpace := 1;
  while (s <> '') and (s[FirstNonSpace] = ' ') and (FirstNonSpace <= Length(s)) do
    FirstNonSpace := FirstNonSpace + 1;
end;


function Whitespace(s: string): string;
var
  i: integer;
begin
  Whitespace := '';
  i := 1;
  while i <= Length(s) do
  begin
    if s[i] in [' ', #9] then
      Whitespace := Whitespace + s[i]
    else
      i := Length(s);
    i := i + 1;
  end;
end;


procedure TPyMemo.KeyUp(var Key: word; Shift: TShiftstate);
var
  i: integer;
  x, y: integer;
  Utf8x: integer;
  CurP, EndP: PChar;
  Len: integer;
  ACodePoint: string;
  q1, q2, Found: boolean;
  Quoted, temp: string;
  Qstart: integer;
  olen: integer;
  s, temps: string;
  OpenBracket, CloseBracket: string;
  BracketCount: integer;
  tempi: integer;
  TF: TFontParams;
begin

  x := self.CaretPos.x;
  y := self.CaretPos.y;

  if not Toggle then
  begin
    OpenBracket := 'foo';
    if (Key = $30) and (Shift = [ssShift]) then
    begin
      OpenBracket := '(';
      CloseBracket := ')';
    end;
    if (Key = $DD) and (Shift = []) then
    begin
      OpenBracket := '[';
      CloseBracket := ']';
    end;
    if (Key = $DD) and (Shift = [ssShift]) then
    begin
      OpenBracket := '{';
      CloseBracket := '}';
    end;
    if OpenBracket <> 'foo' then
    begin
      BracketCount := 1;
      i := SelStart - 2;
      while (i >= 0) and (BracketCount > 0) do
      begin
        temps := GetText(i, 1);
        if temps = CloseBracket then BracketCount := BracketCount + 1;
        if temps = OpenBracket then BracketCount := BracketCount - 1;
        GetTextAttributes(i, TF);
        if TF.Style = [fsBold] then break;
        Dec(i);
      end;
      if BracketCount = 0 then
      begin
        SelText := '';
        Key := 0;
        TouchLine(y);
        tempi := SelStart;
        SelStart := i + 1;
        SelLength := tempi - SelStart;
        Delay(400);
        SelStart := tempi;
        Exit;
      end;
    end;
  end;


  Lines.BeginUpdate;


  //We handle the enter, tab, and backspace keys.

{if (Key=13) and (y>0) and (Lines[y-1]<>'') then          // enter
    begin
       if not Toggle then
       begin
       j:=firstnonspace(Lines[y-1]);
       if Lines[y-1][length(Lines[y-1])] = ':' then j:=j+4;
       Lines[y]:=StringOfChar(' ',j-1)+Lines[y];
       CaretPos := TPoint.Create(j-1,y);
       end;
    end;   }

  if (Key = 13) and (y > 0) and (Lines[y - 1] <> '') then          // enter
  begin
    if not Toggle then
    begin
      temps := Whitespace(Lines[y - 1]);
      if Lines[y - 1][Length(Lines[y - 1])] = ':' then temps := #9 + temps;
      InDelText(temps, SelStart, 0);
      CaretPos := TPoint.Create(Length(temps), y);
    end;
  end;

  if Key = 9 then           // tab
  begin
    if not Toggle then
    begin
      InDelText(#9, SelStart, 0);
      CaretPos := TPoint.Create(x + 1, y);
      Key := 0;
    end;
  end;

  // SHOULD REVISIT THIS NOW YOU HAVE TABS
{if (Key=8) and (x>0) and (copy(Lines[y],1,x) = stringofchar(' ',x)) and OldBlank then           // backspace
    begin
       if not Toggle then
       begin
       tn := 4*((x-1) div 4);
       Lines[y]:=stringofchar(' ',tn)+copy(Lines[y],x+1,length(Lines[y])-x);
       CaretPos := TPoint.Create(tn,y);
       key:=0;
       end;
    end;   }

  // We manipulate the text, doing the substitutions if the user's inside
  // quotes and has the feature turned on.

  if self.Mode <> MM_NORMAL then
  begin
    olen := Utf16Length(self.Lines[y]);
    // We convert the x value to utf8;
    Utf8x := Utf8Cur(x, self.Lines[y]);

    // We find out if we're in quotes.
    // q1 if we're inside single quotes, q2 if we're inside double quotes. Unclosed
    // counts as inside.

    s := '';
    q1 := False;
    q2 := False;
    Found := False;
    i := 0;
    CurP := PChar(self.Lines[y]);        // if s='' then PChar(s) returns a pointer to #0
    EndP := CurP + Length(self.Lines[y]);
    while (CurP < EndP) and not (Found and (not q1) and (not q2)) do
    begin
      i := i + 1;
      Len := UTF8CodepointSize(CurP);
      SetLength(ACodePoint, Len);
      Move(CurP^, ACodePoint[1], Len);
      s := s + ACodePoint;
      if (ACodePoint = '"') and not q1 then
      begin
        q2 := not q2;
        if q2 then Qstart := i + 1;
      end;
      if (ACodePoint = '''') and not q2 then
      begin
        q1 := not q1;
        if q1 then Qstart := i + 1;
      end;
      if (not q1) and (not q2) and not Found then Quoted := '';
      if (q1 and not (ACodePoint = '''')) or (q2 and not (ACodePoint = '"')) then
        Quoted := Quoted + ACodePoint;
      if (i = Utf8x) and (q1 or q2) then Found := True;
      Inc(CurP, Len);
    end;

    // We do the accents if we're in quotes.
    if Found and DataExists then
    begin
      if self.Mode = MM_L1 then i := 1
      else
        i := 2;
      temp := AddAccent(Quoted, i);
      if temp <> Quoted then
      begin
        self.Lines[y] := Utf8Copy(self.Lines[y], 1, Qstart - 1) +
          temp + Utf8Copy(self.Lines[y], Qstart + Utf8Length(Quoted),
          1 + Utf8Length(self.Lines[y]) - Qstart - Utf8Length(Quoted));

        self.CaretPos := TPoint.Create(x + Utf16Length(self.Lines[y]) - olen, y);
      end;
    end;

  end;

  // Then we do the syntax highlighting.

  if not Toggle and not (Key in [37, 40]) then
    // But there's no need to if the user's pressed an arrow key, because then nothing's changed.
  begin
    x := self.CaretPos.x;
    y := self.CaretPos.y;
    if y <= OldY then
      TouchLine(y)
    else
    begin
      for i := OldY to y do
        TouchLine(i);
    end;
    y := OldY;
  end;

  Lines.EndUpdate;

  inherited;

end;

procedure TPyMemo.KeyDown(var Key: word; Shift: TShiftstate);
var
  x, y: integer;
  WS: WideString;
  i, k: integer;
begin

  x := self.CaretPos.x;
  y := self.CaretPos.y;
  OldY := y;

  if not Toggle and (Key = Ord('V')) and (Shift = [ssCtrl]) or
    // This makes sure pasted text assumes the format of whatever it's pasted into.
    (Key = VK_INSERT) and (Shift = [ssShift]) then
  begin
    InDelText(Clipboard.AsText, SelStart, SelLength);
    SelStart := SelStart + Utf16Length(Clipboard.AsText);
    Key := 0;
  end;

  if (Key = Ord('Z')) and (Shift = [ssCtrl]) then
  begin
    WS := Text;
    Key := 0;
    Shift := [];
    while CanUndo do
    begin
      Undo;
      if WS <> Text then
      begin
        TouchLine(CaretPos.y);
        Break;
      end;
    end;
  end;


  OldBlank := ((Copy(Lines[y], 1, x) = StringOfChar(' ', x)));
  Lines.BeginUpdate;
  inherited;
  Lines.EndUpdate;
  Toggle := True;
  if Key = 9 then Key := 0;
  KeyUp(Key, Shift);
  Toggle := False;
end;

procedure TPyMemo.Click;
begin
  OldY := CaretPos.y;
  inherited;
end;

procedure TPyMemo.DoEnter;
begin
  Toggle := True;
  OldY := CaretPos.y;
  inherited;
end;

procedure Register;
begin
  RegisterComponents('Common Controls', [TPyMemo]);
end;

end.
