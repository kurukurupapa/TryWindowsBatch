@echo off
@setlocal enabledelayedexpansion
rem パフォーマンステストの準備をします。

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
rem if "%~1"=="/?" set help=1
rem if "%help%"=="1" (
rem   echo 使い方：%batname% [/?]
rem   exit /b 0
rem )

:MAIN
call :LOG 処理開始します。



rem 準備
call %batdir%\Setting.bat
rem echo on

set start=%DATE% %TIME%
call %prjdir%\Bat\DummyCsv.bat 10000 > %performancedir%\dummy_1MB.csv
set end=%DATE% %TIME%
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.0')+'分（'+$t.TotalSeconds.ToString('0.0')+'秒）'"

set start=%DATE% %TIME%
call %prjdir%\Bat\DummyCsv.bat 100000 > %performancedir%\dummy_10MB.csv
set end=%DATE% %TIME%
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.0')+'分（'+$t.TotalSeconds.ToString('0.0')+'秒）'"

set start=%DATE% %TIME%
call %prjdir%\Bat\DummyCsv.bat 1000000 > %performancedir%\dummy_100MB.csv
set end=%DATE% %TIME%
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.0')+'分（'+$t.TotalSeconds.ToString('0.0')+'秒）'"

rem 後処理
echo off



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
