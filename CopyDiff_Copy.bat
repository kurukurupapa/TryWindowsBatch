@echo off

rem 二つのディレクトリ間の差分ファイルを抽出するWindowsバッチファイルです。

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
if "%4"=="" goto USAGE

:MAIN
echo 処理開始します。



set inbasedir=%1
set outbasedir=%2
set subdir=%3
set subname=%4

set indir=%inbasedir%\%subdir%
set inpath=%indir%\%subname%
set outdir=%outbasedir%\%subdir%
set outpath=%outdir%\%subname%

echo inpath=%inpath%
echo outpath=%outpath%

[ -d %inpath% ]
if %ERRORLEVEL%==0 (
	rem ディレクトリのコピー
	call :MKDIR_PROC %outpath%
	echo xcopy /y /e %inpath% %outpath%
	xcopy /y /e %inpath% %outpath%
) else (
	rem ファイルのコピー
	call :MKDIR_PROC %outdir%
	echo xcopy /y %inpath% %outdir%
	xcopy /y %inpath% %outdir%
)

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
