unit RMInlinePicture;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, RichMemo, Graphics, Types, Dialogs;

type

  { TRichMemoInlinePicture }

  TRichMemoInlinePicture = class(TRichMemoInline)
    Pic: TPicture;
    constructor Create(Apicture: TPicture);
    procedure Draw(Canvas: TCanvas; const ASize: TSize); override;
  end;

implementation

{ TRichMemoInlinePicture }

constructor TRichMemoInlinePicture.Create(Apicture: TPicture);
begin
  inherited Create;
  Pic := APicture;
end;

procedure TRichMemoInlinePicture.Draw(Canvas: TCanvas; const ASize: TSize);
begin
  inherited Draw(Canvas, ASize);
  Canvas.Draw(0, 0, Pic.Graphic);
end;

end.
