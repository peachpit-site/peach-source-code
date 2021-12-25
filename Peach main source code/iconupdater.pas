unit IconUpdater;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Windows;

procedure UpdateIcon(ExeFile, IconFile: string);

implementation

const
  HeaderSize = 6;
  IcoEntrySize = 16;
  ResEntrySize = 14;

procedure UpdateIcon(ExeFile, IconFile: string);
var
  vResHandle: THandle;
  MyIcon: TMemoryStream;
  ImageCount: word;
  ImageSize: DWord;
  ab, m: TMemoryStream;
  i, j: integer;
begin
  MyIcon := TMemoryStream.Create;
  ab := TMemoryStream.Create;
  m := TMemoryStream.Create;
  MyIcon.LoadFromFile(IconFile);
  vResHandle := BeginUpdateResource(PChar(ExeFile), False);
  MyIcon.Seek(4, soFromBeginning);
  ImageCount := MyIcon.ReadWord;
  MyIcon.Seek(0, soFromBeginning);

  for j := 1 to HeaderSize do ab.WriteByte(MyIcon.ReadByte);
  for i := 1 to ImageCount do
  begin
    for j := 1 to IcoEntrySize - 4 do ab.WriteByte(MyIcon.ReadByte);
    MyIcon.ReadDWord;  // To skip over it.
    ab.WriteWord(i);
  end;

  UpdateResource(vResHandle, RT_GROUP_ICON, PChar('MAINICON'), LANG_NEUTRAL,
    ab.Memory, ab.Size);

  for i := 1 to ImageCount do
  begin
    m := TMemoryStream.Create;
    ab.Seek(HeaderSize + (i - 1) * ResEntrySize + 8, soFromBeginning);
    ImageSize := ab.ReadDWord;
    for j := 1 to ImageSize do m.WriteByte(MyIcon.ReadByte);
    UpdateResource(vResHandle, RT_ICON, MAKEINTRESOURCE(i), LANG_NEUTRAL, m.Memory, m.Size);
    m.Free;
  end;

  EndUpDateResource(vResHandle, False);
  MyIcon.Free;
  ab.Free;
end;

end.
