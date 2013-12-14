@echo off

rem 二つのディレクトリ間の差分ファイルを抽出するWindowsバッチファイルです。
rem 
rem 制約事項
rem ・空白を含むディレクトリ/ファイル名は、考慮していません。

setlocal
set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%1"=="" goto USAGE
if "%2"=="" goto USAGE
if "%3"=="" goto USAGE

:MAIN
echo 処理開始します。



set befdir=%1
set aftdir=%2
set outdir=%3
set difflist=%outdir%\diff_list.txt
set filelist=%outdir%\file_list.txt
set filelist2=%outdir%\file_list2.txt
set tmpbat=%outdir%\tmp.bat

echo befdir: %1
echo aftdir: %2
echo outdir: %3

call :MKDIR_PROC %outdir%

rem 差分を取得する
diff -r -q %befdir% %aftdir% > %difflist%

rem cat %difflist%

rem 追加/変更/削除されたファイルの一覧を取得する
cat %difflist% | ^
sed "s!^\(%befdir:\=\\%\)\(/.*\)\?だけに発見: \(.*\)$!DEL,\1\2/\3!" | ^
sed "s!^\(%aftdir:\=\\%\)\(/.*\)\?だけに発見: \(.*\)$!ADD,\1\2/\3!" | ^
sed "s!^ファイル\(.*\)と\(.*\)は違います$!MOD,\2!" | ^
sed "s!/!\\!g" > %filelist2%

awk -F, "{print $2}" %filelist2% > %filelist%

rem cat %filelist%

rem コピー用一時バッチファイルを作成する
cat %filelist% | ^
grep -E "^%aftdir:\=\\%" | ^
sed "s!^%aftdir:\=\\%\\\(.*\)$!.\\\1!" | ^
sed "s!^\(.*\)\\\([^\\]*\)$!call %basedir:\=\\%\\CopyDiff_Copy.bat %aftdir:\=\\% %outdir:\=\\% \1 \2!" > %tmpbat%

rem cat %tmpbat%

rem コピー用一時バッチファイルを実行する
call %tmpbat%


endlocal
goto END
rem ------------------------------
rem 関数群
rem ------------------------------

:MKDIR_PROC
if not exist %1 (
	mkdir %1
)
exit /b 0



:END
echo 正常終了です。
exit /b 0

:USAGE
echo 使い方：%batname% 変更前ディレクトリ 変更後ディレクトリ 出力ディレクトリ
exit /b 0

:ERROR
echo エラー終了です。
exit /b -1

:EOF
