@echo off
@setlocal enabledelayedexpansion
rem tailコマンドライクの各種ワンライナーです。

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
set num=3
set outdir=%CD%
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\tail -n %num% %inpath% > %outpath%

rem Windows標準コマンド
rem 実装方法が思い浮かばない。

rem PowerShell 2.0
rem 全行を読み込むのでパフォーマンス悪い。
set outpath=%outdir%\%basename%_ps_arr.txt
powershell -Command "(Get-Content %inpath%)[-%num%..-1]" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem PowerShell 2.0
rem 全行を読み込むのでパフォーマンス悪い。
set outpath=%outdir%\%basename%_ps_select.txt
powershell -Command "Get-Content %inpath% | Select-Object -Last %num%" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem PowerShell 3.0以上
set outpath=%outdir%\%basename%_ps_cat.txt
powershell -Command "Get-Content %inpath% -Tail %num%" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

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
