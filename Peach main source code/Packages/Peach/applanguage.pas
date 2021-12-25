unit AppLanguage;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, CommonStringFunctions, Dialogs;

procedure GetLanguage(Filename: string);
function Translate(s: string): string;
function TranslateList(s: string; j: integer): string;
procedure Alert(s: string);


var
  AppLang: string;                               // The name of the "application language".


implementation


var
  // A couple of arrays to store the data for the application language, i.e. the bits that say "File"
  // and "Save As" and "Test complete!" etc.
  Keyword, Phrase: array [1..1000] of string;
  // They're parallel, keyword[n] corresponds to phrase[n]
  KeywordCount: integer;
// This says how many entries there are in the arrays, obviously.


function Translate(s: string): string;
var
  i: integer;
begin
  Translate := '<' + s + '>';
  for i := 1 to KeywordCount do if s = Keyword[i] then Translate := Phrase[i];
end;

procedure Alert(s: string);
begin
  ShowMessage(Translate(s));
end;

function TranslateList(s: string; j: integer): string;
var
  i: integer;
begin
  TranslateList := '<' + s + '>' + '+' + IntToStr(j);
  for i := 1 to KeywordCount do if s = Keyword[i] then TranslateList := Phrase[i + j];
end;


procedure GetLanguage(Filename: string);
var
  s: string;
  f: TextFile;
begin
  KeywordCount := 0;
  AssignFile(f, Filename);
  Reset(f);
  while not EOF(f) do
  begin
    ReadLn(f, s);
    if Split(s, ' : ', 2) <> '' then
    begin
      KeywordCount := KeywordCount + 1;
      Keyword[KeywordCount] := Split(s, ' : ', 1);
      Phrase[KeywordCount] := Split(s, ' : ', 2);
    end;
  end;
  Close(f);
end;

end.
