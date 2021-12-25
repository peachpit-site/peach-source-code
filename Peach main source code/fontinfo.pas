unit FontInfo;

// Code by Mr.Madguy of the Lazarus Forums.
// Shine on you crazy diamond!

{$mode objfpc}{$H+}

interface

function FindTrueTypeFontName(const AFileName: string): string;

implementation

uses Classes, SysUtils;

type
  TTrueTypeHeader = packed record
    MajorVersion: word;
    MinorVersion: word;
    NumOfTables: word;
    SearchRange: word;
    EntrySelector: word;
    RangeShift: word;
  end;

  TTrueTypeTableEntry = packed record
    Tag: array[0..3] of char;
    CheckSum: longword;
    Offset: longword;
    Length: longword;
  end;

  TTrueTypeNameTableHeader = packed record
    Selector: word;
    Count: word;
    Offset: word;
  end;

  TTrueTypeNameRecord = packed record
    PlatformID: word;
    EncodingID: word;
    LanguageID: word;
    NameID: word;
    Length: word;
    Offset: word;
  end;

  TWord = packed record
    LowByte: byte;
    HighByte: byte;
  end;

  TLongword = packed record
    LowByte: byte;
    MiddleWord: word;
    HighByte: byte;
  end;

function EncodeWord(AWord: word): word; inline;
begin
  TWord(Result).LowByte := TWord(AWord).HighByte;
  TWord(Result).HighByte := TWord(AWord).LowByte;
end;

function EncodeLong(ALong: longword): longword; inline;
begin
  TLongword(Result).LowByte := TLongword(ALong).HighByte;
  TLongword(Result).MiddleWord := EncodeWord(TLongword(ALong).MiddleWord);
  TLongword(Result).HighByte := TLongword(ALong).LowByte;
end;

function FindTrueTypeFontName(const AFileName: string): string;
var
  Stream: TStream;
  Found: boolean;
  I, J, TableEntryCount, NameRecordCount, Len: integer;
  StorageOffset: longword;
  Header: TTrueTypeHeader;
  TrueTypeTableEntry: TTrueTypeTableEntry;
  TrueTypeNameTableHeader: TTrueTypeNameTableHeader;
  TrueTypeNameRecord: TTrueTypeNameRecord;
  Temp1: ansistring;
  Temp2: unicodestring;
begin
  Result := '';
  try
    try
      Stream := TFileStream.Create(AFileName, fmOpenRead);
      Stream.Read(Header, SizeOf(Header));
      TableEntryCount := EncodeWord(Header.NumOfTables);
      Found := False;
      for I := 0 to TableEntryCount - 1 do
      begin
        Stream.Read(TrueTypeTableEntry, SizeOf(TrueTypeTableEntry));
        if CompareText(TrueTypeTableEntry.Tag, 'name') = 0 then
        begin
          Found := True;
          Break;
        end;
      end;
      if Found then
      begin
        StorageOffset := EncodeLong(TrueTypeTableEntry.Offset);
        Stream.Seek(StorageOffset, soBeginning);
        Stream.Read(TrueTypeNameTableHeader, SizeOf(TrueTypeNameTableHeader));
        StorageOffset := StorageOffset + EncodeWord(TrueTypeNameTableHeader.Offset);
        NameRecordCount := EncodeWord(TrueTypeNameTableHeader.Count);
        for I := 0 to NameRecordCount - 1 do
        begin
          Stream.Read(TrueTypeNameRecord, SizeOf(TrueTypeNameRecord));
          if EncodeWord(TrueTypeNameRecord.NameID) = 1 then
          begin
            Len := EncodeWord(TrueTypeNameRecord.Length);
            {Platform and Encoding stuff!!!}
            if (EncodeWord(TrueTypeNameRecord.PlatformID) = 1) or
              ((EncodeWord(TrueTypeNameRecord.PlatformID) = 3) and
              (EncodeWord(TrueTypeNameRecord.EncodingID) = 0))
            then
            begin
              {ANSI}
              SetLength(Temp1, Len);
              Stream.Seek(StorageOffset + EncodeWord(TrueTypeNameRecord.Offset),
                soBeginning);
              Stream.Read(Temp1[1], Len);
              Result := UTF8Encode(Temp1);
            end
            else
            begin
              {Unicode}
              SetLength(Temp2, Len shr 1);
              Stream.Seek(StorageOffset + EncodeWord(TrueTypeNameRecord.Offset),
                soBeginning);
              Stream.Read(Temp2[1], Len);
              for J := 1 to Length(Temp2) do
              begin
                word(Temp2[J]) := EncodeWord(word(Temp2[J]));
              end;
              Result := UTF8Encode(Temp2);
            end;
            Break;
          end;
        end;
      end;
    finally
      Stream.Free;
    end;
  except
    {Just ignore exceptions}
  end;
end;

end.
