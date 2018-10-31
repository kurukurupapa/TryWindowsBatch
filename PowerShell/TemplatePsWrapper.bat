@echo off
rem PowerShellスクリプトを呼び出します。

set basedir=%~dp0
set basename=%~n0
set batdir=%~dp0
set batname=%~n0%~x0
set mainname=%basename:PsWrapper=%
set mainpsname=%mainname%.ps1
set logpath=%CD%\%mainname%.log

set /p input=開始してよろしいですか？ (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" exit /b 1

echo ログ：%logpath%
type nul > "%logpath%"

rem 引数をまとめて渡す場合
powershell "%basedir%\%mainpsname%" %* >> "%logpath%" 2>&1

rem 引数を1つずつ渡す場合
rem if "%~1"=="" (
rem   powershell "%basedir%\%mainpsname%" >> "%logpath%" 2>&1
rem ) else (
rem   for %%a in (%*) do (
rem     powershell "%basedir%\%mainpsname%" "%%~a" >> "%logpath%" 2>&1
rem   )
rem )

rem 引数のフォルダを展開して渡す場合
rem if "%~1"=="" (
rem   powershell "%basedir%\%mainpsname%" >> "%logpath%" 2>&1
rem ) else (
rem   for %%a in (%*) do (
rem     for /F "usebackq delims=" %%f in (`dir /b /s /a-d /on "%%~a"`) do (
rem       powershell "%basedir%\%mainpsname%" "%%f" >> "%logpath%" 2>&1
rem     )
rem   )
rem )

type "%logpath%"

pause
exit /b 0
