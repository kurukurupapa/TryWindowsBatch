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
set inpath=.\dummy_10MB.csv
set column=6
set outdir=.
set PATH=%PATH%;D:\Apps\gnuwin32\bin
rem @echo on

rem --- キーワードでファイル分割

rem GnuWin32
@rem 1行目のヘッダ行を読み飛ばした。
@rem 指定カラムを文字列編集してファイル名の一部とした。
@set outprefix=%outdir%\%basename%_key_gnuwin32_
@set outprefix2=%outprefix:\=\\%
@del /q %outprefix%*
@echo %DATE% %TIME% GnuWin32 START
awk -F "," "NR>1 {tmp=$%column%; path=\"%outprefix2%\" tmp \".csv\"; print $0 >> path}" %inpath%
@echo %DATE% %TIME% GnuWin32 END
rem Check
rem dir %outprefix%*

rem PowerShell ファイル追記方式
@rem エイリアス cat -> Get-Content
@set outprefix=%outdir%\%basename%_key_ps_append_
@del /q %outprefix%*
@echo %DATE% %TIME% PowerShell ファイル追記方式 START
powershell -Command "cat %inpath% | Select-Object -Skip 1 | %%{ $tmp=$_.Split(',')[%column%-1]; $path='%outprefix%'+$tmp+'.csv'; $_ | Out-File -Append -Encoding Default $path }"
@echo %DATE% %TIME% PowerShell ファイル追記方式 END
rem Check
rem dir %outprefix%*

rem PowerShell ハッシュ方式
@rem エイリアス cat -> Get-Content
@set outprefix=%outdir%\%basename%_key_ps_hash_
@del /q %outprefix%*
@echo %DATE% %TIME% PowerShell ハッシュ方式 START
powershell -Command "$hash=@{}; cat %inpath% | Select-Object -Skip 1 | %%{ $key=$_.Split(',')[%column%-1]; if(-Not $hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_) > $null; }; foreach($k in $hash.Keys){ $path='%outprefix%'+$k+'.csv'; Set-Content -Value $hash[$k] $path }"
@echo %DATE% %TIME% PowerShell ハッシュ方式 END
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
