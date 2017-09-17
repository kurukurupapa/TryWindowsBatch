@echo off
@setlocal enabledelayedexpansion
rem wc -l �R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set inpath=%batdir%\Data\Sample.txt
set num=3
set /a index=%num%-1
rem echo on

rem GnuWin32
%gnubin%\wc -l %inpath%

rem Windows�W���R�}���h for��1
rem ��s�͓ǂݔ�΂����B
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
set i=0 & (for /f "delims= eol=" %%a in (%inpath%) do (set /a i=!i!+1)) & echo !i!

rem Windows�W���R�}���h for��2
rem �I�v�V�����̏ڍׂ́ACatTest.bat�Q�ƁB
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
set i=0 & (for /f "tokens=1* delims=: eol=" %%a in ('findstr /n "^" %inpath%') do (set /a i=!i!+1)) & echo !i!

rem PowerShell
powershell -Command "$(Get-Content %inpath%).Length"

rem Perl
perl -ne "BEGIN{$count=0}; $count+=1; END{print \"$count\n\"}" %inpath%
perl -nE "END{print \"$.\n\"}" %inpath%

rem Ruby
ruby -ne "BEGIN{count=0}; count+=1; END{puts count}" %inpath%

@echo off
rem �㏈��



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
