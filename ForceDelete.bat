@echo off
chcp 65001 >nul

:: ==== CHECK OR REQUEST ADMINISTRATOR PRIVILEGES ====
>nul 2>&1 net session
if %errorlevel% neq 0 (
    call :drawBox "🔥 REQUESTING ADMIN PRIVILEGES 🔥"
    powershell -Command "Start-Process 'wt.exe' -ArgumentList 'new-tab cmd.exe /c \"\"\"%~f0\"\"\"' -Verb RunAs"
    exit /b
)

title ⚡ FORCE DELETE FILE OR FOLDERS ⚡

:RETRY_INPUT
cls
call :drawBox "🔥 FORCE DELETE FILE OR FOLDER 🔥"
set /p target=" ENTER PATH TO FILE OR FOLDER: "
set "target=%target:"=%"
if not exist "%target%" (
    call :drawBox "⚠️  ERROR: PATH NOT FOUND. TRY AGAIN."
    timeout /t 2 >nul
    goto RETRY_INPUT
)

:: DETERMINE IF TARGET IS A DIRECTORY OR FILE
if exist "%target%\" (
    echo.
    call :drawBox "📁 FOLDER DETECTED — TAKING OWNERSHIP 📁"
    takeown /f "%target%" /r /d y >nul

    echo.
    call :drawBox "🔐 SETTING OWNER TO ADMINISTRATORS 🔐"
    icacls "%target%" /setowner "Administrators" /t /c /l /q >nul

    echo.
    call :drawBox "🔐 GRANTING PERMISSION TO ADMINISTRATORS 🔐"
    icacls "%target%" /grant Administrators:F /t /c /q >nul

    call :drawBox "📁  DELETING FOLDER... 📁"
    rmdir /s /q "%target%"
) else (
    echo.
    call :drawBox "📄 FILE DETECTED — TAKING OWNERSHIP... 📄"
    takeown /f "%target%" >nul
    call :drawBox " 🔐 GRANTING PERMISSION TO: %username% 🔐"
    icacls "%target%" /grant "%username%":F >nul
    echo.
    call :drawBox "📄 DELETING FILE... 📄"
    del /f /q "%target%"
)


:: ===== DONE =====
echo.
echo.
echo.
call :drawBox "🎯 DELETE COMPLETE 🎯"
echo.
echo.
echo.

:: FINAL CONFIRMATION POPUP
powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('🎉 Delete file or Folder successfully!!','All Done!','OK','Information')"
:: WAIT BEFORE EXITING
timeout /t 1 >nul
exit /b

:: ===== DRAW A CENTERED BOX =====
:drawBox
setlocal EnableDelayedExpansion
set "msg=%~1"
for /f "tokens=2 delims=:" %%a in ('mode con ^| findstr "Columns"') do set /a "cols=%%a"
call :strlen msg msgLen
set /a pad=(cols - msgLen - 4) / 2
set "spc="
for /L %%i in (1,1,!pad!) do set "spc=!spc! "
set /a boxWidth=msgLen + 4
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

:: ===== STRING LENGTH CALC =====
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

:: ===== CENTER TEXT IN CONSOLE =====
:centerText
setlocal EnableDelayedExpansion
set "text=%~1"
for /f "tokens=2 delims=:" %%a in ('mode con ^| findstr "Columns"') do set /a "cols=%%a"
call :strlen text textLen
set /a pad=(cols - textLen) / 2
set "spaces="
for /L %%i in (1,1,!pad!) do set "spaces=!spaces! "
echo !spaces!!text!
endlocal
goto :eof
