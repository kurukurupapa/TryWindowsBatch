@echo off
@setlocal enabledelayedexpansion
rem �e�X�g���܂��B

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%~1"=="/?" (
  echo �g�����F%batname% [/?]
  exit /b 0
)

:MAIN
call :LOG �����J�n���܂��B



rem �����������ɏ����������܂�
set prjdir=%basedir%\..
set sut=%prjdir%\%basename:Test=%.bat
set datadir=%prjdir%\Data

call :LOG ---�����Ȃ�
call %sut%
call :LOG ---�w���v
call %sut% "/?"
call :LOG ---1�t�@�C��
call %sut% %datadir%\Dummy.txt
call :LOG ---1�t�@�C���i�󔒂���j
call %sut% "%datadir%\Space Dir\Space File.txt"
call :LOG ---�����t�@�C��
call %sut% %datadir%\Dummy.txt %datadir%\Dummy2.txt %datadir%\Dummy3.txt
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
