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
echo Status: Arministrator
timeout /t 1 >nul
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"
echo Path Dp0'd To Script.
timeout /t 1 >nul
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
echo .\Data\Persistence.Txt Done.
timeout /t 1 >nul

:: FIND PYTHON BLOCK, DO NOT MODIFY: START
if "%PYTHON_VERSION_NODECIMAL%"=="0" (
    set /p "PYTHON_VERSION_NODECIMAL=Enter Python Version To Use (eg. 311 or 39): "
)
set "USER_PYTHON_PATH=%LocalAppData%\Programs\Python\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
set "ALL_USERS_PYTHON_PATH=C:\Program Files\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
if exist "%USER_PYTHON_PATH%" (
    set "PYTHON_EXE_TO_USE=%USER_PYTHON_PATH%"
    set "PIP_EXE_TO_USE=%LocalAppData%\Programs\Python\Python%PYTHON_VERSION_NODECIMAL%\Scripts\pip.exe"
    goto :found_python
) else if exist "%ALL_USERS_PYTHON_PATH%" (
    echo Error: Python %PYTHON_VERSION_NODECIMAL% not in default location!
    echo aider requires Python installed to default folder.
    pause
    exit /b 1
) else (
    echo Error: Python %PYTHON_VERSION_NODECIMAL% not found!
    echo Install Python %PYTHON_VERSION_NODECIMAL% to default location.
    goto :end_of_file
)
:found_python
echo Python %PYTHON_VERSION_NODECIMAL% found.
timeout /t 1 >nul
echo Verifying Python and pip...
"%PYTHON_EXE_TO_USE%" --version >nul 2>&1
if errorlevel 1 (
    echo Error: Unable to execute Python. Please check your Python installation.
    goto :end_of_file
)
"%PIP_EXE_TO_USE%" --version >nul 2>&1
if errorlevel 1 (
    echo Error: Unable to execute pip. Attempting to use python -m pip instead.
    set "USE_PYTHON_M_PIP=1"
) else (
    set "USE_PYTHON_M_PIP=0"
)
echo Verification complete.
:: FIND PYTHON BLOCK, DO NOT MODIFY: END

:main_menu
cls
echo ========================================================================================================================
echo                                                      Setup-Installer
echo ========================================================================================================================
echo.
echo.
echo     1. Re-Install Setup Tools
echo.
echo     2. Install `.\Requirements.Txt`
echo.
echo     3. ModelFile Management
echo.
echo.
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo.
echo     * Working Folder:
echo %Script_Directory%
echo.
echo     * Python Location:
echo %PYTHON_EXE_TO_USE%
echo.
echo     * Pip Location:
echo %PIP_EXE_TO_USE%
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
if "%USE_PYTHON_M_PIP%"=="1" (
    "%PYTHON_EXE_TO_USE%" -m pip install --upgrade --force-reinstall setuptools wheel
) else (
    "%PIP_EXE_TO_USE%" install --upgrade --force-reinstall setuptools wheel
)
if errorlevel 1 (
    echo Failed to reinstall setuptools and wheel. Carrying On...
)
echo Setuptools and Wheel, Processes Finished.
echo.
pause
goto main_menu

:install_requirements
echo Installing Requirements...
if "%USE_PYTHON_M_PIP%"=="1" (
    "%PYTHON_EXE_TO_USE%" -m pip install -r requirements.txt
) else (
    "%PIP_EXE_TO_USE%" install -r requirements.txt
)
echo Processed: `requirements.txt`
echo.
echo Verifying installation...
if "%USE_PYTHON_M_PIP%"=="1" (
    "%PYTHON_EXE_TO_USE%" -m pip check
) else (
    "%PIP_EXE_TO_USE%" check
)
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
set /p "model_choice=Selection; Install ModelCard = I, Remove Modelcard = R, Back to Menu = B: "

if /i "%model_choice%"=="I" goto install_model_prompt
if /i "%model_choice%"=="R" goto remove_model_prompt
if /i "%model_choice%"=="B" goto main_menu

echo Invalid choice. Please try again.
timeout /t 2 >nul
goto manage_models

:install_model_prompt
set /p "model_path=Enter the full path to the model including filename: "
set /p "modelfile_path=Enter the full path to the ModelFile: "
set /p "model_name=Enter a name for the new model: "
echo Installing Model to Ollama...
ollama create "%model_name%" -f "%modelfile_path%"
if errorlevel 1 (
    echo Error: Failed to install model.
	timeout /t 3 >nul
) else (
    echo Model %model_name% installed successfully.
    set "MODEL_SELECTION=%model_name%"
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
    echo PIP_EXE_TO_USE=%PIP_EXE_TO_USE%
    echo PYTHON_EXE_TO_USE=%PYTHON_EXE_TO_USE%
    echo MODEL_SELECTION=%MODEL_SELECTION%
    echo THREADS_FOR_OLLAMA=%THREADS_FOR_OLLAMA%
) > ".\data\persistence.txt"
echo Updated: .\data\persistence.txt
goto :eof

:end_of_file
cls
echo.
echo All processes finished.
pause
exit /b