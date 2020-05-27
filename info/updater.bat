::Written by David Losantos (DarviL)

@echo off
color f1
chcp 65001 >Nul
set "mode=mode con cols=55 lines=20"
set ver=1.0.0
title Hammer Language Changer Updater - V%ver%
cls


%mode%
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Updater         [▒▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Downloading latest version. The installation  ║
echo    ║ will finish automatically.                    ║
echo    ║ Please, wait...                               ║
echo    ╚═══════════════════════════════════════════════╝
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/HLCInstaller.bat?raw=true "%1/HLCInstaller.bat" >nul
pause
if exist "%1/data" rd "%1/data" /s /q
start "" "HLCInstaller.bat"
exit