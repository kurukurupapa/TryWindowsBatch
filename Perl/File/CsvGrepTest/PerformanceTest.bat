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
call :LOG �_�~�[CSV�t�@�C���쐬�J�n
if not exist %performancedir%\dummy_10KB.csv  ( call %prjdir%\Bat\DummyCsv.bat 100 > %performancedir%\dummy_10KB.csv )
if not exist %performancedir%\dummy_10MB.csv  ( call %prjdir%\Bat\DummyCsv.bat 100000 > %performancedir%\dummy_10MB.csv )
if not exist %performancedir%\dummy_100MB.csv ( call %prjdir%\Bat\DummyCsv.bat 1000000 > %performancedir%\dummy_100MB.csv )
REM call %prjdir%\Bat\DummyCsv.bat 5000000 > dummy_500MB.csv
REM call %prjdir%\Bat\DummyCsv.bat 10000000 > dummy_1000MB.csv
call :LOG �_�~�[CSV�t�@�C���쐬�I��


echo TEST �p�t�H�[�}���X�e�X�g string�ōs���o
set start=%DATE% %TIME%
perl %mainpath% --column 6 --string 10 %performancedir%\dummy_100MB.csv > %performancedir%\RowString_100MB.csv
set end=%DATE% %TIME%
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.0')+'�� %mainname%'"

set start=%DATE% %TIME%
findstr ",10," %performancedir%\dummy_100MB.csv > %performancedir%\findstr_100MB.csv
set end=%DATE% %TIME%
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.0')+'�� findstr'"

set start=%DATE% %TIME%
findstr ",10," %performancedir%\dummy_100MB.csv > %performancedir%\findstr_100MB.csv
powershell -Command "cat %performancedir%\dummy_100MB.csv | Select-String -Pattern ',10,' | %%{ $_.Line }" > %performancedir%\ps_100MB.csv
set end=%DATE% %TIME%
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.0')+'�� powershell'"

REM call :LOG GnuWin32 grep 10MB �J�n
REM %gnubin%\grep -E ",10," %performancedir%\dummy_10MB.csv > %performancedir%\grep_10MB.csv
REM call :LOG GnuWin32 grep 10MB �I��


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
