@echo off
@setlocal enabledelayedexpansion
rem Sed���C�N�R�}���h�̊e�탏�����C�i�[�ł��B�i�p�t�H�[�}���X�e�X�g�j

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
set inpath=.\dummy_100MB.csv
set outdir=%CD%
set before=abc
set after=_abc_
set PATH=%PATH%;D:\Apps\gnuwin32\bin
rem @echo on

rem GnuWin32
@set outpath=%outdir%\%basename%_gnuwin32.txt
@echo %DATE% %TIME% GnuWin32 START
sed "s/%before%/%after%/g" %inpath% > %outpath%
@echo %DATE% %TIME% GnuWin32 END

rem Windows�W���R�}���h for��1
@rem Windows�o�b�`�t�@�C���ł́A�L���u%�v���u%%�v�փG�X�P�[�v���K�v�B
@rem ��s�͓ǂݔ�΂����B
@set outpath=%outdir%\%basename%_for1.txt
@echo %DATE% %TIME% Windows�W���R�}���hfor��1 START
(for /f "delims= eol=" %%a in (%inpath%) do @((set v=%%a) & (echo !v:%before%=%after%!))) > %outpath%
@echo %DATE% %TIME% Windows�W���R�}���hfor��1 END

rem PowerShell
@rem Windows�o�b�`�t�@�C���ł́A�L���u%�v���u%%�v�փG�X�P�[�v���K�v�B
@rem �G�C���A�X cat -> Get-Content
@set outpath=%outdir%\%basename%_ps.txt
@echo %DATE% %TIME% PowerShell START
powershell -Command "cat %inpath% | %% { $_ -Replace '%before%', '%after%' }" > %outpath%
@echo %DATE% %TIME% PowerShell END

@rem �㏈��
@echo off



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
