unit LockdownOptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFormLO }

  TFormLO = class(TForm)
    Button1: TButton;
    Button2: TButton;
    LockdownGroup: TCheckGroup;
    Shape: TShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormLO: TFormLO;

implementation

{$R *.lfm}

{ TFormLO }

procedure TFormLO.FormActivate(Sender: TObject);
begin
  FormLO.Width := FormLO.LockdownGroup.Width + 24;
end;

procedure TFormLO.Button1Click(Sender: TObject);
begin
  Close;
  ModalResult := mrOk;
end;

procedure TFormLO.Button2Click(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

end.
