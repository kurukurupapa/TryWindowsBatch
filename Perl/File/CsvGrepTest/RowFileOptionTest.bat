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

echo TEST fileで行抽出（ASCII文字）
perl %mainpath% --file %indir%\Grep.txt %indir%\Normal.csv > %workdir%\File_Ascii_Result.csv
findstr "^[be]," %indir%\Normal.csv > %workdir%\File_Ascii_Expectation.csv
call :check %workdir%\File_Ascii_Expectation.csv %workdir%\File_Ascii_Result.csv
if errorlevel 1 ( goto :ERROR )

echo TEST fileで行抽出（日本語）
perl %mainpath% --column 5 --file %indir%\Grep日本語.txt %indir%\Normal.csv > %workdir%\File_Ja_Result.csv
findstr "^[ac]," %indir%\Normal.csv > %workdir%\File_Ja_Expectation.csv
call :check %workdir%\File_Ja_Expectation.csv %workdir%\File_Ja_Result.csv
if errorlevel 1 ( goto :ERROR )

echo TEST fileで行抽出（対象なし）
perl %mainpath% --file %indir%\GrepZero.txt %indir%\Normal.csv > %workdir%\File_Zero_Result.csv
type nul > %workdir%\File_Zero_Expectation.csv
call :check %workdir%\File_Zero_Expectation.csv %workdir%\File_Zero_Result.csv
if errorlevel 1 ( goto :ERROR )

echo TEST fileで存在しないカラム
perl %mainpath% --column 6 --file %indir%\Grep.txt %indir%\Normal.csv > %workdir%\File_NoColumn_Result.csv
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

:check
fc %1 %2 > %tmplog%
set result=%errorlevel%
if %result% neq 0 (
  type %tmplog%
)
exit /b %result%

:EOF
