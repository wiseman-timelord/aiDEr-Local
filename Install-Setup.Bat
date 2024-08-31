:: Script: `.\Install-Setup.Bat` 
@echo off
setlocal EnableDelayedExpansion

:: Global Variables
set "PYTHON_VERSION_NODECIMAL=312"
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "PYTHON_FOLDER_TO_USE="

:: Change to the script's directory
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"

:: Ensure the .\data\ folder exists
if not exist ".\data\" (
    mkdir ".\data"
    echo Created .\data folder.
)

:: Check for persistance.txt and create it if it doesn't exist
if not exist ".\data\persistance.txt" (
    echo # This file stores configuration settings.> ".\data\persistance.txt"
    echo Created persistance.txt.
)

:: Load settings from persistance.txt
for /f "tokens=1,2 delims==" %%A in (.\\data\\persistance.txt) do (
    if "%%A"=="PYTHON_VERSION_NODECIMAL" set "PYTHON_VERSION_NODECIMAL=%%B"
)

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

:: Find Python %PYTHON_VERSION_NODECIMAL% and pip based on config folder location
for %%I in (
    "C:\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
    "C:\Program Files\Python%PYTHON_VERSION_NODECIMAL%\"
    "%LocalAppData%\Programs\Python\Python%PYTHON_VERSION_NODECIMAL%\"
) do (
    if exist "%%~I" (
        set "PYTHON_FOLDER_TO_USE=%%~I"
        set "PYTHON_EXE_TO_USE=%%~dpI\python.exe"
        set "PIP_EXE_TO_USE=%%~dpI\Scripts\pip.exe"
        goto :found_python
    )
)

:: Python Not Found
echo Error: Install Python %PYTHON_VERSION_NODECIMAL%.
goto :end_of_file

:: Python Found
:found_python
echo Python %PYTHON_VERSION_NODECIMAL% found at: %PYTHON_EXE_TO_USE%
echo Using pip from: %PIP_EXE_TO_USE%
echo.

:: Ensure setuptools and wheel are correctly installed
echo Ensuring setuptools and wheel are properly installed...
"%PIP_EXE_TO_USE%" install --upgrade --force-reinstall setuptools wheel
if errorlevel 1 (
    echo Failed to reinstall setuptools and wheel. Exiting...
    goto :end_of_file
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
    goto :end_of_file
)
echo ..Requirements Installed ^(Hopefully^).
echo.
timeout /t 2 >nul

:: Save current settings back to persistance.txt
(
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
) > ".\data\persistance.txt"

:end_of_file
:: Exit Program
echo All Processes Finished.
pause
exit /b
