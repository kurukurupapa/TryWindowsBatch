@echo off
@setlocal enabledelayedexpansion
rem Windowsバッチファイルのテンプレートです。

set basedir=%~dp0
set basename=%~n0
set batdir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%~1"==""   set help=1
if "%~1"=="/?" set help=1
if "%help%"=="1" (
  echo 使い方：%batname% [/?]
  exit /b 0
)

:MAIN
call :LOG 処理開始します。



rem ▼▼▼ここに処理を書きます
echo basedir=%basedir%
echo basename=%basename%
echo batdir=%batdir%
echo batname=%batname%
echo timestamp=%timestamp%
set /a count=0
for %%a in (%*) do (
  set /a count+=1
  echo 引数[!count!]="%%~a"
)
rem for文の使い方
for %%f in (.\*.*) do (
  echo %%f
)
for /L %%i in (1,1,3) do (
  echo %%i
)
rem ▲▲▲ここに処理を書きます



:END
call :LOG 正常終了です。
exit /b 0

:ERROR
call :LOG 異常終了です。
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:EOF
