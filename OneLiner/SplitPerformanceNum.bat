@echo off
@setlocal enabledelayedexpansion
rem split�R�}���h���C�N�̊e�탏�����C�i�[�ł��B�i�p�t�H�[�}���X�e�X�g�j

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
set inpath=%performancedir%\dummy_100MB.csv
set num=100000
set inpath_small=%performancedir%\dummy_1MB.csv
set num_small=10000
set outdir=%performancedir%
rem echo on

rem --- �s���Ńt�@�C������
rem �p�t�H�[�}���X���莖��
rem   �f�[�^�F100���s�A100MB�A�p�\�R���FIntel Atom 1.44GHz ������2GB �X�g���[�WeMMC
rem     0.2�� GnuWin32
rem     0.3�� PowerShell
rem   �f�[�^�F1���s�A1MB�A�p�\�R���FIntel Atom 1.44GHz ������2GB �X�g���[�WeMMC
rem     0.3�� Windows�W���R�}���h for��1

rem GnuWin32
set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
echo %DATE% %TIME% GnuWin32 START %inpath%
set start=%DATE% %TIME%
%gnubin%\split -l %num% %inpath% %outprefix%
set end=%DATE% %TIME%
echo %DATE% %TIME% GnuWin32 END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"
rem Check
rem dir %outprefix%*

rem Windows�W���R�}���h for��1
set outprefix=%outdir%\%basename%_line_for1_
if exist %outprefix%* ( del /q %outprefix%* )
echo %DATE% %TIME% Windows�W���R�}���hfor��1 START %inpath_small%
set start=%DATE% %TIME%
set i=0 & set j=0 & (for /f "delims= eol=" %%a in (%inpath_small%) do (set /a tmp=!i! %% %num_small% & (if !tmp!==0 (set /a j=!j!+1)&(set jstr=00!j!)&(set jstr=!jstr:~-3!)) & (echo %%a)>>%outprefix%!jstr!.txt & set /a i=!i!+1))
set end=%DATE% %TIME%
echo %DATE% %TIME% Windows�W���R�}���hfor��1 END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"
rem Check
rem dir %outprefix%*

rem PowerShell
set outprefix=%outdir%\%basename%_line_ps_
echo %DATE% %TIME% PowerShell START %inpath%
set start=%DATE% %TIME%
powershell -Command "$i=0; cat %inpath% -ReadCount %num% | %%{ Set-Content -Value $_ ('%outprefix%'+([string]($i+1)).PadLeft(3,'0')+'.txt'); $i++ }"
set end=%DATE% %TIME%
echo %DATE% %TIME% PowerShell END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"
rem Check
rem dir %outprefix%*


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
