@echo off

@echo. & echo "Face Restore App" & echo.

@echo. & echo "Starting App..." & echo.

set PATH=C:\Windows\System32;%PATH%

if exist "scripts\config.bat" call scripts\config.bat

if "%update_branch%" == "" set update_branch=main



@>nul findstr /m "conda_sd_ui_deps_installed" scripts\install_status.txt
@if "%ERRORLEVEL%" NEQ "0" (
    for /f "tokens=*" %%a in ('python -c "import os; parts = os.getcwd().split(os.path.sep); print(len(parts))"') do if "%%a" NEQ "2" (
        echo. & echo "!!!! WARNING !!!!" & echo.
        echo "Your 'stable-diffusion-ui' folder is at %cd%" & echo.
        echo "The 'stable-diffusion-ui' folder needs to be at the top of your drive, for e.g. 'C:\stable-diffusion-ui' or 'D:\stable-diffusion-ui' etc."
        echo "Not placing this folder at the top of a drive can cause errors on some computers."
        echo. & echo "Recommended: Please close this window and move the 'stable-diffusion-ui' folder to the top of a drive. For e.g. 'C:\stable-diffusion-ui'. Then run the installer again." & echo.
        echo "Not Recommended: If you're sure that you want to install at the current location, please press any key to continue." & echo.

        pause
    )
)

@>nul findstr /m "chat_gpt_cloned" scripts\install_status.txt

@if "%ERRORLEVEL%" EQU "0" (
    @echo "Repo already cloned , updating from  %update_branch%.." & echo.

    @cd chat_gpt_test

    @call git reset --hard
    @call git -c advice.detachedHead=false checkout "%update_branch%"
    @call git pull

    @cd ..
) else (

    @echo "Downloading chatgpt detector %update_branch% .." & echo.
    @echo "Using %update_branch% chanel" & echo.

      @call git clone -b "%update_branch%" https://github.com/aivisionapp/chat_gpt_detector.git chat_gpt_test && (
        @echo chat_gpt_cloned >> scripts\install_status.txt
    ) || (
        @echo "Error Downloading ChatGPT detector" & echo.
        pause
        @exit /b
    )


)


@call scripts\install.bat






