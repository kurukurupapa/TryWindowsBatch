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
echo performancedir=%performancedir%
rem echo on

rem --- 各行のハッシュ値でファイル分割
rem パフォーマンス測定事例
rem   データ：100万行、100MB、パソコン：Intel Atom 1.44GHz メモリ2GB ストレージeMMC
rem     PowerShell 方式1   2.3～2.4分
set incsv=%performancedir%\dummy_100MB.csv
echo %incsv%

rem PowerShell 方式1
set outprefix=%performancedir%\%basename%_ps1_
set block=100000
set start=%DATE% %TIME%
powershell -Command "cat %incsv% -ReadCount %block% | %%{ $hash=@{}; $_ | %%{ $k=$_.GetHashCode() %% 50 + 50; if(-Not $hash.ContainsKey($k)){ $hash[$k]=[Collections.ArrayList]@() }; $hash[$k].Add($_)>$null }; foreach($k in $hash.Keys){ Out-File -Append -Encoding Default -InputObject $hash[$k] ('%outprefix%'+$k+'.csv') }}"
set end=%DATE% %TIME%
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.0')+'分 PowerShell 方式1'"

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
