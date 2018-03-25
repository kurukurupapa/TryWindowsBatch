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
set mainname=csvgrep
set mainpath=%basedir%\..\%mainname%.pl
set indir=%basedir%\Input
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
if not exist %workdir% ( mkdir %workdir% )

echo TEST �W�����́A�W���o��
perl %mainpath% < %indir%\Normal.csv > %workdir%\StdInOut_Result.csv
fc %indir%\Normal.csv %workdir%\StdInOut_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���̓p�X�w��
perl %mainpath% %indir%\Normal.csv > %workdir%\InPath_Result.csv
fc %indir%\Normal.csv %workdir%\InPath_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���̓p�X�w��i���{�ꂠ��j
perl %mainpath% %indir%\���{��.csv > %workdir%\InPathJa_Result.csv
fc %indir%\���{��.csv %workdir%\InPathJa_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���̓p�X�w��i�t�@�C���Ȃ��G���[�j
perl %mainpath% %indir%\xxx.csv > %workdir%\InErrPath_Result.csv
if %errorlevel% equ 0 ( goto :ERROR )

echo TEST �o�̓p�X�w��
perl %mainpath% -o %workdir%\OutPath_Result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\OutPath_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �o�̓p�X�w��i���{�ꂠ��j
perl %mainpath% -o %workdir%\OutPath���{��_Result.csv < %indir%\Normal.csv
fc %indir%\Normal.csv %workdir%\OutPath���{��_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �o�̓p�X�w��i�t�@�C���������݃G���[�j
perl %mainpath% -o %workdir% < %indir%\Normal.csv
if %errorlevel% equ 0 ( goto :ERROR )

echo TEST ����TSV�t�@�C��
perl %mainpath% --delimiter \t --rowstring 1=d %indir%\Normal.tsv > %workdir%\Tsv_Result.csv
%gnubin%\grep -E "^d" %indir%\Normal.tsv > %workdir%\Tsv_Expectation.csv
fc %workdir%\Tsv_Expectation.csv %workdir%\Tsv_Result.csv > nul
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
