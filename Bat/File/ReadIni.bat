@echo off
@setlocal enabledelayedexpansion
rem INI�t�@�C���ǂݍ��݂̗��K�ł��B

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
if "%~1"=="/?" set help=1
if "%help%"=="1" (
  echo �g�����F%batname% [/?]
  exit /b 0
)

:MAIN
call :LOG �����J�n���܂��B


set inpath=%batdir%\%basename%.ini
set sec=
for /f "tokens=1,2 delims== eol=;" %%a in (%inpath%) do (
  set tmp=%%a
  if "!tmp:~0,1!!tmp:~-1,1!"=="[]" (
    rem �Z�N�V�����̏ꍇ
    set sec=!tmp:~1,-1!
    set key=
    set val=
  ) else (
    rem �L�[�o�����[�̏ꍇ
    set key=%%a
    set val=%%b
  )
  rem �擾�����l���o�͂��Ă݂�
  echo !sec!,!key!,!val!
  rem ���ϐ��ɐݒ肵�Ă݂�
  set !sec!_!key!=!val!
)

rem ���ϐ��ɐݒ肵���l���o�͂��Ă݂�
echo !Section1_Key11!


:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
call :LOG �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:EOF
