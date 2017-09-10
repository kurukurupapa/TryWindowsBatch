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
rem 記号「^」は行連結文字。エスケープしたいときは「^^」とする。
set inpath=%basedir%\Data\Sample.txt
set pattern=abc
set pattern2=サンプル
set pattern_space=a pen
set pattern_re=^^a.*z$
set pattern_re2=サ.*ル
set outdir=%CD%
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
@echo on

rem GnuWin32
grep %pattern% %inpath%
@set outpath=%outdir%\%basename%_gnuwin32.txt
grep -E "(%pattern_re%|%pattern_re2%)" %inpath% > %outpath%
@set outpath=%outdir%\%basename%_gnuwin32_not.txt
grep -v -E "(%pattern_re%|%pattern_re2%)" %inpath% > %outpath%

rem Windows標準コマンド
findstr %pattern% %inpath%
findstr "%pattern% %pattern2%" %inpath%
findstr /c:"%pattern_space%" %inpath%
@set outpath=%outdir%\%basename%_findstr.txt
findstr /r "%pattern_re% %pattern_re2%" %inpath% > %outpath%
@set outpath=%outdir%\%basename%_findstr_v.txt
findstr /v /r "%pattern_re% %pattern_re2%" %inpath% > %outpath%

rem PowerShell
@rem Select-Stringは入力ファイルをUTF-8として読み込む。SJISを読み込むにはGet-Contentを通す。
@rem エイリアス cat -> Get-Content
powershell -Command "cat %inpath% | Select-String -Pattern '%pattern_re%'"
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern%', '%pattern2%', '%pattern_space%') -SimpleMatch -CaseSensitive"
@set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern_re%', '%pattern_re2%') -CaseSensitive" > %outpath%
@set outpath=%outdir%\%basename%_ps_not.txt
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern_re%', '%pattern_re2%') -CaseSensitive -NotMatch" > %outpath%

rem Ruby
@rem デフォルトの外部/内部エンコーディングはWindows-31Jの模様。そのため入力出力ファイルをWindows-31Jと見なす。
@rem 必要ならrubyコマンドの-Eオプションでエンコーディングを指定する。
@rem ワンライナーで書いたRubyスクリプトは、WindowsからRubyへUTF-8で渡し、RubyはWindows-31Jで解釈しようとし、不整合な状態となる模様。
@rem そのため、スクリプトの日本語文字列には明示的にUTF-8を指定する。
@set outpath=%outdir%\%basename%_ruby.txt
ruby -ne "BEGIN{re=Regexp.new('(%pattern_re%|%pattern_re2%)'.force_encoding('UTF-8').encode('Windows-31J'))}; puts $_ if $_ =~ re" %inpath% > %outpath%
@set outpath=%outdir%\%basename%_ruby_not.txt
ruby -ne "BEGIN{re=Regexp.new('(%pattern_re%|%pattern_re2%)'.force_encoding('UTF-8').encode('Windows-31J'))}; puts $_ if $_ ^!~ re" %inpath% > %outpath%

@echo off
rem 後処理
start %winmerge% %outdir%\%basename%_gnuwin32.txt %outdir%\%basename%_findstr.txt
start %winmerge% %outdir%\%basename%_gnuwin32.txt %outdir%\%basename%_ps.txt
start %winmerge% %outdir%\%basename%_gnuwin32.txt %outdir%\%basename%_ruby.txt
start %winmerge% %outdir%\%basename%_gnuwin32_not.txt %outdir%\%basename%_findstr_v.txt
start %winmerge% %outdir%\%basename%_gnuwin32_not.txt %outdir%\%basename%_ps_not.txt
start %winmerge% %outdir%\%basename%_gnuwin32_not.txt %outdir%\%basename%_ruby_not.txt



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
