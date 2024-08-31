@echo off
setlocal EnableDelayedExpansion

:: Global Variables
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "PYTHON_FOLDER_TO_USE="

:: Change to the script's directory
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Error: Admin Required!
    echo Right Click, then Run As Administrator.
    timeout /t 3 >nul
    goto :end_of_file
)
echo Admin Status: Administrator 

:: Check Folder
echo Working Folder: %Script_Directory%
timeout /t 1 >nul

:: Display Is Reset
cls
echo ========================================================================================================================
echo                                                      Setup-Installer
echo ------------------------------------------------------------------------------------------------------------------------
echo.

:: Find Python 3.12 and pip based on config folder location

for %%I in (
    "C:\Python312\python.exe"
    "C:\Program Files\Python312\"
    "%LocalAppData%\Programs\Python\Python312\"
) do (
    if exist "%%~I" (
        set "PYTHON_FOLDER_TO_USE=%%~I"
        set "PYTHON_EXE_TO_USE=%%~dpI\python.exe"
        set "PIP_EXE_TO_USE=%%~dpI\Scripts\pip.exe"
        goto :found_python312
    )
)

:: Python Not Found
echo Error: Install Python 3.12.
goto :end_of_file

:: Python Found
:found_python312
echo Python 3.12 found at: %PYTHON_EXE_TO_USE%
echo Using pip from: %PIP_EXE_TO_USE%
echo.

:: Ensure setuptools and wheel are correctly installed
echo Ensuring setuptools and wheel are properly installed...
"%PIP_EXE_TO_USE%" install --upgrade --force-reinstall setuptools wheel
if errorlevel 1 (
    echo Failed to reinstall setuptools and wheel. Exiting...
    goto end_of_file
)
echo ..Setuptools and wheel are installed.
echo.
timeout /t 2 >nul

:: First run check and requirement installation
echo Installing Requirements...
timeout /t 2 >nul
"%PIP_EXE_TO_USE%" install -r requirements.txt
if errorlevel 1 (
    echo Failed to install requirements. Check Python and pip installation.
    goto end_of_file
)
echo ..Requirements Installed ^(Hopefully^).
echo.
timeout /t 2 >nul

:end_of_file
:: Exit Program
echo All Processes Finished.
pause
exit /b
