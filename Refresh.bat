@echo off
chcp 65001 >nul
:: ==== CHECK OR REQUEST ADMINISTRATOR PRIVILEGES ====
>nul 2>&1 net session
if %errorlevel% neq 0 (
    call :drawBox "🔥 REQUESTING ADMIN PRIVILEGES 🔥"
    powershell -Command "Start-Process 'wt.exe' -ArgumentList 'new-tab cmd.exe /c \"\"\"%~f0\"\"\"' -Verb RunAs"
    exit /b
)

:: ===== Set console color and title =====
title ⚡ ULTRA REFRESH - WIN11 OPTIMIZER ⚡

call :drawBox "🚀 ULTRA REFRESH STARTED 🚀"

:: ===== STEP 1: CLEAR TEMP FILES ===== 
call :drawBox "🧹 CLEARING TEMP FILES..."
del /q /f /s "%TEMP%\*"
del /q /f /s "C:\Windows\Temp\*"
echo ✅ TEMP FILES CLEARED.
echo.

:: ===== STEP 2: CLEAR PREFETCH ===== 
call :drawBox "🧹 CLEARING PREFETCH..."
del /q /f /s C:\Windows\Prefetch\*
echo ✅ PREFETCH CLEARED.
echo.

:: ===== STEP 3: DNS FLUSH ===== 
call :drawBox "🌐 FLUSHING DNS..."
ipconfig /flushdns
ipconfig /registerdns
echo ✅ DNS FLUSHED.
echo.

:: ===== STEP 4: RESTART EXPLORER ===== 
call :drawBox "🔄 RESTARTING EXPLORER..."
taskkill /f /im explorer.exe
start explorer.exe
echo ✅ EXPLORER RESTARTED.
echo.

:: ===== STEP 5: CLEAR CLIPBOARD ===== 
call :drawBox "📋 CLEARING CLIPBOARD..."
echo off | clip
echo ✅ CLIPBOARD CLEARED.
echo.

:: ===== STEP 6: MEMORY OPTIMIZATION ===== 
call :drawBox "🧠 OPTIMIZING MEMORY..."
set standbyTool="C:\Windows\System32\RefreshByAriyanShipu.exe"
if exist %standbyTool% (
    %standbyTool% modifiedpagelist
    %standbyTool% standbylist
    %standbyTool% priority0standbylist
    %standbyTool% workingsets
    echo ✅ MEMORY LISTS CLEANUP SUCCESSFULLY.
) else (
    echo ⚠️ RefreshByAriyanShipu.exe Not Found.
)


echo.

:: ===== STEP 7: DISK CLEANUP ===== 
call :drawBox "🧼 DISK CLEANUP..."
cleanmgr /sagerun:1
echo ✅ DISK CLEANUP TRIGGERED.
echo.

:: ===== DONE =====
echo.
echo.
call :drawBox "🎉 SYSTEM OPTIMIZED SUCCESSFULLY 🎉"
echo.
echo.

:: ===== FINAL POPUP =====
powershell -Command "Add-Type -AssemblyName PresentationFramework;[System.Windows.MessageBox]::Show('🎉 Refresh And Optimized Successfully! 🎉','All Done!','OK','Information')"

:: ===== WAIT BEFORE EXITING =====
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
