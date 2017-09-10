@echo off
@setlocal enabledelayedexpansion
rem Split���C�N�R�}���h�̊e�탏�����C�i�[�ł��B

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
set inpath=%basedir%\Data\Sample.txt
set incsv=%basedir%\Data\Sample.csv
set num=20
set outdir=%basedir%\Work
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
set PATH=%PATH%;D:\Apps\gnuwin32\bin
rem @echo on

rem --- �s���Ńt�@�C������

rem GnuWin32
@set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
split -l %num% %inpath% %outprefix%
rem Check
dir %outprefix%*

rem Windows�W���R�}���h
rem �W���R�}���h�ł͎����ł��Ȃ��H

rem PowerShell
@rem �G�C���A�X cat -> Get-Content
@set outprefix=%outdir%\%basename%_line_ps_
powershell -Command "$i=0; cat %inpath% -ReadCount %num% | %%{ $path='%outprefix%'+([string]($i+1)).PadLeft(3,'0')+'.txt'; Set-Content -Value $_ $path; $i++ }"
rem Check
dir %outprefix%*

rem --- �L�[���[�h�Ńt�@�C������

rem GnuWin32
@rem 1�s�ڂ̃w�b�_�s��ǂݔ�΂����B
@rem �w��J�����𕶎���ҏW���ăt�@�C�����̈ꕔ�Ƃ����B
@set outprefix=%outdir%\%basename%_key_gnuwin32_
@set outprefix2=%outprefix:\=\\%
@del /q %outprefix%*
awk -F "," "NR>1 {tmp=$3; gsub(\"Group\",\"\",tmp); path=\"%outprefix2%\" tmp \".csv\"; print $0 >> path}" %incsv%
rem Check
dir %outprefix%*

rem PowerShell
@rem �G�C���A�X cat -> Get-Content
@set outprefix=%outdir%\%basename%_key_ps_
@del /q %outprefix%*
powershell -Command "cat %incsv% | Select-Object -Skip 1 | %%{ $tmp=$_.Split(',')[2].Replace('Group',''); $path='%outprefix%'+$tmp+'.csv'; $_ | Out-File -Append -Encoding Default $path }"
rem Check
dir %outprefix%*

@echo off
rem �㏈��
fc %outdir%\%basename%_key_gnuwin32_A.csv %outdir%\%basename%_key_ps_A.csv



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
