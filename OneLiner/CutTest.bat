@echo off
@setlocal enabledelayedexpansion
rem cutコマンドライクの各種ワンライナーです。

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
set inpath=%batdir%\Data\Sample.csv
set outdir=%CD%
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\cut -d "," -f 1-2,4 %inpath% > %outpath%

rem Windows標準コマンド for文
rem 注意事項
rem 空行は読み飛ばされる。
rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
rem 下記コマンドをコマンドラインから実行する場合、for文の変数の頭「%%」は「%」とする。
set outpath=%outdir%\%basename%_for.txt
(for /f "delims=, tokens=1-2,4 eol=" %%a in (%inpath%) do (echo %%a,%%b,%%c)) > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem PowerShell
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | %%{ $arr=$_.Split(','); $arr[0]+','+$arr[1]+','+$arr[3] }" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem Perl
set outpath=%outdir%\%basename%_perl.txt
perl -aF, -ne "print \"$F[0],$F[1],$F[3]\n\"" %inpath% > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem Ruby
rem デフォルトの外部/内部エンコーディングはWindows-31Jの模様。そのため入力出力ファイルをWindows-31Jと見なす。
rem 必要ならrubyコマンドの-Eオプションでエンコーディングを指定する。
set outpath=%outdir%\%basename%_ruby.txt
ruby -aF, -ne "puts $F[0]+','+$F[1]+','+$F[3]" %inpath% > %outpath%
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
