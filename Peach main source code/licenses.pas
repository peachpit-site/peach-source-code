unit Licenses;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, AppLanguage,
  Process;

type

  { TFormLicenses }

  TFormLicenses = class(TForm)
    ShowLicensesButton: TButton;
    CloseLicensesButton: TButton;
    LicenseMemo: TMemo;
    procedure CloseLicensesButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ShowLicensesButtonClick(Sender: TObject);
  private

  public

  end;

var
  FormLicenses: TFormLicenses;

implementation

{$R *.lfm}

{ TFormLicenses }

procedure TFormLicenses.CloseLicensesButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TFormLicenses.FormActivate(Sender: TObject);
begin
  FormLicenses.Caption := Translate('FLIC');
  ShowLicensesButton.Caption := Translate('SLIC');
  CloseLicensesButton.Caption := Translate('CLIC');
end;

procedure TFormLicenses.ShowLicensesButtonClick(Sender: TObject);
var
  Pr: TProcess;
begin
  Pr := TProcess.Create(nil);
  Pr.Executable := 'explorer.exe';
  Pr.Parameters.Add(ExtractFilePath(ParamStr(0)) + 'Licenses');
  Pr.Execute;
  Pr.Free;
end;

end.
