@echo off
@setlocal enabledelayedexpansion
rem ls�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set indir=%batdir:~0,-1%\Data
set outdir=%CD%
rem echo on

rem GnuWin32
rem GnuWin32 �t�@�C�����̂�
set outpath=%outdir%\%basename%_gnuwin32_path.txt
%gnubin%\ls -dR %indir%\* > %outpath%
rem GnuWin32 �t�����t��
set outpath=%outdir%\%basename%_gnuwin32_info.txt
%gnubin%\ls -ldR %indir%\* > %outpath%

rem Windows�W���R�}���h for��
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
rem Windows�W���R�}���h for�� �t�@�C�����̂�
set outpath=%outdir%\%basename%_for_path.txt
(for /f "delims= eol=" %%a in ('dir /s /b %indir%') do (set v=%%a & if not "!v:~0,1!"==" " (if "!v:<DIR>=!"=="!v!" echo %%a))) > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_path.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_path.txt %outpath%)

rem Windows�W���R�}���h for�� �t�����t��
rem ������������B

rem Windows�W���R�}���h forfiles
rem �擪�ɋ�s���o�͂���Ă��܂��̂ŁAfindstr�ŏ������Ă��܂��B
rem Windows�W���R�}���h forfiles �t�@�C�����̂�
set outpath=%outdir%\%basename%_forfiles_path.txt
forfiles -s -p %indir% -c "cmd /c echo @path" | findstr "." > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_path.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_path.txt %outpath%)

rem Windows�W���R�}���h forfiles �t�����t��
set outpath=%outdir%\%basename%_forfiles_info.txt
forfiles -s -p %indir% -c "cmd /c echo @fdate,@fsize,DIR=@isdir,@path" | findstr "." > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_info.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_info.txt %outpath%)

rem PowerShell
rem PowerShell �t�@�C�����̂�
set outpath=%outdir%\%basename%_ps_path.txt
powershell -Command "ls -Recurse %indir% | %%{$_.FullName}" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_path.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_path.txt %outpath%)

rem PowerShell �t�����t��
set outpath=%outdir%\%basename%_ps_info.txt
powershell -Command "ls -Recurse %indir% | %%{$_.LastWriteTime.ToString('yyyy/MM/dd HH:mm:ss')+','+$_.Length+','+$_.Attributes+','+$_.FullName}" > %outpath%
rem Check
fc %outdir%\%basename%_gnuwin32_info.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32_info.txt %outpath%)

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
