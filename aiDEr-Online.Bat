:: Script: `.\aiDEr-Online.Bat` 
@echo off
setlocal EnableDelayedExpansion

:: Global Variables
set "PYTHON_VERSION_NODECIMAL=312"
set "PIP_EXE_TO_USE="
set "PYTHON_EXE_TO_USE="
set "PYTHON_FOLDER_TO_USE="

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
echo                                                        Aider Launcher
echo ------------------------------------------------------------------------------------------------------------------------
echo.
echo.
echo.
echo.
echo.
echo                                                 1. Run Aider Normally
echo.
echo.
echo                                                 2. Run Aider with GPT-4o Model
echo.
echo.
echo                                                 3. Run Aider with Claude 3.5 Sonnet Model
echo.
echo.
echo                                                 4. Run Aider with Specific Python File
echo.
echo.
echo.
echo.
echo.
echo ========================================================================================================================
set /p choice="Selection; Program Options = 1-4, Exit Program = X: "

if /i "!choice!"=="X" goto end_of_file
if "!choice!"=="1" goto run_aider
if "!choice!"=="2" goto run_gpt4o
if "!choice!"=="3" goto run_claude
if "!choice!"=="4" goto run_with_file

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

:: Save current settings back to persistance.txt
(
    echo PYTHON_VERSION_NODECIMAL=%PYTHON_VERSION_NODECIMAL%
) > ".\data\persistance.txt"

:end_of_file
echo All Processes Finished.
pause
exit /b
