@echo off
@setlocal enabledelayedexpansion
rem �e��ЂȌ`�t�@�C���𐶐����܂��B

set basedir=%~dp0
set basename=%~n0
set batdir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
set debug=0
if "%~1"==""   set help=1
if "%~1"=="/?" set help=1
set type=%1
set inpath=%batdir%\%basename%.ini
set outdir=%CD%

:MAIN
call :LOG �����J�n���܂��B
if "%help%"=="1" (
  call :HELP
) else (
  call :PROC
)
goto :END


:HELP
echo �g�����F%batname% [/?] type
echo type:
for /f "tokens=1,2 delims== eol=;" %%a in (%inpath%) do (
  set tmp=%%a
  if "!tmp:~0,1!!tmp:~-1,1!"=="[]" (
    rem �Z�N�V�����̏ꍇ
    set sec=!tmp:~1,-1!
    echo !sec!
  )
)
exit /b 0


:PROC
set sec=
for /f "tokens=1,2 delims== eol=;" %%a in (%inpath%) do (
  set tmp=%%a
  if "!tmp:~0,1!!tmp:~-1,1!"=="[]" (
    rem �Z�N�V�����̏ꍇ
    set sec=!tmp:~1,-1!
  ) else (
    rem �L�[�o�����[�̏ꍇ
    set key=%%a
    set val=%%b

    rem �Ώۂł���Ύ��s����
    if "!sec!"=="%type%" (
      echo !val!
      !val!
    )
  )
)
exit /b 0


:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
call :LOG �ُ�I���ł��B
exit /b 1

:LOG
if "%debug%"=="1" (
  echo %DATE% %TIME% %basename% %1 1>&2
)
exit /b 0

:EOF
