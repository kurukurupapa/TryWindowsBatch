@echo off
@setlocal enabledelayedexpansion
rem Splitライクコマンドの各種ワンライナーです。

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
set inpath=%basedir%\Data\Sample.txt
set incsv=%basedir%\Data\Sample.csv
set num=20
set outdir=%basedir%\Work
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
set PATH=%PATH%;D:\Apps\gnuwin32\bin
rem @echo on

rem --- 行数でファイル分割

rem GnuWin32
@set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
split -l %num% %inpath% %outprefix%
rem Check
dir %outprefix%*

rem Windows標準コマンド
rem 標準コマンドでは実現できない？

rem PowerShell
@rem エイリアス cat -> Get-Content
@set outprefix=%outdir%\%basename%_line_ps_
powershell -Command "$i=0; cat %inpath% -ReadCount %num% | %%{ $path='%outprefix%'+([string]($i+1)).PadLeft(3,'0')+'.txt'; Set-Content -Value $_ $path; $i++ }"
rem Check
dir %outprefix%*

rem --- キーワードでファイル分割

rem GnuWin32
@rem 1行目のヘッダ行を読み飛ばした。
@rem 指定カラムを文字列編集してファイル名の一部とした。
@set outprefix=%outdir%\%basename%_key_gnuwin32_
@set outprefix2=%outprefix:\=\\%
@del /q %outprefix%*
awk -F "," "NR>1 {tmp=$3; gsub(\"Group\",\"\",tmp); path=\"%outprefix2%\" tmp \".csv\"; print $0 >> path}" %incsv%
rem Check
dir %outprefix%*

rem PowerShell
@rem エイリアス cat -> Get-Content
@set outprefix=%outdir%\%basename%_key_ps_
@del /q %outprefix%*
powershell -Command "cat %incsv% | Select-Object -Skip 1 | %%{ $tmp=$_.Split(',')[2].Replace('Group',''); $path='%outprefix%'+$tmp+'.csv'; $_ | Out-File -Append -Encoding Default $path }"
rem Check
dir %outprefix%*

@echo off
rem 後処理
fc %outdir%\%basename%_key_gnuwin32_A.csv %outdir%\%basename%_key_ps_A.csv



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
