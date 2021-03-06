@echo off
@setlocal enabledelayedexpansion
rem headコマンドライクの各種ワンライナーです。

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
set /a index=%num%-1
set outdir=%CD%
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\head -n %num% %inpath% > %outpath%
rem Check
copy %outpath% %outdir%\%basename%_ok.txt > nul

rem Windows標準コマンド for文1
rem 空行は読み飛ばされる。
rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
rem 全行を読み込むのでパフォーマンス悪い。
rem 下記コマンドをコマンドラインから実行する場合、for文の変数の頭「%%」は「%」とする。
set outpath=%outdir%\%basename%_for1.txt
set i=0 & (for /f "delims= eol=" %%a in (%inpath%) do ( if !i! lss %num% (echo %%a) & set /a i=!i!+1 )) > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem PowerShell 2.0
rem 全行を読み込むのでパフォーマンス悪い。
set outpath=%outdir%\%basename%_ps_array.txt
powershell -Command "(Get-Content %inpath%)[0..%index%]" > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem PowerShell 2.0
rem 全行を読み込むのでパフォーマンス悪い。
set outpath=%outdir%\%basename%_ps_select.txt
powershell -Command "Get-Content %inpath% | Select-Object -First %num%" > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem PowerShell 3.0以上
set outpath=%outdir%\%basename%_ps_cat.txt
powershell -Command "Get-Content %inpath% -Head %num%" > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem Perl
set outpath=%outdir%\%basename%_perl.txt
perl -ne "print if 1..%num%" %inpath% > %outpath%
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
