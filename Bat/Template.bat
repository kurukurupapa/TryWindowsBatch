@echo off
rem Windowsバッチファイルのテンプレートです。

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%1"=="" goto USAGE
if "%1"=="/?" goto USAGE
set /p input=開始してよろしいですか？ (y/n[y])
if "%input%"=="" set input=y
if not "%input%"=="y" goto EOF

:MAIN
call :LOG 処理開始します。



rem <<< ここに処理を書きます >>>



:END
call :LOG 正常終了です。
pause
exit /b 0

:USAGE
echo 使い方：%batname%
exit /b 0

:ERROR
echo エラー終了です。
exit /b -1

:LOG
echo %DATE% %TIME% %basename% %1
exit /b 0

:EOF
