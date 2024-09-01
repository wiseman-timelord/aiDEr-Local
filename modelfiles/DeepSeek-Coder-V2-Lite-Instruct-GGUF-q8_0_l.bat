:: Global Constants
Set "modelfile_to_use=DeepSeek-Coder-V2-Lite-Instruct-GGUF-q8_0_l.modelfile"
Set "model_to_use=DeepSeek-Coder-V2-Lite-Instruct-GGUF-Q8_0_L.gguf"

:: Check Files
if not exist "%modelfile_to_use%" (
    echo Ollama Modelfile Not Found: %modelfile_to_use%
    timeout /t 3 /nobreak >nul
    goto :exit_bad
)
if not exist "%model_to_use%" (
    echo LLM Model File Not Found: %model_to_use%
    timeout /t 3 /nobreak >nul
	goto :exit_bad
)

:: Models Found 
echo Modelfile and LLM Model, Found. 
timeout /t 2 /nobreak >nul

:: Install Model
echo Installing Model to Ollama...
ollama create deepseek-coder-v2-lite-instruct -f "%modelfile_to_use%"
echo...Install Process Complete.
goto :exit_normal

:: Exit Procedures
:exit_normal
echo All Processes Finished.
echo  Exiting in 5 Seconds...
timeout /t 3 /nobreak >nul
exit /b

:exit_bad
echo Files were Missing...
echo 1. Ensure the Batch file, Modelfile, and Model are in the same folder.
echo 2. Ensure the specific version of the model is "%model_to_use%"
pause
exit /b
