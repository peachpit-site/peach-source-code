{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit PythonPackage;

{$warn 5023 off : no warning about unused units}
interface

uses
  PyMemo, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('PyMemo', @PyMemo.Register);
end;

initialization
  RegisterPackage('PythonPackage', @Register);
end.
