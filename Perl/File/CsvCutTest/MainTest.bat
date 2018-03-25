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
set mainname=csvcut
set mainpath=%basedir%\..\%mainname%.pl
set indir=%basedir%\Input
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
if not exist %workdir% ( mkdir %workdir% )

echo TEST カラム1つ（最初）
perl %mainpath% --column 1 %indir%\Normal.csv > %workdir%\Column1_Result.csv
%gnubin%\cut -d , -f 1 %indir%\Normal.csv > %workdir%\Column1_Expectation.csv
fc %workdir%\Column1_Expectation.csv %workdir%\Column1_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST カラム1つ（最後）
perl %mainpath% --column 5 %indir%\Normal.csv > %workdir%\Column5_Result.csv
%gnubin%\cut -d , -f 5 %indir%\Normal.csv > %workdir%\Column5_Expectation.csv
fc %workdir%\Column5_Expectation.csv %workdir%\Column5_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST カラム複数（全て）
perl %mainpath% --column 1,2,3,4,5 %indir%\Normal.csv > %workdir%\AllColumn_Result.csv
fc %indir%\Normal.csv %workdir%\AllColumn_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 存在しないカラム
perl %mainpath% --column 0,1,6 %indir%\Normal.csv > %workdir%\NoColumn_Result.csv
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
