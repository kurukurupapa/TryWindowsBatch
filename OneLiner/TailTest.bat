@echo off
@setlocal enabledelayedexpansion
rem Tailライクコマンドの各種ワンライナーです。

set basedir=%~dp0
set basename=%~n0
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
set inpath=.\Data\Sample.txt
set num=3
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
rem @echo on

rem Windows標準コマンド
rem 実装方法が思い浮かばない。

rem PowerShell 2.0
set outpath=%outdir%\%basename%_ps2.txt
powershell -Command "(Get-Content %inpath%)[-%num%..-1]" > %outpath%
rem Check
rem fc %inpath% %outpath%

rem PowerShell 3.0以上
set outpath=%outdir%\%basename%_ps3.txt
powershell -Command "Get-Content %inpath% -Tail %num%" > %outpath%
rem Check
rem fc %inpath% %outpath%

@echo off
rem 後処理
start %winmerge% %outdir%\%basename%_ps3.txt %outdir%\%basename%_ps2.txt



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
