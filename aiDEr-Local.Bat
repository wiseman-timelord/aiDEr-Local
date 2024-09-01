@echo off
setlocal enabledelayedexpansion

:: Global Variables
set "OLLAMA_API_BASE=http://127.0.0.1:11434"
set "PYTHON_VERSION_NODECIMAL=0"
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "PYTHON_FOLDER_TO_USE="
set "MODEL_SELECTION=No_Model_Selected"

:: Change to the script's directory
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"

:: Ensure the .\data\ folder exists
if not exist ".\data\" mkdir ".\data" 2>nul || (echo Error: Unable to create .\data folder. & goto :end_of_file)

:: Check for persistence.txt and create it if it doesn't exist
if not exist ".\data\persistence.txt" (
    (
        echo # This file stores configuration settings.
        echo PYTHON_VERSION_NODECIMAL=0
        echo PIP_EXE_TO_USE=
        echo PYTHON_EXE_TO_USE=
        echo PYTHON_FOLDER_TO_USE=
        echo MODEL_SELECTION=No_Model_Selected
    ) > ".\data\persistence.txt" || (echo Error: Unable to create persistence.txt. & goto :end_of_file)
)

:: Load settings from persistence.txt
for /f "tokens=1,* delims==" %%A in ('type ".\data\persistence.txt" ^| findstr /v "^#"') do (
    set "%%A=%%B"
)

:: Check for administrative privileges
net session >nul 2>&1 || (
    echo Error: Admin privileges required. Right-click and select "Run as administrator".
    timeout /t 3 >nul
    exit /b 1
)
echo Admin Status: Administrator

:: Check Folder
echo Working Folder: %Script_Directory%

:: Find Python installation
if "%PYTHON_EXE_TO_USE%"=="" (
    for %%I in (
        "C:\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
        "C:\Program Files\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
        "%LocalAppData%\Programs\Python\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
    ) do (
        if exist "%%~I" (
            set "PYTHON_EXE_TO_USE=%%~I"
            set "PIP_EXE_TO_USE=%%~dpI\Scripts\pip.exe"
            set "PYTHON_FOLDER_TO_USE=%%~dpI"
            goto :found_python
        )
    )

    echo Error: Python %PYTHON_VERSION_NODECIMAL% not found. Please run Install-Setup.Bat first.
    goto :end_of_file
)

:found_python
echo Python %PYTHON_VERSION_NODECIMAL% found at: %PYTHON_EXE_TO_USE%
echo Using pip from: %PIP_EXE_TO_USE%
echo.

:menu
cls
echo ========================================================================================================================
echo                                                       Aider Local Launcher
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo     1. Run Aider with LM Studio
echo     2. Run Aider with, LM Studio and Files
echo     3. Run Ollama with Selected Model
echo     4. Run Ollama with, LM Studio and Files
echo     5. Ollama Models Management (%MODEL_SELECTION%)
echo.
echo ========================================================================================================================
set /p choice="Selection; Menu Options = 1-5, Exit Batch = X: "

if /i "%choice%"=="X" goto :end_of_file
if "%choice%"=="1" goto :run_aider_lmstudio
if "%choice%"=="2" goto :run_aider_lmstudio_file
if "%choice%"=="3" goto :run_aider_ollama
if "%choice%"=="4" goto :run_with_file_ollama
if "%choice%"=="5" goto :manage_models
goto :menu

:run_aider_lmstudio
if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)
echo Running Aider with LM Studio model (%MODEL_SELECTION%)...
"%PYTHON_EXE_TO_USE%" -m aider --openai-api-base "http://localhost:1234/v1" --model "%MODEL_SELECTION%" --edit-format diff
goto :end_of_file

:run_aider_lmstudio_file
if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)
set /p "filename=Enter the Python file to run with Aider: "
if not exist "%filename%" (
    echo Error: File not found.
    timeout /t 3 >nul
    goto :menu
)
echo Running Aider with %filename% using LM Studio model (%MODEL_SELECTION%)...
"%PYTHON_EXE_TO_USE%" -m aider --openai-api-base "http://localhost:1234/v1" --model "%MODEL_SELECTION%" --edit-format diff "%filename%"
goto :end_of_file

:run_aider_ollama
if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)
echo Running Aider with Ollama model (%MODEL_SELECTION%)...
"%PYTHON_EXE_TO_USE%" -m aider --model ollama/%MODEL_SELECTION%
goto :end_of_file

:run_with_file_ollama
if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)
set /p "filename=Enter the Python file to run with Aider: "
if not exist "%filename%" (
    echo Error: File not found.
    timeout /t 3 >nul
    goto :menu
)
echo Running Aider with %filename% using Ollama model (%MODEL_SELECTION%)...
"%PYTHON_EXE_TO_USE%" -m aider --model ollama/%MODEL_SELECTION% "%filename%"
goto :end_of_file

:manage_models
cls
echo ========================================================================================================================
echo                                                 Ollama Model Management
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo     Available Ollama models:
ollama list
echo.
echo ========================================================================================================================
set /p "model_choice=Selection (Select Model = S, Delete Model = D, Back to Menu = M): "
if /i "%model_choice%"=="B" goto :menu
if /i "%model_choice%"=="S" goto :select_model
if /i "%model_choice%"=="D" goto :delete_model_prompt
goto :manage_models

:select_model
set /p "model=Enter the model name (e.g., llama3:70b) or 'B' to go back: "
if /i "%model%"=="B" goto :manage_models
set "MODEL_SELECTION=%model%"
call :update_persistence
echo Model selected: %MODEL_SELECTION%
timeout /t 2 >nul
goto :menu
goto :manage_models

:delete_model_prompt
set /p "model_to_delete=Enter the model name to delete or 'B' to go back: "
if /i "%model_to_delete%"=="B" goto :manage_models
set /p "confirm=Are you sure you want to delete %model_to_delete%? (Y/N): "
if /i "%confirm%"=="Y" (
    ollama rm %model_to_delete% || echo Error: Failed to delete model.
    if "%model_to_delete%"=="%MODEL_SELECTION%" (
        set "MODEL_SELECTION=No_Model_Selected"
        call :update_persistence
    )
)
timeout /t 2 >nul
goto :manage_models

:update_persistence
(
    echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
    echo PIP_EXE_TO_USE=%PIP_EXE_TO_USE%
    echo PYTHON_EXE_TO_USE=%PYTHON_EXE_TO_USE%
    echo PYTHON_FOLDER_TO_USE=%PYTHON_FOLDER_TO_USE%
    echo MODEL_SELECTION=%MODEL_SELECTION%
) > ".\data\persistence.txt"
exit /b

:end_of_file
echo All Processes Finished.
pause
exit /b
