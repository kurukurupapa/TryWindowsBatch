@echo off
rem 設定ファイルです。
rem 外部バッチファイルから呼び出され、変数定義するので、「setlocal enabledelayedexpansion」は記述なし。

:INIT

:MAIN
call :LOG 処理開始します。

set prjdir=%basedir%\..
set datadir=%basedir%\Data
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
set performancedir=%TMP%\TryWindowsBatch\OneLiner
set gnubin=D:\Apps\gnuwin32\bin
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
if not exist %workdir% ( mkdir %workdir% )
if not exist %performancedir% ( mkdir %performancedir% )

:END
call :LOG 正常終了です。
exit /b 0

:ERROR
echo 異常終了です。
exit /b 1

:LOG
echo %DATE% %TIME% 設定ファイル %1 1>&2
exit /b 0

:EOF
