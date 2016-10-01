@echo off
rem �e�L�X�g�t�@�C�����̕������ϊ����܂��B
rem �e�L�X�g�t�@�C���́A�V�t�gJIS�ACRLF�̑O��ł��B

rem �Q�l
rem �o�b�`�t�@�C���Ńe�L�X�g�t�@�C�����̕�����u�� - REONTOSANTA
rem http://knowledge.reontosanta.com/archives/816
rem �o�b�`�t�@�C�� | �e�L�X�g�t�@�C���� 1 �s���ǂݍ��� (���S�ŁH) ( ���̑��R���s���[�^ ) - Kerupani129 Project �̃u���O - Yahoo!�u���O
rem http://blogs.yahoo.co.jp/kerupani/15344574.html

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%1"=="/?" (
  echo �g�����F%batname% ���̓t�@�C�� �o�̓t�@�C�� �u���O������ �u���㕶����
  exit /b 0
)
if "%4"=="" (
  echo �����̐����s���ł��B
  goto ERROR
)
set inpath=%1
set outpath=%2
set before=%3
set after=%4

:MAIN
call :LOG �����J�n���܂��B


type nul > %outpath%
setlocal enabledelayedexpansion
for /f "tokens=1* delims=: eol=" %%a in ('findstr /n "^" %inpath%') do (
  set line=%%b
  if not "!line!" == "" (
    set line=!line:%before%=%after%!
  )
  echo.!line!>> %outpath%
)
endlocal


:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
call :LOG �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1
exit /b 0

:EOF
