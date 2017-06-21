@echo off
@setlocal enabledelayedexpansion
rem テストします。

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%~1"=="/?" (
  echo 使い方：%batname% [/?]
  exit /b 0
)

:MAIN
call :LOG 処理開始します。



rem ▼▼▼ここに処理を書きます
set prjdir=%basedir%\..
set sut=%prjdir%\%basename:Test=%.bat
set datadir=%prjdir%\Data

call :LOG ---引数なし
call %sut%
call :LOG ---ヘルプ
call %sut% "/?"
call :LOG ---1ファイル
call %sut% %datadir%\Dummy.txt
call :LOG ---1ファイル（空白あり）
call %sut% "%datadir%\Space Dir\Space File.txt"
call :LOG ---複数ファイル
call %sut% %datadir%\Dummy.txt %datadir%\Dummy2.txt %datadir%\Dummy3.txt
rem ▲▲▲ここに処理を書きます



:END
call :LOG 正常終了です。
exit /b 0

:ERROR
echo 異常終了です。
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1
exit /b 0

:EOF
