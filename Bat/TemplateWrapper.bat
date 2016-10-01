@echo off
rem Windowsバッチファイルを呼び出します。

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set mainname=%basename:Wrapper=%
set logpath=%CD%\%mainname%.log

set /p input=開始してよろしいですか？ (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" exit /b 1

echo ログ：%logpath%
call "%basedir%\%mainname%.bat" %1 %2 %3 %4 %5 %6 %7 %8 %9 > "%logpath%" 2>&1

pause
exit /b 0
