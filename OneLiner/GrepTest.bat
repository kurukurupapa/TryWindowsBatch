@echo off
@setlocal enabledelayedexpansion
rem Grepライクコマンド（テキストファイルの行抽出）の各種ワンライナーです。

set basedir=%~dp0
set basename=%~n0
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
rem 記号「^」は行連結文字。エスケープしたいときは「^」とする。
set inpath=.\Data\Sample.txt
set pattern=abc
set pattern2=サンプル
set pattern_space=a pen
set pattern_re=^^a.*z$
set pattern_re2=サ.*ル
set outdir=%basedir%\Work
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
@echo on

rem Windows標準コマンド
findstr %pattern% %inpath%
findstr "%pattern% %pattern2%" %inpath%
findstr /c:"%pattern_space%" %inpath%
findstr /r "%pattern_re% %pattern_re2%" %inpath%
@set outpath=%outdir%\%basename%_findstr_v.txt
findstr /v %pattern% %inpath% > %outpath%

rem PowerShell
@rem Select-Stringは入力ファイルをUTF-8として読み込む。SJISを読み込むにはGet-Contentを通す。
@rem エイリアス cat -> Get-Content
powershell -Command "cat %inpath% | Select-String -Pattern '%pattern_re%'"
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern%', '%pattern2%', '%pattern_space%') -SimpleMatch -CaseSensitive"
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern_re%', '%pattern_re2%')"
@set outpath=%outdir%\%basename%_ps_not.txt
powershell -Command "cat %inpath% | Select-String -Pattern %pattern_re% -NotMatch" > %outpath%

@echo off
rem 後処理
rem fc %winmerge% %outdir%\%basename%_findstr_v.txt %outdir%\%basename%_ps_not.txt



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
