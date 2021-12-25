unit PythonFunctions;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, CommonStringFunctions;

function FindErrorLine(s: string; SybilALength: integer): integer;

implementation

// Explanation. When we return an error from the Python, we return the trackback
// of the error lines in reverse order. What we want is the last thing from in
// the .grm file that caused an error, we want to discard the things in Sybil A.
// This, from the point of view of the end-user, is where the bug "is". (Although
// it will still have to be parsed by the thing that does the error reports to
// convert this into a line number relative to the start of the .grm file.)
function FindErrorLine(s: string; SybilALength: integer): integer;
var
  LineNo: integer;
begin
  if s = '' then
  begin
    FindErrorLine := -1;
    Exit;
  end;
  FindErrorLine := StrToInt(Split(s, ', ', 1));
  // So it will report an error in Sybil A if one's actually there.
  while s <> '' do
  begin
    LineNo := StrToInt(Split(s, ', ', 1));
    s := Split(s, ', ', 2);
    if LineNo > SybilALength then
    begin
      FindErrorLine := LineNo;
      Exit;
    end;
  end;
end;

end.
