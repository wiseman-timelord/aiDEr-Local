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

C:\Users\Mastar\AppData\Local\Programs\Python\Python312\python.exe -m pip uninstall -r remove_libraries_0_54_0.txt -y
pause
