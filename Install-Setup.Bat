:: SCRIPT: Install-Setup.Bat
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

:: Check for persistence.txt and create it if it doesn't exist
if not exist ".\data\persistence.txt" (
    (
        echo # This file stores configuration settings.
        echo PYTHON_VERSION_NODECIMAL=0
        echo PIP_EXE_TO_USE=
        echo PYTHON_EXE_TO_USE=
        echo PYTHON_FOLDER_TO_USE=
        echo MODEL_SELECTION=No_Model_Selected
        echo threads_for_ollama=0
    ) > ".\data\persistence.txt"
    echo Created persistence.txt with default values.
)

:: Load settings from persistence.txt
for /f "tokens=1,* delims==" %%A in ('type ".\data\persistence.txt" ^| findstr /v "^#"') do (
    set "%%A=%%B"
)

:: If PYTHON_VERSION_NODECIMAL is 0 or not set, prompt the user
if "%PYTHON_VERSION_NODECIMAL%"=="0" (
    set /p "PYTHON_VERSION_NODECIMAL=Enter Python Version To Use (2-3 digits, e.g., 311 or 39): "
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
echo ========================================================================================================================
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

:: Install requirements with --upgrade flag and handle conflicts
echo Installing Requirements...
"%PIP_EXE_TO_USE%" install --upgrade -r requirements.txt
if errorlevel 1 (
    echo Warning: Some conflicts occurred during installation.
    echo Attempting to resolve conflicts...
    "%PIP_EXE_TO_USE%" install --upgrade --force-reinstall -r requirements.txt
    if errorlevel 1 (
        echo Error: Failed to resolve conflicts. Please check your requirements.txt file.
        goto :end_of_file
    )
)
echo Requirements installed successfully.
echo.

:: Verify installation and check for any remaining conflicts
echo Verifying installation...
"%PIP_EXE_TO_USE%" check
if errorlevel 1 (
    echo Warning: Some conflicts may still exist. Please review the output above.
) else (
    echo All packages are installed correctly with no conflicts.
)
echo.

:: Save current settings back to persistence.txt
(
    echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
    echo PIP_EXE_TO_USE=%PIP_EXE_TO_USE%
    echo PYTHON_EXE_TO_USE=%PYTHON_EXE_TO_USE%
    echo PYTHON_FOLDER_TO_USE=%PYTHON_FOLDER_TO_USE%
    echo MODEL_SELECTION=No_Model_Selected
    echo threads_for_ollama=0
) > ".\data\persistence.txt"

:end_of_file
echo ========================================================================================================================
echo All processes finished.
pause
exit /b