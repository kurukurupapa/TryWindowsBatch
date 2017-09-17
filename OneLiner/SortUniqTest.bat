@echo off
@setlocal enabledelayedexpansion
rem sort,uniq�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set outdir=%CD%
rem echo on

rem GnuWin32 sort,uniq
set outpath=%outdir%\%basename%_gnuwin32_sort_uniq.txt
%gnubin%\cat %inpath% | %gnubin%\sort | %gnubin%\uniq > %outpath%
rem Check
copy %outpath% %outdir%\%basename%_ok.txt > nul

rem GnuWin32 awk
set outpath=%outdir%\%basename%_gnuwin32_awk.txt
%gnubin%\awk "{ hash[$_]=1 } END{ for(k in hash){print k} }" %inpath% | %gnubin%\sort > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem Windows�W���R�}���h
set outpath=%outdir%\%basename%_sort_for1.txt
set p= & (for /f "delims= eol=" %%a in ('sort %inpath%') do (if not "%p%"=="%%a" (echo %%a) & set p=%%a)) > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem PowerShell
rem �G�C���A�X cat -> Get-Content, sort -> Sort-Object
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | sort | Get-Unique | Out-File -Encoding Default %outpath%"
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

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
