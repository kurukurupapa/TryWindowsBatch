@echo off
@setlocal enabledelayedexpansion
rem cat�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set inpath=%batdir%\Data\Sample.txt
set outdir=%batdir%\Work
rem echo on


echo GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
%gnubin%\cat %inpath% > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)


echo Windows�W���R�}���h type�R�}���h
set outpath=%outdir%\%basename%_type.txt
type %inpath% > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

echo Windows�W���R�}���h for��1 �ȈՔ�
rem �e�s�́A�󔒂܂��̓^�u�ŕ�������A1�ڂ̃g�[�N���̂ݏo�͂����B
rem �u;�v�n�܂�̍s�̓R�����g�s�Ƃ݂Ȃ���ǂݔ�΂����B
rem ��s�͓ǂݔ�΂����B
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
set outpath=%outdir%\%basename%_for1.txt
(for /f %%a in (%inpath%) do (echo %%a)) > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

echo Windows�W���R�}���h for��2 ���P��
rem �g�[�N�������A�R�����g�s������s��Ȃ��B
rem ��s�͓ǂݔ�΂����B
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
set outpath=%outdir%\%basename%_for2.txt
(for /f "delims= eol=" %%a in (%inpath%) do (echo %%a)) > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

echo Windows�W���R�}���h for��3 ���P��
rem /f�I�v�V�����Ńe�L�X�g�t�@�C���̒��g�������ł���B
rem �e�s�͋�؂蕶���ŕ�������g�[�N���ƌĂ΂��B��؂蕶����delims�Ŏw��\�B�f�t�H���g�̓X�y�[�X�ƃ^�u�B
rem �����ΏۂƂ���g�[�N����tokens�Ŏw��\�B�����w�肵���ꍇ�A�������ϐ��i���L%a�j����ɃA���t�@�x�b�g���ɐV���ȕϐ��i%b,%c,...�j����`����Ċe�g�[�N�����ݒ肳���B
rem �R�����g�s�͓ǂݔ�΂����B�R�����g�s�Ɣ��f����s��������eol�Ŏw��\�B�f�t�H���g�́u;�v�B
rem ��s�͓ǂݔ�΂����B���L�̂悤�Ɂufindstr /n "^"�v�ōs�ԍ���t�^���A�udelims=:�v�ōs�ԍ���؂�̂Ă邱�Ƃŋ�s��\���ł���B
rem �������A���e�L�X�g�̍s�����u:�v�̏ꍇ�A�s�ԍ��t�^���́u:�v�ƁA���e�L�X�g�s���́u:�v���A�����Ă��܂��A1�̋�؂蕶���Ƃ��Ĉ����A�u:�v�������Ă��܂��B
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
set outpath=%outdir%\%basename%_for3.txt
(for /f "tokens=1* delims=: eol=" %%a in ('findstr /n "^" %inpath%') do (echo.%%b)) > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

echo Windows�W���R�}���h for��4 ���P��
rem ��Lfor��3�ɔ�ׂāA�s���u:�v���c�����Ƃ��ł���B
rem �Q��
rem �o�b�`�t�@�C�� | �e�L�X�g�t�@�C���� 1 �s���ǂݍ��� (���S�ŁH) ( ���̑��R���s���[�^ ) - Kerupani129 Project �̃u���O - Yahoo!�u���O
rem https://blogs.yahoo.co.jp/kerupani/15344574.html
set outpath=%outdir%\%basename%_for4.txt
(for /f "tokens=* delims=0123456789 eol=" %%a in ('findstr /n "^" %inpath%') do (set v=%%a& echo.!v:~1!)) > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)


echo PowerShell
rem �G�C���A�X cat -> Get-Content
set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath%" > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)


:PERL
echo Perl
set outpath=%outdir%\%basename%_perl
perl -ne "print $_" %inpath% > %outpath%1.txt
perl -pe "" %inpath% > %outpath%2.txt
rem Check
call :CHECK %inpath% %outpath%1.txt
call :CHECK %inpath% %outpath%2.txt


echo Ruby
rem �f�t�H���g�̊O��/�����G���R�[�f�B���O��Windows-31J�̖͗l�B���̂��ߓ��͏o�̓t�@�C����Windows-31J�ƌ��Ȃ��B
rem �K�v�Ȃ�ruby�R�}���h��-E�I�v�V�����ŃG���R�[�f�B���O���w�肷��B
set outpath=%outdir%\%basename%_ruby.txt
ruby -ne "puts $_" %inpath% > %outpath%
rem Check
fc %inpath% %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %inpath% %outpath%)

rem �㏈��
echo off
start %winmerge% %outdir%\%basename%_for2.txt %outdir%\%basename%_for4.txt



:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
echo �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:CHECK
fc %1 %2 > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %1 %2)
exit /b 0

:EOF
