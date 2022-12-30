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
call conda env list | findstr ocr_reader
if "%ERRORLEVEL%" NEQ "0" (
    @rem create conda env with python 3.9
    call conda create -y -n ocr_reader python=3.9 || (
       @echo. & echo "Error creating conda enviroment for OCR Reader.. press any key to exit" & echo.
        pause
        exit /b
    )
) else (
    @rem env already exists
    @echo "Envirnoment already exists."
)




@rem activate conda env

call conda activate ocr_reader
@if "%ERRORLEVEL%" NEQ "0" (
       @echo. & echo "Error activating conda for OCR Reader.. press any key to exit" & echo.
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

        echo "Error installing fastapi .. press any key to exit" & echo.
        pause
        exit /b
    )


)


call python scripts\check_modules.py pytesseract  
if "%ERRORLEVEL%" EQU "0" (
    echo "pytesseract have already been installed."
) else (
        echo "pytesseract not installeed. installing now..."
        set PYTHONNOUSERSITE=1
        set PYTHONPATH=%INSTALL_ENV_DIR%\lib\site-packages


        @call where python

        @call python --version

        @call conda install -c conda-forge -y pytesseract  || (

        echo "Error installing fastapi .. press any key to exit" & echo.
        pause
        exit /b
    )


)




call python scripts\check_modules.py docquery  
if "%ERRORLEVEL%" EQU "0" (
    echo "docquery have already been installed."
) else (
        echo "docquery not installeed. installing now..."
        set PYTHONNOUSERSITE=1
        set PYTHONPATH=%INSTALL_ENV_DIR%\lib\site-packages


        @call where python

        @call python --version

        @call pip install docquery || (

        echo "Error installing fastapi .. press any key to exit" & echo.
        pause
        exit /b
    )


)



@call WHERE uvicorn > .tmp
@>nul findstr /m "uvicorn" .tmp
@if "%ERRORLEVEL%" NEQ "0" (
    echo "Error installing uvicorn .. press any key to exit" & echo.
    pause
    exit /b
)

set PYTHONPATH=%INSTALL_ENV_DIR%\lib\site-packages
echo PYTHONPATH=%PYTHONPATH%

@set APP_PATH=%cd%\app
@if NOT DEFINED BIND_PORT set BIND_PORT=8000
@if NOT DEFINED BIND_IP set BIND_IP=0.0.0.0
@if NOT DEFINED UI_PATH set UI_PATH=%cd%\app\ui


@uvicorn main:server_api --app-dir "%APP_PATH%" --port %BIND_PORT% --host %BIND_IP% --log-level error


@pause
