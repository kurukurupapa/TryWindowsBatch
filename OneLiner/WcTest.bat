@echo off
@setlocal enabledelayedexpansion
rem wc -l �R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set pathlist=%inpath%
set pathlist=%pathlist% %batdir%\Data\OneLine.txt
set pathlist=%pathlist% %batdir%\Data\Zero.txt
rem echo on

rem GnuWin32
echo GnuWin32
for %%p in (%pathlist%) do (
  %gnubin%\wc -l %%p
)

rem Windows�W���R�}���h for��1
rem ��s�͓ǂݔ�΂����B
rem �usetlocal enabledelayedexpansion�v���w�肵�Ă���ꍇ�A�u!�v��u!�v�Ŋ���ꂽ�����񂪏�����B
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
echo Windows for��
for %%p in (%pathlist%) do (
  set i=0 & (for /f "delims= eol=" %%a in (%%p) do (set /a i=!i!+1)) & echo !i!
)

rem Windows�W���R�}���h for��2
rem �I�v�V�����̏ڍׂ́ACatTest.bat�Q�ƁB
rem ���L�R�}���h���R�}���h���C��������s����ꍇ�Afor���̕ϐ��̓��u%%�v�́u%�v�Ƃ���B
for %%p in (%pathlist%) do (
  set i=0 & (for /f "tokens=1* delims=: eol=" %%a in ('findstr /n "^" %%p') do (set /a i=!i!+1)) & echo !i!
)

rem PowerShell
echo PowerShell
for %%p in (%pathlist%) do (
  rem ���̎������ƁA1�s�̏ꍇ�A���������o�͂��Ă��܂��B
  rem powershell -Command "$(Get-Content %%p).Length"
  powershell -Command "$(Get-Content %%p | Measure-Object).Count"
)
for %%p in (%pathlist%) do (
  powershell -Command "$i=0; cat %%p | %%{ $i++ }; $i"
)

rem Perl
echo Perl
for %%p in (%pathlist%) do (
  perl -ne "BEGIN{$count=0}; $count+=1; END{print \"$count\n\"}" %%p
)
for %%p in (%pathlist%) do (
  perl -nE "END{print \"$.\n\"}" %%p
)

rem Ruby
rem TODO 0�o�C�g�t�@�C���̏ꍇ�A�o�͂��Ȃ��Ȃ��Ă��܂��B
echo Ruby
for %%p in (%pathlist%) do (
  ruby -ne "BEGIN{count=0}; count+=1; END{puts count}" %%p
)

@echo off
rem �㏈��



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
