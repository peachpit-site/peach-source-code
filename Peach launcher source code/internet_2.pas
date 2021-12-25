unit Internet_2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient,
  openssl, opensslsockets, CommonStringFunctions, Dialogs;

function GetStringFromUrl(Url: string): string;
procedure GetFileFromUrl(Url, Filename: string);
function GetListFromUrl(Url: string): TStringList;


implementation


function GetStringFromUrl(Url: string): string;
var
  Client: TFPHttpClient;

begin
  InitSSLInterface;

  Client := TFPHttpClient.Create(nil);
  try
    Client.AllowRedirect := True;
    GetStringFromUrl := Trim(Client.Get(URL));
  finally
    Client.Free;
  end;

end;


function GetListFromUrl(Url: string): TStringList;
var
  s: string;
  List: TStringList;
begin
  List := TStringList.Create();
  s := GetStringFromUrl(Url);
  while s <> '' do
  begin
    List.Add(Split(s, #13, 1));
    s := Split(s, #13, 2);
  end;
  GetListFromUrl := List;
end;

procedure GetFileFromUrl(Url, Filename: string);

var
  Client: TFPHttpClient;
  FS: TStream;

begin
  InitSSLInterface;
  Client := TFPHttpClient.Create(nil);
  FS := TFileStream.Create(Filename, fmCreate or fmOpenWrite);
  try
    try
      { Allow redirections }
      Client.AllowRedirect := True;
      Client.Get(Url, FS);
    except
      on E: EHttpClient do
        writeln(E.Message)
      else
        raise;
    end;
  finally
    FS.Free;
    Client.Free;
  end;
end;


end.
