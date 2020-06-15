::Written by David Losantos (DarviL)

@echo off
chcp 65001 >nul
echo Please, wait...


:checksum
(
	echo Hammer Language Changer Installer LOG
	echo Created by DarviL.
	echo [%date%] - [%time%]
	echo ─────────────────────────────────────────────────
	echo:
) > log.txt


::Check vars
set ver=1.0
set ver_number=3
echo [Version: "%ver%"] [Compilation: "%ver_number%"] >> log.txt

set "mode=mode con cols=55 lines=20"

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
if "%1"=="del_data" (
	if exist "data" (
		rd "data" /s /q
		echo [%time%]: Removed data folder succesfully. >> log.txt
	) else echo [%time%]: "data" folder does not exist. Unable to delete the files. >> log.txt
)
if "%1"=="skip_downloads" (
	set skip_downloads=1
	echo [%time%]: Skipping all the possible downloads. >> log.txt
)


::Check files
if not exist "data" mkdir "data"
if not exist "%temp%\HLC" mkdir "%temp%\HLC"
if not exist "data/p2_spanish.dll" set download_required=1
if not exist "data/p2_original.dll" set download_required=1
if not exist "data/p2_french.dll" set download_required=1

if exist "updater.bat" (
	del "updater.bat" /f /q
	echo [%time%]: Program updated succesfully! >> log.txt
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
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/info/version.hlc?raw=true "%cd%\data\version.hlc" >nul
set /p ver_git_number=<"%cd%\data\version.hlc"
del "data\version.hlc" /f
if "%ver_number%" LSS "%ver_git_number%" (
	echo [%time%]: A newer version has been found [%ver_git_number%] >> log.txt
	%colors_info%
	
	cls
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer      ![▒▒▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ There is a newer version available.           ║
	echo    ║ Press any key to install the new version      ║
	echo    ║ automatically.                                ║
	echo    ╚═══════════════════════════════════════════════╝
	echo     Current Compilation Nº: %ver_number%
	echo     New Compilation Nº: %ver_git_number%
	pause >nul
	
	cls
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer      ![▒▒▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ Initializing update process...                ║
	echo    ║ Please, wait...                               ║
	echo    ╚═══════════════════════════════════════════════╝
	bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/info/updater.bat?raw=true "%cd%\updater.bat" >nul
	start "" updater.bat "%cd%"
	exit
) else echo [%time%]: Using latest version. >> log.txt


::If any of the required files is missing, redownload all of them.
if "%download_required%"=="1" (
	echo [%time%]: Asset files are missing. Starting download process... >> log.txt
	cls
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer       [▒▒▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ Couldn't find asset file/s.                   ║
	echo    ║ Downloading required files... Please, wait... ║
	echo    ╚═══════════════════════════════════════════════╝
	echo     - Information:
	echo:
	
	call :db_download
	
	echo ───────────────────────────────────────────────────────
	echo        Download process finished. Initializing...
	echo [%time%]: Download process finished. >> log.txt
	timeout 3 /nobreak >nul
)

call :steam_find





:install_pick-game
%mode%

echo [%time%]: Steam located at: "%steam_path%" >> log.txt
%colors_normal%

cls
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
if %errorlevel% == 1 set selected_game=p2




:install_pick-dll
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
%colors_normal%
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
echo    ║ B: French - Orinji Neko %state_fr%                   ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ C: Original - Valve %state_original%                       ║
echo    ╚═══════════════════════════════════════════════╝
choice /c abc /n >nul
if %errorlevel% == 1 set selected_dll=spanish
if %errorlevel% == 2 set selected_dll=french
if %errorlevel% == 3 set selected_dll=original





::Detecting if Hammer is running using an interesting way yikes.
:install_copy
%mode%

cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [██▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Please, wait...                               ║
echo    ╚═══════════════════════════════════════════════╝

tasklist |find "hammer.exe" >nul
if %errorlevel% == 0 (
	call :error_hammer-open
) else (
	::And there we go, the final step. Here we are copying the file (finally). As you can see, it also created that file in bin, wich will tell the Installer what language is being used rn.

	if not exist "data\%file_prefix%_%selected_dll%.dll" echo [%time%]: Couldn't find "data\%file_prefix%_%selected_dll%.dll". >> log.txt &goto checksum
	copy "data\%file_prefix%_%selected_dll%.dll" "%bin_path%\hammer_dll.dll" /y >nul &&echo [%time%]: %selected_dll% DLL has been copied succesfully as "%bin_path%\hammer_dll.dll". >> log.txt
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

:db_download
set /a total_files=4
set /a current_file=1

call :file_download p2_spanish.dll
call :file_download p2_french.dll
call :file_download p2_original.dll
call :file_download info.txt

exit /b


:file_download
echo        [%current_file%/%total_files%] Downloading "%1"...
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/dlls/%1?raw=true "%cd%\data\%1" >nul &&echo [%time%]: Downloaded "%1". >> log.txt
set /a current_file=%current_file%+1
exit /b






::This function will try to find where is Steam located.
:steam_find
cls
if exist "data/steam_path.hlc" set /p "steam_path="<data/steam_path.hlc
if exist "%ProgramFiles(x86)%\steam\steam.exe" set "steam_path=%ProgramFiles(x86)%\Steam"
if exist "%ProgramFiles%\Steam\steam.exe" set "steam_path=%ProgramFiles%\Steam"

if not defined steam_path (
	if not defined steam_find-log_shown (
		echo [%time%]: Couldn't find the Steam path automatically. >> log.txt
		set steam_find-log_shown=1
	)
	call :error_steam-find_fail
) else goto install_pick-game





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
	goto install_copy
)





:error_steam-find_fail
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
findstr """ "%temp%\HLC\path.tmp"
cls
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

echo %steam_path%> "data\steam_path.hlc"
goto steam_find