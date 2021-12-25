unit Register;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TFormRegister }

  TFormRegister = class(TForm)
    ButtonOK: TButton;
    ButtonCancel: TButton;
    EditPW: TEdit;
    EditFN: TEdit;
    EditLN: TEdit;
    EditUN: TEdit;
    EditEM: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Divider: TShape;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormRegister: TFormRegister;

implementation

{$R *.lfm}

{ TFormRegister }

procedure TFormRegister.ButtonOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormRegister.FormActivate(Sender: TObject);
begin
  Height := ButtonOK.Top + ButtonOK.Height + 12;
end;

procedure TFormRegister.ButtonCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
