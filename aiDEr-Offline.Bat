:: Script: `.\aiDEr-Offline.Bat` 
@echo off
setlocal EnableDelayedExpansion

:: Global Variables
set "PYTHON_VERSION_NODECIMAL=312"
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "PYTHON_FOLDER_TO_USE="
set "OLLAMA_API_BASE=http://127.0.0.1:11434"
set "model_selection_name=(Select A Model)"

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
    if "%%A"=="model_selection_name" set "model_selection_name=%%B"
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
echo                                                       Aider Offline Launcher
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

:found_python
echo Python %PYTHON_VERSION_NODECIMAL% found at: %PYTHON_EXE_TO_USE%
echo Using pip from: %PIP_EXE_TO_USE%
echo.

:menu
cls
echo ========================================================================================================================
echo                                                       Aider Offline Launcher
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo.
echo.
echo.
echo.
echo                                                 1. Start Ollama Server Normally
echo.
echo.
echo                                                 2. Ollama Models Management
echo                                                         (%model_selection_name%)
echo.
echo                                                 3. Run Aider with Selected Model
echo.
echo.
echo                                                 4. Run Aider with File and Model
echo.
echo.
echo.
echo.
echo.
echo ========================================================================================================================
set /p choice="Selection; Program Options = 1-4, Exit Program = X: "

if /i "!choice!"=="X" goto end_of_file
if "!choice!"=="1" goto start_server
if "!choice!"=="2" goto manage_models
if "!choice!"=="3" goto run_aider
if "!choice!"=="4" goto run_with_file

goto menu

:start_server
echo Starting Ollama server...
timeout /t 2 >nul
start ollama serve
goto menu

:manage_models
cls
echo ========================================================================================================================
echo                                                 Ollama Model Management
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo.
echo.
echo.
echo.
echo                                                Available Ollama models:
echo.
ollama list
echo.
echo.
echo.
echo.
echo.
echo ========================================================================================================================
set /p "model_choice=Selection, Select Model = S, Delete Model = D, Back To Menu = B: "
if /i "!model_choice!"=="B" goto menu
if /i "!model_choice!"=="S" goto select_model
if /i "!model_choice!"=="D" goto delete_model_prompt
goto manage_models

:select_model
set /p "model=Enter the model name you want to use (e.g., llama3:70b) or 'B' to go back: "
if /i "!model!"=="B" goto manage_models
set "model_selection_name=%model%"
echo You selected the model: %model%
pause
goto manage_models

:delete_model_prompt
set /p "model_to_delete=Enter the model name you want to delete or 'B' to go back: "
if /i "!model_to_delete!"=="B" goto manage_models
echo You are about to delete the model: %model_to_delete%
set /p "confirm=Are you sure you want to delete this model? (Y/N): "
if /i "!confirm!"=="Y" (
    echo Deleting model %model_to_delete%...
    ollama rm %model_to_delete%
    echo Model deleted.
    if "%model_to_delete%"=="%model_selection_name%" set "model_selection_name=(Select A Model)"
) else (
    echo Deletion cancelled.
)
pause
goto manage_models

:run_aider
if "%model_selection_name%"=="(Select A Model)" (
    echo No model selected. Please select a model first.
    timeout /t 2 >nul
    goto menu
)
echo Running Aider with Ollama model (%model_selection_name%)...
timeout /t 2 >nul
"%PYTHON_EXE_TO_USE%" -m aider --model ollama/%model_selection_name%
goto end_of_file

:run_with_file
if "%model_selection_name%"=="(Select A Model)" (
    echo No model selected. Please select a model first.
    timeout /t 2 >nul
    goto menu
)
set /p "filename=Enter the Python file to run with Aider and Ollama: "
echo Running Aider with %filename% using Ollama model (%model_selection_name%)...
timeout /t 2 >nul
"%PYTHON_EXE_TO_USE%" -m aider --model ollama/%model_selection_name% %filename%
goto end_of_file

:: Save current settings back to persistance.txt
(
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
    echo model_selection_name=%model_selection_name%
) > ".\data\persistance.txt"

:end_of_file
echo All Processes Finished.
pause
exit /b
