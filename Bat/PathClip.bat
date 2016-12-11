@echo off
@setlocal enabledelayedexpansion
rem �t�@�C��/�t�H���_�̃p�X���N���b�v�{�[�h�ɃR�s�[���܂��B

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%1"=="/?" (
  echo �g�����F%batname% [/?]
  exit /b 0
)

:MAIN
call :LOG �����J�n���܂��B



set tmppath=%basedir%\%basename%_tmp.txt
type nul > "%tmppath%"
for %%a in (%*) do (
  echo %%a>>"%tmppath%"
)
type "%tmppath%" | clip



:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
echo �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1
exit /b 0

:EOF
