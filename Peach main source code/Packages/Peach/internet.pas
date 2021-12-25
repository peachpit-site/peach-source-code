unit Internet;

{A repository of things that interface with the server. They are all very
similar, explaining the rather clumsy way they're written — it was just easier
to do a bunch of copy-and-pasting at the time. I *will* refactor it.

Also contains the thing for downloading pictures.}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Vocab, Controls, Dialogs, FpHttpClient, Graphics,
  OpenSslSockets, CommonStringFunctions, AppLanguage, DateUtils;

procedure Download_picture(const APicture: TPicture; const AUrl: string);
function Add_user(UN, FN, LN, PW, EM: string): boolean;
function ValidateUser(UN, PW: string): boolean;
function Delete_user(UN, PW: string): boolean;
function UpdateEmail(UN, PW, EM: string): boolean;
function UpdatePassword(UN, PW, NP: string): boolean;
function MailNewPassword(UN, EM, PW: string): boolean;
function AddClass(PW, TN, FN, LN, CN: string): integer;
function DeleteClass(PW, TN, CI: string): boolean;
function UpdateAdmissionsPolicy(PW, TN, CI, OP: string): boolean;
function Get_admissions_policy(PW, UN, CI: string): string;
function Get_class_id(PW, UN, TN, CN: string): string;
procedure AddStudentToClass(PW, UN, TN, SN, CI: string);
procedure DeleteStudentFromClass(PW, SN, CI: string);
function Teacher_delete_student_from_class(PW, TN, SN, CI: string): boolean;
function Get_classes(PW, SN: string): TStrings;
function Teacher_get_classes(PW, TN: string): TStrings;
function Get_roster(PW, TN, CI: string): TStrings;
procedure SendNotification(PW, SN, RN, CI, CN: string; N: char);
function Get_notifications(PW, RN: string): TStrings;
function UploadAssignment(PW, TN, CI, D: string; RS: boolean; A, AN: string): boolean;
function Get_assignments(PW, SN: string): TStrings;
function Get_assignment(PW, UN, AI: string): TStrings;
function DeleteAssignment(PW, TN, AI: string): boolean;
function Get_assignments_by_class(PW, TN, ClassID: string): TStrings;
function Get_names(PW, UN: string): string;
function UploadResult(PW, SN, AI: string; SC: integer): boolean;
function ListAssignmentsByClass(PW, UN, CI: string): TStrings;
function Get_results(PW, TN, CI: string): TStrings;
procedure ConvertDateTime(DateTimeStr: string; var DateStr, TimeStr: string);



var
  FirstName, LastName: string;
  Username: string;
  Email, Password: string;
  SignedIn: boolean;

implementation


// ************* DOWNLOAD PICTURE **************

procedure Download_picture(const APicture: TPicture; const AUrl: string);
var
  LMemoryStream: TMemoryStream;
begin
  LMemoryStream := TMemoryStream.Create;
  try
    TFPHTTPClient.SimpleGet(AUrl, LMemoryStream);
    LMemoryStream.Position := 0;
    APicture.LoadFromStream(LMemoryStream);
  finally
    FreeAndNil(LMemoryStream);
  end;
end;

// ******************* TRANSLATE ERROR ***************

function TranslateError(s: string): string;
begin
  if IsLeft(s, 'st : ') then s := Translate(Split(s, ' : ', 2));
  TranslateError := s;
end;

// ******************* USERS *************************

function Add_user(UN, FN, LN, PW, EM: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('UserName=' + UN);
      FormData.Add('FirstName=' + FN);
      FormData.Add('LastName=' + LN);
      FormData.Add('PWord=' + PW);
      FormData.Add('EMail=' + EM);
      SimpleFormPost('https://api.peachpit.site/add_user.php', FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if (S <> 'OK') then
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') =
          mrCancel then S := Translate('CANCEL')
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
    Add_user := (S = 'OK');
  end;
end;

function ValidateUser(UN, PW: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  ValidateUser := False;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('UserName=' + UN);
      FormData.Add('PWord=' + PW);
      SimpleFormPost('https://api.peachpit.site/validate_user.php', FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S = 'OK' then ValidateUser := True;
      if (S <> 'OK') then
      begin
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL');
      end;
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  ValidateUser := (S = 'OK');
end;

function Get_names(PW, UN: string): string;
var
  Response: TStringStream;
  S: string;
  T: string;
  FormData: TStrings;
begin
  T := '';
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('UserName=' + UN);
      SimpleFormPost('https://api.peachpit.site/get_names.php', FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if GetItem(S, ' : ', 1) = 'OK' then
      begin
        T := Split(S, ' : ', 2);
        S := 'OK';
      end
      else
      if QuestionDlg('Error', TranslateError(S) + sLineBreak +
        Translate('RorC'), mtCustom,
        [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
        S := Translate('CANCEL')
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  Get_names := T;
end;

function Delete_user(UN, PW: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('UserName=' + UN);
      FormData.Add('PWord=' + PW);
      SimpleFormPost('https://api.peachpit.site/delete_user.php', FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL')
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  Delete_user := (S = 'OK');
end;

function UpdateEmail(UN, PW, EM: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('UserName=' + UN);
      FormData.Add('Password=' + PW);
      FormData.Add('EMail=' + EM);
      SimpleFormPost('https://api.peachpit.site/update_email.php', FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL')
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  UpdateEmail := (S = 'OK');
end;

function UpdatePassword(UN, PW, NP: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('UserName=' + UN);
      FormData.Add('Password=' + PW);
      FormData.Add('NewPassword=' + NP);
      SimpleFormPost('https://api.peachpit.site/update_password.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL')
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  UpdatePassword := (S = 'OK');
end;

function MailNewPassword(UN, EM, PW: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('UserName=' + UN);
      FormData.Add('EMail=' + EM);
      FormData.Add('Password=' + PW);
      SimpleFormPost('https://api.peachpit.site/mail_new_password.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL')
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  MailNewPassword := (S = 'OK');
end;


// ******************** CLASSES AND ROSTER ******************

function AddClass(PW, TN, FN, LN, CN: string): integer;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    AddClass := 0;
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('TeacherFirstName=' + FN);
      FormData.Add('TeacherLastName=' + LN);
      FormData.Add('ClassName=' + CN);
      SimpleFormPost('https://api.peachpit.site/add_class.php', FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if (Split(S, ' : ', 1) = 'OK') then
        AddClass := StrToInt(Split(S, ' : ', 2))
      else
      if QuestionDlg('Error', TranslateError(S) + sLineBreak +
        Translate('RorC'), mtCustom,
        [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
        AddClass := -1
    until AddClass <> 0;
    Free;
  end;
end;

function DeleteClass(PW, TN, CI: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('ClassID=' + CI);
      SimpleFormPost('https://api.peachpit.site/delete_class.php', FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
      begin
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL');
      end;
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  DeleteClass := (S = 'OK');
end;

function UpdateAdmissionsPolicy(PW, TN, CI, OP: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('ClassID=' + CI);
      FormData.Add('Open=' + OP);
      SimpleFormPost('https://api.peachpit.site/update_admissions_policy.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL')
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  UpdateAdmissionsPolicy := (S = 'OK');
end;

function Get_admissions_policy(PW, UN, CI: string): string;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('UserName=' + UN);
      FormData.Add('ClassID=' + CI);
      SimpleFormPost('https://api.peachpit.site/get_admissions_policy.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if not ((S = 'O') or (S = 'A') or (S = 'C')) then
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL')
    until (((S = 'O') or (S = 'A') or (S = 'C')) or (S = Translate('CANCEL')));
    Free;
  end;
  Get_admissions_policy := S;
end;

function Get_class_id(PW, UN, TN, CN: string): string;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    Response := TStringStream.Create('');
    FormData := TStringList.Create;
    FormData.Clear;
    FormData.Add('PWord=' + PW);
    FormData.Add('UserName=' + UN);
    FormData.Add('TeacherName=' + TN);
    FormData.Add('ClassName=' + CN);
    SimpleFormPost('https://api.peachpit.site/get_class_id.php', FormData, Response);
    S := Response.DataString;
    Response.Destroy;
    FormData.Destroy;
    Free;
  end;
  Get_class_id := S;
end;

procedure AddStudentToClass(PW, UN, TN, SN, CI: string);
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('UserName=' + UN);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('StudentName=' + SN);
      FormData.Add('ClassID=' + CI);
      SimpleFormPost('https://api.peachpit.site/add_student_to_class.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
      begin
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := 'OK';
      end;
    until S = 'OK';
    Free;
  end;
end;

procedure DeleteStudentFromClass(PW, SN, CI: string);
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('StudentName=' + SN);
      FormData.Add('ClassID=' + CI);
      SimpleFormPost('https://api.peachpit.site/delete_student_from_class.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
      begin
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := 'OK';
      end;
    until S = 'OK';
    Free;
  end;
end;

function Teacher_delete_student_from_class(PW, TN, SN, CI: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('StudentName=' + SN);
      FormData.Add('ClassID=' + CI);
      SimpleFormPost('https://api.peachpit.site/teacher_delete_student_from_class.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
      begin
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL');
      end;
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  Teacher_delete_student_from_class := (S = 'OK');
end;

function Get_classes(PW, SN: string): TStrings;
var
  RStrings: TStrings;
  S: string;
  FormData: TStrings;
  i: integer;

begin
  ;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('StudentName=' + SN);
      SimpleFormPost('https://api.peachpit.site/get_classes.php', FormData, RStrings);
      FormData.Destroy;
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        S := '';
        for i := 0 to RStrings.Count - 1 do
          S := S + RStrings[i] + sLineBreak;
        ShowMessage(S);
        if QuestionDlg('Error.', Translate('RorC'),
          mtCustom, [mrYes, 'Retry', mrCancel, Translate('CANCEL')],
          '') = mrCancel then S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if S = Translate('CANCEL') then RStrings.Clear;
  Get_classes := RStrings;
end;

function Teacher_get_classes(PW, TN: string): TStrings;
var
  RStrings: TStrings;
  S: string;
  FormData: TStrings;
  i: integer;

begin
  ;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      SimpleFormPost('https://api.peachpit.site/teacher_get_classes.php',
        FormData, RStrings);
      FormData.Destroy;
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        S := '';
        for i := 0 to RStrings.Count - 1 do
          S := S + RStrings[i] + sLineBreak;
        ShowMessage(S);
        if QuestionDlg('Error.', Translate('RorC'),
          mtCustom, [mrYes, 'Retry', mrCancel, Translate('CANCEL')],
          '') = mrCancel then S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if S = Translate('CANCEL') then RStrings.Clear;
  Teacher_get_classes := RStrings;
end;

function Get_roster(PW, TN, CI: string): TStrings;
var
  RStrings: TStrings;
  S: string;
  FormData: TStrings;
  i: integer;

begin
  ;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('ClassID=' + CI);
      SimpleFormPost('https://api.peachpit.site/get_roster.php', FormData, RStrings);
      FormData.Destroy;
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        S := '';
        for i := 0 to RStrings.Count - 1 do
          S := S + RStrings[i] + sLineBreak;
        ShowMessage(S);
        if QuestionDlg('Error.', Translate('RorC'),
          mtCustom, [mrYes, 'Retry', mrCancel, Translate('CANCEL')],
          '') = mrCancel then S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if S = Translate('CANCEL') then RStrings.Clear;
  Get_roster := RStrings;
end;

// ************************** NOTIFICATIONS *****************

procedure SendNotification(PW, SN, RN, CI, CN: string; N: char);
// If, and only if, CI = '', the PHP will attempt to identify the class by
// combining the recipient name with the class name.
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('SenderName=' + SN);
      FormData.Add('RecipientName=' + RN);
      FormData.Add('ClassID=' + CI);
      FormData.Add('ClassName=' + CN);
      FormData.Add('Notification=' + N);
      SimpleFormPost('https://api.peachpit.site/send_notification.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if (S = 'OK') then
      begin
        if N = 'r' then ShowMessage(Translate('NSent'));
      end
      else
      begin
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := 'OK';
      end;
    until S = 'OK';
    Free;
  end;
end;


function Get_notifications(PW, RN: string): TStrings;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
  RStrings: TStrings;
  i: integer;

begin

  // We must be able to download the notifications and delete them: we keep going
  // until we've done both, or quit. If we quit after downloading them but
  // before deleting them they will not be displayed, to prevent confusion all
  // round.

  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('RecipientName=' + RN);
      SimpleFormPost('https://api.peachpit.site/get_notifications.php',
        FormData, RStrings);
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        s := '';
        for i := 0 to RStrings.Count - 1 do
          s := s + RStrings[i] + sLineBreak;
        ShowMessage(s);
        if QuestionDlg('Error.', Translate('RorC'),
          mtCustom, [mrYes, 'Retry', mrCancel, Translate('CANCEL')],
          '') = mrCancel then S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if (S = 'OK') then with TFPHttpClient.Create(nil) do
    begin
      repeat
        Response := TStringStream.Create('');
        FormData := TStringList.Create;
        FormData.Clear;
        FormData.Add('PWord=' + PW);
        FormData.Add('RecipientName=' + RN);
        SimpleFormPost('https://api.peachpit.site/delete_notifications.php',
          FormData, Response);
        S := Response.DataString;
        Response.Destroy;
        FormData.Destroy;
        if S <> 'OK' then
          if QuestionDlg('Error', TranslateError(S) + sLineBreak +
            Translate('RorC'), mtCustom,
            [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
            S := Translate('CANCEL')
      until (S = 'OK') or (S = Translate('CANCEL'));
      Free;
    end;
  if S = Translate('CANCEL') then RStrings.Clear;
  Get_notifications := RStrings;
end;

// ************************** ASSIGNMENTS ******************

function UploadAssignment(PW, TN, CI, D: string; RS: boolean; A, AN: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('ClassID=' + CI);
      FormData.Add('Due=' + D);
      FormData.Add('AssignmentName=' + AN);
      if RS then FormData.Add('Resittable=1')
      else
        FormData.Add('Resittable=0');
      FileFormPost('https://api.peachpit.site/upload_assignment.php',
        FormData, 'Assignment', A, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
      begin
        ShowMessage('here');
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL');
      end;
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  UploadAssignment := (S = 'OK');
end;

function Get_assignments(PW, SN: string): TStrings;
var
  RStrings: TStrings;
  S: string;
  FormData: TStrings;
  i: integer;

begin
  ;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('StudentName=' + SN);
      SimpleFormPost('https://api.peachpit.site/get_assignments.php',
        FormData, RStrings);
      FormData.Destroy;
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        S := '';
        for i := 0 to RStrings.Count - 1 do
          S := S + RStrings[i] + sLineBreak;
        if QuestionDlg('Error ' + S, Translate('RorC'),
          mtCustom, [mrYes, 'Retry', mrCancel, Translate('CANCEL')],
          '') = mrCancel then S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if S = Translate('CANCEL') then RStrings.Clear;
  Get_assignments := RStrings;
end;


function Get_assignments_by_class(PW, TN, ClassID: string): TStrings;
var
  RStrings: TStrings;
  S: string;
  FormData: TStrings;
  i: integer;

begin
  ;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('ClassID=' + ClassID);
      SimpleFormPost('https://api.peachpit.site/get_assignments_by_class.php',
        FormData, RStrings);
      FormData.Destroy;
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        S := '';
        for i := 0 to RStrings.Count - 1 do
          S := S + RStrings[i] + sLineBreak;
        if QuestionDlg('Error ' + S, Translate('RorC'),
          mtCustom, [mrYes, 'Retry', mrCancel, Translate('CANCEL')],
          '') = mrCancel then S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if S = Translate('CANCEL') then RStrings.Clear;
  Get_assignments_by_class := RStrings;
end;



function Get_assignment(PW, UN, AI: string): TStrings;
var
  RStrings: TStrings;
  S: string;
  FormData: TStrings;
  i: integer;
begin
  ;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('UserName=' + UN);
      FormData.Add('AssignmentID=' + AI);
      SimpleFormPost('https://api.peachpit.site/get_assignment.php',
        FormData, RStrings);
      FormData.Destroy;
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        S := '';
        for i := 0 to RStrings.Count - 1 do
          S := S + RStrings[i] + sLineBreak;
        if QuestionDlg('Error ' + S, Translate('RorC'),
          mtCustom, [mrYes, 'Retry', mrCancel, Translate('CANCEL')],
          '') = mrCancel then S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if S = Translate('CANCEL') then RStrings.Clear;
  Get_assignment := RStrings;
end;



function DeleteAssignment(PW, TN, AI: string): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('AssignmentID=' + AI);
      SimpleFormPost('https://api.peachpit.site/delete_assignment.php',
        FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
      begin
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL');
      end;
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  DeleteAssignment := (S = 'OK');
end;


// ********************************* RESULTS ***************************

function UploadResult(PW, SN, AI: string; SC: integer): boolean;
var
  Response: TStringStream;
  S: string;
  FormData: TStrings;
begin
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      Response := TStringStream.Create('');
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('StudentName=' + SN);
      FormData.Add('AssignmentID=' + AI);
      FormData.Add('Score=' + IntToStr(SC));
      SimpleFormPost('https://api.peachpit.site/upload_result.php', FormData, Response);
      S := Response.DataString;
      Response.Destroy;
      FormData.Destroy;
      if S <> 'OK' then
      begin
        if QuestionDlg('Error', TranslateError(S) + sLineBreak +
          Translate('RorC'), mtCustom,
          [mrYes, 'Retry', mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL');
      end;
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  UploadResult := (S = 'OK');
end;

function ListAssignmentsByClass(PW, UN, CI: string): TStrings;
var
  RStrings: TStrings;
  S: string;
  FormData: TStrings;

begin
  ;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + UN);
      FormData.Add('ClassID=' + CI);
      SimpleFormPost('https://api.peachpit.site/list_assignments_by_class.php',
        FormData, RStrings);
      FormData.Destroy;
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        S := '';
        if QuestionDlg('Error.', Translate('RorC'),
          mtCustom, [mrYes, 'Retry', mrCancel, Translate('CANCEL')],
          '') = mrCancel then S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if S = Translate('CANCEL') then RStrings.Clear;
  ListAssignmentsByClass := RStrings;
end;

function Get_results(PW, TN, CI: string): TStrings;
var
  RStrings: TStrings;
  S: string;
  FormData: TStrings;
  i: integer;

begin
  ;
  with TFPHttpClient.Create(nil) do
  begin
    repeat
      RStrings := TStringList.Create;
      RStrings.Clear;
      FormData := TStringList.Create;
      FormData.Clear;
      FormData.Add('PWord=' + PW);
      FormData.Add('TeacherName=' + TN);
      FormData.Add('ClassID=' + CI);
      SimpleFormPost('https://api.peachpit.site/get_results.php', FormData, RStrings);
      FormData.Destroy;
      S := '';
      if (RStrings.Count > 0) and (RStrings.Strings[RStrings.Count - 1] = 'OK') then
      begin
        RStrings.Delete(RStrings.Count - 1);
        S := 'OK';
      end;
      if S <> 'OK' then
      begin
        S := '';
        for i := 0 to RStrings.Count - 1 do
          S := S + RStrings[i] + sLineBreak;
        ShowMessage(S);
        if QuestionDlg('Error.', Translate('RorC'),
          mtCustom, [mrYes, Translate('RETRY'),
          mrCancel, Translate('CANCEL')], '') = mrCancel then
          S := Translate('CANCEL');
      end
    until (S = 'OK') or (S = Translate('CANCEL'));
    Free;
  end;
  if S = Translate('CANCEL') then RStrings.Clear;
  Get_results := RStrings;
end;


procedure ConvertDateTime(DateTimeStr: string; var DateStr, TimeStr: string);
var
  tempdt: TDateTime;
begin
  // For each time value we got from MySQL in format yyyy:mm:dd hh:ss we need
  // to convert it into Pascal's TDateTime format so we can convert to local
  // time. Then we reformat it for display using the formatting information
  // in the .lng file.
  DateStr := Split(DateTimeStr, ' ', 1);
  TimeStr := Split(DateTimeStr, ' ', 2);
  tempdt := EncodeDateTime(StrToInt(GetItem(DateStr, '-', 1)),
    StrToInt(GetItem(DateStr, '-', 2)), StrToInt(GetItem(DateStr, '-', 3)),
    StrToInt(GetItem(TimeStr, ':', 1)), StrToInt(GetItem(TimeStr, ':', 2)),
    StrToInt(GetItem(TimeStr, ':', 3)),
    0  // MySQL doesn't supply us with milliseconds unless we ask it nicely.
    );
  tempdt := UniversalTimeToLocal(tempdt);
  DateStr := FormatDateTime(Translate('Date format 2'), tempdt);
  TimeStr := FormatDateTime('hh:mm ampm', tempdt);
end;


end.
