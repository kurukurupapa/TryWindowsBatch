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
call %batdir%\Setting.bat

echo TEST 正常系
perl %mainpath% %indir%\Normal1.csv %indir%\Normal2.csv > %workdir%\Normal_Result.txt
fc %expdir%\Normal.txt %workdir%\Normal_Result.txt > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 正常系（keyオプション）
perl %mainpath% --key 2,3 %indir%\Normal1.csv %indir%\Normal2.csv > %workdir%\Normal_Key2-3_Result.txt
fc %expdir%\Normal_Key2-3.txt %workdir%\Normal_Key2-3_Result.txt > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 存在しないカラム
perl %mainpath% --key 999 %indir%\Normal1.csv %indir%\Normal2.csv > %workdir%\NoColumn_Result.txt
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
