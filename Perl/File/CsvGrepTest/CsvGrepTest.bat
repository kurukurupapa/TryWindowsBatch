@echo off
@setlocal enabledelayedexpansion
rem �e�X�g���܂��B

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
rem   echo �g�����F%batname% [/?]
rem   exit /b 0
rem )

:MAIN
call :LOG �����J�n���܂��B



rem ����
rem set mainname=%basename:Test=%
set mainname=csvgrep
set mainpath=%basedir%\..\%mainname%.pl
set indir=%basedir%\Input
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
set tmppath=%workdir%\%basename%.log
if not exist %workdir% ( mkdir %workdir% )

echo TEST �w���v
perl %mainpath% -h > %tmppath%
fc %expdir%\Usage.txt %tmppath% > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �W�����́A�W���o��
perl %mainpath% < %indir%\Normal.csv > %workdir%\stdinout_result.csv
fc %indir%\Normal.csv %workdir%\stdinout_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���̓p�X�w��
perl %mainpath% %indir%\Normal.csv > %workdir%\inpath_result.csv
fc %indir%\Normal.csv %workdir%\inpath_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���̓p�X�w��i���{�ꂠ��j
perl %mainpath% %indir%\���{��.csv > %workdir%\inpath_ja_result.csv
fc %indir%\���{��.csv %workdir%\inpath_ja_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���̓p�X�w��i�t�@�C���Ȃ��G���[�j
perl %mainpath% %indir%\xxx.csv > %workdir%\inerrpath_result.csv
if %errorlevel% equ 0 ( goto :ERROR )

echo TEST �o�̓p�X�w��
perl %mainpath% -o %workdir%\outpath_result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\outpath_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �o�̓p�X�w��i���{�ꂠ��j
perl %mainpath% -o %workdir%\outpath_���{��_result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\outpath_���{��_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �o�̓p�X�w��i�t�@�C���������݃G���[�j
perl %mainpath% -o %workdir% < %indir%\Normal.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST rowstring�ōs���o�iASCII�����j
perl %mainpath% --rowstring 1=b %indir%\Normal.csv > %workdir%\rowstring_result.csv
%gnubin%\grep -E "^b," %indir%\Normal.csv > %workdir%\rowstring_expectation.csv
fc %workdir%\rowstring_expectation.csv %workdir%\rowstring_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstring�ōs���o�i���{��j
perl %mainpath% --rowstring 5=���������� %indir%\Normal.csv > %workdir%\rowstring_ja_result.csv
%gnubin%\grep ���������� %indir%\Normal.csv > %workdir%\rowstring_ja_expectation.csv
fc %workdir%\rowstring_ja_expectation.csv %workdir%\rowstring_ja_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstring�ōs���o�i�ΏۂȂ��j
perl %mainpath% --rowstring 1=xxx %indir%\Normal.csv > %workdir%\rowstring_zero_result.csv
%gnubin%\grep xxx %indir%\Normal.csv > %workdir%\rowstring_zero_expectation.csv
fc %workdir%\rowstring_zero_expectation.csv %workdir%\rowstring_zero_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstring�ő��݂��Ȃ��J����
perl %mainpath% --rowstring 0=xxx,1=b,999=xxx %indir%\Normal.csv > %workdir%\rowstring_nocolumn_result.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST rowfile�ōs���o�iASCII�����j
perl %mainpath% --rowfile 1=%indir%\Grep.txt %indir%\Normal.csv > %workdir%\rowfile_result.csv
%gnubin%\grep -E "^[be]," %indir%\Normal.csv > %workdir%\rowfile_expectation.csv
fc %workdir%\rowfile_expectation.csv %workdir%\rowfile_result.csv > nul
if errorlevel 1 ( goto :ERROR )

REM echo TEST rowfile�ōs���o�i���{��j
REM perl %mainpath% --rowfile 5=%indir%\Grep���{��.txt %indir%\Normal.csv > %workdir%\rowfile_ja_result.csv
REM perl %mainpath% --rowfile 5=%indir%\GrepJa.txt %indir%\Normal.csv > %workdir%\rowfile_ja_result.csv
REM %gnubin%\grep -E "(����������|����������)" %indir%\Normal.csv > %workdir%\rowfile_ja_expectation.csv
REM fc %workdir%\rowfile_ja_expectation.csv %workdir%\rowfile_ja_result.csv > nul
REM if errorlevel 1 ( goto :ERROR )

echo TEST rowfile�ōs���o�i�ΏۂȂ��j
perl %mainpath% --rowfile 1=%indir%\GrepZero.txt %indir%\Normal.csv > %workdir%\rowfile_zero_result.csv
type nul > %workdir%\rowfile_zero_expectation.csv
fc %workdir%\rowfile_zero_expectation.csv %workdir%\rowfile_zero_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowfile�ő��݂��Ȃ��J����
perl %mainpath% --rowfile 999=%indir%\Grep.txt %indir%\Normal.csv > %workdir%\rowfile_nocolumn_result.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST ����TSV�t�@�C��
perl %mainpath% --delimiter \t --rowstring 1=d %indir%\Normal.tsv > %workdir%\tsv_result.csv
%gnubin%\grep -E "^d" %indir%\Normal.tsv > %workdir%\tsv_expectation.csv
fc %workdir%\tsv_expectation.csv %workdir%\tsv_result.csv > nul
if errorlevel 1 ( goto :ERROR )

rem �㏈��
echo off



:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
echo �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:EOF
