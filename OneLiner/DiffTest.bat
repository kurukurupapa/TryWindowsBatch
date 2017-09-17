@echo off
@setlocal enabledelayedexpansion
rem diff�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
call %batdir%\Setting.bat
set inpath1=%batdir%\Data\Sample.txt
set inpath2=%batdir%\Data\Sample2.txt
set outdir=%CD%
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\diff %inpath1% %inpath2% > %outpath%

rem Windows�W���R�}���h fc�R�}���h
set outpath=%outdir%\%basename%_fc.txt
fc %inpath1% %inpath2% > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem PowerShell
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "Compare-Object (cat %inpath1%) (cat %inpath2%) | Out-File -Encoding Default %outpath%"
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

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
