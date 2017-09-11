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
set inpath=%basedir%\Data\Sample.txt
set incsv=%basedir%\Data\Sample.csv
set num=20
set outdir=%CD%
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
set PATH=%PATH%;D:\Apps\gnuwin32\bin
rem @echo on

rem --- �s���Ńt�@�C������

rem GnuWin32
@set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
split -l %num% %inpath% %outprefix%
rem Check
dir %outprefix%*

rem Windows�W���R�}���h for��1
@rem ��s�͓ǂݔ�΂����B
@rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
@rem �����ł́A�L���u%�v���u%%�v�փG�X�P�[�v���Ă���B
@set outprefix=%outdir%\%basename%_line_for1_
@del /q %outprefix%*
set i=0 & set j=0 & (for /f "delims= eol=" %%a in (%inpath%) do (set /a tmp=!i! %% %num% & (if !tmp!==0 set /a j=!j!+1) & (echo %%a)>>%outprefix%!j!.txt & set /a i=!i!+1))
rem Check
dir %outprefix%*

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

rem PowerShell �t�@�C���ǋL����
@rem �G�C���A�X cat -> Get-Content
@set outprefix=%outdir%\%basename%_key_ps_append_
@del /q %outprefix%*
powershell -Command "cat %incsv% | Select-Object -Skip 1 | %%{ $tmp=$_.Split(',')[2].Replace('Group',''); $path='%outprefix%'+$tmp+'.csv'; $_ | Out-File -Append -Encoding Default $path }"
rem Check
dir %outprefix%*

rem PowerShell �n�b�V������
@rem �G�C���A�X cat -> Get-Content
@set outprefix=%outdir%\%basename%_key_ps_hash_
@set column=2
@del /q %outprefix%*
powershell -Command "$hash=@{}; cat %incsv% | Select-Object -Skip 1 | %%{ $key=$_.Split(',')[%column%-1].Replace('Group',''); if(!$hash.ContainsKey($key)){$hash[$key]=[Collections.ArrayList]@()}; $hash[$key].Add($_) }; foreach($k in $hash.Keys){ $path='%outprefix%'+$k+'.csv'; Set-Content -Value $hash[$k] $path }"
rem Check
dir %outprefix%*

@rem �㏈��
@echo off
fc %outdir%\%basename%_line_gnuwin32.txt.aa %outdir%\%basename%_line_for1_1.txt
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
