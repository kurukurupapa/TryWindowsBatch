@echo off
@setlocal enabledelayedexpansion
rem INIファイル読み込みの練習です。

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
if "%~1"=="/?" set help=1
if "%help%"=="1" (
  echo 使い方：%batname% [/?]
  exit /b 0
)

:MAIN
call :LOG 処理開始します。


set inpath=%batdir%\%basename%.ini
set sec=
for /f "tokens=1,2 delims== eol=;" %%a in (%inpath%) do (
  set tmp=%%a
  if "!tmp:~0,1!!tmp:~-1,1!"=="[]" (
    rem セクションの場合
    set sec=!tmp:~1,-1!
    set key=
    set val=
  ) else (
    rem キーバリューの場合
    set key=%%a
    set val=%%b
  )
  rem 取得した値を出力してみる
  echo !sec!,!key!,!val!
  rem 環境変数に設定してみる
  set !sec!_!key!=!val!
)

rem 環境変数に設定した値を出力してみる
echo !Section1_Key11!


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
