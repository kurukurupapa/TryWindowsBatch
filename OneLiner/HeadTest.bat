@echo off
@setlocal enabledelayedexpansion
rem Head���C�N�R�}���h�̊e�탏�����C�i�[�ł��B

set basedir=%~dp0
set basename=%~n0
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
set inpath=.\Data\Sample.txt
set num=3
set /a index=%num%-1
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
rem @echo on

rem Windows�W���R�}���h for��1
rem ��s�͓ǂݔ�΂����B
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem �S�s��ǂݍ��ނ̂Ńp�t�H�[�}���X�����B
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
set outpath=%outdir%\%basename%_for1.txt
set i=0 & (for /f "delims= eol=" %%a in (%inpath%) do ( if !i! lss %num% (echo %%a) & set /a i=!i!+1 )) > %outpath%
rem Check
rem fc %inpath% %outpath%

rem PowerShell 2.0
set outpath=%outdir%\%basename%_ps2.txt
powershell -Command "(Get-Content %inpath%)[0..%index%]" > %outpath%
rem Check
rem fc %inpath% %outpath%

rem PowerShell 3.0�ȏ�
set outpath=%outdir%\%basename%_ps3.txt
powershell -Command "Get-Content %inpath% -Head %num%" > %outpath%
rem Check
rem fc %inpath% %outpath%

@echo off
rem �㏈��
start %winmerge% %outdir%\%basename%_ps3.txt %outdir%\%basename%_ps2.txt
start %winmerge% %outdir%\%basename%_ps3.txt %outdir%\%basename%_for1.txt



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