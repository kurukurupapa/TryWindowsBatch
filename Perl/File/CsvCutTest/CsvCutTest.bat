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
set mainname=csvcut
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

echo TEST ���̓p�X�w��i�t�@�C���Ȃ��G���[�j
perl %mainpath% %indir%\xxx.csv > %workdir%\inerrpath_result.csv
if %errorlevel% equ 0 ( goto :ERROR )

echo TEST �o�̓p�X�w��
perl %mainpath% -o %workdir%\outpath_result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\outpath_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �o�̓p�X�w��i�t�@�C���������݃G���[�j
perl %mainpath% -o %workdir% < %indir%\Normal.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST �J����1�i�ŏ��j
perl %mainpath% --column 1 %indir%\Normal.csv > %workdir%\column1_result.csv
%gnubin%\cut -d , -f 1 %indir%\Normal.csv > %workdir%\column1_expectation.csv
fc %workdir%\column1_expectation.csv %workdir%\column1_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �J����1�i�Ō�j
perl %mainpath% --column 5 %indir%\Normal.csv > %workdir%\column5_result.csv
%gnubin%\cut -d , -f 5 %indir%\Normal.csv > %workdir%\column5_expectation.csv
fc %workdir%\column5_expectation.csv %workdir%\column5_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �J���������i�S�āj
perl %mainpath% --column 1,2,3,4,5 %indir%\Normal.csv > %workdir%\allcolumn_result.csv
fc %indir%\Normal.csv %workdir%\allcolumn_result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���݂��Ȃ��J����
perl %mainpath% --column 0,1,6 %indir%\Normal.csv > %workdir%\nocolumn_result.csv
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST ����TSV�t�@�C��
perl %mainpath% --delimiter \t --column 3 %indir%\Normal.tsv > %workdir%\tsv_result.csv
%gnubin%\cut -f 3 %indir%\Normal.tsv > %workdir%\tsv_expectation.csv
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
