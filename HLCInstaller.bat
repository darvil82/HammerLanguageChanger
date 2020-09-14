::Written by David Losantos (DarviL)

@echo off
chcp 65001 >nul
echo Please, wait...


:checksum
if "%log_msg%" == "1" (
	echo:
	echo:
	echo:
) >> log.txt

if not defined log_msg (
	set log_msg=1
	echo Hammer Language Changer Installer LOG
	echo Created by DarviL.
	echo [%date%] - [%time%]
	echo ─────────────────────────────────────────────────
	echo:
) > log.txt



::Check vars
set ver=1.2
set ver_number=5
echo [Version: "%ver%"] [Compilation: "%ver_number%"] >> log.txt

set "mode=mode con cols=55 lines=20"
set "mode2=mode con cols=55 lines=30"

set colors_normal=color f1
set colors_error=color fc
set colors_info=color f6
set colors_correct=color f2

title Hammer Language Changer Installer - V%ver%
%mode%
%colors_normal%



::Check parameters
if "%1"=="force_update" (
	echo [%time%]: Forcing the program to update... >> log.txt
	set ver_number=0
)
if "%1"=="skip_downloads" (
	set skip_downloads=1
	echo [%time%]: Skipping all the possible downloads. >> log.txt
)
if "%1"=="download" (
	echo Downloading "%2" to "%cd%"...
	call :file_download %2
	copy "%temp%\HLC\%2" "%cd%"
	exit
)



::Check files
if not exist "%temp%\HLC" (
	mkdir "%temp%\HLC"
) else (
	rd "%temp%\HLC" /s /q
	mkdir "%temp%\HLC"
)

if "%skip_downloads%" == "1" goto steam_find


::Check if user it's connected to internet
cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [▒▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Attempting to connect to GitHub...            ║
echo    ║ Please, wait...                               ║
echo    ╚═══════════════════════════════════════════════╝
ping github.com /n 1 >nul
if %errorlevel% == 1 (
	echo [%time%]: Unable to connect to GitHub. >> log.txt
	call :error_no-internet
)

cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [▒▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Checking for updates...                       ║
echo    ║ Please, wait...                               ║
echo    ╚═══════════════════════════════════════════════╝


::Download the git ver file, wich contents the latest version number. Then compare it with the current version. Horrid way of checking what's the latest version: Yes. Works: Yes.
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/info/version.hlc?raw=true "%temp%\HLC\version.hlc" >nul
set /p ver_git_number=<"%temp%\HLC\version.hlc"
del "%temp%\HLC\version.hlc" /f
if "%ver_number%" LSS "%ver_git_number%" (
	echo [%time%]: A newer version has been found [%ver_git_number%] >> log.txt
	%colors_info%
	
	cls
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer      ![▒▒▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ There is a newer version available.           ║
	echo    ║ Press any key to open the releases page       ║
	echo    ║ to download the latest update.                ║
	echo    ╚═══════════════════════════════════════════════╝
	echo     Current Build Nº: %ver_number%
	echo     New Build Nº: %ver_git_number%
	pause>nul
	start "" "https://github.com/L89David/HammerLanguageChanger/releases"
	if exist "%temp%\HLC" rd "%temp%\HLC"
	exit
) else echo [%time%]: Using latest version. >> log.txt


call :steam_find





:install_pick-game
%mode2%
%colors_normal%

cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [█▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Welcome to the Hammer Language installation   ║
echo    ║ setup! In wich game you would like to change  ║
echo    ║ the Hammer DLL?                               ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Available Games:                              ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ A: Portal 2                                   ║
echo    ║ B: Counter Strike: Global Offensive           ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo ―――――――――――――――――――――――――――――――――――――――――――――――――――――――
echo:
echo    ┌───────────────────────────────────────────────┐
echo    │ Other:                                        │
echo    ├───────────────────────────────────────────────┤
echo    │ R: Report an Issue                            │
echo    │ H: Help                                       │
echo    │ U: Contribute                                 │
echo    │ G: GitHub                                     │
echo    └───────────────────────────────────────────────┘
choice /c abrhug /n >nul
if %errorlevel% == 1 set selected_game=p2
if %errorlevel% == 2 set selected_game=csgo

if %errorlevel% == 3 start "" "https://github.com/L89David/HammerLanguageChanger/issues/new" &&goto install_pick-game
if %errorlevel% == 4 start "" "https://github.com/L89David/HammerLanguageChanger/wiki/Installation" &&goto install_pick-game
if %errorlevel% == 5 start "" "https://github.com/L89David/HammerLanguageChanger/wiki/Contributing" &&goto install_pick-game
if %errorlevel% == 6 start "" "https://github.com/L89David/HammerLanguageChanger" &&goto install_pick-game




:install_pick-dll
%mode%

if %selected_game%==p2 (
	if exist "%steam_path%\steamapps\common\Portal 2\bin" (
		echo [%time%]: Selected game: Portal 2. >> log.txt
		set "bin_path=%steam_path%\steamapps\common\Portal 2\bin"
		set file_prefix=p2
	) else echo [%time%]: Couldn't locate bin folder. >> log.txt &exit
)
if %selected_game%==csgo (
	if exist "%steam_path%\steamapps\common\Counter-Strike Global Offensive\bin" (
		echo [%time%]: Selected game: Counter Strike: Global Offensive. >> log.txt
		set "bin_path=%steam_path%\steamapps\common\Counter-Strike Global Offensive\bin"
		set file_prefix=csgo
	) else echo [%time%]: Couldn't locate bin folder. >> log.txt &exit
)

set "state_es=   "
set "state_fr=   "
set "state_original=   "

::Check if the hlc config file is stored inside bin... This file just tells this crappy function wich language is being used rn. If not found, just set that user is using Valve's DLL.
if exist "%bin_path%\HLC\language_selected.hlc" (
	set /p current_language=<"%bin_path%\HLC\language_selected.hlc"
	echo [%time%]: Getting current config from "%bin_path%\HLC\language_selected.hlc". {current_language=%current_language%} >> log.txt
	if "%current_language%"=="spanish" set state_es=[√]
	if "%current_language%"=="french" set state_fr=[√]
	if "%current_language%"=="original" set state_original=[√]
) else (
	set state_original=[√]
	echo [%time%]: Couldn't get user config. Setting default values. >> log.txt
)


cls
%colors_normal%
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [██▒] ║
echo    ╟───────────────────────────────────────────────╢
if %selected_game%==p2 echo    ║ Game selected: Portal 2                       ║
if %selected_game%==csgo echo    ║ Game selected: Counter Strike: Global Offe... ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Available DLL's:                              ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ A: Spanish - DarviL %state_es%                       ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ B: Original - Valve %state_original%                       ║
echo    ╚═══════════════════════════════════════════════╝
choice /c abc /n >nul
if %errorlevel% == 1 set selected_dll=spanish
if %errorlevel% == 2 set selected_dll=original





::Detecting if Hammer is running using an interesting way yikes.
:install_copy
%mode%
cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [██▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Downloading and copying DLL...                ║
echo    ║ Please wait...                                ║
echo    ╚═══════════════════════════════════════════════╝

if not exist "%temp%\HLC\%file_prefix%_%selected_dll%.dll" (
	call :file_download %file_prefix%_%selected_dll%.dll
) else echo [%time%]: Found "%file_prefix%_%selected_dll%.dll". No need to redownload it. >> log.txt

tasklist |find "hammer.exe" >nul
if %errorlevel% == 0 (
	call :error_hammer-open
) else (
	::Copying the file (finally). As you can see, it also created that file in bin, wich will tell the Installer what language is being used rn.
	if not exist "%temp%\HLC\%file_prefix%_%selected_dll%.dll" echo [%time%]: Couldn't find "%temp%\HLC\%file_prefix%_%selected_dll%.dll". Restarting. >> log.txt &goto checksum
	copy "%temp%\HLC\%file_prefix%_%selected_dll%.dll" "%bin_path%\hammer_dll.dll" /y >nul &&echo [%time%]: %selected_dll% DLL has been copied succesfully as "%bin_path%\hammer_dll.dll". >> log.txt
	if not exist "%bin_path%\HLC" mkdir "%bin_path%\HLC"
	echo %selected_dll%> "%bin_path%\HLC\language_selected.hlc"
	
	goto install_end
)





:install_end
%mode%

(
	echo [%time%]: Installation finished succesfully.
	echo:
) >> log.txt

%colors_correct%
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
if %errorlevel% == 1 goto install_pick-dll
if %errorlevel% == 2 exit








::=========== FUNCTIONS ============

:file_download
if "%skip_downloads%" == "1" exit /b
echo [%time%]: Downloading "%1"... >> log.txt
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/dlls/%1?raw=true "%temp%\HLC\%1" >nul &&echo [%time%]: Downloaded "%1". >> log.txt
if not %errorlevel% == 0 echo [%time%]: Error while downloading "%1". >> log.txt
exit /b



::This function will try to find where is Steam located.
:steam_find
cls
if exist "%temp%\HLC\steam_path.hlc" set /p "steam_path="<%temp%\HLC\steam_path.hlc
if exist "%ProgramFiles(x86)%\steam\steam.exe" set "steam_path=%ProgramFiles(x86)%\Steam"
if exist "%ProgramFiles%\Steam\steam.exe" set "steam_path=%ProgramFiles%\Steam"


if not defined steam_path (
	if not defined steam_find-log_shown (
		echo [%time%]: Couldn't find the Steam path automatically. >> log.txt
		set steam_find-log_shown=1
	)
	call :error_steam-find_fail
) else (
	echo [%time%]: Steam located at: "%steam_path%" >> log.txt
	goto install_pick-game
)




:error_no-internet
cls
%colors_error%

echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [▒▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Unable to connect to GitHub.                  ║
echo    ║ Please, check your internet conection, or     ║
echo    ║ check the GitHub server status.               ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ A: Check GitHub status.                       ║
echo    ║ B: Retry to connect.                          ║
echo    ║ C: Exit.                                      ║
echo    ╚═══════════════════════════════════════════════╝
choice /c abc /n >nul
if %errorlevel% == 1 start "" "https://www.githubstatus.com/"
if %errorlevel% == 2 goto checksum
if %errorlevel% == 3 exit
goto error_no-internet




:error_hammer-open
echo [%time%]: Detected hammer running. >> log.txt
%mode%
%colors_error%

cls
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
if %errorlevel% == 1 (
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
	%colors_normal%
	goto install_copy
)





:error_steam-find_fail
cls
%mode%
%colors_error%

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
if not defined steam_path (
	echo [%time%]: -INPUT- Not defined. >> log.txt
	set steam_path=
	goto steam_find
)

echo %steam_path% > "%temp%\HLC\path.tmp"
findstr "\"" %temp%\HLC\path.tmp

if %errorlevel%==0 (
	echo [%time%]: -INPUT- Added quotation marks. >> log.txt
	set steam_path=
	goto steam_find
)

if not exist "%steam_path%\steam.exe" (
	echo [%time%]: Couldn't find "steam.exe" in "%steam_path%". >> log.txt
	set steam_path=
	goto steam_find
)

echo %steam_path%> "%temp%\HLC\steam_path.hlc"
goto steam_find