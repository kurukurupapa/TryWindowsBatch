@echo off
@setlocal enabledelayedexpansion
rem catコマンドライクの各種ワンライナーです。

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
set inpath=%batdir%\Data\Sample.txt
set outdir=%batdir%\Work
rem echo on


echo GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\cat %inpath% > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)


echo Windows標準コマンド typeコマンド
set outpath=%outdir%\%basename%_type.txt
type %inpath% > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

echo Windows標準コマンド for文1 簡易版
rem 各行は、空白またはタブで分割され、1つ目のトークンのみ出力される。
rem 「;」始まりの行はコメント行とみなされ読み飛ばされる。
rem 空行は読み飛ばされる。
rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
rem 下記コマンドをコマンドラインから実行する場合、for文の変数の頭「%%」は「%」とする。
set outpath=%outdir%\%basename%_for1.txt
(for /f %%a in (%inpath%) do (echo %%a)) > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

echo Windows標準コマンド for文2 改善版
rem トークン分割、コメント行判定を行わない。
rem 空行は読み飛ばされる。
rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
rem 下記コマンドをコマンドラインから実行する場合、for文の変数の頭「%%」は「%」とする。
set outpath=%outdir%\%basename%_for2.txt
(for /f "delims= eol=" %%a in (%inpath%) do (echo %%a)) > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

echo Windows標準コマンド for文3 改善版
rem /fオプションでテキストファイルの中身を処理できる。
rem 各行は区切り文字で分割されトークンと呼ばれる。区切り文字はdelimsで指定可能。デフォルトはスペースとタブ。
rem 処理対象とするトークンはtokensで指定可能。複数指定した場合、代入する変数（下記%a）を基準にアルファベット順に新たな変数（%b,%c,...）が定義されて各トークンが設定される。
rem コメント行は読み飛ばされる。コメント行と判断する行頭文字はeolで指定可能。デフォルトは「;」。
rem 空行は読み飛ばされる。下記のように「findstr /n "^"」で行番号を付与し、「delims=:」で行番号を切り捨てることで空行を表示できる。
rem しかし、元テキストの行頭が「:」の場合、行番号付与時の「:」と、元テキスト行頭の「:」が連続してしまい、1つの区切り文字として扱われ、「:」が消えてしまう。
rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
rem 下記コマンドをコマンドラインから実行する場合、for文の変数の頭「%%」は「%」とする。
set outpath=%outdir%\%basename%_for3.txt
(for /f "tokens=1* delims=: eol=" %%a in ('findstr /n "^" %inpath%') do (echo.%%b)) > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

echo Windows標準コマンド for文4 改善版
rem 上記for文3に比べて、行頭「:」を残すことができる。
rem 参照
rem バッチファイル | テキストファイルを 1 行ずつ読み込む (完全版？) ( その他コンピュータ ) - Kerupani129 Project のブログ - Yahoo!ブログ
rem https://blogs.yahoo.co.jp/kerupani/15344574.html
set outpath=%outdir%\%basename%_for4.txt
(for /f "tokens=* delims=0123456789 eol=" %%a in ('findstr /n "^" %inpath%') do (set v=%%a& echo.!v:~1!)) > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)


echo PowerShell
rem エイリアス cat -> Get-Content
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath%" > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)


:PERL
echo Perl
set outpath=%outdir%\%basename%_perl
perl -ne "print $_" %inpath% > %outpath%1.txt
perl -pe "" %inpath% > %outpath%2.txt
rem Check
call :CHECK %inpath% %outpath%1.txt
call :CHECK %inpath% %outpath%2.txt


echo Ruby
rem デフォルトの外部/内部エンコーディングはWindows-31Jの模様。そのため入力出力ファイルをWindows-31Jと見なす。
rem 必要ならrubyコマンドの-Eオプションでエンコーディングを指定する。
set outpath=%outdir%\%basename%_ruby.txt
ruby -ne "puts $_" %inpath% > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

rem 後処理
echo off
start %winmerge% %outdir%\%basename%_for2.txt %outdir%\%basename%_for4.txt



:END
call :LOG 正常終了です。
exit /b 0

:ERROR
echo 異常終了です。
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:CHECK
fc %1 %2 > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %1 %2)
exit /b 0

:EOF
