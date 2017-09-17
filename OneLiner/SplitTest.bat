@echo off
@setlocal enabledelayedexpansion
rem splitコマンドライクの各種ワンライナーです。

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
set outdir=%CD%
rem echo on

rem --- 行数でファイル分割
set inpath=%batdir%\Data\Sample.txt
set num=20

rem GnuWin32
set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
%gnubin%\split -l %num% %inpath% %outprefix%
rem Check
dir %outprefix%*

rem Windows標準コマンド for文1
rem 空行は読み飛ばされる。
rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
rem ここでは、記号「%」を「%%」へエスケープしている。
set outprefix=%outdir%\%basename%_line_for1_
del /q %outprefix%* > nul
set i=0 & set j=0 & (for /f "delims= eol=" %%a in (%inpath%) do (set /a tmp=!i! %% %num% & (if !tmp!==0 (set /a j=!j!+1)&(set jstr=00!j!)&(set jstr=!jstr:~-3!)) & (echo %%a)>>%outprefix%!jstr!.txt & set /a i=!i!+1))
rem Check
dir %outprefix%*
fc %outdir%\%basename%_line_gnuwin32.txt.aa %outprefix%001.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_line_gnuwin32.txt.aa %outprefix%001.txt)

rem PowerShell
rem エイリアス cat -> Get-Content
set outprefix=%outdir%\%basename%_line_ps_
powershell -Command "$i=0; cat %inpath% -ReadCount %num% | %%{ Set-Content -Value $_ ('%outprefix%'+([string]($i+1)).PadLeft(3,'0')+'.txt'); $i++ }"
rem Check
dir %outprefix%*
fc %outdir%\%basename%_line_gnuwin32.txt.aa %outprefix%001.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_line_gnuwin32.txt.aa %outprefix%001.txt)

rem --- キーワードでファイル分割
set incsv=%batdir%\Data\Sample.csv
set column=3

rem GnuWin32
rem 1行目ヘッダ行を読み飛ばす。
set outprefix=%outdir%\%basename%_key_gnuwin32_
set outprefix2=%outprefix:\=\\%
del /q %outprefix%* > nul
%gnubin%\awk -F "," "NR>1 { print $0 >> \"%outprefix2%\" $%column% \".csv\" }" %incsv%
%gnubin%\awk -F "," "NR>1 { tmp=$%column%; gsub(\"Group\",\"\",tmp); print $0 >> \"%outprefix2%\" tmp \".csv\"}" %incsv%
rem Check
dir %outprefix%*

rem PowerShell ファイル追記方式
rem メモリをあまり使わないで処理できるが、かなり遅い。大きいファイルには向かない。
rem 1行目ヘッダ行を読み飛ばす。
set outprefix=%outdir%\%basename%_key_ps_append_
del /q %outprefix%* > nul
powershell -Command "cat %incsv% | Select-Object -Skip 1 | %%{ Out-File -Append -Encoding Default -InputObject $_ ('%outprefix%'+($_.Split(',')[%column%-1])+'.csv') }"
powershell -Command "cat %incsv% | Select-Object -Skip 1 | %%{ Out-File -Append -Encoding Default -InputObject $_ ('%outprefix%'+($_.Split(',')[%column%-1].Replace('Group',''))+'.csv') }"
rem Check
dir %outprefix%*
fc %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv)

rem PowerShell ハッシュ方式
rem 多くのメモリを使用して、ファイル書き込みを最適化。
rem 入力ファイルと同等のメモリを使用してしまうため、巨大ファイルには向かない。
rem もうワンライナーというレベルではなく、ちょっとしたプログラミングになっている。。。
rem 1行目ヘッダ行を読み飛ばす。
rem Windowsバッチファイルにおける特殊記号のエスケープ「!」→「^!」
set outprefix=%outdir%\%basename%_key_ps_hash_
powershell -Command "$hash=@{}; cat %incsv% | Select-Object -Skip 1 | %%{ $key=$_.Split(',')[%column%-1]; if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Set-Content -Value $hash[$k] ('%outprefix%'+$k+'.csv') }"
powershell -Command "$hash=@{}; cat %incsv% | Select-Object -Skip 1 | %%{ $key=$_.Split(',')[%column%-1].Replace('Group',''); if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Set-Content -Value $hash[$k] ('%outprefix%'+$k+'.csv') }"
rem Check
dir %outprefix%*
fc %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv)

rem PowerShell ファイル追記方式・ハッシュ方式のハイブリッド
rem メモリ使用量に制限を設けて、ファイル書き込みを最適化。巨大ファイルでも対応可能。
rem もうワンライナーというレベルではなく、ちょっとしたプログラミングになっている。。。
rem 1行目ヘッダ行の読み飛ばしを省略。
rem Windowsバッチファイルにおける特殊記号のエスケープ「!」→「^!」
set outprefix=%outdir%\%basename%_key_ps_hybrid_
set block=100000
del /q %outprefix%* > nul
powershell -Command "cat %incsv% -ReadCount %block% | %%{ $hash=@{}; $_ | %%{ $key=$_.Split(',')[%column%-1]; if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Out-File -Append -Encoding Default -InputObject $hash[$k] ('%outprefix%'+$k+'.csv') }}"
powershell -Command "cat %incsv% -ReadCount %block% | %%{ $hash=@{}; $_ | %%{ $key=$_.Split(',')[%column%-1].Replace('Group',''); if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Out-File -Append -Encoding Default -InputObject $hash[$k] ('%outprefix%'+$k+'.csv') }}"
rem Check
dir %outprefix%*
fc %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv)

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
