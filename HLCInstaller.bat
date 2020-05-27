::Written by David Losantos (DarviL)

@echo off
color f1
chcp 65001 >Nul
set "mode=mode con cols=55 lines=20"
set ver=1.0.1
set ver_number=2
title Hammer Language Changer Installer - V%ver%
cls





:checksum
%mode%
(
	echo Hammer Language Changer Installer LOG
	echo Created by DarviL.
	echo [%date%] - [%time%]
	echo ─────────────────────────────────────────────────
	echo:
) > log.txt


if not exist "data" mkdir "data"
if not exist "data/p2_spanish.dll" set download_required=1
if not exist "data/p2_original.dll" set download_required=1

if exist "updater.bat" (
	del "updater.bat" /f /q
	echo [%time%]: Program updated succesfully! >> log.txt
)


::Check if user it's connected to internet
ping google.com /n 1 >nul
if %errorlevel%==1 (
	echo [%time%]: Having an stable internet conection is required for using the program. >> log.txt
	exit
)

echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [▒▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Checking for updates...                       ║
echo    ║ Please, wait...                               ║
echo    ╚═══════════════════════════════════════════════╝

::Download the git ver file, wich contents the latest version number. Then compare it with the current version. Horrid way of checking what's the latest version: Yes. Works: Yes.
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/info/version.hlc?raw=true "%cd%\data\version.hlc" >nul
set /p current_version=<"%cd%\data\version.hlc"
del "data\version.hlc" /f
if "%ver_number%" LSS "%current_version%" (
	echo [%time%]: A newer version has been found. >> log.txt
	cls
	color f6
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer      ![▒▒▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ There is a newer version available.           ║
	echo    ║ Press any key to install the new version      ║
	echo    ║ automatically.                                ║
	echo    ╚═══════════════════════════════════════════════╝
	echo     Current version: %ver%
	echo     New version: %current_version%
	pause>nul
	bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/info/updater.bat?raw=true "%cd%\updated.bat" >nul
	start "" updater.bat "%cd%"
	exit
) else echo [%time%]: Using latest version. >> log.txt


set total_files=2


::If any of the required files is missing, redownload all of them.
if "%download_required%"=="1" (
	echo [%time%]: Asset files are missing. Starting download process... >> log.txt
	cls
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer       [▒▒▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ Couldn't find asset files.                    ║
	echo    ║ Downloading required files... Please, wait... ║
	echo    ╚═══════════════════════════════════════════════╝
	echo     - Information:
	echo:
	
	echo        [1/%total_files%] Downloading "dlls/p2_spanish.dll"...
	bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/dlls/p2_spanish.dll?raw=true "%cd%\data\p2_spanish.dll" >nul &&echo [%time%]: Downloaded "p2_spanish.dll". >> log.txt

	echo        [2/%total_files%] Downloading "dlls/p2_original.dll"...
	bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/dlls/p2_original.dll?raw=true "%cd%\data\p2_original.dll" >nul &&echo [%time%]: Downloaded "p2_original.dll". >> log.txt
	
	echo ───────────────────────────────────────────────────────
	echo        Download process finished. Initializing...
	echo [%time%]: Download process finished. >> log.txt
	timeout 3 /nobreak >nul
)





::This function will try to find where is Steam located, as you can see, his IQ it's not really high, and I'm pretty sure he will need help...
::That's why I did this, if it can't find Steam, it'll just prompt you to put the Steam path. I hope people will read that YOU CAN'T PUT QUOTATION MARKS...
:steam_find
cls
if exist "data/steam_path.hlc" set /p "steam_path="<data/steam_path.hlc
if exist "%ProgramFiles(x86)%\steam\steam.exe" set "steam_path=%ProgramFiles(x86)%\Steam"
if exist "%ProgramFiles%\Steam\steam.exe" set "steam_path=%ProgramFiles%\Steam"

if not defined steam_path (
	goto steam_find-fail
) else goto step1


:steam_find-fail
%mode%
color fc
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer      ![█▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Unable to find the Steam path.                ║
echo    ║ Please, drag the Steam folder to this program ║
echo    ║ and press ENTER in order to continue          ║
echo    ║ with the installation.                        ║
echo    ║                                               ║
echo    ║ Make sure you remove the quotation marks!     ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo ───────────────────────────────────────────────────────
set /p steam_path=
if not defined steam_path echo [%time%]: -INPUT- Invalid value. >> log.txt &goto steam_find
if not exist "%steam_path%\steam.exe" (
	echo [%time%]: Couldn't find "steam.exe" at "%steam_path%. >> log.txt
	exit
)
echo %steam_path%> "data\steam_path.hlc"





:step1
%mode%
echo %steam_path%
echo [%time%]: Steam located at: "%steam_path%" >> log.txt
cls
color f1
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [█▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Welcome to the Hammer Language installation   ║
echo    ║ setup! In wich game you would like to use     ║
echo    ║ a translation for Hammer?                     ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Available Games:                              ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ A: Portal 2                                   ║
echo    ╚═══════════════════════════════════════════════╝
choice /c a /n >nul
if %errorlevel%==1 set selected_game=p2




:step2
%mode%
if %selected_game%==p2 (
	if exist "%steam_path%\steamapps\common\Portal 2\bin" (
		echo [%time%]: Selected game: Portal 2. >> log.txt
		set "bin_path=%steam_path%\steamapps\common\Portal 2\bin"
		set file_prefix=p2
	) else echo [%time%]: Couldn't locate bin folder. >> log.txt &exit
)

set "state_es=   "
set "state_fr=   "
set "state_original=   "

::Check if the hlc config file is stored inside bin... This file just tells this crappy function wich language is being used rn. If not found, just set that user is using Valve's DLL.
if exist "%bin_path%\HLC\language_selected.hlc" set /p current_language=<"%bin_path%\HLC\language_selected.hlc"
if exist "%bin_path%\HLC\language_selected.hlc" (
	echo [%time%]: Getting current config from "%bin_path%\HLC\language_selected.hlc". {current_language=%current_language%} >> log.txt
	if "%current_language%"=="spanish" set state_es=[√]
	if "%current_language%"=="french" set state_fr=[√]
	if "%current_language%"=="original" set state_original=[√]
) else (
	set state_original=[√]
	echo [%time%]: Couldn't get user config. Setting default values. >> log.txt
)


cls
color f1
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [██▒] ║
echo    ╟───────────────────────────────────────────────╢
if %selected_game%==p2 echo    ║ Game selected: Portal 2                       ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Available languages:                          ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ A: Spanish - DarviL %state_es%                       ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ B: Original - Valve %state_original%                       ║
echo    ╚═══════════════════════════════════════════════╝
choice /c ab /n >nul
if %errorlevel%==1 set selected_dll=spanish
if %errorlevel%==2 set selected_dll=original
if %errorlevel%==3 set selected_dll=original





::This just works.
:step3
%mode%
cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [██▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Please, wait...                               ║
echo    ╚═══════════════════════════════════════════════╝
tasklist |find "hammer.exe" >nul
if %errorlevel%==0 (
	echo [%time%]: Detected hammer running. >> log.txt
	goto step3_hammer-open
) else goto step3_proceed





:step3_hammer-open
%mode%
cls
color fc
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer      ![██▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Hammer is currently running! It has to be     ║
echo    ║ closed in order to continue.                  ║
echo    ║ Please, save your possible unsaved documents  ║
echo    ║ before continuing with the installation.      ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ P: Continue with the installation.            ║
echo    ╚═══════════════════════════════════════════════╝
choice /c p /n >nul
if %errorlevel%==1 (
	cls
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer       [██▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ Please, wait...                               ║
	echo    ╚═══════════════════════════════════════════════╝
	
	taskkill /im hammer.exe /f >nul
	echo [%time%]: Trying to close "hammer.exe" >> "log.txt"
	timeout 2 /nobreak >nul
	goto step3_proceed
)


::And there we go, the final step. Here we are copying the file (finally). As you can see, it also created that file in bin, wich will tell the Installer what language is being used rn.
:step3_proceed
if not exist "data\%file_prefix%_%selected_dll%.dll" echo [%time%]: Couldn't find "data\%file_prefix%_%selected_dll%.dll". >> log.txt &exit
copy "data\%file_prefix%_%selected_dll%.dll" "%bin_path%\hammer_dll.dll" /y >nul &&echo [%time%]: %selected_dll% DLL has been copied succesfully as "%bin_path%\hammer_dll.dll". >> log.txt
if not exist "%bin_path%\HLC" mkdir "%bin_path%\HLC"
echo %selected_dll%> "%bin_path%\HLC\language_selected.hlc"





:finish
%mode%
(
	echo [%time%]: Installation finished succesfully.
	echo:
) >> log.txt

color f2
cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer      √[███] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ The DLL has been installed correctly!         ║
echo    ║                                               ║
echo    ║ A: Get back to the language selection menu.   ║
echo    ║ B: Exit the program.                          ║
echo    ╚═══════════════════════════════════════════════╝
choice /c ab /n >nul
if %errorlevel%==1 goto step2
if %errorlevel%==2 exit
goto step2
