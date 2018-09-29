@echo off
@setlocal enabledelayedexpansion
rem 各種ひな形ファイルを生成します。

set basedir=%~dp0
set basename=%~n0
set batdir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
set debug=0
if "%~1"==""   set help=1
if "%~1"=="/?" set help=1
set type=%1
set inpath=%batdir%\%basename%.ini
set outdir=%CD%

:MAIN
call :LOG 処理開始します。
if "%help%"=="1" (
  call :HELP
) else (
  call :PROC
)
goto :END


:HELP
echo 使い方：%batname% [/?] type
echo type:
for /f "tokens=1,2 delims== eol=;" %%a in (%inpath%) do (
  set tmp=%%a
  if "!tmp:~0,1!!tmp:~-1,1!"=="[]" (
    rem セクションの場合
    set sec=!tmp:~1,-1!
    echo !sec!
  )
)
exit /b 0


:PROC
set sec=
for /f "tokens=1,2 delims== eol=;" %%a in (%inpath%) do (
  set tmp=%%a
  if "!tmp:~0,1!!tmp:~-1,1!"=="[]" (
    rem セクションの場合
    set sec=!tmp:~1,-1!
  ) else (
    rem キーバリューの場合
    set key=%%a
    set val=%%b

    rem 対象であれば実行する
    if "!sec!"=="%type%" (
      echo !val!
      !val!
    )
  )
)
exit /b 0


:END
call :LOG 正常終了です。
exit /b 0

:ERROR
call :LOG 異常終了です。
exit /b 1

:LOG
if "%debug%"=="1" (
  echo %DATE% %TIME% %basename% %1 1>&2
)
exit /b 0

:EOF
