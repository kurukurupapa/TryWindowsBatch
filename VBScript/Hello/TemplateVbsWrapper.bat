@echo off
rem VBScript���Ăяo���܂��B

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set mainname=%basename:VbsWrapper=%
set logpath=%CD%\%mainname%.log

set /p input=�J�n���Ă�낵���ł����H (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" exit /b 1

echo ���O�F%logpath%
cscript "%basedir%\%mainname%.vbs" %1 %2 %3 %4 %5 %6 %7 %8 %9 > "%logpath%" 2>&1

pause
exit /b 0
