@echo off
@setlocal enabledelayedexpansion
rem �_�~�[��CSV�t�@�C�����쐬���܂��B
rem DummyCsv.bat 100000 > dummy_10MB.csv
rem DummyCsv.bat 1000000 > dummy_100MB.csv

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%~1"==""   set help=1
if "%~1"=="/?" set help=1
if "%help%"=="1" (
  echo �g�����F%batname% [/?] �s��
  exit /b 0
)
set numline=%1

:MAIN
call :LOG �����J�n���܂��B



set char50=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
for /L %%i in (1,1,%numline%) do (
  set /a number=!RANDOM!
  rem set /a number=!RANDOM!*10000/32768
  echo %%i,0123456789,"abcde","ABCDE","���{��e�L�X�g",!number!,%char50%
  set /a tmp=%%i%%10000
  if !tmp!==0 (
    call :LOG %%i
  )
)



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
