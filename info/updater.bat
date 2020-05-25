::Written by David Losantos (DarviL)

@echo off
color f1
chcp 65001 >Nul
set "mode=mode con cols=55 lines=20"
set ver=1.0.0
title Hammer Language Changer Updater - V%ver%
cls


%mode%
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Updater               ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Downloading latest version.                   ║
echo    ║ Please, wait...                               ║
echo    ╚═══════════════════════════════════════════════╝
echo %1
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/HLCInstaller.bat?raw=true %1/HLCInstaller.bat >nul
rd "data" /s /q
start "" "HLCInstaller.bat"
exit
