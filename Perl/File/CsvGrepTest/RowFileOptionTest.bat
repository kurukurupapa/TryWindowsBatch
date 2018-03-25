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
rem set mainname=%basename:Test=%
set mainname=csvgrep
set mainpath=%basedir%\..\%mainname%.pl
set indir=%basedir%\Input
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
set tmppath=%workdir%\%basename%.log
if not exist %workdir% ( mkdir %workdir% )

echo TEST rowfileで行抽出（ASCII文字）
perl %mainpath% --rowfile 1=%indir%\Grep.txt %indir%\Normal.csv > %workdir%\RowFile_Ascii_Result.csv
%gnubin%\grep -E "^[be]," %indir%\Normal.csv > %workdir%\RowFile_Ascii_Expectation.csv
fc %workdir%\RowFile_Ascii_Expectation.csv %workdir%\RowFile_Ascii_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

REM echo TEST rowfileで行抽出（日本語）
REM perl %mainpath% --rowfile 5=%indir%\Grep日本語.txt %indir%\Normal.csv > %workdir%\RowFile_Ja_Result.csv
REM perl %mainpath% --rowfile 5=%indir%\GrepJa.txt %indir%\Normal.csv > %workdir%\RowFile_Ja_Result.csv
REM %gnubin%\grep -E "(あいうえお|さしすせそ)" %indir%\Normal.csv > %workdir%\RowFile_Ja_Expectation.csv
REM fc %workdir%\RowFile_Ja_Expectation.csv %workdir%\RowFile_Ja_Result.csv > nul
REM if errorlevel 1 ( goto :ERROR )

echo TEST rowfileで行抽出（対象なし）
perl %mainpath% --rowfile 1=%indir%\GrepZero.txt %indir%\Normal.csv > %workdir%\RowFile_Zero_Result.csv
type nul > %workdir%\RowFile_Zero_Expectation.csv
fc %workdir%\RowFile_Zero_Expectation.csv %workdir%\RowFile_Zero_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowfileで存在しないカラム
perl %mainpath% --rowfile 999=%indir%\Grep.txt %indir%\Normal.csv > %workdir%\RowFile_NoColumn_Result.csv
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
