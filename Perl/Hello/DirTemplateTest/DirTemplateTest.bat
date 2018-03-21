@echo off
@setlocal enabledelayedexpansion
rem �e�X�g���܂��B

set basedir=%~dp0
set basename=%~n0
set batdir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
rem if "%~1"==""   set help=1
rem if "%~1"=="/?" set help=1
rem if "%help%"=="1" (
rem   echo �g�����F%batname% [/?]
rem   exit /b 0
rem )

:MAIN
call :LOG �����J�n���܂��B



rem ����
set mainname=%basename:Test=%
set mainpath=%basedir%\..\%mainname%.pl
set inpdir=%basedir%\Input
set expdir=%basedir%\Expectation
set workdir=%basedir%\work
set tmppath=%workdir%\%basename%.log
if not exist %workdir% ( mkdir %workdir% )

rem �e�X�g
perl %mainpath% > %tmppath%
fc %expdir%\Usage.txt %tmppath%
if errorlevel 1 ( goto :ERROR )

perl %mainpath% -h > %tmppath%
fc %expdir%\Usage.txt %tmppath%
if errorlevel 1 ( goto :ERROR )

pushd %inpdir%
perl %mainpath% . > %tmppath%
popd
fc %expdir%\Normal.txt %tmppath%
if errorlevel 1 ( goto :ERROR )

rem �㏈��
echo off



:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
echo �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:EOF
