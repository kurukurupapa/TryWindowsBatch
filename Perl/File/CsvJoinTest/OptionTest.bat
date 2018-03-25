@echo off
@setlocal enabledelayedexpansion
rem テストします。

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
set mainname=csvjoin
set mainpath=%basedir%\..\%mainname%.pl
set indir=%basedir%\Input
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
if not exist %workdir% ( mkdir %workdir% )

echo TEST 入力パス指定（ファイルなしエラー）
perl %mainpath% %indir%\xxx.csv %indir%\xxx.csv > %workdir%\InErrPath_Result.csv
if %errorlevel% equ 0 ( goto :ERROR )

echo TEST 出力パス指定
perl %mainpath% %indir%\Normal1.csv %indir%\Normal2.csv -o %workdir%\OutPath_Result.csv
fc %expdir%\NormalKey1.csv %workdir%\OutPath_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 出力パス指定（ファイル書き込みエラー）
perl %mainpath% %indir%\Normal1.csv %indir%\Normal2.csv -o %workdir%
if %errorlevel% equ 0 ( goto :ERROR )

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
