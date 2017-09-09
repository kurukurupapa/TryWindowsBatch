@echo off
@setlocal enabledelayedexpansion
rem Grep���C�N�R�}���h�i�e�L�X�g�t�@�C���̍s���o�j�̊e�탏�����C�i�[�ł��B

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
rem �L���u^�v�͍s�A�������B�G�X�P�[�v�������Ƃ��́u^�v�Ƃ���B
set inpath=.\Data\Sample.txt
set pattern=abc
set pattern2=�T���v��
set pattern_space=a pen
set pattern_re=^^a.*z$
set pattern_re2=�T.*��
set outdir=%basedir%\Work
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
@echo on

rem Windows�W���R�}���h
findstr %pattern% %inpath%
findstr "%pattern% %pattern2%" %inpath%
findstr /c:"%pattern_space%" %inpath%
findstr /r "%pattern_re% %pattern_re2%" %inpath%
@set outpath=%outdir%\%basename%_findstr_v.txt
findstr /v %pattern% %inpath% > %outpath%

rem PowerShell
@rem Select-String�͓��̓t�@�C����UTF-8�Ƃ��ēǂݍ��ށBSJIS��ǂݍ��ނɂ�Get-Content��ʂ��B
@rem �G�C���A�X cat -> Get-Content
powershell -Command "cat %inpath% | Select-String -Pattern '%pattern_re%'"
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern%', '%pattern2%', '%pattern_space%') -SimpleMatch -CaseSensitive"
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern_re%', '%pattern_re2%')"
@set outpath=%outdir%\%basename%_ps_not.txt
powershell -Command "cat %inpath% | Select-String -Pattern %pattern_re% -NotMatch" > %outpath%

@echo off
rem �㏈��
rem fc %winmerge% %outdir%\%basename%_findstr_v.txt %outdir%\%basename%_ps_not.txt



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
