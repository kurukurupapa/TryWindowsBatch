@echo off
@setlocal enabledelayedexpansion
rem splitコマンドライクの各種ワンライナーです。（パフォーマンステスト）

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
set inpath=%performancedir%\dummy_100MB.csv
set num=100000
set inpath_small=%performancedir%\dummy_1MB.csv
set num_small=10000
set outdir=%performancedir%
rem echo on

rem --- 行数でファイル分割
rem パフォーマンス測定事例
rem   データ：100万行、100MB、パソコン：Intel Atom 1.44GHz メモリ2GB ストレージeMMC
rem     0.2分 GnuWin32
rem     0.3分 PowerShell
rem   データ：1万行、1MB、パソコン：Intel Atom 1.44GHz メモリ2GB ストレージeMMC
rem     0.3分 Windows標準コマンド for文1

rem GnuWin32
set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
echo %DATE% %TIME% GnuWin32 START %inpath%
set start=%DATE% %TIME%
%gnubin%\split -l %num% %inpath% %outprefix%
set end=%DATE% %TIME%
echo %DATE% %TIME% GnuWin32 END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'分'"
rem Check
rem dir %outprefix%*

rem Windows標準コマンド for文1
set outprefix=%outdir%\%basename%_line_for1_
if exist %outprefix%* ( del /q %outprefix%* )
echo %DATE% %TIME% Windows標準コマンドfor文1 START %inpath_small%
set start=%DATE% %TIME%
set i=0 & set j=0 & (for /f "delims= eol=" %%a in (%inpath_small%) do (set /a tmp=!i! %% %num_small% & (if !tmp!==0 (set /a j=!j!+1)&(set jstr=00!j!)&(set jstr=!jstr:~-3!)) & (echo %%a)>>%outprefix%!jstr!.txt & set /a i=!i!+1))
set end=%DATE% %TIME%
echo %DATE% %TIME% Windows標準コマンドfor文1 END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'分'"
rem Check
rem dir %outprefix%*

rem PowerShell
set outprefix=%outdir%\%basename%_line_ps_
echo %DATE% %TIME% PowerShell START %inpath%
set start=%DATE% %TIME%
powershell -Command "$i=0; cat %inpath% -ReadCount %num% | %%{ Set-Content -Value $_ ('%outprefix%'+([string]($i+1)).PadLeft(3,'0')+'.txt'); $i++ }"
set end=%DATE% %TIME%
echo %DATE% %TIME% PowerShell END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'分'"
rem Check
rem dir %outprefix%*


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
