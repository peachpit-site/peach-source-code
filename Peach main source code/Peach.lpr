program Peach;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads,  {$ENDIF}  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  main,
  SearchAndReplace,
  AppearanceOptions,
  LockdownOptions,
  Publish,
  QAUnit,
  SignIn,
  AssignHomework,
  Internet,
  Register,
  StudentClasses,
  TeacherClasses,
  Assignments,
  TestResults,
  InterposerEdit,
  RMInlinePicture,
  IconUpdater,
  VersionSupport,
  AppLanguage,
  CommonStringFunctions,
  Vocab,
  FontInfo,
  Licenses,
  PythonFunctions,
  WMemo,
  PyMemo;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormFind, FormFind);
  Application.CreateForm(TFormAO, FormAO);
  Application.CreateForm(TFormLO, FormLO);
  Application.CreateForm(TFormPublish, FormPublish);
  Application.CreateForm(TFormQA, FormQA);
  Application.CreateForm(TFormSignIn, FormSignIn);
  Application.CreateForm(TFormAssignHomework, FormAssignHomework);
  Application.CreateForm(TFormRegister, FormRegister);
  Application.CreateForm(TFormSClasses, FormSClasses);
  Application.CreateForm(TFormStudents, FormStudents);
  Application.CreateForm(TFormAssignments, FormAssignments);
  Application.CreateForm(TFormResults, FormResults);
  Application.CreateForm(TFormLicenses, FormLicenses);
  Application.Run;
end.
