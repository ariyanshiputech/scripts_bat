@echo off
chcp 65001 >nul
:: ==== CHECK OR REQUEST ADMINISTRATOR PRIVILEGES ====
>nul 2>&1 net session
if %errorlevel% neq 0 (
    call :drawBox "🔥 REQUESTING ADMINISTRATIVE PRIVILEGES 🔥"
    powershell -Command "Start-Process 'wt.exe' -ArgumentList 'new-tab cmd.exe /c \"\"\"%~f0\"\"\"' -Verb RunAs"
    exit /b
)

:: ===== SET CONSOLE TITLE =====
title CLEAN TEMP FILES BY ARIYAN SHIPU

:: ===== CLEAN WINDOWS TEMP =====
echo.
call :drawBox "🔄 CLEANING C:\Windows\Temp ..."
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%x in ("C:\Windows\Temp\*") do (
    echo ✅ DELETING FOLDER: %%x
    rd /s /q "%%x" >nul 2>&1
)
call :drawBox "✅ CREATE TEMP FOLDER IN C:\Windows"
md "C:\Windows\Temp" 2>nul

:: ===== CLEAN ALL APPDATA LOCAL TEMP FOLDERS FROM USER PROFILES =====
echo.
call :drawBox "🔄 CLEANING AppData\Local\Temp folders from all users..."
for /d %%u in ("C:\Users\*") do (
    if exist "%%u\AppData\Local\Temp" (
        echo ✅ CLEANING: %%u\AppData\Local\Temp
        del /s /f /q "%%u\AppData\Local\Temp\*.*" >nul 2>&1
        for /d %%x in ("%%u\AppData\Local\Temp\*") do (
            rd /s /q "%%x" >nul 2>&1
        )
    )
)


:: ===== CLEAN PREFETCH =====
echo.
call :drawBox "🔄 CLEANING C:\Windows\Prefetch ..."
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

:: ===== CLEAN SYSTEMTEMP =====
echo.
call :drawBox "🔄 CLEANING C:\Windows\SystemTemp ..."
del /s /f /q "C:\Windows\SystemTemp\*.*" >nul 2>&1

:: ===== CLEAN ADMINISTRATOR APPDATA LOCAL TEMP =====
echo.
call :drawBox "🔄 CLEANING C:\Users\Administrator\AppData\Local\Temp ..."
del /s /f /q "C:\Users\Administrator\AppData\Local\Temp\*.*" >nul 2>&1

:: ===== CLEAN USER TEMP (%TEMP%) =====
echo.
call :drawBox "🔄 CLEANING USER TEMP (%TEMP%) ..."
del /s /f /q "%TEMP%\*.*" >nul 2>&1
for /d %%x in ("%TEMP%\*") do (
    echo ✅ DELETING FOLDER: %%x
    rd /s /q "%%x" >nul 2>&1
)

:: ===== CLEAN APPDATA LOCAL TEMP =====
echo.
call :drawBox "🔄 Cleaning AppData\Local\Temp for user: %USERNAME% ..."
del /s /f /q "%USERPROFILE%\AppData\Local\Temp\*.*" >nul 2>&1
for /d %%x in ("%USERPROFILE%\AppData\Local\Temp\*") do (
    echo ✅ DELETING FOLDER: %%x
    rd /s /q "%%x" >nul 2>&1
)

:: ===== CLEAN OTHER SYSTEM JUNK FOLDERS =====
echo.
call :drawBox "🔄 CLEANING SYSTEM JUNK FOLDERS ..."
for %%D in (
    "C:\Windows\Tmp"
    "C:\Windows\Temporary Internet Files"
    "C:\Windows\History"
    "C:\Windows\Cookies"
    "C:\Windows\Recent"
    "C:\Windows\Spool\Printers"
) do (
    echo ✅ REMOVING FOLDER: %%D
    rd /s /q %%D >nul 2>&1
)

:: ===== DELETE OLD WINDOWS SWAP FILE (IF EXISTS) =====
echo.
call :drawBox "🔄 DELETING SWAP FILE IF EXISTS ..."
del /f /q "C:\WIN386.SWP" >nul 2>&1

:: ===== CLEAR EVENT LOGS =====
echo.
call :drawBox "🔄 Clearing Windows Event Logs ..."
for /F "tokens=*" %%G in ('wevtutil.exe el') DO (
    echo CLEARING LOG: %%G
    wevtutil.exe cl "%%G" >nul 2>&1
)

:: ===== DONE =====
echo.
echo.
echo.
call :drawBox "✅ ALL CLEANING TASKS ARE COMPLETED."
echo.
echo.
echo.

:: ===== FINAL POPUP OF EXIT CONFIRMITION =====
powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show(' System cleaned successfully!','Cleanup Complete','OK','Information')"

:: WAIT 1 SECOND THEN AUTO-EXIT
timeout /t 1 >nul
exit

:: --- DRAW A CENTERED BOX WITH MESSAGE ---
:drawBox
setlocal EnableDelayedExpansion
set "msg=%~1"
for /f "tokens=2 delims=:" %%a in ('mode con ^| findstr "Columns"') do set /a "cols=%%a"
call :strlen msg msgLen
set /a pad=(cols - msgLen - 2) / 2
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

:: --- CALCULATE STRING LENGTH ---
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


:: --- CENTER TEXT IN CONSOLE ---
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





