@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title 🔥 CREATE FILE AND FOLDERS 🔥

:: Draw starting banner
call :drawBox "🔥 CREATE FILE AND FOLDERS 🔥"

:: Define names
set "names=jack john lily emma alex chris nina lucas oliver sophia liam mia noah ava ethan isabella mason charlotte logan amelia james harper benjamin evelyn elijah abigail william ella daniel scarlett michael aria jackson grace sebastian chloe aiden zoey matthew riley joseph leah david samuel hannah carter zoe owen nora"
set i=0

:: Split names into array
for %%n in (%names%) do (
    set /a i+=1
    set "name[!i!]=%%n"
)
set "nameCount=%i%"

:: Prompt for path
set /p "path=ENTER THE PATH WHERE YOU WANT TO CREATE: "
if not exist "%path%" (
    call :drawBox "❌ ERROR: THE SPECIFIED PATH DOES NOT EXIST ❌"
    pause
    exit /b
)

:: Prompt for limits
set /p "folderLimit=ENTER NUMBER OF FOLDERS TO CREATE: "
set /p "fileLimit=ENTER NUMBER OF FILES PER FOLDER: "

:: Create output file to store created paths
set "pathFile=%path%\path.txt"
del "%pathFile%" >nul 2>&1

:: Generate folders and files
for /l %%f in (1,1,%folderLimit%) do (
    set /a r=!random! %% nameCount + 1
    call set "prefix=%%name[!r!]%%"

    set "foldername=!prefix!-!random!"
    set "folder_path=%path%\!foldername!"
    mkdir "!folder_path!" >nul 2>&1

    if exist "!folder_path!" (
        echo !folder_path!>>"%pathFile%"

        for /l %%i in (1,1,%fileLimit%) do (
            set "filename=!prefix!-!random!.txt"
            set "file_path=!folder_path!\!filename!"
            echo !file_path!>>"!file_path!"
            echo !file_path!>>"%pathFile%"
        )
    )
)

echo.
echo ✅ All folders and files have been created.
echo 📁 Paths saved to: "%pathFile%"
:: ===== Done =====
echo.
echo.
echo.
echo ✅ All cleaning tasks are completed.
echo.
echo.
echo.

:: ===== Final popup =====
powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show(' System cleaned successfully!','Cleanup Complete','OK','Information')"

:: Wait 1 second then auto-exit
timeout /t 1 >nul
exit


:: --- FUNCTION: Draw Centered Message Box ---
:drawBox
setlocal EnableDelayedExpansion
set "msg=%~1"
for /f "tokens=2 delims=:" %%a in ('mode con ^| findstr "Columns"') do set /a cols=%%a
call :strlen msg msgLen
set /a pad=(cols - msgLen - 6) / 2
set "spc="
for /L %%i in (1,1,!pad!) do set "spc=!spc! "
set /a boxWidth=msgLen + 6
set "lineTop=╔"
set "lineMid=║"
set "lineBot=╚"
for /L %%i in (1,1,!boxWidth!) do (
    set "lineTop=!lineTop!═"
    set "lineMid=!lineMid! "
    set "lineBot=!lineBot!═"
)
set "lineTop=!lineTop!╗"
set "lineBot=!lineBot!╝"
set "lineMid=!lineMid!║"
echo(
echo !spc!!lineTop!
echo !spc!║  !msg!  ║
echo !spc!!lineBot!
endlocal
goto :eof

:: --- FUNCTION: String Length ---
:strlen
setlocal EnableDelayedExpansion
set "s=!%1!"
set /a len=0
:loop
if defined s (
    set "s=!s:~1!"
    set /a len+=1
    goto loop
)
endlocal & set "%2=%len%"
goto :eof
