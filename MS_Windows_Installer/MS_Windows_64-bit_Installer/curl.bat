echo on
powershell "(new-object System.Net.WebClient).DownloadFile('%2', '%4')"
@echo off
