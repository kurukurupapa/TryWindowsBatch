@echo off
@setlocal enabledelayedexpansion
rem sedコマンドライクの各種ワンライナーです。

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
set before=abc
set after=_abc_
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\sed "s/%before%/%after%/g" %inpath% > %outpath%
rem Check
copy %outpath% %outdir%\%basename%_ok.txt > nul

rem Windows標準コマンド for文
rem Windowsバッチファイルでは、記号「%」を「%%」へエスケープが必要。
rem 空行は読み飛ばされる。
set outpath=%outdir%\%basename%_for1.txt
(for /f "delims= eol=" %%a in (%inpath%) do @((set v=%%a) & (echo !v:%before%=%after%!))) > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem PowerShell
rem Windowsバッチファイルでは、記号「%」を「%%」へエスケープが必要。
rem エイリアス cat -> Get-Content
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | %%{ $_ -Replace '%before%', '%after%' } | Out-File -Encoding Default %outpath%"
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
