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

echo TEST 標準入力、標準出力
perl %mainpath% < %indir%\Normal.csv > %workdir%\StdInOut_Result.csv
fc %indir%\Normal.csv %workdir%\StdInOut_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 入力パス指定
perl %mainpath% %indir%\Normal.csv > %workdir%\InPath_Result.csv
fc %indir%\Normal.csv %workdir%\InPath_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 入力パス指定（日本語あり）
perl %mainpath% %indir%\日本語.csv > %workdir%\InPathJa_Result.csv
fc %indir%\日本語.csv %workdir%\InPathJa_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 入力パス指定（ファイルなしエラー）
perl %mainpath% %indir%\xxx.csv > %workdir%\InErrPath_Result.csv
if %errorlevel% equ 0 ( goto :ERROR )

echo TEST 出力パス指定
perl %mainpath% -o %workdir%\OutPath_Result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\OutPath_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 出力パス指定（日本語あり）
perl %mainpath% -o %workdir%\OutPath日本語_Result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\OutPath日本語_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST 出力パス指定（ファイル書き込みエラー）
perl %mainpath% -o %workdir% < %indir%\Normal.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST 入力TSVファイル
perl %mainpath% --delimiter \t --string d %indir%\Normal.tsv > %workdir%\Tsv_Result.csv
findstr "^d" %indir%\Normal.tsv > %workdir%\Tsv_Expectation.csv
fc %workdir%\Tsv_Expectation.csv %workdir%\Tsv_Result.csv > %tmplog%
if errorlevel 1 (
  echo perl %mainpath% --delimiter \t --string d %indir%\Normal.tsv
  type %tmplog%
  goto :ERROR
)

echo TEST invertオプション
perl %mainpath% --invert --string b %indir%\Normal.csv > %workdir%\Invert_Result.csv
findstr /v "^b," %indir%\Normal.csv > %workdir%\Invert_Expectation.csv
fc %workdir%\Invert_Expectation.csv %workdir%\Invert_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST unmatchオプション
perl %mainpath% --string b %indir%\Normal.csv --unmatch %workdir%\Unmatch_Result2.csv > %workdir%\Unmatch_Result1.csv
findstr    "^b," %indir%\Normal.csv > %workdir%\Unmatch_Expectation1.csv
findstr /v "^b," %indir%\Normal.csv > %workdir%\Unmatch_Expectation2.csv
fc %workdir%\Unmatch_Expectation1.csv %workdir%\Unmatch_Result1.csv > nul
if errorlevel 1 ( goto :ERROR )
fc %workdir%\Unmatch_Expectation2.csv %workdir%\Unmatch_Result2.csv > nul
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
