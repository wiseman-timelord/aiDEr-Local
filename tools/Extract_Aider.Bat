@echo off
setlocal EnableDelayedExpansion

:: ADMIN AND DP0, BLOCK, DO NOT MODIFY: START...
net session >nul 2>&1 || (
    echo Error: Admin privileges required. Right-click and select "Run as administrator".
    exit /b 1
)
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"
:: ...ADMIN AND DP0, BLOCK, DO NOT MODIFY: END.

:: Global Variables
set "sevenzip=C:\Program Files\7-Zip\7z.exe"

REM Check if 7z.exe exists
if not exist "%sevenzip%" (
    echo Error: 7z.exe not found at "%sevenzip%"!
    echo Ensure 7-Zip is installed correctly.
    timeout /t 3 >nul
    exit /b 1
)

:refresh
cls
set "zipfound=false"
set "index=0"
echo ------------------------------------------------------------------------------------------------------------------------
echo                                                 Aider Extractor
echo ------------------------------------------------------------------------------------------------------------------------
echo.

REM Search and Present aider-*.zip files.
for %%F in (aider-*.zip) do (
    set /a index+=1
    set "file!index!=%%F"
    echo !index!. %%F
    set "zipfound=true"
)

if "!zipfound!" == "false" (
    echo No aider-*.zip files found in "%Script_Directory%".
    echo.
    echo Press R to refresh, or X to exit.
) else (
    echo.
    set "choice="
    set /p "choice=Selection; Menu Options = 1-#, Refresh Files = R, Exit Program = X: "
)

REM Handle user's choice
if /i "!choice!"=="R" goto refresh
if /i "!choice!"=="X" goto end

for /l %%I in (1,1,!index!) do (
    if "!choice!"=="%%I" set "selectedfile=!file%%I!"
)

if not defined selectedfile (
    echo Invalid selection. Please try again.
    timeout /t 2 >nul
    goto refresh
)

REM Extract the selected ZIP file
echo Extracting "!selectedfile!" to "%Script_Directory%"...
"%sevenzip%" x "!selectedfile!" -o"%Script_Directory%" -y

if %errorlevel% neq 0 (
    echo Error: Extraction of "!selectedfile!" failed.
    timeout /t 3 >nul
    exit /b 1
) else (
    echo Extraction Finished: !selectedfile!
)

pause
goto refresh

:end
REM Return to the original directory
popd
endlocal
exit /b
