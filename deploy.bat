@echo off
echo ---
echo.

set PACKAGE_NAME=%1
set ARGS_AFTER_PACKAGE_NAME=
shift
:loop1
if "%1"=="" goto after_loop
set ARGS_AFTER_PACKAGE_NAME=%ARGS_AFTER_PACKAGE_NAME% %1
shift
goto loop1

:after_loop
echo %PACKAGE_NAME%
echo %ARGS_AFTER_PACKAGE_NAME%

powershell -Command "ps_deploy -m %PACKAGE_NAME% '%ARGS_AFTER_PACKAGE_NAME%'"
