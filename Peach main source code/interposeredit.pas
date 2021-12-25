unit InterposerEdit;

// It's an interposer class because I'm gonna have to keep on tinkering with it
// for a while.

// And it's a class at all because the only way I can find to do this flicker-
// free is to override the TextChanged method of the class, the various event
// handlers aren't up to the job.

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, LazUTF8, LazUTF16, Windows, Vocab, Dialogs,
  CommonStringFunctions;

const
  ED_NORMAL = 0;
  ED_AL1 = 1;
  ED_AL2 = 2;
  ED_SPLIT = 3;
  ED_KEYS = 4;

type
  TEdit = class(StdCtrls.TEdit)
  protected
    procedure TextChanged; override;
    procedure WndProc(var Msg: TMessage); override;
  private
    FMode: byte;
  public
    property Mode: byte read FMode write FMode default ED_NORMAL;
  end;

implementation

procedure TEdit.TextChanged;
var
  Diff: integer;
  s: string;
  Utf8x: integer;
begin

  // Changing the Text of the TEdit from within the program loses the position
  // of the cursor. We record this datum now ...
  Diff := self.SelStart - Utf16Length(self.Text);
  // .. and later on will put the cursor back where it should be, by assuming that
  // any change of length to the text was caused by what the user just typed.

  if self.Mode = ED_NORMAL then Exit;

  if self.Mode in [ED_AL1, ED_AL2] then
  begin
    if self.Mode = ED_AL1 then self.Text := AddAccent(self.Text, 1);
    if self.Mode = ED_AL2 then self.Text := AddAccent(self.Text, 2);
  end;

  // We keep the ' — ' from getting partially deleted.
  if self.Mode in [ED_SPLIT, ED_KEYS] then
  begin
    s := self.Text;
    Replace(s, '—', ' — ');
    Replace(s, '—  ', '— ');
    Replace(s, '  —', ' —');
    self.Text := s;
  end;

  if self.Mode in [ED_SPLIT] then
  begin
    if (Pos(' — ', self.Text) = 0) then
      self.Text := AddAccent(self.Text, 1)   // This bit probably unnecessary.
    else
      self.Text := AddAccent(Split(self.Text, ' — ', 1), 1) +
        ' — ' + AddAccent(Split(self.Text, ' — ', 2), 2);
  end;

  // We put the cursor where it should be.

  self.SelStart := Diff + Utf16Length(self.Text);

  if self.Mode in [ED_SPLIT, ED_KEYS] then
  begin
    // This is just for pretty, so that a line with no data has no emdash.
    if (Pos(' — ', self.Text) = 0) and (self.Text <> '') then
    begin
      Diff := self.SelStart;
      self.Text := self.Text + ' — ';
      self.SelStart := Diff;
    end;
    if self.Text = ' — ' then self.Text := '';
  end;
end;

// When answering a question the student shouldn't cheat by pasting.
procedure TEdit.WndProc(var Msg: TMessage);
begin
  if (self.Mode in [ED_AL1, ED_AL2]) and (Msg.Msg = WM_PASTE) then Msg.Msg := WM_NULL;
  inherited;
end;

end.
