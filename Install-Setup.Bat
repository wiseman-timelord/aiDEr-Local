:: SCRIPT: Setup-Install.Bat
@echo off
setlocal EnableDelayedExpansion

:: Persistence Variables
set "PYTHON_VERSION_NODECIMAL=0"
set "PYTHON_EXE_TO_USE="
set "MODEL_SELECTION=No_Model_Selected"
set "THREADS_FOR_OLLAMA=0"

:: Global Constants
set "TARGET_MODEL_PATH="
set "TARGET_MODELFILE_PATH="

:: ADMIN AND DP0, BLOCK, DO NOT MODIFY: START
net session >nul 2>&1 || (
    echo Error: Admin privileges required. Right-click and select "Run as administrator".
    timeout /t 3 >nul
    exit /b 1
)
echo Status: Administrator
timeout /t 1 >nul
set "SCRIPT_DIRECTORY_PATH=%~dp0"
set "SCRIPT_DIRECTORY_PATH=%SCRIPT_DIRECTORY_PATH:~0,-1%"
pushd "%SCRIPT_DIRECTORY_PATH%"
echo Path Dp0'd To Script.
timeout /t 1 >nul
:: ...ADMIN AND DP0, BLOCK, DO NOT MODIFY: END

:: Check for, .\data and .\data\persistence.txt and create as required.
if not exist ".\data" (
    mkdir ".\data" && echo Created .\data folder.
)
if not exist ".\data\persistence.txt" (
    (
        echo # This file stores configuration settings.
        echo PYTHON_VERSION_NODECIMAL=0
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
)
echo .\Data\Persistence.Txt Done.
timeout /t 1 >nul

:: FIND PYTHON BLOCK, DO NOT MODIFY: START
if "%PYTHON_VERSION_NODECIMAL%"=="0" (
    set /p "PYTHON_VERSION_NODECIMAL=Enter Python Version To Use (e.g., 311 or 39): "
)
set "USER_PYTHON_PATH=%LocalAppData%\Programs\Python\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
set "ALL_USERS_PYTHON_PATH=C:\Program Files\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
if exist "%USER_PYTHON_PATH%" (
    set "PYTHON_EXE_TO_USE=%USER_PYTHON_PATH%"
    goto :found_python
) else if exist "%ALL_USERS_PYTHON_PATH%" (
    set "PYTHON_EXE_TO_USE=%ALL_USERS_PYTHON_PATH%"
    goto :found_python
) else (
    echo Error: Python %PYTHON_VERSION_NODECIMAL% not found!
    echo Please install Python %PYTHON_VERSION_NODECIMAL% to the default location.
    goto :end_of_file
)
:found_python
echo Python %PYTHON_VERSION_NODECIMAL% found.
timeout /t 1 >nul
call :update_persistence
:: FIND PYTHON BLOCK, DO NOT MODIFY: END

:main_menu
cls
echo ========================================================================================================================
echo                                                      Setup-Installer
echo ========================================================================================================================
echo.
echo.
echo.
echo     1. Install `.\Requirements.Txt`
echo.
echo     2. ModelFile Management
echo.
echo     3. Re-Install Setup Tools
echo.
echo.
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo.
echo     * Admin Status:
echo Administrator
echo.
echo     * Working Folder:
echo %SCRIPT_DIRECTORY_PATH%
echo.
echo     * Python Location:
echo %PYTHON_EXE_TO_USE%
echo.
echo.
echo ========================================================================================================================
set /p choice="Selection; Menu Options = 1-3, Exit Batch = X: "

if "%choice%"=="1" goto install_requirements
if "%choice%"=="2" goto manage_models
if "%choice%"=="3" goto reinstall_setup_tools
if /i "%choice%"=="X" goto end_of_file

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto main_menu

:reinstall_setup_tools
echo Ensuring setuptools and wheel are properly installed...
"%PYTHON_EXE_TO_USE%" -m pip install --upgrade --force-reinstall setuptools wheel
if errorlevel 1 (
    echo Failed to reinstall setuptools and wheel. Carrying On...
)
echo Setuptools and Wheel processes finished.
echo.
pause
goto main_menu

:install_requirements
echo Installing Requirements...
"%PYTHON_EXE_TO_USE%" -m pip install -r requirements.txt
echo Processed: `requirements.txt`
echo.
echo Verifying installation...
"%PYTHON_EXE_TO_USE%" -m pip check
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
echo     * Available Ollama models:
ollama list
echo.
echo.
echo.
echo.
echo  ========================================================================================================================
set /p "MODEL_MANAGE_CHOICE=Selection; Install ModelCard = I, Remove Modelcard = R, Back to Menu = B: "

if /i "%MODEL_MANAGE_CHOICE%"=="I" goto install_model_prompt
if /i "%MODEL_MANAGE_CHOICE%"=="R" goto remove_model_prompt
if /i "%MODEL_MANAGE_CHOICE%"=="B" goto main_menu

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto manage_models

:: Main script section for installing a model
:install_model_prompt
set /p "TARGET_MODEL_PATH=Enter the full path to the model including filename: "
set /p "TARGET_MODELFILE_PATH=Enter the full path to the ModelFile: "

:: Extract the last folder name from the model path
for %%A in ("%TARGET_MODEL_PATH%") do (
    for %%B in ("%%~dpA\.") do set "last_folder=%%~nxB"
)

:: Convert the last folder name to lowercase and sanitize it
for /f "usebackq tokens=*" %%c in (`powershell -Command "$name = '%last_folder%'; $name = $name -replace '[^a-zA-Z0-9-]', ''; $name = $name.ToLower(); $name"`) do set "OLLAMA_MODEL_NAME=%%c"

:confirm_OLLAMA_MODEL_NAME
echo Model name will be: %OLLAMA_MODEL_NAME%
set /p "confirm=Is this model name okay? (Y/N): "
if /i "%confirm%"=="Y" goto install_model
for %%C in ("%TARGET_MODEL_PATH%") do set "proposed_OLLAMA_MODEL_NAME=%%~nC"
set "proposed_OLLAMA_MODEL_NAME=%proposed_OLLAMA_MODEL_NAME: =-%"
for /f "usebackq tokens=*" %%c in (`powershell -Command "$name = '%proposed_OLLAMA_MODEL_NAME%'; $name = $name -replace '[^a-zA-Z0-9-]', ''; $name = $name.ToLower(); $name"`) do set "proposed_OLLAMA_MODEL_NAME=%%c"
echo Do you want to use the model file name instead? "%proposed_OLLAMA_MODEL_NAME%" (Y/N):
set /p "confirm=Is this model name okay? (Y/N): "
if /i "%confirm%"=="Y" (
    set "OLLAMA_MODEL_NAME=%proposed_OLLAMA_MODEL_NAME%"
    goto install_model
)
set /p "OLLAMA_MODEL_NAME=Please enter the desired model name: "
set "OLLAMA_MODEL_NAME=%OLLAMA_MODEL_NAME: =-%"
for /f "usebackq tokens=*" %%d in (`powershell -Command "$name = '%OLLAMA_MODEL_NAME%'; $name = $name -replace '[^a-zA-Z0-9-]', ''; $name = $name.ToLower(); $name"`) do set "OLLAMA_MODEL_NAME=%%d"
goto confirm_OLLAMA_MODEL_NAME
:install_model
echo Installing Model to Ollama...
ollama create "%OLLAMA_MODEL_NAME%" -f "%TARGET_MODELFILE_PATH%"
if errorlevel 1 (
    echo Error: Failed to install model.
    timeout /t 3 >nul
) else (
    echo Model %OLLAMA_MODEL_NAME% installed successfully.
    set "MODEL_SELECTION=%OLLAMA_MODEL_NAME%"
    call :update_persistence
)
timeout /t 2 >nul
goto manage_models

:remove_model_prompt
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
    echo PYTHON_EXE_TO_USE=%PYTHON_EXE_TO_USE%
    echo MODEL_SELECTION=%MODEL_SELECTION%
    echo THREADS_FOR_OLLAMA=%THREADS_FOR_OLLAMA%
) > ".\data\persistence.txt"
echo Updated: .\data\persistence.txt
timeout /t 1 >nul
goto :eof

:end_of_file
cls
echo.
echo All processes finished.
pause
exit /b
