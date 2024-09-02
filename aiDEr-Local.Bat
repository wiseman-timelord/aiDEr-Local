:: SCRIPT: aiDEr-Local.Bat
@echo off
setlocal enabledelayedexpansion

:: Persistence Variables
set "PYTHON_VERSION_NODECIMAL=0"
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "MODEL_SELECTION=No_Model_Selected"
set "THREADS_FOR_OLLAMA=0"
set "MODEL_NAME_FOR_AIDER="

:: Script Variables
set "file_list="
set "file_count=1"
set "OLLAMA_API_BASE=http://localhost:11434"
set "LMS_API_TO_USE=http://localhost:1234/v1"

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
echo.
echo.
echo     1. Run Aider with LM Studio (Not Working)
echo.
echo.
echo     2. Run Aider with, LM Studio and Files (Not Working)
echo.
echo.
echo     3. Run Aider with, Ollama and Selected Model
echo.
echo.
echo     4. Run Aider with, Ollama and Selected Model and Files
echo.
echo.
echo     5. Manage Ollama Settings
echo M: %MODEL_SELECTION%, T: %THREADS_FOR_OLLAMA%
echo.
echo.
echo.
echo.
echo.
echo ------------------------------------------------------------------------------------------------------------------------
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
echo.
echo     Available Ollama models:
ollama list
echo.
echo.
echo     Current Model Used:
echo %MODEL_SELECTION%
echo.
echo.
echo     CPU Threads Available:
wmic cpu get NumberOfLogicalProcessors
echo.
echo     Current Threads Used:
echo %THREADS_FOR_OLLAMA%
echo.
echo.
echo.
echo.
echo ------------------------------------------------------------------------------------------------------------------------
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
echo Saving Persistance File...
(
    echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=!PYTHON_VERSION_NODECIMAL!
    echo PIP_EXE_TO_USE=!PIP_EXE_TO_USE!
    echo PYTHON_EXE_TO_USE=!PYTHON_EXE_TO_USE!
    echo MODEL_SELECTION=!MODEL_SELECTION!
    echo THREADS_FOR_OLLAMA=!THREADS_FOR_OLLAMA!
) > ".\data\persistence.txt"
echo Saved: .\data\persistance.txt
goto :eof

:: Run LM Studio
:run_aider_lmstudio
if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)
echo Running Aider with LM Studio (%LMS_API_TO_USE%)...
"%PYTHON_EXE_TO_USE%" -m aider --openai-api-base "%LMS_API_TO_USE%"
goto :end_of_file

:: Run LM Studio with Files inc selection
:run_aider_lmstudio_file
if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)
:collect_files_lmstudio
set /p "filename=Enter Full-Path to File Number %file_count% (or blank to continue): "
if "%filename%"=="" goto :run_aider_lmstudio_file_execute
if not exist "%filename%" (
    echo Error: File not found.
    timeout /t 3 >nul
    goto :collect_files_lmstudio
)
set "file_list=!file_list! "%filename%""
set /a file_count+=1
goto :collect_files_lmstudio
:run_aider_lmstudio_file_execute
if "%file_list%"=="" (
    echo No files were entered. Returning to menu.
    timeout /t 3 >nul
    goto :menu
)
echo Running Aider with Files using LM Studio model (%LMS_API_TO_USE%)...
"%PYTHON_EXE_TO_USE%" -m aider --openai-api-base "%LMS_API_TO_USE%" "%file_list%"
goto :end_of_file

:: Run Ollama
:run_aider_ollama
if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)
echo Starting Ollama server...
start "Ollama Serve" cmd /c "ollama serve"
timeout /t 3 >nul
echo Setting API Base...
start "Ollama API Base" setx OLLAMA_API_BASE "%OLLAMA_API_BASE%"
timeout /t 3 >nul
if not "%THREADS_FOR_OLLAMA%"=="0" (
    set OLLAMA_NUM_THREADS=%THREADS_FOR_OLLAMA%
)

for /f "tokens=1 delims=:" %%a in ("%MODEL_SELECTION%") do set "MODEL_NAME_FOR_AIDER=%%a"
echo Running Aider with Ollama model (%MODEL_NAME_FOR_AIDER%)...
"%PYTHON_EXE_TO_USE%" -m aider --model "ollama/%MODEL_NAME_FOR_AIDER%"
goto :end_of_file

:: Run Ollama with Files inc selection
:run_with_file_ollama
if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)
echo Starting Ollama server...
start "Ollama Serve" cmd /c "ollama serve"
timeout /t 3 >nul
echo Setting API Base...
start "Ollama API Base" setx OLLAMA_API_BASE "%OLLAMA_API_BASE%"
timeout /t 3 >nul
:collect_files_ollama
set /p "filename=Enter Full-Path to File Number %file_count% (or blank to continue): "
if "%filename%"=="" goto :run_with_file_ollama_execute
if not exist "%filename%" (
    echo Error: File not found.
    timeout /t 3 >nul
    goto :collect_files_ollama
)
set "file_list=!file_list! "%filename%""
set /a file_count+=1
goto :collect_files_ollama
:run_with_file_ollama_execute
if "%file_list%"=="" (
    echo No files were entered. Returning to menu.
    timeout /t 3 >nul
    goto :menu
)
if not "%THREADS_FOR_OLLAMA%"=="0" (
    set OLLAMA_NUM_THREADS=%THREADS_FOR_OLLAMA%
)

for /f "tokens=1 delims=:" %%a in ("%MODEL_SELECTION%") do set "MODEL_NAME_FOR_AIDER=%%a"
echo Running Aider with Files using Ollama model (%MODEL_NAME_FOR_AIDER%)...
"%PYTHON_EXE_TO_USE%" -m aider --model "ollama/%MODEL_NAME_FOR_AIDER%" %file_list%
goto :end_of_file
goto :end_of_file

:save_and_exit
call :update_persistence
goto :menu

:end_of_file
echo All Processes Finished.
pause
exit /b
