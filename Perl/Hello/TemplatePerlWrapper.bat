@echo off
rem Perlスクリプトを呼び出します。

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set mainname=%basename:PerlWrapper=%
set mainpath=%basedir%\%mainname%.pl
set logpath=%basedir%\%mainname%.log

set /p input=開始してよろしいですか？ (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" exit /b 1

echo ログ：%logpath%
type nul > "%logpath%"

rem 引数をまとめて渡す場合
perl "%mainpath%" %* >> "%logpath%" 2>&1

rem 引数を1つずつ渡す場合
rem if "%1"=="" (
rem   perl "%mainpath%" >> "%logpath%" 2>&1
rem ) else (
rem   for %%a in (%*) do (
rem     perl "%mainpath%" "%%a" >> "%logpath%" 2>&1
rem   )
rem )

rem 引数のフォルダを展開して渡す場合
rem if "%1"=="" (
rem   perl "%mainpath%" >> "%logpath%" 2>&1
rem ) else (
rem   for %%a in (%*) do (
rem     for /F "usebackq" %%f in (`dir /b /s /a-d /on "%%a"`) do (
rem       perl "%mainpath%" "%%f" >> "%logpath%" 2>&1
rem     )
rem   )
rem )

type "%logpath%"

pause
exit /b 0
