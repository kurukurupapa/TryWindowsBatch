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

echo TEST ヘルプ
perl %mainpath% -h > %tmppath%
fc %expdir%\Usage.txt %tmppath% > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 標準入力、標準出力
perl %mainpath% < %indir%\Normal.csv > %workdir%\stdinout_result.csv
fc %indir%\Normal.csv %workdir%\stdinout_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 入力パス指定
perl %mainpath% %indir%\Normal.csv > %workdir%\inpath_result.csv
fc %indir%\Normal.csv %workdir%\inpath_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 入力パス指定（日本語あり）
perl %mainpath% %indir%\日本語.csv > %workdir%\inpath_ja_result.csv
fc %indir%\日本語.csv %workdir%\inpath_ja_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 入力パス指定（ファイルなしエラー）
perl %mainpath% %indir%\xxx.csv > %workdir%\inerrpath_result.csv
if %errorlevel% equ 0 ( goto :ERROR )

echo TEST 出力パス指定
perl %mainpath% -o %workdir%\outpath_result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\outpath_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 出力パス指定（日本語あり）
perl %mainpath% -o %workdir%\outpath_日本語_result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\outpath_日本語_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 出力パス指定（ファイル書き込みエラー）
perl %mainpath% -o %workdir% < %indir%\Normal.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST rowstringで行抽出（ASCII文字）
perl %mainpath% --rowstring 1=b %indir%\Normal.csv > %workdir%\rowstring_result.csv
%gnubin%\grep -E "^b," %indir%\Normal.csv > %workdir%\rowstring_expectation.csv
fc %workdir%\rowstring_expectation.csv %workdir%\rowstring_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstringで行抽出（日本語）
perl %mainpath% --rowstring 5=さしすせそ %indir%\Normal.csv > %workdir%\rowstring_ja_result.csv
%gnubin%\grep さしすせそ %indir%\Normal.csv > %workdir%\rowstring_ja_expectation.csv
fc %workdir%\rowstring_ja_expectation.csv %workdir%\rowstring_ja_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstringで行抽出（対象なし）
perl %mainpath% --rowstring 1=xxx %indir%\Normal.csv > %workdir%\rowstring_zero_result.csv
%gnubin%\grep xxx %indir%\Normal.csv > %workdir%\rowstring_zero_expectation.csv
fc %workdir%\rowstring_zero_expectation.csv %workdir%\rowstring_zero_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstringで存在しないカラム
perl %mainpath% --rowstring 0=xxx,1=b,999=xxx %indir%\Normal.csv > %workdir%\rowstring_nocolumn_result.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST rowfileで行抽出（ASCII文字）
perl %mainpath% --rowfile 1=%indir%\Grep.txt %indir%\Normal.csv > %workdir%\rowfile_result.csv
%gnubin%\grep -E "^[be]," %indir%\Normal.csv > %workdir%\rowfile_expectation.csv
fc %workdir%\rowfile_expectation.csv %workdir%\rowfile_result.csv > nul
if errorlevel 1 ( goto :ERROR )

REM echo TEST rowfileで行抽出（日本語）
REM perl %mainpath% --rowfile 5=%indir%\Grep日本語.txt %indir%\Normal.csv > %workdir%\rowfile_ja_result.csv
REM perl %mainpath% --rowfile 5=%indir%\GrepJa.txt %indir%\Normal.csv > %workdir%\rowfile_ja_result.csv
REM %gnubin%\grep -E "(あいうえお|さしすせそ)" %indir%\Normal.csv > %workdir%\rowfile_ja_expectation.csv
REM fc %workdir%\rowfile_ja_expectation.csv %workdir%\rowfile_ja_result.csv > nul
REM if errorlevel 1 ( goto :ERROR )

echo TEST rowfileで行抽出（対象なし）
perl %mainpath% --rowfile 1=%indir%\GrepZero.txt %indir%\Normal.csv > %workdir%\rowfile_zero_result.csv
type nul > %workdir%\rowfile_zero_expectation.csv
fc %workdir%\rowfile_zero_expectation.csv %workdir%\rowfile_zero_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowfileで存在しないカラム
perl %mainpath% --rowfile 999=%indir%\Grep.txt %indir%\Normal.csv > %workdir%\rowfile_nocolumn_result.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST 入力TSVファイル
perl %mainpath% --delimiter \t --rowstring 1=d %indir%\Normal.tsv > %workdir%\tsv_result.csv
%gnubin%\grep -E "^d" %indir%\Normal.tsv > %workdir%\tsv_expectation.csv
fc %workdir%\tsv_expectation.csv %workdir%\tsv_result.csv > nul
if errorlevel 1 ( goto :ERROR )

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
