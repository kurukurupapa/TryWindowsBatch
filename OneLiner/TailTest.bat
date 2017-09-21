@echo off
@setlocal enabledelayedexpansion
rem tail�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set inpath=%batdir%\Data\Sample.txt
set num=3
set outdir=%CD%
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\tail -n %num% %inpath% > %outpath%

rem Windows�W���R�}���h
rem �������@���v�������΂Ȃ��B

rem PowerShell 2.0
rem �S�s��ǂݍ��ނ̂Ńp�t�H�[�}���X�����B
set outpath=%outdir%\%basename%_ps_arr.txt
powershell -Command "(Get-Content %inpath%)[-%num%..-1]" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem PowerShell 2.0
rem �S�s��ǂݍ��ނ̂Ńp�t�H�[�}���X�����B
set outpath=%outdir%\%basename%_ps_select.txt
powershell -Command "Get-Content %inpath% | Select-Object -Last %num%" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem PowerShell 3.0�ȏ�
set outpath=%outdir%\%basename%_ps_cat.txt
powershell -Command "Get-Content %inpath% -Tail %num%" > %outpath%
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
