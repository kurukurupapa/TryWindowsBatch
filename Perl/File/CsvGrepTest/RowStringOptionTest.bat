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

echo TEST string�ōs���o�iASCII�����j
perl %mainpath% --string b %indir%\Normal.csv > %workdir%\String_Ascii_Result.csv
findstr "^b," %indir%\Normal.csv > %workdir%\String_Ascii_Expectation.csv
call :check %workdir%\String_Ascii_Expectation.csv %workdir%\String_Ascii_Result.csv
if errorlevel 1 ( goto :ERROR )

echo TEST string�ōs���o�i���{��j
perl %mainpath% --column 5 --string ���������� %indir%\Normal.csv > %workdir%\String_Ja_Result.csv
findstr ���������� %indir%\Normal.csv > %workdir%\String_Ja_Expectation.csv
call :check %workdir%\String_Ja_Expectation.csv %workdir%\String_Ja_Result.csv
if errorlevel 1 ( goto :ERROR )

echo TEST string�ōs���o�i�ΏۂȂ��j
perl %mainpath% --string xxx %indir%\Normal.csv > %workdir%\String_Zero_Result.csv
type nul > %workdir%\String_Zero_Expectation.csv
call :check %workdir%\String_Zero_Expectation.csv %workdir%\String_Zero_Result.csv
if errorlevel 1 ( goto :ERROR )

echo TEST string�ő��݂��Ȃ��J����
perl %mainpath% --column 0 --string b %indir%\Normal.csv > %workdir%\String_NoColumn_Result.csv
if %errorlevel% equ 0 ( goto :ERROR )
perl %mainpath% --column 6 --string b %indir%\Normal.csv > %workdir%\String_NoColumn_Result.csv
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

:check
fc %1 %2 > %tmplog%
set result=%errorlevel%
if %result% neq 0 (
  type %tmplog%
)
exit /b %result%

:EOF
