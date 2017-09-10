@echo off
@setlocal enabledelayedexpansion
rem Split���C�N�R�}���h�̊e�탏�����C�i�[�ł��B�i�p�t�H�[�}���X�e�X�g�j

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
set inpath=.\dummy_1000MB.csv
set num=100000
set inpath_small=.\dummy_10MB.csv
set num_small=10000
set outdir=.
set PATH=%PATH%;D:\Apps\gnuwin32\bin
rem @echo on

rem --- �s���Ńt�@�C������

rem GnuWin32
@set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
@echo %DATE% %TIME% GnuWin32 START
split -l %num% %inpath% %outprefix%
@echo %DATE% %TIME% GnuWin32 END
rem Check
rem dir %outprefix%*

rem Windows�W���R�}���h for��1
@rem ��s�͓ǂݔ�΂����B
@rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
@rem �����ł́A�L���u%�v���u%%�v�փG�X�P�[�v���Ă���B
@set outprefix=%outdir%\%basename%_line_for1_
@del /q %outprefix%*
@echo ���̓t�@�C��=%inpath_small%
@echo %DATE% %TIME% Windows�W���R�}���hfor��1 START
(set /a i=0)&(set /a j=0)&(for /f "delims= eol=" %%a in (%inpath_small%) do ((set /a tmp=!i! %% %num_small%)&(if !tmp!==0 (set /a j=!j!+1)&(set jstr=00!j!)&(set jstr=!jstr:~-3!))&((echo %%a)>>%outprefix%!jstr!.txt)&(set /a i=!i!+1)))
@echo %DATE% %TIME% Windows�W���R�}���hfor��1 END
rem Check
rem dir %outprefix%*

rem PowerShell
@rem �G�C���A�X cat -> Get-Content
@set outprefix=%outdir%\%basename%_line_ps_
@echo %DATE% %TIME% PowerShell START
powershell -Command "$i=0; cat %inpath% -ReadCount %num% | %%{ $path='%outprefix%'+([string]($i+1)).PadLeft(3,'0')+'.txt'; Set-Content -Value $_ $path; $i++ }"
@echo %DATE% %TIME% PowerShell END
rem Check
rem dir %outprefix%*

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
