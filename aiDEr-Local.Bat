@echo off
setlocal enabledelayedexpansion

:: Persistence Variables
set "PYTHON_VERSION_NODECIMAL=0"
set "PYTHON_EXE_TO_USE="
set "MODEL_SELECTION=No_Model_Selected"
set "THREADS_FOR_OLLAMA=0"

:: Script Variables
set "FULL_PATH_FILES_LIST="
set "file_count=1"
set "OLLAMA_API_BASE=http://localhost:11434"
set "MODEL_NAME_FOR_AIDER="

:: ADMIN AND DP0, BLOCK, DO NOT MODIFY: START...
net session >nul 2>&1 || (
    echo Error: Admin privileges required. Right-click and select "Run as administrator".
    timeout /t 3 >nul
    exit /b 1
)
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"
:: ...ADMIN AND DP0, BLOCK, DO NOT MODIFY: END.

:: PERSISTENCE BLOCK, DO NOT MODIFY: START...
if not exist ".\data\persistence.txt" (
    echo Ensure to run `Setup-install` first, then you can run `aiDEr-Local.Bat`.
    goto :end_of_file
)
for /f "tokens=1,* delims==" %%A in ('type ".\data\persistence.txt" ^| findstr /v "^#"') do (
    set "%%A=%%B"
)
:: ...PERSISTENCE BLOCK, DO NOT MODIFY: END.

:menu
cls
echo ========================================================================================================================
echo                                                    AiDEr-Local Launcher
echo ========================================================================================================================
echo.
echo.
echo     1. Run Aider with Ollama and Selected Model
echo.
echo     2. Run Aider with Ollama and Selected Model and Files
echo.
echo     3. Run Aider with Ollama and Selected Model and Files from Folder
echo.
echo     4. Manage Ollama Settings
echo.
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo     * Model Selected: 
echo %MODEL_SELECTION%
echo.
echo     * Threads Used:
echo %THREADS_FOR_OLLAMA%
echo.
echo     * Python Location:
echo %PYTHON_EXE_TO_USE%
echo.
echo.
echo ========================================================================================================================
set /p choice="Selection; Menu Options = 1-4, Exit Batch = X: "

if /i "%choice%"=="X" goto :end_of_file
if "%choice%"=="1" goto :run_aider
if "%choice%"=="2" goto :collect_files
if "%choice%"=="3" goto :collect_files_from_folder
if "%choice%"=="4" goto :manage_models
goto :menu

:manage_models
cls
echo ========================================================================================================================
echo                                              Ollama-Aider Settings Management
echo ========================================================================================================================
echo.
echo.
echo.
echo.
echo.
echo     * Available Ollama models:
ollama list
echo.
echo     * Current Model Used:
echo %MODEL_SELECTION%
echo.
echo     * CPU Threads Available:
wmic cpu get NumberOfLogicalProcessors
echo     * Current Threads Used:
echo %THREADS_FOR_OLLAMA%
echo.
echo.
echo.
echo.
echo.
echo ------------------------------------------------------------------------------------------------------------------------
set /p "model_choice=Selection; Select Model = S, Set Threads = T, Back to Menu = B: "

if /i "%model_choice%"=="B" goto :save_and_exit
if /i "%model_choice%"=="S" goto :select_model
if /i "%model_choice%"=="T" goto :set_threads
goto :manage_models

:set_threads
set /p "THREADS_FOR_OLLAMA=Enter the number of threads for Ollama (0 for default): "
echo THREADS_FOR_OLLAMA=%THREADS_FOR_OLLAMA%>> ".\data\persistence.txt"
echo Number of threads set to: %THREADS_FOR_OLLAMA%
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

:run_aider
cls
echo ========================================================================================================================
echo                                                      aiDEr-Local
echo ========================================================================================================================
echo.

if "%MODEL_SELECTION%"=="No_Model_Selected" (
    echo No model selected. Please select a model first.
    timeout /t 3 >nul
    goto :menu
)

set "API_BASE=%OLLAMA_API_BASE%"
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

echo Running Aider with Ollama model...
%PYTHON_EXE_TO_USE% -m aider --model ollama/%MODEL_NAME_FOR_AIDER%
goto :end_of_file

:collect_files
setlocal enabledelayedexpansion
set "FULL_PATH_FILES_LIST="
set "file_count=1"

:collect_files_loop
set "FULL_PATH_TO_FILE="
set /p "FULL_PATH_TO_FILE=Enter Full-Path to File Number %file_count% (or blank to continue): "
if "%FULL_PATH_TO_FILE%"=="" goto :run_with_files
if not exist "%FULL_PATH_TO_FILE%" (
    echo Error: File not found.
    timeout /t 3 >nul
    goto :collect_files_loop
)
set "FULL_PATH_FILES_LIST=!FULL_PATH_FILES_LIST! "!FULL_PATH_TO_FILE!""
set /a file_count+=1
if %file_count% leq 5 goto :collect_files_loop

:run_with_files
if "%FULL_PATH_FILES_LIST%"=="" (
    echo No files were entered. Returning to menu.
    timeout /t 3 >nul
    goto :menu
)
for /f "tokens=1 delims=:" %%a in ("%MODEL_SELECTION%") do set "MODEL_NAME_FOR_AIDER=%%a"
echo Running Aider with Files using Ollama model...
%PYTHON_EXE_TO_USE% -m aider --model ollama/%MODEL_NAME_FOR_AIDER% %FULL_PATH_FILES_LIST%
goto :end_of_file

:collect_files_from_folder
setlocal enabledelayedexpansion
set "folder_path="
set /p "folder_path=Enter the full path to the folder: "
if not exist "%folder_path%" (
    echo Error: Folder not found.
    timeout /t 3 >nul
    goto :menu
)
set "FULL_PATH_FILES_LIST="
set "file_count=0"
set "MAXIMUM_NUMBER_FILES=20"
echo Listing files in the folder (max %MAXIMUM_NUMBER_FILES% files):
for %%F in ("%folder_path%\*.*") do (
    set /a "file_count+=1"
    if %file_count% leq %MAXIMUM_NUMBER_FILES% (
        set "FULL_PATH_FILES_LIST=!FULL_PATH_FILES_LIST! "%%~fF""
        echo %file_count%: %%~nxF
    ) else (
        echo Max file limit reached. Some files may be omitted.
        goto :end_FULL_PATH_FILES_LIST
    )
)

:end_FULL_PATH_FILES_LIST
if %file_count% equ 0 (
    echo No files found in the specified folder.
    timeout /t 3 >nul
    goto :menu
)
echo.
echo Found %file_count% files in the folder (max %MAXIMUM_NUMBER_FILES% files displayed).
echo.
set /p "confirm=Do you want to run Aider with these files? (Y/N): "
if /i "%confirm%" neq "Y" goto :menu
for /f "tokens=1 delims=:" %%a in ("%MODEL_SELECTION%") do set "MODEL_NAME_FOR_AIDER=%%a"
echo Running Aider with Files from Folder using Ollama model...
"%PYTHON_EXE_TO_USE%" -m aider --model "ollama/%MODEL_NAME_FOR_AIDER%" %FULL_PATH_FILES_LIST%
goto :end_of_file

:update_persistence
echo Saving Persistence File...
(
    echo # This file stores configuration settings.
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
    echo PYTHON_EXE_TO_USE=%PYTHON_EXE_TO_USE%
    echo MODEL_SELECTION=%MODEL_SELECTION%
    echo THREADS_FOR_OLLAMA=%THREADS_FOR_OLLAMA%
) > ".\data\persistence.txt"
echo Saved: .\data\persistence.txt
goto :eof

:save_and_exit
call :update_persistence
goto :menu

:end_of_file
endlocal
echo All Processes Finished.
pause
exit /b