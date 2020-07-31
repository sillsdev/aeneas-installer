This provides a simple installer for [Aeneas](https://github.com/readbeyond/aeneas) for MS Windows 8 and up.

1. To build this installer for MS Windows first download (and extract) or clone this repository.
2. Then open Command Prompt and _cd_ to _MS\_Windows\_Installer_  
3. Next run `build\_setup.bat` which will install the necessary applications for building.  
4. Then run `build\_packages.bat` which will then build all the individual packages.
4. Finally run `build\_installer.bat` which will then build the main installer.

NOTE: This will build an installer for 32-bit Windows setups.

The 64-bit installer scripts can be found in the _MS\_Windows\_64-bit\_Installer_ folder.
