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
if not exist %workdir% ( mkdir %workdir% )

echo TEST �J����1�i�ŏ��j
perl %mainpath% --column 1 %indir%\Normal.csv > %workdir%\Column1_Result.csv
%gnubin%\cut -d , -f 1 %indir%\Normal.csv > %workdir%\Column1_Expectation.csv
fc %workdir%\Column1_Expectation.csv %workdir%\Column1_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �J����1�i�Ō�j
perl %mainpath% --column 5 %indir%\Normal.csv > %workdir%\Column5_Result.csv
%gnubin%\cut -d , -f 5 %indir%\Normal.csv > %workdir%\Column5_Expectation.csv
fc %workdir%\Column5_Expectation.csv %workdir%\Column5_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �J���������i�S�āj
perl %mainpath% --column 1,2,3,4,5 %indir%\Normal.csv > %workdir%\AllColumn_Result.csv
fc %indir%\Normal.csv %workdir%\AllColumn_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���݂��Ȃ��J����
perl %mainpath% --column 0,1,6 %indir%\Normal.csv > %workdir%\NoColumn_Result.csv
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
