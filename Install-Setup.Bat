:: SCRIPT: Install-Setup.Bat
@echo off
setlocal EnableDelayedExpansion

:: Persistence Variables
set "PYTHON_VERSION_NODECIMAL=0"
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "MODEL_SELECTION=No_Model_Selected"
set "THREADS_FOR_OLLAMA=0"

:: ADMIN AND DP0, BLOCK, DO NOT MODIFY: START
net session >nul 2>&1 || (
    echo Error: Admin privileges required. Right-click and select "Run as administrator".
    timeout /t 3 >nul
    exit /b 1
)
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"
:: ...ADMIN AND DP0, BLOCK, DO NOT MODIFY: END

cls
echo ========================================================================================================================
echo                                                      Setup-Installer
echo ========================================================================================================================
echo.
echo Admin Status: Administrator 
echo Working Folder: %Script_Directory%
timeout /t 1 >nul

:: Check for, .\data and .\data\persistence.txt and create as required.
echo Checking Persistance File...
if not exist ".\data" (
    mkdir ".\data" && echo Created .\data folder.
)
if not exist ".\data\persistence.txt" (
    (
        echo # This file stores configuration settings.
        echo PYTHON_VERSION_NODECIMAL=0
        echo PIP_EXE_TO_USE=
        echo PYTHON_EXE_TO_USE=%PYTHON_EXE_TO_USE%
        echo MODEL_SELECTION=No_Model_Selected
        echo THREADS_FOR_OLLAMA=0
    ) > ".\data\persistence.txt"
    echo Created .\data\persistence.txt.
) else (
    for /f "usebackq tokens=1,* delims==" %%A in (".\data\persistence.txt") do (
        if not "%%A" == "" if not "%%A:~0,1%" == "#" (
            set "%%A=%%B"
        )
    )
	echo Loaded: .\data\persistance.txt
)

:: FIND PYTHON BLOCK, DO NOT MODIFY: START
if "%PYTHON_VERSION_NODECIMAL%"=="0" (
    set /p "PYTHON_VERSION_NODECIMAL=Enter Python Version To Use (eg. 311 or 39): "
)
for %%I in (
    "C:\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
    "C:\Program Files\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
    "%LocalAppData%\Programs\Python\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
) do (
    if exist "%%~I" (
        set "PYTHON_EXE_TO_USE=%%~dpI\python.exe"
        set "PIP_EXE_TO_USE=%%~dpI\Scripts\pip.exe"
        goto :found_python
    )
)
echo Error: Python %PYTHON_VERSION_NODECIMAL% not found. Please install Python %PYTHON_VERSION_NODECIMAL%.
goto :end_of_file
:found_python
echo Python %PYTHON_VERSION_NODECIMAL% found.
echo Using `python.exe` from: %PYTHON_EXE_TO_USE%
echo Using `pip.exe` from: %PIP_EXE_TO_USE%
echo.
:: FIND PYTHON BLOCK, DO NOT MODIFY: END

:: Ensure setuptools and wheel are correctly installed
echo Ensuring setuptools and wheel are properly installed...
"%PIP_EXE_TO_USE%" install --upgrade --force-reinstall setuptools wheel
if errorlevel 1 (
    echo Failed to reinstall setuptools and wheel. Carrying On...
)
echo Setuptools and Wheel, Processes Finished.
echo.

:: Install requirements and verify Install.
echo Installing Requirements...
"%PIP_EXE_TO_USE%" install -r requirements.txt
echo Processed: `requirements.txt`
echo.
echo Verifying installation...
"%PIP_EXE_TO_USE%" check
if errorlevel 1 (
    echo Warning: Some conflicts may still exist. Please review the output above.
) else (
    echo All packages are installed correctly with no conflicts.
)
echo.

:: Save current  settings back to persistence.txt
echo Saving Persistance File...
(
    echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
    echo PIP_EXE_TO_USE=%PIP_EXE_TO_USE%
    echo PYTHON_EXE_TO_USE=%PYTHON_EXE_TO_USE%
    echo MODEL_SELECTION=%MODEL_SELECTION%
    echo THREADS_FOR_OLLAMA=%THREADS_FOR_OLLAMA%
) > ".\data\persistence.txt"
echo Saved: .\data\persistance.txt

:end_of_file
echo ========================================================================================================================
echo All processes finished.
pause
exit /b