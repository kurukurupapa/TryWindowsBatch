@echo off
@setlocal enabledelayedexpansion
rem diffコマンドライクの各種ワンライナーです。
rem 一般的なテキストを比較

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
set inpath1=%batdir%\Data\Sample.txt
set inpath2=%batdir%\Data\Sample2.txt
set outdir=%workdir%
rem echo on

echo GnuWin32
set outpath=%outdir%\%basename%_text_gnuwin32.txt
%gnubin%\diff %inpath1% %inpath2% > %outpath%

echo Windows標準コマンド fcコマンド
set outpath=%outdir%\%basename%_text_fc.txt
fc %inpath1% %inpath2% > %outpath%
rem Check
call :CHECK %outdir%\%basename%_text_gnuwin32.txt %outpath%

echo PowerShell
set outpath=%outdir%\%basename%_text_ps.txt
powershell -Command "Compare-Object (cat %inpath1%) (cat %inpath2%) | %%{ $_.SideIndicator+' '+$_.InputObject }" > %outpath%
rem Check
call :CHECK %outdir%\%basename%_text_gnuwin32.txt %outpath%

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

:CHECK
fc %1 %2 > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %1 %2)
exit /b 0

:EOF
