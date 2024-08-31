:: Script: `.\aiDEr-Local.Bat` 
@echo off
setlocal enabledelayedexpansion

set "OLLAMA_API_BASE=http://127.0.0.1:11434"
set "model_selection_name=(Select A Model)"

:: Change to the script's directory
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"

:: Ensure the .\data\ folder exists
if not exist ".\data\" mkdir ".\data" 2>nul || (echo Error: Unable to create .\data folder. & goto :end_of_file)

:: Check for persistance.txt and create it if it doesn't exist
if not exist ".\data\persistance.txt" (
    (echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=0
    echo model_selection_name=(Select A Model)) > ".\data\persistance.txt" || (echo Error: Unable to create persistance.txt. & goto :end_of_file)
)

:: Load settings from persistance.txt
for /f "tokens=1,* delims==" %%A in ('type ".\data\persistance.txt" ^| findstr /v "^#"') do (
    set "%%A=%%B"
)

:: If PYTHON_VERSION_NODECIMAL is 0 or not set, prompt the user
if "%PYTHON_VERSION_NODECIMAL%"=="0" (
    set /p "PYTHON_VERSION_NODECIMAL=Enter Python Version To Use (no decimal), Eg 312, 39: "
    call :update_persistence
)

:: Check for administrative privileges
net session >nul 2>&1 || (
    echo Error: Admin privileges required. Right-click and select "Run as administrator".
    pause
    exit /b 1
)
echo Admin Status: Administrator

:: Check Folder
echo Working Folder: %Script_Directory%

:: Find Python installation
for %%I in (
    "C:\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
    "C:\Program Files\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
    "%LocalAppData%\Programs\Python\Python%PYTHON_VERSION_NODECIMAL%\python.exe"
) do (
    if exist "%%~I" (
        set "PYTHON_EXE_TO_USE=%%~I"
        set "PIP_EXE_TO_USE=%%~dpI\Scripts\pip.exe"
        goto :found_python
    )
)

echo Error: Python %PYTHON_VERSION_NODECIMAL% not found. Please install it or check your PYTHON_VERSION_NODECIMAL setting.
goto :end_of_file

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
echo 1. Start Ollama Server Normally
echo 2. Ollama Models Management (%model_selection_name%)
echo 3. Run Aider with Selected Model
echo 4. Run Aider with File and Model
echo.
echo ========================================================================================================================
set /p choice="Selection (1-4, or X to exit): "

if /i "%choice%"=="X" goto :end_of_file
if "%choice%"=="1" goto :start_server
if "%choice%"=="2" goto :manage_models
if "%choice%"=="3" goto :run_aider
if "%choice%"=="4" goto :run_with_file
goto :menu

:start_server
echo Starting Ollama server...
start "" ollama serve
timeout /t 2 >nul
goto :menu

:manage_models
cls
echo ========================================================================================================================
echo                                                 Ollama Model Management
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo Available Ollama models:
ollama list
echo.
echo ========================================================================================================================
set /p "model_choice=Selection (S=Select Model, D=Delete Model, B=Back to Menu): "
if /i "%model_choice%"=="B" goto :menu
if /i "%model_choice%"=="S" goto :select_model
if /i "%model_choice%"=="D" goto :delete_model_prompt
goto :manage_models

:select_model
set /p "model=Enter the model name (e.g., llama3:70b) or 'B' to go back: "
if /i "%model%"=="B" goto :manage_models
set "model_selection_name=%model%"
call :update_persistence
echo Model selected: %model%
pause
goto :manage_models

:delete_model_prompt
set /p "model_to_delete=Enter the model name to delete or 'B' to go back: "
if /i "%model_to_delete%"=="B" goto :manage_models
set /p "confirm=Are you sure you want to delete %model_to_delete%? (Y/N): "
if /i "%confirm%"=="Y" (
    ollama rm %model_to_delete% || echo Error: Failed to delete model.
    if "%model_to_delete%"=="%model_selection_name%" (
        set "model_selection_name=(Select A Model)"
        call :update_persistence
    )
)
pause
goto :manage_models

:run_aider
if "%model_selection_name%"=="(Select A Model)" (
    echo No model selected. Please select a model first.
    pause
    goto :menu
)
echo Running Aider with Ollama model (%model_selection_name%)...
"%PYTHON_EXE_TO_USE%" -m aider --model ollama/%model_selection_name%
goto :end_of_file

:run_with_file
if "%model_selection_name%"=="(Select A Model)" (
    echo No model selected. Please select a model first.
    pause
    goto :menu
)
set /p "filename=Enter the Python file to run with Aider: "
if not exist "%filename%" (
    echo Error: File not found.
    pause
    goto :menu
)
echo Running Aider with %filename% using Ollama model (%model_selection_name%)...
"%PYTHON_EXE_TO_USE%" -m aider --model ollama/%model_selection_name% "%filename%"
goto :end_of_file

:update_persistence
(
    echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
    echo model_selection_name=%model_selection_name%
) > ".\data\persistance.txt"
exit /b

:end_of_file
echo All Processes Finished.
pause
exit /b