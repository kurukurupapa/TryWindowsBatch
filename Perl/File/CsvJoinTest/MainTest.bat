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
set mainname=csvjoin
set mainpath=%basedir%\..\%mainname%.pl
set indir=%basedir%\Input
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
if not exist %workdir% ( mkdir %workdir% )

echo TEST ����n
perl %mainpath% %indir%\Normal1.csv %indir%\Normal2.csv -o %workdir%\Normal_Key1_Result.csv
fc %expdir%\NormalKey1.csv %workdir%\Normal_Key1_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ����n�i--file1key,--file2key�j
perl %mainpath% --file1key 2,3 --file2key 2,3 %indir%\Normal1.csv %indir%\Normal2.csv -o %workdir%\Normal_Key2-3_Result.csv
fc %expdir%\NormalKey2-3.csv %workdir%\Normal_Key2-3_Result.csv > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���݂��Ȃ��J����
perl %mainpath% --file1key 999 --file2key 999 %indir%\Normal1.csv %indir%\Normal2.csv -o %workdir%\NoColumn_Result.csv
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
