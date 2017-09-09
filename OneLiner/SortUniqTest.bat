@echo off
@setlocal enabledelayedexpansion
rem Sort,Uniqライクコマンドの各種ワンライナーです。

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
set inpath=%basedir%\Data\Sample.txt
set outdir=%basedir%\Work
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
@echo on

rem Windows標準コマンド
@set outpath=%outdir%\%basename%_sort_for1.txt
set p= & (for /f "delims= eol=" %%a in ('sort %inpath%') do @(if not "%p%"=="%%a" (echo %%a) & set p=%%a)) > %outpath%

rem PowerShell
@rem エイリアス cat -> Get-Content, sort -> Sort-Object
@set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | sort | Get-Unique" > %outpath%

@rem 後処理
@echo off
start %winmerge% %outdir%\%basename%_sort_for1.txt %outdir%\%basename%_ps.txt



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
