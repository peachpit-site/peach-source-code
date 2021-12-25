unit SearchAndReplace;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFormFind }

  TFormFind = class(TForm)
    FindButton: TButton;
    CheckCase: TCheckBox;
    EditReplace: TEdit;
    EditFind: TEdit;
    procedure EditFindKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure EditReplaceKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FindButtonClick(Sender: TObject);
  private

  public

  end;

var
  FormFind: TFormFind;

implementation

{$R *.lfm}

{ TFormFind }

procedure TFormFind.FindButtonClick(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TFormFind.EditFindKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Key = 13) and not EditReplace.Visible then FindButtonClick(FormFind);
end;

procedure TFormFind.EditReplaceKeyUp(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if (Key = 13) then FindButtonClick(FormFind);
end;



end.
