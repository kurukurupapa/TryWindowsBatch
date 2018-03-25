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

echo TEST rowstring�ōs���o�iASCII�����j
perl %mainpath% --rowstring 1=b %indir%\Normal.csv > %workdir%\RowString_Ascii_Result.csv
%gnubin%\grep -E "^b," %indir%\Normal.csv > %workdir%\RowString_Ascii_Expectation.csv
fc %workdir%\RowString_Ascii_Expectation.csv %workdir%\RowString_Ascii_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstring�ōs���o�i���{��j
perl %mainpath% --rowstring 5=���������� %indir%\Normal.csv > %workdir%\RowString_Ja_Result.csv
%gnubin%\grep ���������� %indir%\Normal.csv > %workdir%\RowString_Ja_Expectation.csv
fc %workdir%\RowString_Ja_Expectation.csv %workdir%\RowString_Ja_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstring�ōs���o�i�ΏۂȂ��j
perl %mainpath% --rowstring 1=xxx %indir%\Normal.csv > %workdir%\RowString_Zero_Result.csv
%gnubin%\grep xxx %indir%\Normal.csv > %workdir%\RowString_Zero_Expectation.csv
fc %workdir%\RowString_Zero_Expectation.csv %workdir%\RowString_Zero_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST rowstring�ő��݂��Ȃ��J����
perl %mainpath% --rowstring 0=xxx,1=b,999=xxx %indir%\Normal.csv > %workdir%\RowString_NoColumn_Result.csv
if %errorlevel% equ 0 ( goto :ERROR )

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
