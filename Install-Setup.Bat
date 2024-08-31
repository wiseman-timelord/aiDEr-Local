:: Script: `.\Install-Setup.Bat` 
@echo off
setlocal EnableDelayedExpansion

:: Global Variables
set "PYTHON_VERSION_NODECIMAL=0"
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

:: If PYTHON_VERSION_NODECIMAL is 0 or not set, prompt the user
if "%PYTHON_VERSION_NODECIMAL%"=="0" (
    set /p "PYTHON_VERSION_NODECIMAL=Enter Python Version To Use (no decimal), Eg 312, 39: "
)

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Error: Admin privileges required!
    echo Please right-click and select "Run as administrator".
    pause
    exit /b 1
)

echo Admin Status: Administrator 
echo Working Folder: %Script_Directory%
timeout /t 1 >nul

cls
echo ========================================================================================================================
echo                                                      Setup-Installer
echo ------------------------------------------------------------------------------------------------------------------------
echo.

:: Find Python and pip based on config folder location
for %%I in (
    "C:\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
    "C:\Program Files\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
    "%LocalAppData%\Programs\Python\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
) do (
    if exist "%%~I" (
        set "PYTHON_EXE_TO_USE=%%~I"
        set "PYTHON_FOLDER_TO_USE=%%~dpI"
        set "PIP_EXE_TO_USE=%%~dpI\Scripts\pip.exe"
        goto :found_python
    )
)

:: Python Not Found
echo Error: Python %PYTHON_VERSION_NODECIMAL% not found. Please install Python %PYTHON_VERSION_NODECIMAL%.
goto :end_of_file

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
echo Setuptools and wheel are installed.
echo.

:: Install requirements
echo Installing Requirements...
"%PIP_EXE_TO_USE%" install -r requirements.txt
if errorlevel 1 (
    echo Failed to install requirements. Please check your Python and pip installation.
    goto :end_of_file
)
echo Requirements installed successfully.
echo.

:: Save current settings back to persistance.txt
(
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
) > ".\data\persistance.txt"

:end_of_file
echo All processes finished.
pause
exit /b