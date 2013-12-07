@echo off

rem gnuwin32��sed���g���Ă݂��o�b�`�t�@�C���ł��B

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
rem if "%1"=="" goto USAGE

:MAIN
echo �����J�n���܂��B



set datadir=%basedir%Data
set outdir=%basedir%Result
set expectdir=%basedir%Expect

if not exist %outdir% (
	mkdir %outdir%
)

echo --------------------------------------------------
echo ���p�����̕ϊ�

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
echo sed�X�N���v�g�t�@�C�����g�p���Ă݂�

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
echo ���p�L���̕ϊ�

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
rem �_�u���N�H�[�e�[�V�����i"�j����肭�ϊ��ł��܂���ł����B
rem �R�}���h���C�����玟�̃R�}���h�ł͕ϊ��\�B
rem  sed s/\"//g .\TestData\SedTest_ASCII.txt
rem ���o�b�`�t�@�C���Ŏ��s���悤�Ƃ���ƕ��@�G���[�ƂȂ�B

rem �u$�v�u.�v�u/�v�u[�v�u]�v�u\�v�́A�u\�v�ŃG�X�P�[�v���K�v�ł����B
rem �u%�v�́A�u%�v�ŃG�X�P�[�v���K�v�ł����B
rem �u&�v�u<�v�u>�v�u|�v�́A�u"�v�Ŋ����āA�G�X�P�[�v�i�H�j���܂����B
rem �u^�v�́A�O�Ɂu\�v��t���āA�u"�v�Ŋ���K�v������܂����B

diff %expectfile% %outfile%
if %ERRORLEVEL%==0 (
	echo OK
) else (
	echo NG
)

echo --------------------------------------------------
echo ���{��iSJIS�j�̕ϊ�

set infile=%datadir%\SedTest_SJIS_CRLF.txt
set outfile=%outdir%\SedTest_SJIS_CRLF.txt
set expectfile=%expectdir%\SedTest_SJIS_CRLF.txt

sed -e s/��/����/g -e s/�`/�`�i�`���_�j/g %infile% > %outfile%
rem cat %outfile%

diff %expectfile% %outfile%
if %ERRORLEVEL%==0 (
	echo OK
) else (
	echo NG
)

echo --------------------------------------------------
echo ���{��iUTF-8�j�̕ϊ�

set infile=%datadir%\SedTest_UTF-8_LF.txt
set outfile=%outdir%\SedTest_UTF-8_LF.txt
set expectfile=%expectdir%\SedTest_UTF-8_LF.txt

iconv -f UTF-8 %infile% | ^
sed -e s/��/����/g -e s/�`/�`�i�`���_�j/g | ^
iconv -t UTF-8 > %outfile%

rem diff�Ŕ�r�\�ȃt�@�C���ɕϊ�
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
echo ����I���ł��B
exit /b 0

:USAGE
echo �g�����F%batname%
exit /b 0

:ERROR
echo �G���[�I���ł��B
exit /b -1

:EOF
