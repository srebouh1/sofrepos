@echo off
echo ---
echo.

set PACKAGE_NAME=%1
set ARGS_AFTER_PACKAGE_NAME=
set PVERSION=
shift
:loop1
if "%1"=="" goto after_loop

if "%1"=="pversion" (
    shift
    set PVERSION=%2
) else (
    set ARGS_AFTER_PACKAGE_NAME=%ARGS_AFTER_PACKAGE_NAME% %1
)
shift
goto loop1

:after_loop
echo Package Name: %PACKAGE_NAME%
echo Arguments after Package Name: %ARGS_AFTER_PACKAGE_NAME%

if not "%PVERSION%"=="" (
    echo Version: %PVERSION%
    powershell -Command "deploy_pversion -m '%PACKAGE_NAME%' -cmd_args '%ARGS_AFTER_PACKAGE_NAME%' -pversion '%PVERSION%'"
) else (
    echo No version provided
    powershell -Command "deploy_pversion -m '%PACKAGE_NAME%' -cmd_args '%ARGS_AFTER_PACKAGE_NAME%'"
)