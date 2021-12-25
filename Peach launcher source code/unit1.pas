unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Graphics, ExtCtrls,
  Dialogs, Controls, Internet_2, UpdateOptions, process, IconUpdater,
  StdCtrls, CommonStringFunctions, AppLanguage, Crt;

type

  { TForm1 }

  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Process1: TProcess;
    Shape1: TShape;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

var
  UpdateCheck: boolean;
  hd: string;

function Newer(x, y: string): boolean;
var
  i: integer;
begin
  Newer := False;
  for i := 1 to 4 do
  begin
    if StrToInt(GetItem(x, '.', i)) > StrToInt(GetItem(y, '.', i)) then
    begin
      Newer := True;
      break;
    end;
    if StrToInt(GetItem(x, '.', i)) < StrToInt(GetItem(y, '.', i)) then break;
  end;
end;

function UpdateExecutable: string;   // Returns the file path and name of the executable.
var
  NewVersion, OldVersion: string;
  UpdateSetting: integer;
  VersionSetting: integer;
  AvailableUpdates: TStringList;
  UpdatesExist: boolean;
  UpdateFilename, UpdateFilePath: string;
  VersionName: string;
  ExeName: string;
  f: TextFile;
  i: integer;
begin
  hd := ExtractFilePath(ParamStr(0));
  AssignFile(f, hd + 'Peach\Resources\Rsc files\data0.rsc');
  Reset(f);
  ReadLn(f, ExeName);
  Close(f);
  UpdateExecutable := hd + 'Peach\' + ExeName + '.exe';
  AssignFile(f, hd + 'Peach\Resources\Rsc files\update settings.rsc');
  Reset(f);
  ReadLn(f, UpdateSetting);
  ReadLn(f, VersionSetting);
  Close(f);
  if UpdateSetting = 1 then Exit;
  AssignFile(f, hd + 'Peach\Resources\Rsc files\version.rsc');
  Reset(f);
  ReadLn(f, OldVersion);
  Close(f);

  if VersionSetting = 0 then
    VersionName := 'Win64-latest'
  else
    VersionName := 'Win64-stable';

  UpdatesExist := False;
  AvailableUpdates := GetListFromUrl(
    'https://github.com/peachpit-site/peach-updates/releases/download/' +
    VersionName + '/updates.txt');
  for i := 0 to AvailableUpdates.Count - 1 do
  begin
    NewVersion := Trim(GetItem(AvailableUpdates[i], ' : ', 1));
    UpdatesExist := UpdatesExist or Newer(NewVersion, Oldversion);
  end;

  if UpdatesExist then
  begin
    if UpdateSetting = 2 then
    begin
      FormUpdate.Memo1.Text :=
        GetStringFromUrl('https://github.com/peachpit-site/peach-updates/releases/download/' +
        VersionName + '/changes.txt');
      for i := 0 to 1 do
        FormUpdate.VersionGroup.Items.Add(TranslateList('Vers0', i));
      FormUpdate.VersionGroup.ItemIndex := VersionSetting;
      FormUpdate.ShowModal;
      if FormUpdate.ModalResult = mrAbort then
      begin
        AvailableUpdates.Free;
        Exit;
      end;
      AssignFile(f, PChar(hd + 'Peach\Resources\Rsc files\update settings.rsc'));
      Rewrite(f);
      WriteLn(f, FormUpdate.UpdateGroup.ItemIndex);
      WriteLn(f, FormUpdate.VersionGroup.ItemIndex);
      Close(f);
    end;
    for i := 0 to AvailableUpdates.Count - 1 do
    begin
      NewVersion := Trim(GetItem(AvailableUpdates[i], ' : ', 1));
      if Newer(NewVersion, Oldversion) then
      begin
        UpdateFilePath := Trim(GetItem(AvailableUpdates[i], ' : ', 2));
        UpdateFilename := ExtractFilename(UpdateFilePath);
        if UpdateFileName = 'Peach.exe' then
        begin
          GetFileFromUrl('https://github.com/peachpit-site/peach-updates/releases/download/'
            + VersionName + '/Peach.exe', PChar(hd + 'Peach\' + ExeName + '.exe'));
          UpdateIcon(hd + 'Peach\' + ExeName + '.exe', hd +
            'Peach\Resources\Icon\icon.ico');
          AssignFile(f, PChar(hd + 'Peach\Resources\Rsc files\version.rsc'));
          Rewrite(f);
          WriteLn(f, NewVersion);
          Close(f);
        end
        else
          GetFileFromUrl('https://github.com/peachpit-site/peach-updates/releases/download/'
            + VersionName + '/' + UpdateFileName,
            PChar(hd + 'Peach\' + UpdateFilePath));
      end;
    end;
  end;
  AvailableUpdates.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  f: TextFile;
begin

  UpdateCheck := True;

  Top := (Screen.Height - Height) div 2;
  Left := (Screen.Width - Width) div 2;

  AssignFile(f, PChar(ExtractFilePath(ParamStr(0)) +
    '\Peach\Resources\Rsc files\data1.rsc'));
  Reset(f);
  Readln(f);
  Readln(f);
  Readln(f);
  Readln(f);
  Readln(f, applang);
  CloseFile(f);

  GetLanguage(PChar(ExtractFilePath(ParamStr(0)) + 'Peach\Internationalization\' +
    applang + '.lng'));

  Form1.Label1.Caption := Translate('PbP');

end;

procedure TForm1.FormActivate(Sender: TObject);
var
  i: integer;
  ExeName: string;
  f: TextFile;

begin

  Application.ProcessMessages;

  if not UpdateCheck then Exit;
  UpdateCheck := False;

  // Updates the executable from GitHub if necessary, returns the filename.

  ExeName := UpdateExecutable();

  // Creates a dummy file.
  AssignFile(f, PChar(hd + 'Peach\Resources\File transfer\launchertomain.rsc'));
  Rewrite(f);
  WriteLn(f, 'Hi!');
  CloseFile(f);

  // Starts the main program.
  Process1 := TProcess.Create(nil);
  try
    Process1.InheritHandles := False;
    Process1.Options := [];
    Process1.ShowWindow := swoShow;
    for i := 1 to GetEnvironmentVariableCount do
      Process1.Environment.Add(GetEnvironmentString(i));
    Process1.Executable := ExeName;
    Process1.Execute;
  finally
    Process1.Free;
  end;

  // Waits for the main program to be fully up and running.
  while FileExists(PChar(hd + 'Peach\Resources\File transfer\launchertomain.rsc')) do
  begin
  end;

  // Goodnight Las Vegas.
  Close;

end;

end.
