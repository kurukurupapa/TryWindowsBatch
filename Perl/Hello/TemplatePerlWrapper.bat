@echo off
rem Perl�X�N���v�g���Ăяo���܂��B

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set mainname=%basename:PerlWrapper=%
set mainpath=%basedir%\%mainname%.pl
set logpath=%basedir%\%mainname%.log

set /p input=�J�n���Ă�낵���ł����H (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" exit /b 1

echo ���O�F%logpath%
type nul > "%logpath%"

rem �������܂Ƃ߂ēn���ꍇ
perl "%mainpath%" %* >> "%logpath%" 2>&1

rem ������1���n���ꍇ
rem if "%1"=="" (
rem   perl "%mainpath%" >> "%logpath%" 2>&1
rem ) else (
rem   for %%a in (%*) do (
rem     perl "%mainpath%" "%%a" >> "%logpath%" 2>&1
rem   )
rem )

rem �����̃t�H���_��W�J���ēn���ꍇ
rem if "%1"=="" (
rem   perl "%mainpath%" >> "%logpath%" 2>&1
rem ) else (
rem   for %%a in (%*) do (
rem     for /F "usebackq" %%f in (`dir /b /s /a-d /on "%%a"`) do (
rem       perl "%mainpath%" "%%f" >> "%logpath%" 2>&1
rem     )
rem   )
rem )

type "%logpath%"

pause
exit /b 0
