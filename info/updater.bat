::Written by David Losantos (DarviL)

@echo off
color f1
chcp 65001 >Nul
set "mode=mode con cols=55 lines=10"
set ver=1.0.0
title Hammer Language Changer Updater - V%ver%
cls


if not defined %1 exit

echo msgbox ("Downloading the latest version. The installation will finish automatically. Please, wait...") > "%temp%/HLC/update_msg.vbs"


%mode%
start "" "%temp%/HLC/update_msg.vbs"
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/HLCInstaller.bat?raw=true "%1/HLCInstaller.bat" >nul
if exist "%1/data" rd "%1/data" /s /q
taskkill /im wscript.exe /f >nul
start "" "HLCInstaller.bat"
	
exit