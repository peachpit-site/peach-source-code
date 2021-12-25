unit CommonStringFunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LazUTF8, LazUTF16, Dialogs;

function Split(s, t: string; i: integer): string;
function GetItem(s, t: string; i: integer): string;
function IsHex(t: string): boolean;
function StripTrailingSpaces(s: string): string;
function FindText(s, t: string; p: integer; m: boolean): integer;
function IsValidFileName(const Filename: string): boolean;
function CurPos(s: string; n: integer): integer;
function Utf8Cur(x: integer; s: string): integer;
procedure Replace(var s: string; t, u: string);
function IsDecimal(t: string): boolean;


implementation

function Split(s, t: string; i: integer): string;
var
  n: integer;
begin
  n := 1;
  while (Copy(s, n, Length(t)) <> t) and (n <= Length(s) - Length(t)) do n := n + 1;
  if Copy(s, n, Length(t)) = t then
  begin
    if i = 1 then Split := Copy(s, 1, n - 1)
    else
      Split := Copy(s, n + Length(t), 1 + Length(s) - n - Length(t));
  end
  else
  begin
    if i = 1 then Split := s
    else
      Split := '';
  end;
end;

function GetItem(s, t: string; i: integer): string;
begin
  if i = 1 then GetItem := Split(s, t, 1)
  else
    GetItem := GetItem(Split(s, t, 2), t, i - 1);
end;

function IsHex(t: string): boolean;
var
  i: integer;
begin
  IsHex := (t <> '');
  for i := 1 to Length(t) do
    IsHex := IsHex and (t[i] in ['0', '1', '2', '3', '4', '5', '6',
      '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'A', 'B', 'C', 'D', 'E', 'F']);
end;

function StripTrailingSpaces(s: string): string;
var
  j: integer;
begin
  j := Length(s);
  while (s <> '') and (s[j] = ' ') and (j > 0) do j := j - 1;
  StripTrailingSpaces := Copy(s, 1, j);
end;

function FindText(s, t: string; p: integer; m: boolean): integer;
begin
  if not m then
  begin
    s := Utf8LowerCase(s);
    t := Utf8LowerCase(t);
  end;
  FindText := Utf8Pos(t, s, p);
end;

function CurPos(s: string; n: integer): integer;
begin
  CurPos := Utf16Length(Utf8Copy(s, 1, n));
end;

function IsValidFileName(const Filename: string): boolean;
var
  c: char;
begin
  Result := (Filename <> '') and (not (Filename[Length(Filename)] in [' ', '.'])) and
    (Filename[1] in ['a' .. 'z'] + ['A' .. 'Z']);
  if Result then
  begin
    for c in Filename do
    begin
      Result := (c in ['a' .. 'z']) or (c in ['A' .. 'Z']) or
        (c in ['0' .. '9']) or (c in [' ', '_']);
      if not Result then break;
    end;
  end;
  IsValidFilename := Result;
end;

function Utf8Cur(x: integer; s: string): integer;
var
  WS: WideString;
  i, j: integer;
begin
  Utf8Cur := 0;
  WS := Utf8ToUtf16(s);
  j := 0;
  for i := 1 to Length(WS) do
  begin
    if not ((Ord(WS[i]) >= $D800) and (Ord(WS[i]) < $DC00)) then
      j := j + 1;
    if i = x then Utf8Cur := j;
  end;
end;

function IsDecimal(t: string): boolean;
var
  i: integer;
begin
  IsDecimal := (t <> '');
  for i := 1 to Length(t) do
    IsDecimal := IsDecimal and (t[i] in ['0', '1', '2', '3', '4', '5',
      '6', '7', '8', '9']);
end;


procedure Replace(var s: string; t, u: string);
// Got some strange behaviour from the available functions, wrote my own.}
var
  i: integer;
begin
  i := 1;
  repeat
    if Copy(s, i, Length(t)) = t then
    begin
      s := Copy(s, 1, i - 1) + u + Copy(s, i + Length(t), 1 +
        Length(s) - i - Length(t));
      i := i + Length(u) - Length(t);
    end;
    i := i + 1;
  until i > (Length(s) - Length(t)) + 1;
end;

end.
