::Written by David Losantos (DarviL)

@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
echo Please, wait...


:checksum
if "%log_msg%" == "1" (
	echo:
	echo:
	echo:
) >> log.txt

if not defined log_msg (
	echo Hammer Language Changer Installer LOG
	echo Created by DarviL.
	echo [%date%] - [%time%]
	echo ─────────────────────────────────────────────────
	echo:
) > log.txt




::Check vars
set ver=1.5
set ver_number=10

if not defined log_msg echo [Version: "%ver%"] [Build: "%ver_number%"] >> log.txt
set log_msg=1

mode con cols=55 lines=8
set mode_lines=8

set colors_normal=color f1
set colors_error=color fc
set colors_info=color f6
set colors_correct=color f2

title Hammer Language Changer Installer - V%ver%



::Check parameters
set parm1=%1
set parm2=%2

if "%parm1%"=="help" (
	echo Available parameters: force_update, skip_downloads, download, ignore_hammer.
	exit /b
)
if "%parm1%"=="force_update" (
	echo [%time%]: Forcing the program to update... >> log.txt
	set ver_number=0
)
if "%parm1%"=="skip_downloads" (
	echo [%time%]: Skipping all the possible downloads. >> log.txt
	set skip_downloads=1
)
if "%parm1%"=="download" (
	if not defined parm2 exit /b
	echo Downloading "%parm2%" to "!cd!"...
	call :file_download %parm2%
	if exist "!temp!\HLC\%parm2%" (
		copy "!temp!\HLC\%parm2%" "!cd!" >nul
		call :show_msg "Downloaded '%parm2%' to '!cd!'." 64
	) else (
		call :show_msg "Couldn't download '%parm2%'." 16
	)
	exit /b
)
if "%parm1%"=="ignore_hammer" (
	echo [%time%]: Ignoring Hammer state when copying files... >> log.txt
	set ignore_hammer=1
)
if "%parm1%"=="no_transitions" (
	echo [%time%]: Canceling all mode change transitions... >> log.txt
	set mode_cancel_transtitions=1
)



::Check files
if not exist "!temp!\HLC" (
	mkdir "!temp!\HLC"
) else (
	rd "!temp!\HLC" /s /q
	mkdir "!temp!\HLC"
)

if "%skip_downloads%" == "1" goto steam_find



::Check if user is connected to internet
%colors_normal%
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
echo [%time%]: Checking for updates... >> log.txt

::Download the git ver file, wich contents the latest version number. Then compare it with the current version.
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/info/version.hlc?raw=true "!temp!\HLC\version.hlc" >nul
set /p ver_git_number=<"!temp!\HLC\version.hlc"
del "!temp!\HLC\version.hlc" /f
if %ver_number% LSS %ver_git_number% (
	echo [%time%]: A newer version has been found ^(GitHub: "!ver_git_number!"^). >> log.txt
	%colors_info%
	call :mode_change 11
	
	cls
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer      ^^![▒▒▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ There is a newer version available.           ║
	echo    ║ Press any key to open the releases page       ║
	echo    ║ to download the latest update.                ║
	echo    ╚═══════════════════════════════════════════════╝
	echo     Current Build Nº: %ver_number%
	echo     New Build Nº: %ver_git_number%
	pause>nul
	start "" "https://github.com/L89David/HammerLanguageChanger/releases"
	if exist "!temp!\HLC" rd "!temp!\HLC"
	exit
) else echo [%time%]: Using latest version (GitHub: "!ver_git_number!"). >> log.txt


call :steam_find





:install_pick-game
call :mode_change 27
%colors_normal%

cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [█▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Welcome to the Hammer Language installation   ║
echo    ║ setup^^! In wich game you would like to change  ║
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
if %selected_game%==p2 (
	if exist "!steam_path!\steamapps\common\Portal 2\bin" (
		echo [%time%]: Selected game: Portal 2. >> log.txt
		set "bin_path=!steam_path!\steamapps\common\Portal 2\bin"
		set file_prefix=p2
	) else (
		call :show_msg "Couldn't locate the 'bin' folder inside '!steam_path!\steamapps\common\Portal 2'." 16
		echo [%time%]: Couldn't locate bin folder in '!steam_path!\steamapps\common\Portal 2'. >> log.txt &exit
	)
)
if %selected_game%==csgo (
	if exist "!steam_path!\steamapps\common\Counter-Strike Global Offensive\bin" (
		echo [%time%]: Selected game: Counter Strike: Global Offensive. >> log.txt
		set "bin_path=!steam_path!\steamapps\common\Counter-Strike Global Offensive\bin"
		set file_prefix=csgo
	) else (
		call :show_msg "Couldn't locate the 'bin' folder inside '!steam_path!\steamapps\common\Counter-Strike Global Offensive'." 16
		echo "[%time%]: Couldn't locate bin folder in '!steam_path!\steamapps\common\Counter-Strike Global Offensive'." >> log.txt &exit
	)
)

set "state_es=   "
set "state_fr=   "
set "state_original=   "

::Check if the hlc config file is stored inside bin... This file just tells this wich language is being used rn. If not found, just set that user is using Valve's DLL.
if exist "!bin_path!\HLC\language_selected.hlc" (
	set /p current_language=<"!bin_path!\HLC\language_selected.hlc"
	echo [%time%]: Getting current config from '!bin_path!\HLC\language_selected.hlc' {current_language=!current_language!} >> log.txt
	if "!current_language!"=="spanish" set state_es=[√]
	if "!current_language!"=="french" set state_fr=[√]
	if "!current_language!"=="original" set state_original=[√]
) else (
	set state_original=[√]
	echo [%time%]: Couldn't get user config. Setting default values. >> log.txt
)


cls
%colors_normal%
call :mode_change 15
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




:install_copy
call :mode_change 8
cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer       [██▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Downloading and copying DLL...                ║
echo    ║ Please wait...                                ║
echo    ╚═══════════════════════════════════════════════╝

if not exist "!temp!\HLC\%file_prefix%_%selected_dll%.dll" (
	call :file_download %file_prefix%_%selected_dll%.dll
) else echo [%time%]: Found "%file_prefix%_%selected_dll%.dll". No need to redownload it. >> log.txt

::Trying to catch hammer open. If it's open, warn the user before closing it. If not, continue.
tasklist |find "hammer.exe" >nul
if %errorlevel% == 0 (
	if not defined ignore_hammer call :error_hammer-open
)

::Copying the file. As you can see, it also created that file in bin, wich will tell the Installer what language is being used rn.
if not exist "!temp!\HLC\%file_prefix%_%selected_dll%.dll" echo [%time%]: Couldn't find "!temp!\HLC\%file_prefix%_%selected_dll%.dll". Restarting. >> log.txt &goto checksum
copy "!temp!\HLC\%file_prefix%_%selected_dll%.dll" "!bin_path!\hammer_dll.dll" /y >nul &&echo [%time%]: %selected_dll% DLL has been copied succesfully as "!bin_path!\hammer_dll.dll". >> log.txt
if not exist "!bin_path!\HLC" mkdir "!bin_path!\HLC"
echo %selected_dll%> "!bin_path!\HLC\language_selected.hlc"
if "%hammer_closed%" == "1" (
	echo [%time%]: Starting Hammer... >> log.txt
	start "" "!bin_path!\hammer.exe" -nop4
	set hammer_closed=0
)

goto install_end





:install_end
call :mode_change 10

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
echo    ║ The DLL has been installed correctly^^!         ║
echo    ║                                               ║
echo    ║ A: Get back to the language selection menu.   ║
echo    ║ B: Exit the program.                          ║
echo    ╚═══════════════════════════════════════════════╝
choice /c ab /n >nul
if %errorlevel% == 1 goto install_pick-dll
if %errorlevel% == 2 exit








::=========== FUNCTIONS ============

::Downloads a file specified from the DLLS folder inside the HLC repo.
:file_download
if "%skip_downloads%" == "1" exit /b
echo [%time%]: Downloading "%1"... >> log.txt
bitsadmin /transfer /download https://github.com/L89David/HammerLanguageChanger/blob/master/dlls/%1?raw=true "!temp!\HLC\%1" >nul &&echo [%time%]: Downloaded "%1". >> log.txt
if not %errorlevel% == 0 echo [%time%]: Error while downloading "%1". >> log.txt
exit /b




::This function will try to find where is Steam located. First, try to get saved config from 'steam_path.hlc', this will speed up the process without
::needing to do a 'heavy' search on every launch. If not found, try to find the Steam folder by reading the registry key that Steam made. If the path
::was finally found, write it inside 'steam_path.hlc', and if not, ask the user where is it.
:steam_find
cls
if exist "!cd!\steam_path.hlc" (
	set /p "steam_path="<!cd!\steam_path.hlc
	echo [%time%]: ^(steam_find^) Steam located at: "!steam_path!" ^(Got from: '!cd!/steam_path.hlc'^) >> log.txt
	goto install_pick-game
)

reg query HKCU\Software\Valve\Steam /v SteamPath > "!temp!\HLC\path.tmp"
if "%errorlevel%"=="0" for /f "usebackq tokens=1,2* skip=2" %%G in ("!temp!\HLC\path.tmp") do set "steam_path=%%I"

if not defined steam_path (
	if not defined steam_find-log_shown (
		echo [%time%]: ^(steam_find^) Couldn't find the Steam path automatically. >> log.txt
		set steam_find-log_shown=1
	)
	goto error_steam-find_fail
) else (
	if not exist "!steam_path!/steam.exe" (
		if not defined steam_find-log_shown (
			echo [%time%]: ^(steam_find^) Couldn't find "Steam.exe" in "!steam_path!". >> log.txt
			set steam_find-log_shown=1
		)
		goto error_steam-find_fail
	) else (
		echo !steam_path!>"!cd!\steam_path.hlc"
		call :show_msg "Your Steam path has been found automatically in '!steam_path!'. This config has been saved in '!cd!\steam_path.hlc'." 64
		echo [%time%]: ^(steam_find^) Steam located at: "!steam_path!" >> log.txt
		goto install_pick-game
	)
)




:error_no-internet
cls
%colors_error%
call :mode_change 15

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
call :mode_change 14
%colors_error%

cls
echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer      ^^![██▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Hammer is currently running^^! It has to be     ║
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
	set hammer_closed=1
	call :mode_change 7
	cls
	echo:
	echo    ╔═══════════════════════════════════════════════╗
	echo    ║ Hammer Language Changer Installer       [██▒] ║
	echo    ╟───────────────────────────────────────────────╢
	echo    ║ Please, wait...                               ║
	echo    ╚═══════════════════════════════════════════════╝

	echo [%time%]: Trying to close Hammer >> "log.txt"
	taskkill /im hammer.exe /f >nul 2>&1
	timeout 1 /nobreak >nul
	%colors_normal%
	goto install_copy
)




::If Steam path auto search failed, this will ask the user where is steam located. After checking by itself that the path is correct, save it in 'steam_path.hlc'.
:error_steam-find_fail
cls
call :mode_change 20
%colors_error%

echo:
echo    ╔═══════════════════════════════════════════════╗
echo    ║ Hammer Language Changer Installer      ^^![█▒▒] ║
echo    ╟───────────────────────────────────────────────╢
echo    ║ Unable to find the Steam path.                ║
echo    ║ Please, drag the Steam folder to this program ║
echo    ║ and press ENTER in order to continue          ║
echo    ║ with the installation.                        ║
echo    ║                                               ║
echo    ║ Make sure you remove the quotation marks^^!     ║
echo    ╚═══════════════════════════════════════════════╝
echo:
echo ───────────────────────────────────────────────────────

set /p steam_path=
if not defined steam_path (
	call :show_msg "Please input a valid path." 16
	echo [%time%]: -INPUT- Not defined. >> log.txt
	set steam_path=
	goto steam_find
)

echo !steam_path! > "!temp!\HLC\input.tmp"
findstr "\"" !temp!\HLC\input.tmp

if %errorlevel%==0 (
	call :show_msg "Please, don't input quotation marks." 16
	echo [%time%]: -INPUT- Added quotation marks. >> log.txt
	set steam_path=
	goto steam_find
)

if not exist "!steam_path!\steam.exe" (
	call :show_msg "Couldn't find 'steam.exe' in '!steam_path!'." 16
	echo [%time%]: Couldn't find "steam.exe" in "!steam_path!". >> log.txt
	set steam_path=
	goto steam_find
)

echo !steam_path!> "!cd!\steam_path.hlc"
call :show_msg "Your Steam path has been set correctly as '!steam_path!'. This config has been saved in '!cd!\steam_path.hlc'." 64
goto steam_find




::Function to display simple Visual Basic Script dialog boxes.
:show_msg
::call :show_msg "msg" buttons
echo msgbox1=MsgBox(%1, %2, "HLCInstaller") > "!temp!\HLC\msg.vbs"
start "" "!temp!\HLC\msg.vbs"
exit /b




::Function to resize the window dynamically.
:mode_change
set /a mode_change_parm1=%1
if "%mode_cancel_transtitions%"=="1" (
	mode con lines=%mode_change_parm1%
	exit /b
)

if !mode_change_parm1! LSS !mode_lines! (
    for /l %%G in (!mode_lines!,-1,!mode_change_parm1!) do (
       mode con lines=%%G
    )
) else (
    for /l %%G in (!mode_lines!,1,!mode_change_parm1!) do (
       mode con lines=%%G
    )
)
set mode_lines=%mode_change_parm1%
exit /b