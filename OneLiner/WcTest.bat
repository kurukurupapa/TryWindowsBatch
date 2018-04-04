@echo off
@setlocal enabledelayedexpansion
rem wc -l コマンドライクの各種ワンライナーです。

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
set pathlist=%inpath%
set pathlist=%pathlist% %batdir%\Data\OneLine.txt
set pathlist=%pathlist% %batdir%\Data\Zero.txt
rem echo on

rem GnuWin32
echo GnuWin32
for %%p in (%pathlist%) do (
  %gnubin%\wc -l %%p
)

rem Windows標準コマンド for文1
rem 空行は読み飛ばされる。
rem 「setlocal enabledelayedexpansion」を指定している場合、「!」や「!」で括られた文字列が消える。
rem 下記コマンドをコマンドラインから実行する場合、for文の変数の頭「%%」は「%」とする。
echo Windows for文
for %%p in (%pathlist%) do (
  set i=0 & (for /f "delims= eol=" %%a in (%%p) do (set /a i=!i!+1)) & echo !i!
)

rem Windows標準コマンド for文2
rem オプションの詳細は、CatTest.bat参照。
rem 下記コマンドをコマンドラインから実行する場合、for文の変数の頭「%%」は「%」とする。
for %%p in (%pathlist%) do (
  set i=0 & (for /f "tokens=1* delims=: eol=" %%a in ('findstr /n "^" %%p') do (set /a i=!i!+1)) & echo !i!
)

rem PowerShell
echo PowerShell
for %%p in (%pathlist%) do (
  rem 次の実装だと、1行の場合、文字数を出力してしまう。
  rem powershell -Command "$(Get-Content %%p).Length"
  powershell -Command "$(Get-Content %%p | Measure-Object).Count"
)
for %%p in (%pathlist%) do (
  powershell -Command "$i=0; cat %%p | %%{ $i++ }; $i"
)

rem Perl
echo Perl
for %%p in (%pathlist%) do (
  perl -ne "BEGIN{$count=0}; $count+=1; END{print \"$count\n\"}" %%p
)
for %%p in (%pathlist%) do (
  perl -nE "END{print \"$.\n\"}" %%p
)

rem Ruby
rem TODO 0バイトファイルの場合、出力がなくなってしまう。
echo Ruby
for %%p in (%pathlist%) do (
  ruby -ne "BEGIN{count=0}; count+=1; END{puts count}" %%p
)

@echo off
rem 後処理



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
