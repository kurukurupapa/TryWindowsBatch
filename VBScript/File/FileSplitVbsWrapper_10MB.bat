@echo off
rem VBScriptを呼び出します。

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set mainname=FileSplit
set logpath=%CD%\%mainname%.log

rem set /p input=開始してよろしいですか？ (y/n[y])
rem if "%input%"=="" set input=y
rem if not "%input%"=="y" exit /b 1

echo ログ：%logpath%
type nul > "%logpath%"
if "%1"=="" (
  cscript //Nologo "%basedir%\%mainname%.vbs" >> "%logpath%" 2>&1
) else (
  for %%a in (%*) do (
    cscript //Nologo "%basedir%\%mainname%.vbs" 10485760 %%a >> "%logpath%" 2>&1
  )
)
type "%logpath%"

rem pause
exit /b 0
