@echo off
@setlocal enabledelayedexpansion
rem 文字コード、改行コード変換の各種ワンライナーです。

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
set sjispath=%batdir%\Data\Sample.txt
set sjislfpath=%batdir%\Data\Sample_SJIS_LF.txt
set sjiscrlfpath=%batdir%\Data\Sample.txt
set utf8path=%batdir%\Data\Sample_UTF8_LF.txt
set utf8lfpath=%batdir%\Data\Sample_UTF8_LF.txt
set utf8crlfpath=%batdir%\Data\Sample_UTF8_CRLF.txt
set utf8bomlfpath=%batdir%\Data\Sample_UTF8-BOM_LF.txt
set utf8bomcrlfpath=%batdir%\Data\Sample_UTF8-BOM_CRLF.txt
set crlfpath=%batdir%\Data\Sample.txt
set outdir=%CD%
rem echo on

rem GnuWin32
rem GnuWin32のsedはSJISを前提にしている模様。UTF8を渡すと処理が止まり応答がなくなった。
set outprefix=%outdir%\%basename%_gnuwin32_
rem 文字コード変換 SJIS → UTF-8
%gnubin%\iconv -c -f CP932 -t UTF-8 %sjislfpath% > %outprefix%iconv_UTF8_LF.txt
%gnubin%\iconv -c -f CP932 -t UTF-8 %sjiscrlfpath% > %outprefix%iconv_UTF8_CRLF.txt
rem 文字コード変換 UTF-8 → SJIS
%gnubin%\iconv -c -f UTF-8 -t CP932 %utf8lfpath% > %outprefix%iconv_SJIS_LF.txt
%gnubin%\iconv -c -f UTF-8 -t CP932 %utf8crlfpath% > %outprefix%iconv_SJIS_CRLF.txt
rem 改行コード変換 CRLF → LF
%gnubin%\cat %sjiscrlfpath% | %gnubin%\tr -d \r > %outprefix%tr_SJIS_LF.txt
%gnubin%\cat %utf8crlfpath% | %gnubin%\tr -d \r > %outprefix%tr_UTF8_LF.txt
rem 改行コード変換 CRLF → LF（SJIS前提）
%gnubin%\sed -b "s/\r//g" %sjiscrlfpath% > %outprefix%sed_SJIS_LF.txt
rem 改行コード変換 LF → CRLF（SJIS前提）
%gnubin%\sed "" %sjislfpath% > %outprefix%sed_SJIS_CRLF.txt
rem Check
fc /b %utf8lfpath% %outprefix%iconv_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%iconv_UTF8_LF.txt)
fc /b %utf8crlfpath% %outprefix%iconv_UTF8_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8crlfpath% %outprefix%iconv_UTF8_CRLF.txt)
fc /b %sjislfpath% %outprefix%iconv_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%iconv_SJIS_LF.txt)
fc /b %sjiscrlfpath% %outprefix%iconv_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%iconv_SJIS_CRLF.txt)
fc /b %sjislfpath% %outprefix%tr_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%tr_SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%tr_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%tr_UTF8_LF.txt)
fc /b %sjislfpath% %outprefix%sed_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%sed_SJIS_LF.txt)
fc /b %sjiscrlfpath% %outprefix%sed_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%sed_SJIS_CRLF.txt)

rem Windows標準コマンド
set outprefix=%outdir%\%basename%_win_
rem 文字コード変換 UTF-8 → SJIS
rem TODO 上手くいかない。 start /min /wait cmd /c chcp 932 ^& cmd /c type %utf8lfpath% ^> %outprefix%chcp_SJIS_LF.txt
rem TODO 上手くいかない。 start /min /wait cmd /c chcp 932 ^& cmd /c type %utf8crlfpath% ^> %outprefix%chcp_SJIS_CRLF.txt
rem 文字コード変換 SJIS → UTF-8
rem TODO 上手くいかない。 start /min /wait cmd /c chcp 65001 ^& cmd /u /c type %sjislfpath% ^> %outprefix%chcp_UTF8_LF.txt
rem TODO 上手くいかない。 start /min /wait cmd /c chcp 65001 ^& cmd /c type %sjiscrlfpath% ^> %outprefix%chcp_UTF8_CRLF.txt
rem Check
rem fc /b %sjislfpath% %outprefix%chcp_SJIS_LF.txt > nul
rem if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%chcp_SJIS_LF.txt)
rem fc /b %sjiscrlfpath% %outprefix%chcp_SJIS_CRLF.txt > nul
rem if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%chcp_SJIS_CRLF.txt)

rem PowerShell
rem Out-Fileだと-Encodingに「Byte」が使えない。「Byte」を使いたいときはSet-Contentを使う。Set-Contentだとリードロックがかかる。
rem PowerShellのUTF-8は、BOM付きUTF-8。
rem .NET Frameworkの[Text.Encoding]::UTF8は、BOM付きUTF-8。
rem .NET Framework WriteAllText,AppendAllTextのデフォルト文字コードはUTF-8の模様。明示的に指定したいときは[Text.UTF8Encoding]$falseとする。
set outprefix=%outdir%\%basename%_ps_charset_
rem 文字コード変換 UTF-8 → SJIS（改行コードLF出力は煩雑なので、ここではCRLF出力のみ扱う。）
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | Out-File -Encoding Default %outprefix%Out-File_SJIS_CRLF.txt"
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | Set-Content -Encoding Default %outprefix%Set-Content_SJIS_CRLF.txt"
rem 文字コード変換 SJIS → BOM付きUTF-8（改行コードLF出力は煩雑なので、ここではCRLF出力のみ扱う。）
powershell -Command "cat %sjiscrlfpath% | Out-File -Encoding UTF8 %outprefix%Out-File_UTF8-BOM_CRLF.txt"
powershell -Command "cat %sjiscrlfpath% | Set-Content -Encoding UTF8 %outprefix%Set-Content_UTF8-BOM_CRLF.txt"
rem 文字コード変換 SJIS → BOMなしUTF-8
powershell -Command "cat %sjiscrlfpath% | %%{ [Text.Encoding]::UTF8.GetBytes($_+\"`n\") } | Set-Content -Encoding Byte %outprefix%Set-Content_UTF8_LF.txt"
powershell -Command "cat %sjiscrlfpath% | %%{ [Text.Encoding]::UTF8.GetBytes($_+\"`r`n\") } | Set-Content -Encoding Byte %outprefix%Set-Content_UTF8_CRLF.txt"
rem Check
fc /b %sjiscrlfpath% %outprefix%Out-File_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%Out-File_SJIS_CRLF.txt)
fc /b %sjiscrlfpath% %outprefix%Set-Content_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%Set-Content_SJIS_CRLF.txt)
fc /b %utf8bomcrlfpath% %outprefix%Out-File_UTF8-BOM_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomcrlfpath% %outprefix%Out-File_UTF8-BOM_CRLF.txt)
fc /b %utf8bomcrlfpath% %outprefix%Set-Content_UTF8-BOM_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomcrlfpath% %outprefix%Set-Content_UTF8-BOM_CRLF.txt)
fc /b %utf8lfpath% %outprefix%Set-Content_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%Set-Content_UTF8_LF.txt)
fc /b %utf8crlfpath% %outprefix%Set-Content_UTF8_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8crlfpath% %outprefix%Set-Content_UTF8_CRLF.txt)

rem 改行コード変換 CRLF → LF
rem   ※PowerShell 5.0以降が使える環境なら、方式５が良さそう。それ以外なら、方式６だと思う。
set outprefix=%outdir%\%basename%_ps_newline_
rem   ※方式１。PowerShell 2.0以降。ファイルサイズ同等のメモリを使用する。最終行の改行はCRLFになってしまう。NG。
rem powershell -Command "(cat %sjiscrlfpath%) -join \"`n\" | Out-File -Encoding Default %outprefix%cat-join_Out-File_SJIS_LF.txt"
rem powershell -Command "(cat %sjiscrlfpath%) -join \"`n\" | Set-Content -Encoding Default %outprefix%cat-join_Set-Content_SJIS_LF.txt"
rem powershell -Command "(cat -Encoding UTF8 %utf8crlfpath%) -join \"`n\" | Out-File -Encoding UTF8 %outprefix%cat-join_Out-File_UTF8_LF.txt"
rem powershell -Command "(cat -Encoding UTF8 %utf8crlfpath%) -join \"`n\" | Set-Content -Encoding UTF8 %outprefix%cat-join_Set-Content_UTF8_LF.txt"
rem   ※方式２：.NET Framework WriteAllText使用。PowerShell 2.0以降＋.NET Framework。ファイルサイズ同等のメモリを使用する。
powershell -Command "$_=(cat %sjiscrlfpath%) -join \"`n\"; [IO.File]::WriteAllText('%outprefix%cat-join_WriteAllText_SJIS_LF.txt',$_+\"`n\",[Text.Encoding]::GetEncoding('SJIS'))"
powershell -Command "$_=(cat -Encoding UTF8 %utf8crlfpath%) -join \"`n\"; [IO.File]::WriteAllText('%outprefix%cat-join_WriteAllText_UTF8_LF.txt',$_+\"`n\",[Text.UTF8Encoding]$false)"
rem   ※方式３：.NET Framework WriteAllText、catの「-Raw」使用。PowerShell 3.0以降＋.NET Framework。ファイルサイズ同等のメモリを使用する。
powershell -Command "$_=(cat %sjiscrlfpath% -Raw) -Replace \"`r\",\"\"; [IO.File]::WriteAllText('%outprefix%cat-Raw_WriteAllText_SJIS_LF.txt',$_,[Text.Encoding]::GetEncoding('SJIS'))"
powershell -Command "$_=(cat -Encoding UTF8 %utf8crlfpath% -Raw) -Replace \"`r\",\"\"; [IO.File]::WriteAllText('%outprefix%cat-Raw_WriteAllText_UTF8_LF.txt',$_,[Text.UTF8Encoding]$false)"
rem   ※方式４：Out-File,Set-Contentの「-NoNewline」使用、PowerShell 5.0以降。
powershell -Command "cat %sjiscrlfpath% | %%{ $_+\"`n\" } | Out-File -Encoding Default -NoNewline %outprefix%cat_Out-File-NoNewline_SJIS_LF.txt"
powershell -Command "cat %sjiscrlfpath% | %%{ $_+\"`n\" } | Set-Content -Encoding Default -NoNewline %outprefix%cat_Set-Content-NoNewline_SJIS_LF.txt"
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | %%{ $_+\"`n\" } | Out-File -Encoding UTF8 -NoNewline %outprefix%cat_Out-File-NoNewline_UTF8-BOM_LF.txt"
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | %%{ $_+\"`n\" } | Set-Content -Encoding UTF8 -NoNewline %outprefix%cat_Set-Content-NoNewline_UTF8-BOM_LF.txt"
rem   ※方式５：ファイル追記方式、.NET Framework使用。ファイル書き込みがかなり遅い。あまり現実的ではなさそう。
rem del /q %outprefix%cat_AppendAllText_*_LF.txt
rem powershell -Command "cat %sjiscrlfpath% | %%{ [IO.File]::AppendAllText('%outprefix%cat_AppendAllText_SJIS_LF.txt',$_+\"`n\",[Text.Encoding]::GetEncoding('SJIS')) }"
rem powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | %%{ [IO.File]::AppendAllText('%outprefix%cat_AppendAllText_UTF8_LF.txt',$_+\"`n\",[Text.UTF8Encoding]$false) }"
rem   ※方式６：バイナリ書き込み、.NET Framework使用。
powershell -Command "cat %sjiscrlfpath% | %%{ [Text.Encoding]::GetEncoding('SJIS').GetBytes($_+\"`n\") } | Set-Content -Encoding Byte %outprefix%cat_GetBytes_Set-Content_SJIS_LF.txt"
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | %%{ [Text.Encoding]::UTF8.GetBytes($_+\"`n\") } | Set-Content -Encoding Byte %outprefix%cat_GetBytes_Set-Content_UTF8_LF.txt"
rem Check
rem   ※方式２
fc /b %sjislfpath% %outprefix%cat-join_WriteAllText_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat-join_WriteAllText_SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%cat-join_WriteAllText_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%cat-join_WriteAllText_UTF8_LF.txt)
rem   ※方式３
fc /b %sjislfpath% %outprefix%cat-Raw_WriteAllText_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat-Raw_WriteAllText_SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%cat-Raw_WriteAllText_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%cat-Raw_WriteAllText_UTF8_LF.txt)
rem   ※方式４
fc /b %sjislfpath% %outprefix%cat_Out-File-NoNewline_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat_Out-File-NoNewline_SJIS_LF.txt)
fc /b %sjislfpath% %outprefix%cat_Set-Content-NoNewline_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat_Set-Content-NoNewline_SJIS_LF.txt)
fc /b %utf8bomlfpath% %outprefix%cat_Out-File-NoNewline_UTF8-BOM_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomlfpath% %outprefix%cat_Out-File-NoNewline_UTF8-BOM_LF.txt)
fc /b %utf8bomlfpath% %outprefix%cat_Set-Content-NoNewline_UTF8-BOM_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomlfpath% %outprefix%cat_Set-Content-NoNewline_UTF8-BOM_LF.txt)
rem   ※方式６
fc /b %sjislfpath% %outprefix%cat_GetBytes_Set-Content_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat_GetBytes_Set-Content_SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%cat_GetBytes_Set-Content_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%cat_GetBytes_Set-Content_UTF8_LF.txt)

rem 改行コード変換 LF → CRLF
set outprefix=%outdir%\%basename%_ps_newline_
powershell -Command "cat %sjislfpath% | Out-File -Encoding Default %outprefix%cat_Out-File_SJIS_CRLF.txt"
powershell -Command "cat %sjislfpath% | Set-Content -Encoding Default %outprefix%cat_Set-Content_SJIS_CRLF.txt"
powershell -Command "cat -Encoding UTF8 %utf8lfpath% | Out-File -Encoding UTF8 %outprefix%cat_Out-File_UTF8-BOM_CRLF.txt"
powershell -Command "cat -Encoding UTF8 %utf8lfpath% | Set-Content -Encoding UTF8 %outprefix%cat_Set-Content_UTF8-BOM_CRLF.txt"
rem Check
fc /b %sjiscrlfpath% %outprefix%cat_Out-File_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%cat_Out-File_SJIS_CRLF.txt)
fc /b %sjiscrlfpath% %outprefix%cat_Set-Content_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%cat_Set-Content_SJIS_CRLF.txt)
fc /b %utf8bomcrlfpath% %outprefix%cat_Out-File_UTF8-BOM_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomcrlfpath% %outprefix%cat_Out-File_UTF8-BOM_CRLF.txt)
fc /b %utf8bomcrlfpath% %outprefix%cat_Set-Content_UTF8-BOM_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomcrlfpath% %outprefix%cat_Set-Content_UTF8-BOM_CRLF.txt)

rem Perl
rem ActivePerlだと（？）、ファイル読み込み時にCRLF→LFに変換される模様。
set outprefix=%outdir%\%basename%_perl_
rem 改行コード変換 CRLF → LF
perl -pne "BEGIN{binmode(STDOUT)}" %sjiscrlfpath% > %outprefix%SJIS_LF.txt
perl -pne "BEGIN{binmode(STDOUT)}" %utf8crlfpath% > %outprefix%UTF8_LF.txt
rem 改行コード変換 LF → CRLF
perl -pne "" %sjislfpath% > %outprefix%SJIS_CRLF.txt
perl -pne "" %utf8lfpath% > %outprefix%UTF8_CRLF.txt
rem Check
fc /b %sjislfpath% %outprefix%SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%UTF8_LF.txt)
fc /b %sjiscrlfpath% %outprefix%SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%SJIS_CRLF.txt)
fc /b %utf8crlfpath% %outprefix%UTF8_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8crlfpath% %outprefix%UTF8_CRLF.txt)

rem Ruby
rem デフォルトの外部/内部エンコーディングはWindows-31Jの模様。そのため入力出力ファイルをWindows-31Jと見なす。
rem 必要ならrubyコマンドの-Eオプションでエンコーディングを指定する。
rem ファイル読み込み時にCRLF→LFに変換される模様。
set outprefix=%outdir%\%basename%_ruby_
rem 改行コード変換 CRLF → LF
ruby -pne "BEGIN{STDOUT.binmode}" %sjiscrlfpath% > %outprefix%SJIS_LF.txt
ruby -pne "BEGIN{$stdout.binmode}" %sjiscrlfpath% > %outprefix%SJIS_LF2.txt
ruby -pne "BEGIN{STDOUT.binmode}" %utf8crlfpath% > %outprefix%UTF8_LF.txt
ruby -pne "BEGIN{$stdout.binmode}" %utf8crlfpath% > %outprefix%UTF8_LF2.txt
rem 改行コード変換 LF → CRLF
ruby -pne "" %sjislfpath% > %outprefix%SJIS_CRLF.txt
ruby -pne "" %utf8lfpath% > %outprefix%UTF8_CRLF.txt
rem Check
fc /b %sjislfpath% %outprefix%SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%SJIS_LF.txt)
fc /b %sjislfpath% %outprefix%SJIS_LF2.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%SJIS_LF2.txt)
fc /b %utf8lfpath% %outprefix%UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%UTF8_LF.txt)
fc /b %utf8lfpath% %outprefix%UTF8_LF2.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%UTF8_LF2.txt)
fc /b %sjiscrlfpath% %outprefix%SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%SJIS_CRLF.txt)
fc /b %utf8crlfpath% %outprefix%UTF8_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8crlfpath% %outprefix%UTF8_CRLF.txt)

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
