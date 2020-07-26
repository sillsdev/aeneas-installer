; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "aeneas tools"
#define MyAppVersion "[AENEAS_VER]"
#define MyAppPublisher "Daniel Bair"
#define MyAppURL "http://www.danielbair.com/"
#define MyAppInstallDir "C:\aeneas-install"
#define MyAppFileName "aeneas-windows-setup-[AENEAS_VER]_3"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{A15A9B64-C0EF-4E13-926C-0C60A8FA9FBC}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
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
WelcomeLabel2=This will install aeneas [AENEAS_VER] on your computer.%n%naeneas is a Python library and a set of tools for automated audio and text synchronization.%n%nIn addition to aeneas, the following independent programs necessary for running aeneas are contained in this installer:%n1. FFmpeg%n2. eSpeak-NG-ng%n3. Python%n%nIt is recommended that you close all other applications before continuing.

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{pf}\Python38\Scripts;{olddata}"; Components: python; Check: NeedsAddPath('{pf}\Python38\Scripts')
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{pf}\Python38\;{olddata}"; Components: python; Check: NeedsAddPath('{pf}\Python38\')
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{pf}\FFmpeg\bin"; Components: ffmpeg; Check: NeedsAddPath(ExpandConstant('{pf}\FFmpeg\bin'))
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{pf}\eSpeak-NG-ng"; Components: espeak-ng; Check: NeedsAddPath(ExpandConstant('{pf}\eSpeak-NG'))

[Components]
Name: "ffmpeg"; Description: "Install FFmpeg [FFMPEG_VER]"; ExtraDiskSpaceRequired: 111181824; Types: full compact custom; Flags: fixed
Name: "espeak-ng"; Description: "Install eSpeak-NG [ESPEAK_VER]"; ExtraDiskSpaceRequired: 11223040; Types: full compact custom; Flags: fixed
Name: "python"; Description: "Install Python [PYTHON_VER]"; ExtraDiskSpaceRequired: 106450944; Types: full compact custom; Flags: fixed
Name: "bs4"; Description: "Install Python Module BeautifulSoup4 [BS4_VER]"; ExtraDiskSpaceRequired: 3400000; Types: full compact custom; Flags: fixed
Name: "lxml"; Description: "Install Python Module lxml [LXML_VER]"; ExtraDiskSpaceRequired: 0; Types: full compact custom; Flags: fixed
Name: "numpy"; Description: "Install Python Module NumPy [NUMPY_VER]"; ExtraDiskSpaceRequired: 0; Types: full compact custom; Flags: fixed
Name: "aeneas"; Description: "Install Python Module aeneas [AENEAS_VER]"; ExtraDiskSpaceRequired: 0; Types: full compact custom; Flags: fixed

[Files]
Source: "[AENEAS_FILE]"; DestDir: "{app}"; Components: aeneas; Flags: ignoreversion
Source: "[NUMPY_FILE]"; DestDir: "{app}"; Components: numpy; Flags: ignoreversion
Source: "[LXML_FILE]"; DestDir: "{app}"; Components: lxml; Flags: ignoreversion
Source: "[BS4_FILE]"; DestDir: "{app}"; Components: bs4; Flags: ignoreversion
Source: "[SOUPSIEVE_FILE]"; DestDir: "{app}"; Components: bs4; Flags: ignoreversion
Source: "[PIP_FILE]"; DestDir: "{app}"; Components: python; Flags: ignoreversion
Source: "[PYTHON_FILE]"; DestDir: "{app}"; Components: python; Flags: ignoreversion
Source: "[FFMPEG_FILE]"; DestDir: "{app}"; Components: ffmpeg; Flags: ignoreversion
Source: "[ESPEAK_FILE]"; DestDir: "{app}"; Components: espeak-ng; Flags: ignoreversion
Source: "espeak-ng.lib"; DestDir: "{app}"; Components: espeak-ng; Flags: ignoreversion
Source: "aeneas_check_setup.bat"; DestDir: "{app}"; Components: aeneas; Flags: ignoreversion
Source: "install_packages.bat"; DestDir: "{app}"; Components: aeneas; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\[FFMPEG_FILE]"; Parameters: "/SILENT"; Description: "Install FFmpeg [FFMPEG_VER]"; Components: ffmpeg; Flags: shellexec waituntilterminated
Filename: "{app}\[ESPEAK_FILE]"; Parameters: "/PASSIVE InstallAllUsers=1 PrependPath=1"; Description: "Install eSpeak-NG [ESPEAK_VER]"; Components: espeak-ng; Flags: shellexec waituntilterminated
Filename: "{app}\[PYTHON_FILE]"; Parameters: "/PASSIVE InstallAllUsers=1 PrependPath=1"; Description: "Install Python [PYTHON_VER]"; Components: python; Flags: shellexec waituntilterminated
Filename: "{app}\install_packages.bat"; Description: "Install Aeneas [AENEAS_VER] and dependencies"; Components: aeneas; Flags: shellexec waituntilterminated
Filename: "{app}\aeneas_check_setup.bat"; Description: "Check Aeneas Setup"; Components: aeneas; Flags: shellexec waituntilterminated

[UninstallRun]
Filename: "{pf}\FFmpeg\unins000.exe"; Parameters: "/SILENT"; Components: ffmpeg; Flags: shellexec waituntilterminated
Filename: "{sys}\MSIEXEC.EXE"; Parameters: "/PASSIVE /X {app}\[ESPEAK_FILE]"; Components: espeak-ng; Flags: shellexec waituntilterminated
Filename: "{sys}\MSIEXEC.EXE"; Parameters: "/PASSIVE /X {app}\[PYTHON_FILE]"; Components: python; Flags: shellexec waituntilterminated

[UninstallDelete]
Type: filesandordirs; Name: "{pf}\Python38"; Components: python
Type: filesandordirs; Name: "{sys}\espeak-ng.dll"; Components: espeak-ng
Type: filesandordirs; Name: "{app}";

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
