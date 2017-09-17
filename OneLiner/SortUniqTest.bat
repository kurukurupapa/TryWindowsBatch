@echo off
@setlocal enabledelayedexpansion
rem sort,uniqコマンドライクの各種ワンライナーです。

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
rem   echo 使い方：%batname% [/?]
rem   exit /b 0
rem )

:MAIN
call :LOG 処理開始します。



rem 準備
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

rem Windows標準コマンド
set outpath=%outdir%\%basename%_sort_for1.txt
set p= & (for /f "delims= eol=" %%a in ('sort %inpath%') do (if not "%p%"=="%%a" (echo %%a) & set p=%%a)) > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem PowerShell
rem エイリアス cat -> Get-Content, sort -> Sort-Object
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | sort | Get-Unique | Out-File -Encoding Default %outpath%"
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem 後処理
echo off



:END
call :LOG 正常終了です。
exit /b 0

:ERROR
echo 異常終了です。
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:EOF
