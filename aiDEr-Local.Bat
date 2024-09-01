:: SCRIPT: aiDEr-Local.Bat
@echo off
setlocal enabledelayedexpansion

:: DO NOT, MODIFY OR MOVE, START...
net session >nul 2>&1 || (
    echo Error: Admin privileges required. Right-click and select "Run as administrator".
    timeout /t 3 >nul
    exit /b 1
)
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"
:: ...DO NOT, MODIFY OR MOVE, END.

:: Global Variables
set "OLLAMA_API_BASE=http://127.0.0.1:11434"
set "PYTHON_VERSION_NODECIMAL=0"
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "PYTHON_FOLDER_TO_USE="
set "MODEL_SELECTION=No_Model_Selected"
set "THREADS_FOR_OLLAMA=0"

:: Load Globals from `.\data\persistence.txt` section
if not exist ".\data\persistence.txt" (
    echo Ensure to run `Setup-install` first, then you can run `aiDEr-Local.Bat`.
    goto :end_of_file
)
for /f "tokens=1,* delims==" %%A in ('type ".\data\persistence.txt" ^| findstr /v "^#"') do (
    set "%%A=%%B"
)

:menu
cls
echo ========================================================================================================================
echo                                                      Aider Local Launcher
echo ========================================================================================================================
echo.
echo.
echo     1. Run Aider with LM Studio
echo.
echo     2. Run Aider with, LM Studio and Files
echo.
echo     3. Run Ollama with Selected Model 
echo.
echo     4. Run Ollama with, Selected Model and Files 
echo.
echo     5. Manage Ollama Settings - M: %MODEL_SELECTION%, T: %THREADS_FOR_OLLAMA%
echo.
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

:manage_models
cls
echo ========================================================================================================================
echo                                                Ollama Settings Management
echo ========================================================================================================================
echo.
echo.
echo     Available Ollama models:
ollama list
echo.
echo     Current Model Used:
echo %MODEL_SELECTION%
echo.
echo     CPU Threads Available:
wmic cpu get NumberOfLogicalProcessors
echo     Current Threads Used:
echo %THREADS_FOR_OLLAMA%
echo.
echo.
echo ========================================================================================================================
set /p "model_choice=Selection; Select Model = S, Delete Modelcard = D, Set Threads = T, Back to Menu = B: "

if /i "%model_choice%"=="B" goto :save_and_exit
if /i "%model_choice%"=="S" goto :select_model
if /i "%model_choice%"=="D" goto :delete_model_prompt
if /i "%model_choice%"=="T" goto :set_threads
goto :manage_models

:set_threads
set /p "THREADS_FOR_OLLAMA=Enter the number of threads for Ollama (0 for default): "
echo THREADS_FOR_OLLAMA=!THREADS_FOR_OLLAMA!>> ".\data\persistence.txt"
echo Number of threads set to: !THREADS_FOR_OLLAMA!
timeout /t 2 >nul
goto :manage_models

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
set "OLLAMA_CMD=%PYTHON_EXE_TO_USE% -m aider --model ollama/%MODEL_SELECTION%"

if not "%THREADS_FOR_OLLAMA%"=="0" (
    set "OLLAMA_CMD=%OLLAMA_CMD% --ollama-extra-flags OLLAMA_NUM_THREADS=%THREADS_FOR_OLLAMA%"
)
echo Running Aider with Ollama model (%MODEL_SELECTION%)...
%OLLAMA_CMD%
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
set "OLLAMA_CMD=%PYTHON_EXE_TO_USE% -m aider --model ollama/%MODEL_SELECTION% "%filename%""

if not "%THREADS_FOR_OLLAMA%"=="0" (
    set "OLLAMA_CMD=%OLLAMA_CMD% --ollama-extra-flags OLLAMA_NUM_THREADS=%THREADS_FOR_OLLAMA%"
)
echo Running Aider with %filename% using Ollama model (%MODEL_SELECTION%)...
%OLLAMA_CMD%
goto :end_of_file

:select_model
set /p "model=Enter the model name (e.g., llama3:70b) or 'B' to go back: "
if /i "%model%"=="B" goto :manage_models
set "MODEL_SELECTION=%model%"
call :update_persistence
echo Model selected: %MODEL_SELECTION%
timeout /t 2 >nul
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
        echo Model %model_to_delete% deleted. Model selection cleared.
    )
)
timeout /t 2 >nul
goto :manage_models

:update_persistence
(
    echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=!PYTHON_VERSION_NODECIMAL!
    echo PIP_EXE_TO_USE=!PIP_EXE_TO_USE!
    echo PYTHON_EXE_TO_USE=!PYTHON_EXE_TO_USE!
    echo PYTHON_FOLDER_TO_USE=!PYTHON_FOLDER_TO_USE!
    echo MODEL_SELECTION=!MODEL_SELECTION!
    echo THREADS_FOR_OLLAMA=!THREADS_FOR_OLLAMA!
) > ".\data\persistence.txt"
goto :eof

:save_and_exit
call :update_persistence
goto :menu

:end_of_file
echo All Processes Finished.
pause
exit /b
