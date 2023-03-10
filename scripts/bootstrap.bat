@echo off

@rem This script will install git and conda (if not found on the PATH variable)
@rem  using micromamba (an 8mb static-linked single-file binary, conda replacement).
@rem For users who already have git and conda, this step will be skipped.
@rem This enables a user to install this project without manually installing conda and git.



@rem config
set MAMBA_ROOT_PREFIX=%cd%\installer_files\mamba
set INSTALL_ENV_DIR=%cd%\installer_files\env
set MICROMAMBA_DOWNLOAD_URL=https://github.com/aivisionapp/chat_gpt_detector/releases/download/v0.1/micromamba.exe
set umamba_exists=F
set OLD_APPDATA=%APPDATA%
set OLD_USERPROFILE=%USERPROFILE%
set APPDATA=%cd%\installer_files\appdata
set USERPROFILE=%cd%\profile


@rem 
if exist "%INSTALL_ENV_DIR%" set PATH=%INSTALL_ENV_DIR%;%INSTALL_ENV_DIR%\Library\bin;%INSTALL_ENV_DIR%\Scripts;%INSTALL_ENV_DIR%\Library\usr\bin;%PATH%


set PACKAGES_TO_INSTALL=
if not exist "%INSTALL_ENV_DIR%\etc\profile.d\conda.sh" set PACKAGES_TO_INSTALL=%PACKAGES_TO_INSTALL% conda


call git --version >.tmp1 2>.tmp2
if "%ERRORLEVEL%" NEQ "0" set PACKAGES_TO_INSTALL=%PACKAGES_TO_INSTALL% git

@rem for debugging
@echo %PACKAGES_TO_INSTALL%

call "%MAMBA_ROOT_PREFIX%\micromamba.exe" --version >.tmp1 2>.tmp2
if "%ERRORLEVEL%" EQU "0" set umamba_exists=T


@rem (if necessary) install git and conda into a contained environment

if "%PACKAGES_TO_INSTALL%" NEQ "" (

    @rem download micromamba 

    if "%umamba_exists%" == "F" (
        echo "Downloading micromamba from %MICROMAMBA_DOWNLOAD_URL% to %MAMBA_ROOT_PREFIX%\micromamba.exe"
        
        mkdir "%MAMBA_ROOT_PREFIX%" 
        call curl -Lk "%MICROMAMBA_DOWNLOAD_URL%" > "%MAMBA_ROOT_PREFIX%\micromamba.exe"

        @REM if "%ERRORLEVEL%" NEQ "0" (
        @REM     echo "There was a problem downloading micromamba. Cannot continue."
        @REM     pause
        @REM     exit /b
        @REM )

        mkdir "%APPDATA%"
        mkdir "%USERPROFILE%"
        @rem test the mamba binary
        echo Micromamba version:
        call "%MAMBA_ROOT_PREFIX%\micromamba.exe" --version


    )

    @rem create installer environment

    if not exist "%INSTALL_ENV_DIR%" (
        echo "Creating conda environment in %INSTALL_ENV_DIR%"
        call "%MAMBA_ROOT_PREFIX%\micromamba.exe" create -y --prefix "%INSTALL_ENV_DIR%" -c conda-forge %PACKAGES_TO_INSTALL%
    )


    if not exist "%INSTALL_ENV_DIR%" (
        echo "There was a problem creating the conda environment. Cannot continue."
        pause
        exit /b
    )

    @rem revert to old APPDATA.
    set APPDATA=%OLD_APPDATA%
    set USERPROFILE=%OLD_USERPROFILE%


)

