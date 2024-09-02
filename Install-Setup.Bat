@echo off
setlocal EnableDelayedExpansion

:: Persistence Variables
set "PYTHON_VERSION_NODECIMAL=0"
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "MODEL_SELECTION=No_Model_Selected"
set "THREADS_FOR_OLLAMA=0"

:: Global Constants
set "model_path="
set "modelfile_path="

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

:: Check for, .\data and .\data\persistence.txt and create as required.
echo Checking Persistence File...
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
    echo Loaded: .\data\persistence.txt
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

:main_menu
cls
echo ========================================================================================================================
echo                                                      Setup-Installer
echo ========================================================================================================================
echo.
echo.
echo.
echo     1. Re-Install Setup Tools
echo.
echo.
echo     2. Install `.\Requirements.Txt`
echo.
echo.
echo     3. ModelFile Management
echo.
echo.
echo.
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo.
echo.
echo Admin Status: Administrator 
echo Working Folder: %Script_Directory%
echo.
echo.
echo.
echo ========================================================================================================================
set /p choice="Selection; Menu Options = 1-3, Exit Batch = X: "

if "%choice%"=="1" goto reinstall_setup_tools
if "%choice%"=="2" goto install_requirements
if "%choice%"=="3" goto manage_models
if /i "%choice%"=="X" goto end_of_file

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto main_menu

:reinstall_setup_tools
echo Ensuring setuptools and wheel are properly installed...
"%PIP_EXE_TO_USE%" install --upgrade --force-reinstall setuptools wheel
if errorlevel 1 (
    echo Failed to reinstall setuptools and wheel. Carrying On...
)
echo Setuptools and Wheel, Processes Finished.
echo.
pause
goto main_menu

:install_requirements
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
pause
goto main_menu

:manage_models
cls
echo ========================================================================================================================
echo                                              Ollama Model Management
echo ========================================================================================================================
echo.
echo.
echo.
echo     Available Ollama models:
ollama list
echo.
echo.
echo.
echo.
echo  ========================================================================================================================
set /p "model_choice=Selection; Install ModelCard = I, Delete Modelcard = D, Back to Menu = B: "

if /i "%model_choice%"=="I" goto install_model
if /i "%model_choice%"=="D" goto delete_model_prompt
if /i "%model_choice%"=="B" goto main_menu

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto manage_models

:install_model
set /p "model_path=Enter the full path to the model including filename: "
set /p "modelfile_path=Enter the full path to the ModelFile: "
set /p "model_name=Enter a name for the new model: "
echo Installing Model to Ollama...
ollama create "%model_name%" -f "%modelfile_path%"
if errorlevel 1 (
    echo Error: Failed to install model.
) else (
    echo Model %model_name% installed successfully.
    set "MODEL_SELECTION=%model_name%"
    call :update_persistence
)
timeout /t 2 >nul
goto manage_models

:delete_model_prompt
set /p "model_to_delete=Enter the model name to delete or 'B' to go back: "
if /i "%model_to_delete%"=="B" goto manage_models
set /p "confirm=Are you sure you want to delete %model_to_delete%? (Y/N): "
if /i "%confirm%"=="Y" (
    ollama rm %model_to_delete% || echo Error: Failed to delete model.
    if "%model_to_delete%"=="%MODEL_SELECTION%" (
        set "MODEL_SELECTION=No_Model_Selected"
        call :update_persistence
        echo Model %model_to_delete% deleted. Model selection cleared.
    )
)
timeout /t 2 >nul
goto manage_models

:update_persistence
(
    echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
    echo PIP_EXE_TO_USE=%PIP_EXE_TO_USE%
    echo PYTHON_EXE_TO_USE=%PYTHON_EXE_TO_USE%
    echo MODEL_SELECTION=%MODEL_SELECTION%
    echo THREADS_FOR_OLLAMA=%THREADS_FOR_OLLAMA%
) > ".\data\persistence.txt"
echo Updated: .\data\persistence.txt
goto :eof

:end_of_file
echo ========================================================================================================================
echo All processes finished.
pause
exit /b