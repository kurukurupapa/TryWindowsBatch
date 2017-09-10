@echo off
@setlocal enabledelayedexpansion
rem Sedライクコマンドの各種ワンライナーです。（パフォーマンステスト）

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
set inpath=.\dummy_100MB.csv
set outdir=%CD%
set before=abc
set after=_abc_
set PATH=%PATH%;D:\Apps\gnuwin32\bin
rem @echo on

rem GnuWin32
@set outpath=%outdir%\%basename%_gnuwin32.txt
@echo %DATE% %TIME% GnuWin32 START
sed "s/%before%/%after%/g" %inpath% > %outpath%
@echo %DATE% %TIME% GnuWin32 END

rem Windows標準コマンド for文1
@rem Windowsバッチファイルでは、記号「%」を「%%」へエスケープが必要。
@rem 空行は読み飛ばされる。
@set outpath=%outdir%\%basename%_for1.txt
@echo %DATE% %TIME% Windows標準コマンドfor文1 START
(for /f "delims= eol=" %%a in (%inpath%) do @((set v=%%a) & (echo !v:%before%=%after%!))) > %outpath%
@echo %DATE% %TIME% Windows標準コマンドfor文1 END

rem PowerShell
@rem Windowsバッチファイルでは、記号「%」を「%%」へエスケープが必要。
@rem エイリアス cat -> Get-Content
@set outpath=%outdir%\%basename%_ps.txt
@echo %DATE% %TIME% PowerShell START
powershell -Command "cat %inpath% | %% { $_ -Replace '%before%', '%after%' }" > %outpath%
@echo %DATE% %TIME% PowerShell END

@rem 後処理
@echo off



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
