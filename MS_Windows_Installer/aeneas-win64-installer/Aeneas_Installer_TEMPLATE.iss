; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "aeneas tools"
#define MyAppVersion "[AENEAS_VER]"
#define MyAppPublisher "Daniel Bair"
#define MyAppURL "http://www.danielbair.com/"
#define MyAppInstallDir "C:\aeneas-install"
#define MyAppFileName "aeneas-win64-setup-[AENEAS_VER]_3"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{47679629-20DD-4D46-AE0C-D137DD0BF1FD}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64
UsePreviousAppDir=yes
DefaultDirName={#MyAppInstallDir}
DisableDirPage=yes
DisableWelcomePage=no
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
DisableProgramGroupPage=yes
LicenseFile=LICENSE.txt
InfoBeforeFile=README.txt
OutputDir=.\
OutputBaseFilename={#MyAppFileName}
Compression=lzma
SolidCompression=yes
ChangesEnvironment=yes
;SignTool=mysigntool

[Messages]
WelcomeLabel2=This will install aeneas [AENEAS_VER] on your computer.%n%naeneas is a Python library and a set of tools for automated audio and text synchronization.%n%nIn addition to aeneas, the following independent programs necessary for running aeneas are contained in this installer:%n1. eSpeak-NG%n2. FFmpeg%n3. Python%n%nIt is recommended that you close all other applications before continuing.

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Components]
Name: "espeak"; Description: "Install eSpeak-NG [ESPEAK_VER]"; ExtraDiskSpaceRequired: 11223040; Types: full custom
Name: "ffmpeg"; Description: "Install FFmpeg [FFMPEG_VER]"; ExtraDiskSpaceRequired: 111181824; Types: full custom
Name: "python"; Description: "Install Python [PYTHON_VER]"; ExtraDiskSpaceRequired: 106450944; Types: full
Name: "bs4"; Description: "Install Python Module BeautifulSoup4 [BS4_VER]"; ExtraDiskSpaceRequired: 3400000; Types: full compact custom
Name: "lxml"; Description: "Install Python Module lxml [LXML_VER]"; ExtraDiskSpaceRequired: 3548446; Types: full compact custom
Name: "numpy"; Description: "Install Python Module NumPy [NUMPY_VER]"; ExtraDiskSpaceRequired: 12971083; Types: full compact custom
Name: "aeneas"; Description: "Install Python Module aeneas [AENEAS_VER]"; ExtraDiskSpaceRequired: 4885092; Types: full compact custom
; NOTE: Previous used "Flags: fixed" on each component

[Files]
Source: "python-wheels\[AENEAS_FILE]"; DestDir: "{app}"; Components: aeneas; Flags: ignoreversion
Source: "python-wheels\[NUMPY_FILE]"; DestDir: "{app}"; Components: numpy; Flags: ignoreversion
Source: "python-wheels\[LXML_FILE]"; DestDir: "{app}"; Components: lxml; Flags: ignoreversion
Source: "python-wheels\[BS4_FILE]"; DestDir: "{app}"; Components: bs4; Flags: ignoreversion
Source: "python-wheels\[SOUPSIEVE_FILE]"; DestDir: "{app}"; Components: bs4; Flags: ignoreversion
Source: "aeneas-win-installer-packages\[PYTHON_FILE]"; DestDir: "{app}"; Components: python; Flags: ignoreversion
Source: "aeneas-win-installer-packages\[FFMPEG_FILE]"; DestDir: "{app}"; Components: ffmpeg; Flags: ignoreversion
Source: "aeneas-win-installer-packages\[ESPEAK_FILE]"; DestDir: "{app}"; Components: espeak; Flags: ignoreversion
Source: "espeak-ng.lib"; DestDir: "{app}"; Components: espeak; Flags: ignoreversion
;Source: "install_packages.bat"; DestDir: "{app}"; Components: aeneas; Flags: ignoreversion
Source: "aeneas_check_setup.bat"; DestDir: "{app}"; Components: aeneas; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\[ESPEAK_FILE]"; Parameters: "/PASSIVE"; StatusMsg: "Installing eSpeak-NG [ESPEAK_VER]"; Components: espeak; Flags: shellexec waituntilterminated; AfterInstall: CustomCopyFile('{commonpf64}\eSpeak NG\espeak-ng.exe','{commonpf64}\eSpeak NG\espeak.exe')
Filename: "{app}\[FFMPEG_FILE]"; Parameters: "/SILENT /ALLUSERS"; StatusMsg: "Installing FFmpeg [FFMPEG_VER]"; Components: ffmpeg; Flags: shellexec waituntilterminated
Filename: "{app}\[PYTHON_FILE]"; Parameters: "/PASSIVE InstallAllUsers=1 PrependPath=1 TargetDir=""{commonpf64}""\Python38"; StatusMsg: "Installing Python [PYTHON_VER]"; Components: python; Flags: shellexec waituntilterminated
Filename: "{commonpf64}\Python38\Scripts\pip.exe"; Parameters: "install -U {app}\[NUMPY_FILE]"; StatusMsg: "Installing NumPy [NUMPY_VER]"; Components: numpy; Flags: shellexec waituntilterminated
Filename: "{commonpf64}\Python38\Scripts\pip.exe"; Parameters: "install -U {app}\[LXML_FILE]"; StatusMsg: "Installing lxml [LXML_VER]"; Components: lxml; Flags: shellexec waituntilterminated
Filename: "{commonpf64}\Python38\Scripts\pip.exe"; Parameters: "install -U {app}\[SOUPSIEVE_FILE]"; StatusMsg: "Installing SoupSieve [SOUPSIEVE_VER]"; Components: bs4; Flags: shellexec waituntilterminated
Filename: "{commonpf64}\Python38\Scripts\pip.exe"; Parameters: "install -U {app}\[BS4_FILE]"; StatusMsg: "Installing BeautifulSoup4 [BS4_VER]"; Components: bs4; Flags: shellexec waituntilterminated
Filename: "{commonpf64}\Python38\Scripts\pip.exe"; Parameters: "install -U {app}\[AENEAS_FILE]"; StatusMsg: "Installing Aeneas [AENEAS_VER]"; Components: aeneas; Flags: shellexec waituntilterminated; BeforeInstall: CustomCopyFile('{app}\espeak-ng.lib','{commonpf64}\Python38\libs'); AfterInstall: CustomCopyFile('{commonpf64}\eSpeak NG\libespeak-ng.dll','{commonpf64}\Python38\Lib\site-packages\aeneas\cew')
;Filename: "{app}\install_packages.bat"; StatusMsg: "Installing Aeneas [AENEAS_VER] and dependencies"; Components: aeneas; Flags: shellexec waituntilterminated
Filename: "{app}\aeneas_check_setup.bat"; StatusMsg: "Checking Aeneas Setup"; Components: aeneas; Flags: shellexec waituntilterminated

[UninstallRun]
Filename: "{commonpf64}\Python38\Scripts\pip.exe"; Parameters: "uninstall -y aeneas beautifulsoup4 soupsieve lxml numpy"; Components: aeneas; Flags: shellexec waituntilterminated
Filename: "{sys}\MSIEXEC.EXE"; Parameters: "/PASSIVE /X {app}\[PYTHON_FILE]"; Components: python; Flags: shellexec waituntilterminated; BeforeInstall: CustomDeleteFile('{commonpf64}\Python38\lib\espeak-ng.lib')
Filename: "{commonpf64}\FFmpeg\unins000.exe"; Parameters: "/SILENT"; Components: ffmpeg; Flags: shellexec waituntilterminated
Filename: "{sys}\MSIEXEC.EXE"; Parameters: "/PASSIVE /X {app}\[ESPEAK_FILE]"; Components: espeak; Flags: shellexec waituntilterminated; BeforeInstall: CustomDeleteFile('{commonpf64}\eSpeak NG\espeak.exe')

[UninstallDelete]
Type: filesandordirs; Name: "{commonpf64}\FFmpeg"; Components: ffmpeg
Type: filesandordirs; Name: "{commonpf64}\eSpeak NG"; Components: espeak
Type: filesandordirs; Name: "{app}";

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{userappdata}\python\python38\Scripts;{olddata}"; Components: aeneas; Check: NeedsAddPath('{userappdata}\python\python38\Scripts')
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{commonpf64}\eSpeak NG;{olddata}"; Components: espeak; Check: NeedsAddPath('{commonpf64}\eSpeak NG')

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  // look for the path with leading and trailing semicolon
  // Pos() returns 0 if not found
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;

procedure CustomCopyFile(S: String; D: String);
begin
  Log('CopyFile(''' + S + ''', ''' + D + ''') called');
  FileCopy(ExpandConstant(S),ExpandConstant(D), False);
end;

procedure CustomDeleteFile(S: String);
begin
  Log('DeleteFile(''' + S + ''') called');
  DeleteFile(ExpandConstant(S));
end;