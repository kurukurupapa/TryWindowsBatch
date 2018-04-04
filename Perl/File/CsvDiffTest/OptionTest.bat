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
call %batdir%\Setting.bat

echo TEST ���̓p�X�w��i���{�ꂠ��j
perl %mainpath% %indir%\Normal���{��1.csv %indir%\Normal���{��2.csv > %workdir%\InPathJa_Result.txt
fc %expdir%\Normal_Ja.txt %workdir%\InPathJa_Result.txt > nul
if errorlevel 1 ( goto :ERROR )

echo TEST ���̓p�X�w��i�t�@�C���Ȃ��G���[�j
perl %mainpath% %indir%\xxx.csv %indir%\xxx.csv > %workdir%\InErrPath_Result.txt
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST �o�̓p�X�w��
perl %mainpath% %indir%\Normal1.csv %indir%\Normal2.csv -o %workdir%\OutPath_Result.txt
fc %expdir%\Normal.txt %workdir%\OutPath_Result.txt > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �o�̓p�X�w��i���{�ꂠ��j
perl %mainpath% %indir%\Normal1.csv %indir%\Normal2.csv -o %workdir%\OutPath���{��_Result.txt
fc %expdir%\Normal.txt %workdir%\OutPath���{��_Result.txt > nul
if errorlevel 1 ( goto :ERROR )

echo TEST �o�̓p�X�w��i�t�@�C���������݃G���[�j
perl %mainpath% %indir%\Normal1.csv %indir%\Normal2.csv -o %workdir%
if %errorlevel% equ 0 ( goto :ERROR )


echo TEST ����TSV�t�@�C��
perl %mainpath% --delimiter \t %indir%\Tsv1.tsv %indir%\Tsv2.tsv > %workdir%\Tsv_Result.txt
fc %expdir%\Tsv.txt %workdir%\Tsv_Result.txt > nul
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
