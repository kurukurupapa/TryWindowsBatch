@echo off
@setlocal enabledelayedexpansion
rem sed�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set outdir=%CD%
set before=abc
set after=_abc_
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\sed "s/%before%/%after%/g" %inpath% > %outpath%
rem Check
copy %outpath% %outdir%\%basename%_ok.txt > nul

rem Windows�W���R�}���h for��
rem Windows�o�b�`�t�@�C���ł́A�L���u%�v���u%%�v�փG�X�P�[�v���K�v�B
rem ��s�͓ǂݔ�΂����B
set outpath=%outdir%\%basename%_for1.txt
(for /f "delims= eol=" %%a in (%inpath%) do @((set v=%%a) & (echo !v:%before%=%after%!))) > %outpath%
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

rem PowerShell
rem Windows�o�b�`�t�@�C���ł́A�L���u%�v���u%%�v�փG�X�P�[�v���K�v�B
rem �G�C���A�X cat -> Get-Content
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | %%{ $_ -Replace '%before%', '%after%' } | Out-File -Encoding Default %outpath%"
rem Check
fc %outdir%\%basename%_ok.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_ok.txt %outpath%)

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
