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
if "%~1"==""   set help=1
if "%~1"=="/?" set help=1
if "%help%"=="1" (
  echo 使い方：%batname% [/?] type
  echo type - bat, vbs
  exit /b 0
)
set type=%1

:MAIN
call :LOG 処理開始します。



if "%type%"=="bat" (
  set inlist=%batdir%\..\Bat\Template.bat
  set inlist=!inlist! %batdir%\..\Bat\TemplateBatWrapper.bat
) else if "%type%"=="vbs" (
  set inlist=%batdir%\..\VBScript\Hello\Template.vbs
  set inlist=!inlist! %batdir%\..\VBScript\Hello\TemplateVbsWrapper.bat
)

for %%f in (!inlist!) do (
  if not exist %%f (
    call :LOG %%f が見つかりません。
    goto ERROR
  )
  copy %%f .
)



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
