@echo off
rem Windows�o�b�`�t�@�C�����Ăяo���܂��B

set basedir=%~dp0
set basename=%~n0
set batdir=%~dp0
set batname=%~n0%~x0
set mainname=%basename:BatWrapper=%
set logpath=%CD%\%mainname%.log

set /p input=�J�n���Ă�낵���ł����H (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" exit /b 1

echo ���O�F%logpath%
type nul > "%logpath%"

rem �������܂Ƃ߂ēn���ꍇ
call "%basedir%\%mainname%.bat" %* >> "%logpath%" 2>&1

rem ������1���n���ꍇ
rem if "%~1"=="" (
rem   call "%basedir%\%mainname%.bat" >> "%logpath%" 2>&1
rem ) else (
rem   for %%a in (%*) do (
rem     call "%basedir%\%mainname%.bat" "%%~a" >> "%logpath%" 2>&1
rem   )
rem )

rem �����̃t�H���_��W�J���ēn���ꍇ
rem if "%~1"=="" (
rem   call "%basedir%\%mainname%.bat" >> "%logpath%" 2>&1
rem ) else (
rem   for %%a in (%*) do (
rem     for /F "usebackq delims=" %%f in (`dir /b /s /a-d /on "%%~a"`) do (
rem       call "%basedir%\%mainname%.bat" "%%f" >> "%logpath%" 2>&1
rem     )
rem   )
rem )

type "%logpath%"

pause
exit /b 0
