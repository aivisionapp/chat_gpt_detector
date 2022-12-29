@echo off

@echo "Starting installer"

if exist "%cd%\profile" (
    set USERPROFILE=%cd%\profile
)

set INSTALL_ENV_DIR=%cd%\installer_files\env

@mkdir tmp
@set TMP=%cd%\tmp
@set TEMP=%cd%\tmp

set INSTALL_ENV_DIR=%cd%\installer_files\env


@rem check if the env with name "chat_gpt_detector" already exists
call conda env list | findstr chat_gpt_detector
if "%ERRORLEVEL%" NEQ "0" (
    @rem create conda env with python 3.8
    call conda create -y -n chat_gpt_detector python=3.8 || (
        echo "Error creating conda environment for Chat-GPT detector. Sorry about that, please try again." & echo.
        pause
        exit /b
    )
) else (
    @rem env already exists
    @echo "Chat-GPT detector conda environment already exists."
)




@rem activate conda env

call conda activate chat_gpt_detector
@if "%ERRORLEVEL%" NEQ "0" (
       @echo. & echo "Error activating conda for Chat-GPT detector. Sorry about that, please try again." & echo.
       pause
       exit /b
)


@rem installing python dependencies


set PATH=C:\Windows\System32;%PATH%

call python scripts\check_modules.py uvicorn fastapi 
if "%ERRORLEVEL%" EQU "0" (
    echo "fastapi have already been installed."
) else (
        echo "Apps dependencies are not installed. Installing them now..."
        set PYTHONNOUSERSITE=1
        set PYTHONPATH=%INSTALL_ENV_DIR%\lib\site-packages


        @call where python

        @call python --version

        @call conda install -c conda-forge -y uvicorn fastapi  || (

        echo "Error installing fastapi. Sorry about that :(" & echo.
        pause
        exit /b
    )


)

@call WHERE uvicorn > .tmp
@>nul findstr /m "uvicorn" .tmp
@if "%ERRORLEVEL%" NEQ "0" (
    @echo. & echo "UI packages not found! Sorry about that, please try to:" & echo "  1. Run this installer again." & echo "  2. If that doesn't fix it, please try the common troubleshooting steps at https://github.com/cmdr2/stable-diffusion-ui/wiki/Troubleshooting" & echo "  3. If those steps don't help, please copy *all* the error messages in this window, and ask the community at https://discord.com/invite/u9yhsFmEkB" & echo "  4. If that doesn't solve the problem, please file an issue at https://github.com/cmdr2/stable-diffusion-ui/issues" & echo "Thanks!" & echo.
    pause
    exit /b
)
