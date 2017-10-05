@echo off
@setlocal enabledelayedexpansion
rem lsコマンドライクの各種ワンライナーです。

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
set indir=%batdir:~0,-1%\Data
set outdir=%CD%
rem echo on

rem GnuWin32
rem GnuWin32 ファイル名のみ
set outpath=%outdir%\%basename%_gnuwin32_path.txt
%gnubin%\ls -dR %indir%\* > %outpath%
rem GnuWin32 付加情報付き
set outpath=%outdir%\%basename%_gnuwin32_info.txt
%gnubin%\ls -ldR %indir%\* > %outpath%

rem Windows標準コマンド for文
rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
rem 下記コマンドをコマンドラインから実行する場合、for文の変数の頭「%%」は「%」とする。
rem Windows標準コマンド for文 ファイル名のみ
set outpath=%outdir%\%basename%_for_path.txt
(for /f "delims= eol=" %%a in ('dir /s /b %indir%') do (set v=%%a & if not "!v:~0,1!"==" " (if "!v:<DIR>=!"=="!v!" echo %%a))) > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_path.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_path.txt %outpath%)

rem Windows標準コマンド for文 付加情報付き
rem 実装が難しそう。

rem Windows標準コマンド forfiles
rem 先頭に空行が出力されてしまうので、findstrで除去しています。
rem Windows標準コマンド forfiles ファイル名のみ
set outpath=%outdir%\%basename%_forfiles_path.txt
forfiles -s -p %indir% -c "cmd /c echo @path" | findstr "." > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_path.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_path.txt %outpath%)

rem Windows標準コマンド forfiles 付加情報付き
set outpath=%outdir%\%basename%_forfiles_info.txt
forfiles -s -p %indir% -c "cmd /c echo @fdate,@fsize,DIR=@isdir,@path" | findstr "." > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_info.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_info.txt %outpath%)

rem PowerShell
rem PowerShell ファイル名のみ
set outpath=%outdir%\%basename%_ps_path.txt
powershell -Command "ls -Recurse %indir% | %%{$_.FullName}" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_path.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_path.txt %outpath%)

rem PowerShell 付加情報付き
set outpath=%outdir%\%basename%_ps_info.txt
powershell -Command "ls -Recurse %indir% | %%{$_.LastWriteTime.ToString('yyyy/MM/dd HH:mm:ss')+','+$_.Length+','+$_.Attributes+','+$_.FullName}" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_info.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_info.txt %outpath%)

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
