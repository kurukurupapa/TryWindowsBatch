@echo off
rem Windows�o�b�`�t�@�C���̃e���v���[�g�ł��B

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



rem �����������ɏ����������܂�
echo basedir=%basedir%
echo basename=%basename%
echo batname=%batname%
echo timestamp=%timestamp%
echo ����1=%1
echo ����2=%2
rem �����������ɏ����������܂�



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
