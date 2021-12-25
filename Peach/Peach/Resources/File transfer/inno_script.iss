#define MyAppName "Peach"
#define MyAppVersion "0.10.6.1"
#define MyAppPublisher "Peachpit"
#define MyAppExeName "Peach.exe"
#define MyAppAssocName "Vocabulary file"
#define MyAppAssocExt ".vcb"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt
[Setup]
AppId={{A4541547-4DAF-409B-BA1D-7B6E9A6BF8A6}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
UsePreviousAppDir=no
DefaultDirName={autopf}\{#MyAppName}
ChangesAssociations=yes
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
OutputDir=C:\Users\owner\Documents\Peach project\Peach\Peach\Installation
OutputBaseFilename=Peach setup
SetupIconFile=C:\Users\owner\Documents\Peach project\Peach\Peach\Resources\Icon\icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "armenian"; MessagesFile: "compiler:Languages\Armenian.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "catalan"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "corsican"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "czech"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "danish"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "dutch"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "finnish"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "icelandic"; MessagesFile: "compiler:Languages\Icelandic.isl"
Name: "italian"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "norwegian"; MessagesFile: "compiler:Languages\Norwegian.isl"
Name: "polish"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "slovak"; MessagesFile: "compiler:Languages\Slovak.isl"
Name: "slovenian"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"
[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
[Dirs]
Name: "{app}\Peach"; Permissions: users-full;
Name: "{app}\Peach\Grammar plugins"; Permissions: users-full;
Name: "{app}\Peach\Internationalization"; Permissions: users-full;
Name: "{app}\Peach\Licenses"; Permissions: users-full;
Name: "{app}\Peach\Resources"; Permissions: users-full; Attribs: hidden;
Name: "{app}\Peach\Vocab lists"; Permissions: users-full;
Name: "{app}\Peach\Installation"; Permissions: users-full;
Name: "{app}\Peach\Workspace"; Permissions: users-full; Attribs: hidden;
Name: "{app}\Peach\Workspace 2"; Permissions: users-full; Attribs: hidden;
[Files]
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\Workspace 2\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion;
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\Workspace\{#MyAppExeName}"; DestDir: "{app}\Peach"; Flags: ignoreversion;
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\Grammar plugins\*"; DestDir: "{app}\Peach\Grammar plugins"; Flags: ignoreversion; Permissions: users-full;
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\Internationalization\*"; DestDir: "{app}\Peach\Internationalization"; Flags: ignoreversion; Permissions: users-full; 
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\Licenses\*"; DestDir: "{app}\Peach\Licenses"; Flags: ignoreversion recursesubdirs createallsubdirs; Permissions: users-full;
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\Resources\*"; DestDir: "{app}\Peach\Resources"; Flags: ignoreversion recursesubdirs createallsubdirs; Permissions: users-full;
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\Vocab lists\*"; DestDir: "{app}\Peach\Vocab lists"; Flags: ignoreversion; Permissions: users-full; 
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\libeay32.dll"; DestDir: "{app}\Peach"; Flags: ignoreversion;
Source: "C:\Users\owner\Documents\Peach project\Peach\Peach\ssleay32.dll"; DestDir: "{app}\Peach"; Flags: ignoreversion;
Source: "C:\Users\owner\Documents\Peach project\Peach\\libeay32.dll"; DestDir: "{app}"; Flags: ignoreversion;
Source: "C:\Users\owner\Documents\Peach project\Peach\\ssleay32.dll"; DestDir: "{app}"; Flags: ignoreversion;
Source: "C:\Windows\Fonts\Arbit Solaris.ttf"; DestDir: "{autofonts}"; FontInstall: "Arbit Solaris"; Flags: onlyifdoesntexist uninsneveruninstall
Source: "C:\Windows\Fonts\cambria.ttc"; DestDir: "{autofonts}"; FontInstall: "cambria"; Flags: onlyifdoesntexist uninsneveruninstall
[Registry]
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".myp"; ValueData: ""
[Icons]
Name: "{autoprograms}\{#MyAppName}"; FileName: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; FileName: "{app}\{#MyAppExeName}"; Tasks: desktopicon
[Run]
FileName: "{app}\Peach.exe"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
