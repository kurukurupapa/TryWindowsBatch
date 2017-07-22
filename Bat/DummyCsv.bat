@echo off
@setlocal enabledelayedexpansion
rem ダミーのCSVファイルを作成します。
rem DummyCsv.bat 100000 > dummy_10MB.csv
rem DummyCsv.bat 1000000 > dummy_100MB.csv

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%~1"==""   set help=1
if "%~1"=="/?" set help=1
if "%help%"=="1" (
  echo 使い方：%batname% [/?] 行数
  exit /b 0
)
set numline=%1

:MAIN
call :LOG 処理開始します。



set char50=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
for /L %%i in (1,1,%numline%) do (
  set /a number=!RANDOM!
  rem set /a number=!RANDOM!*10000/32768
  echo %%i,0123456789,"abcde","ABCDE","日本語テキスト",!number!,%char50%
  set /a tmp=%%i%%10000
  if !tmp!==0 (
    call :LOG %%i
  )
)



:END
call :LOG 正常終了です。
exit /b 0

:ERROR
echo 異常終了です。
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:EOF
