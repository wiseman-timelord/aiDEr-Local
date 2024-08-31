@echo off
setlocal EnableDelayedExpansion

:: Global Variables
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "PYTHON_FOLDER_TO_USE="

:: Change to the script's directory
set "Script_Directory=%~dp0"
set "Script_Directory=%Script_Directory:~0,-1%"
pushd "%Script_Directory%"

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
echo                                                        Aider Launcher
echo ------------------------------------------------------------------------------------------------------------------------
echo.

:: Find Python 3.12 and pip based on config folder location
for %%I in (
    "C:\Python312\python.exe"
    "C:\Program Files\Python312\"
    "%LocalAppData%\Programs\Python\Python312\"
) do (
    if exist "%%~I" (
        set "PYTHON_FOLDER_TO_USE=%%~I"
        set "PYTHON_EXE_TO_USE=%%~dpI\python.exe"
        set "PIP_EXE_TO_USE=%%~dpI\Scripts\pip.exe"
        goto :found_python312
    )
)

:: Python Not Found
echo Error: Install Python 3.12.
goto :end_of_file

:found_python312
echo Python 3.12 found at: %PYTHON_EXE_TO_USE%
echo Using pip from: %PIP_EXE_TO_USE%
echo.

:menu
cls
echo ========================================================================================================================
echo                                                        Aider Launcher
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo 1. Run Aider normally
echo 2. Run Aider with GPT-4o Model
echo 3. Run Aider with Claude 3.5 Sonnet Model
echo 4. Run Aider with specific Python file
echo 5. Exit
echo.
set /p choice="Select an option (1-5): "

if "!choice!"=="1" goto run_aider
if "!choice!"=="2" goto run_gpt4o
if "!choice!"=="3" goto run_claude
if "!choice!"=="4" goto run_with_file
if "!choice!"=="5" goto end_of_file

goto menu

:run_aider
echo Running Aider normally...
timeout /t 2 >nul
"%PYTHON_EXE_TO_USE%" -m aider
goto end_of_file

:run_gpt4o
set /p "api_key=Enter your OpenAI API Key: "
echo Running Aider with GPT-4o Model...
timeout /t 2 >nul
"%PYTHON_EXE_TO_USE%" -m aider --4o --openai-api-key %api_key%
goto end_of_file

:run_claude
set /p "api_key=Enter your OpenRouter API Key: "
echo Running Aider with Claude 3.5 Sonnet Model...
timeout /t 2 >nul
"%PYTHON_EXE_TO_USE%" -m aider --model openrouter/anthropic/claude-3.5-sonnet --openrouter-api-key %api_key%
goto end_of_file

:run_with_file
set /p "filename=Enter the Python file to run with Aider: "
echo Running Aider with %filename%...
timeout /t 2 >nul
"%PYTHON_EXE_TO_USE%" -m aider %filename%
goto end_of_file

:end_of_file
echo All Processes Finished.
pause
exit /b
