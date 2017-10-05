@echo off
@setlocal enabledelayedexpansion
rem cut�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set inpath=%batdir%\Data\Sample.csv
set outdir=%CD%
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\cut -d "," -f 1-2,4 %inpath% > %outpath%

rem Windows�W���R�}���h for��
rem ���ӎ���
rem ��s�͓ǂݔ�΂����B
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
set outpath=%outdir%\%basename%_for.txt
(for /f "delims=, tokens=1-2,4 eol=" %%a in (%inpath%) do (echo %%a,%%b,%%c)) > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem PowerShell
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | %%{ $arr=$_.Split(','); $arr[0]+','+$arr[1]+','+$arr[3] }" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem Perl
set outpath=%outdir%\%basename%_perl.txt
perl -aF, -ne "print \"$F[0],$F[1],$F[3]\n\"" %inpath% > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem Ruby
rem �f�t�H���g�̊O��/�����G���R�[�f�B���O��Windows-31J�̖͗l�B���̂��ߓ��͏o�̓t�@�C����Windows-31J�ƌ��Ȃ��B
rem �K�v�Ȃ�ruby�R�}���h��-E�I�v�V�����ŃG���R�[�f�B���O���w�肷��B
set outpath=%outdir%\%basename%_ruby.txt
ruby -aF, -ne "puts $F[0]+','+$F[1]+','+$F[3]" %inpath% > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

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
