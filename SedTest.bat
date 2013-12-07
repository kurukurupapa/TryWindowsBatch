@echo off

rem gnuwin32のsedを使ってみたバッチファイルです。

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



set datadir=%basedir%Data
set outdir=%basedir%Result
set expectdir=%basedir%Expect

if not exist %outdir% (
	mkdir %outdir%
)

echo --------------------------------------------------
echo 半角文字の変換

set infile=%datadir%\SedTest_ASCII.txt
set outfile=%outdir%\SedTest_ASCII.txt
set expectfile=%expectdir%\SedTest_ASCII.txt

sed s/abc/ABC/g %infile% > %outfile%
rem cat %outfile%

diff %expectfile% %outfile%
if %ERRORLEVEL%==0 (
	echo OK
) else (
	echo NG
)

echo --------------------------------------------------
echo sedスクリプトファイルを使用してみる

set infile=%datadir%\SedTest_ASCII.txt
set scriptfile=%datadir%\SedTest_ASCII.sed
set outfile=%outdir%\SedTest_ASCII2.txt
set expectfile=%expectdir%\SedTest_ASCII2.txt

sed -f %scriptfile% %infile% > %outfile%
rem cat %outfile%

diff %expectfile% %outfile%
if %ERRORLEVEL%==0 (
	echo OK
) else (
	echo NG
)

echo --------------------------------------------------
echo 半角記号の変換

set infile=%datadir%\SedTest_ASCII.txt
set outfile=%outdir%\SedTest_ASCII3.txt
set expectfile=%expectdir%\SedTest_ASCII3.txt

sed s/a//g %infile% | ^
sed s/!//g | ^
sed s/#//g | ^
sed s/\$//g | ^
sed s/%%//g | ^
sed s/"&"//g | ^
sed s/'//g | ^
sed s/(//g | ^
sed s/)//g | ^
sed s/*//g | ^
sed s/+//g | ^
sed s/,//g | ^
sed s/-//g | ^
sed s/\.//g | ^
sed s/\///g | ^
sed s/://g | ^
sed s/;//g | ^
sed s/"<"//g | ^
sed s/=//g | ^
sed s/">"//g | ^
sed s/?//g | ^
sed s/@//g | ^
sed s/\[//g | ^
sed s/\\//g | ^
sed s/\]//g | ^
sed s/"\^"//g | ^
sed s/_//g | ^
sed s/{//g | ^
sed s/"|"//g | ^
sed s/}//g | ^
sed s/~//g > %outfile%
rem cat %outfile%

rem sed s/"//g
rem ダブルクォーテーション（"）が上手く変換できませんでした。
rem コマンドラインから次のコマンドでは変換可能。
rem  sed s/\"//g .\TestData\SedTest_ASCII.txt
rem 当バッチファイルで実行しようとすると文法エラーとなる。

rem 「$」「.」「/」「[」「]」「\」は、「\」でエスケープが必要でした。
rem 「%」は、「%」でエスケープが必要でした。
rem 「&」「<」「>」「|」は、「"」で括って、エスケープ（？）しました。
rem 「^」は、前に「\」を付けて、「"」で括る必要がありました。

diff %expectfile% %outfile%
if %ERRORLEVEL%==0 (
	echo OK
) else (
	echo NG
)

echo --------------------------------------------------
echo 日本語（SJIS）の変換

set infile=%datadir%\SedTest_SJIS_CRLF.txt
set outfile=%outdir%\SedTest_SJIS_CRLF.txt
set expectfile=%expectdir%\SedTest_SJIS_CRLF.txt

sed -e s/朝/朝方/g -e s/～/～（チルダ）/g %infile% > %outfile%
rem cat %outfile%

diff %expectfile% %outfile%
if %ERRORLEVEL%==0 (
	echo OK
) else (
	echo NG
)

echo --------------------------------------------------
echo 日本語（UTF-8）の変換

set infile=%datadir%\SedTest_UTF-8_LF.txt
set outfile=%outdir%\SedTest_UTF-8_LF.txt
set expectfile=%expectdir%\SedTest_UTF-8_LF.txt

iconv -f UTF-8 %infile% | ^
sed -e s/朝/朝方/g -e s/～/～（チルダ）/g | ^
iconv -t UTF-8 > %outfile%

rem diffで比較可能なファイルに変換
iconv -f UTF-8 %outfile% | sed s/\n/\r\n/g > %outfile%.sjis
iconv -f UTF-8 %expectfile% | sed s/\n/\r\n/g > %expectfile%.sjis

diff %expectfile%.sjis %outfile%.sjis
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
