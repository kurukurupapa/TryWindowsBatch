@echo off
@setlocal enabledelayedexpansion
rem split�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set outdir=%CD%
rem echo on

rem --- �s���Ńt�@�C������
set inpath=%batdir%\Data\Sample.txt
set num=20

rem GnuWin32
set outprefix=%outdir%\%basename%_line_gnuwin32.txt.
%gnubin%\split -l %num% %inpath% %outprefix%
rem Check
dir %outprefix%*

rem Windows�W���R�}���h for��1
rem ��s�͓ǂݔ�΂����B
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem �����ł́A�L���u%�v���u%%�v�փG�X�P�[�v���Ă���B
set outprefix=%outdir%\%basename%_line_for1_
del /q %outprefix%* > nul
set i=0 & set j=0 & (for /f "delims= eol=" %%a in (%inpath%) do (set /a tmp=!i! %% %num% & (if !tmp!==0 (set /a j=!j!+1)&(set jstr=00!j!)&(set jstr=!jstr:~-3!)) & (echo %%a)>>%outprefix%!jstr!.txt & set /a i=!i!+1))
rem Check
dir %outprefix%*
fc %outdir%\%basename%_line_gnuwin32.txt.aa %outprefix%001.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_line_gnuwin32.txt.aa %outprefix%001.txt)

rem PowerShell
rem �G�C���A�X cat -> Get-Content
set outprefix=%outdir%\%basename%_line_ps_
powershell -Command "$i=0; cat %inpath% -ReadCount %num% | %%{ Set-Content -Value $_ ('%outprefix%'+([string]($i+1)).PadLeft(3,'0')+'.txt'); $i++ }"
rem Check
dir %outprefix%*
fc %outdir%\%basename%_line_gnuwin32.txt.aa %outprefix%001.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_line_gnuwin32.txt.aa %outprefix%001.txt)

rem --- �L�[���[�h�Ńt�@�C������
set incsv=%batdir%\Data\Sample.csv
set column=3

rem GnuWin32
rem 1�s�ڃw�b�_�s��ǂݔ�΂��B
set outprefix=%outdir%\%basename%_key_gnuwin32_
set outprefix2=%outprefix:\=\\%
del /q %outprefix%* > nul
%gnubin%\awk -F "," "NR>1 { print $0 >> \"%outprefix2%\" $%column% \".csv\" }" %incsv%
%gnubin%\awk -F "," "NR>1 { tmp=$%column%; gsub(\"Group\",\"\",tmp); print $0 >> \"%outprefix2%\" tmp \".csv\"}" %incsv%
rem Check
dir %outprefix%*

rem PowerShell �t�@�C���ǋL����
rem �����������܂�g��Ȃ��ŏ����ł��邪�A���Ȃ�x���B�傫���t�@�C���ɂ͌����Ȃ��B
rem 1�s�ڃw�b�_�s��ǂݔ�΂��B
set outprefix=%outdir%\%basename%_key_ps_append_
del /q %outprefix%* > nul
powershell -Command "cat %incsv% | Select-Object -Skip 1 | %%{ Out-File -Append -Encoding Default -InputObject $_ ('%outprefix%'+($_.Split(',')[%column%-1])+'.csv') }"
powershell -Command "cat %incsv% | Select-Object -Skip 1 | %%{ Out-File -Append -Encoding Default -InputObject $_ ('%outprefix%'+($_.Split(',')[%column%-1].Replace('Group',''))+'.csv') }"
rem Check
dir %outprefix%*
fc %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv)

rem PowerShell �n�b�V������
rem �����̃��������g�p���āA�t�@�C���������݂��œK���B
rem ���̓t�@�C���Ɠ����̃��������g�p���Ă��܂����߁A����t�@�C���ɂ͌����Ȃ��B
rem �����������C�i�[�Ƃ������x���ł͂Ȃ��A������Ƃ����v���O���~���O�ɂȂ��Ă���B�B�B
rem 1�s�ڃw�b�_�s��ǂݔ�΂��B
rem Windows�o�b�`�t�@�C���ɂ��������L���̃G�X�P�[�v�u!�v���u^!�v
set outprefix=%outdir%\%basename%_key_ps_hash_
powershell -Command "$hash=@{}; cat %incsv% | Select-Object -Skip 1 | %%{ $key=$_.Split(',')[%column%-1]; if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Set-Content -Value $hash[$k] ('%outprefix%'+$k+'.csv') }"
powershell -Command "$hash=@{}; cat %incsv% | Select-Object -Skip 1 | %%{ $key=$_.Split(',')[%column%-1].Replace('Group',''); if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Set-Content -Value $hash[$k] ('%outprefix%'+$k+'.csv') }"
rem Check
dir %outprefix%*
fc %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv)

rem PowerShell �t�@�C���ǋL�����E�n�b�V�������̃n�C�u���b�h
rem �������g�p�ʂɐ�����݂��āA�t�@�C���������݂��œK���B����t�@�C���ł��Ή��\�B
rem �����������C�i�[�Ƃ������x���ł͂Ȃ��A������Ƃ����v���O���~���O�ɂȂ��Ă���B�B�B
rem 1�s�ڃw�b�_�s�̓ǂݔ�΂����ȗ��B
rem Windows�o�b�`�t�@�C���ɂ��������L���̃G�X�P�[�v�u!�v���u^!�v
set outprefix=%outdir%\%basename%_key_ps_hybrid_
set block=100000
del /q %outprefix%* > nul
powershell -Command "cat %incsv% -ReadCount %block% | %%{ $hash=@{}; $_ | %%{ $key=$_.Split(',')[%column%-1]; if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Out-File -Append -Encoding Default -InputObject $hash[$k] ('%outprefix%'+$k+'.csv') }}"
powershell -Command "cat %incsv% -ReadCount %block% | %%{ $hash=@{}; $_ | %%{ $key=$_.Split(',')[%column%-1].Replace('Group',''); if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Out-File -Append -Encoding Default -InputObject $hash[$k] ('%outprefix%'+$k+'.csv') }}"
rem Check
dir %outprefix%*
fc %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_key_gnuwin32_A.csv %outprefix%A.csv)

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
