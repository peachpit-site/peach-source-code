unit SignIn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TFormSignIn }

  TFormSignIn = class(TForm)
    ButtonCancel: TButton;
    ButtonOK: TButton;
    EditPassword: TEdit;
    EditUsername: TEdit;
    LabelPassword: TLabel;
    LabelUsername: TLabel;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure EditPasswordKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormSignIn: TFormSignIn;

implementation

{$R *.lfm}

{ TFormSignIn }

procedure TFormSignIn.ButtonOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormSignIn.EditPasswordKeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if Key = 13 then ButtonOKClick(EditPassword);
end;

procedure TFormSignIn.FormActivate(Sender: TObject);
begin
  EditUsername.SetFocus;
end;

procedure TFormSignIn.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
