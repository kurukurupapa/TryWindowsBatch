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
echo performancedir=%performancedir%
rem echo on

rem --- �e�s�̃n�b�V���l�Ńt�@�C������
rem �p�t�H�[�}���X���莖��
rem   �f�[�^�F100���s�A100MB�A�p�\�R���FIntel Atom 1.44GHz ������2GB �X�g���[�WeMMC
rem     PowerShell ����1   2.3�`2.4��
set incsv=%performancedir%\dummy_100MB.csv
echo %incsv%

rem PowerShell ����1
set outprefix=%performancedir%\%basename%_ps1_
set block=100000
set start=%DATE% %TIME%
powershell -Command "cat %incsv% -ReadCount %block% | %%{ $hash=@{}; $_ | %%{ $k=$_.GetHashCode() %% 50 + 50; if(-Not $hash.ContainsKey($k)){ $hash[$k]=[Collections.ArrayList]@() }; $hash[$k].Add($_)>$null }; foreach($k in $hash.Keys){ Out-File -Append -Encoding Default -InputObject $hash[$k] ('%outprefix%'+$k+'.csv') }}"
set end=%DATE% %TIME%
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.0')+'�� PowerShell ����1'"

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
