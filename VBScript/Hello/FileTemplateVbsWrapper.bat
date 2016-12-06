@echo off
rem VBScriptを呼び出します。

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set mainname=%basename:VbsWrapper=%
set logpath=%CD%\%mainname%.log

set /p input=開始してよろしいですか？ (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" exit /b 1

echo ログ：%logpath%
type nul > %logpath%
for %%a in (%*) do (
  cscript //Nologo "%basedir%\%mainname%.vbs" %%a >> "%logpath%" 2>&1
)

pause
exit /b 0
