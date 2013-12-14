@echo off

rem 二つのディレクトリ間の差分ファイルを抽出する練習です。

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
rem if "%1"=="" goto USAGE

:MAIN
echo 処理開始します。



set databasedir=%basedir%Data\DiffCopyTest
set outbasedir=%basedir%Result\DiffCopyTest
set expectbasedir=%basedir%Expect\DiffCopyTest

if not exist %outbasedir% (
	mkdir %outbasedir%
)

echo --------------------------------------------------
echo Case001

rem 準備
set indir1=%databasedir%\Case001\Dir1
set indir2=%databasedir%\Case001\Dir2
set outdir=%outbasedir%\Case001
set expectdir=%expectbasedir%\Case001

echo rmdir /s /q %outdir%
rmdir /s /q %outdir%

rem テスト実行
call DiffCopy.bat %indir1% %indir2% %outdir%

rem 検証
diff -r %expectdir% %outdir%
if %ERRORLEVEL%==0 (
	echo OK
) else (
	echo NG
)

echo --------------------------------------------------
echo Case002

rem 準備
set indir1=%databasedir%\Case002\Dir1
set indir2=%databasedir%\Case002\Dir2
set outdir=%outbasedir%\Case002
set expectdir=%expectbasedir%\Case002

echo rmdir /s /q %outdir%
rmdir /s /q %outdir%

rem テスト実行
call DiffCopy.bat %indir1% %indir2% %outdir%

rem 検証
diff -r %expectdir% %outdir%
if %ERRORLEVEL%==0 (
	echo OK
) else (
	echo NG
)

echo --------------------------------------------------



:END
echo 正常終了です。
exit /b 0

:USAGE
echo 使い方：%batname%
exit /b 0

:ERROR
echo エラー終了です。
exit /b -1

:EOF
