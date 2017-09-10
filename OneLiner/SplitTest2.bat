@echo off
@setlocal enabledelayedexpansion
rem Splitライクコマンドの各種ワンライナーです。（パフォーマンステスト）

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
set inpath=.\dummy_1000MB.csv
set num=100000
set inpath_small=.\dummy_10MB.csv
set num_small=10000
set outdir=.
set PATH=%PATH%;D:\Apps\gnuwin32\bin
rem @echo on

rem --- 行数でファイル分割

rem GnuWin32
@set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
@echo %DATE% %TIME% GnuWin32 START
split -l %num% %inpath% %outprefix%
@echo %DATE% %TIME% GnuWin32 END
rem Check
rem dir %outprefix%*

rem Windows標準コマンド for文1
@rem 空行は読み飛ばされる。
@rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
@rem ここでは、記号「%」を「%%」へエスケープしている。
@set outprefix=%outdir%\%basename%_line_for1_
@del /q %outprefix%*
@echo 入力ファイル=%inpath_small%
@echo %DATE% %TIME% Windows標準コマンドfor文1 START
(set /a i=0)&(set /a j=0)&(for /f "delims= eol=" %%a in (%inpath_small%) do ((set /a tmp=!i! %% %num_small%)&(if !tmp!==0 (set /a j=!j!+1)&(set jstr=00!j!)&(set jstr=!jstr:~-3!))&((echo %%a)>>%outprefix%!jstr!.txt)&(set /a i=!i!+1)))
@echo %DATE% %TIME% Windows標準コマンドfor文1 END
rem Check
rem dir %outprefix%*

rem PowerShell
@rem エイリアス cat -> Get-Content
@set outprefix=%outdir%\%basename%_line_ps_
@echo %DATE% %TIME% PowerShell START
powershell -Command "$i=0; cat %inpath% -ReadCount %num% | %%{ $path='%outprefix%'+([string]($i+1)).PadLeft(3,'0')+'.txt'; Set-Content -Value $_ $path; $i++ }"
@echo %DATE% %TIME% PowerShell END
rem Check
rem dir %outprefix%*

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
