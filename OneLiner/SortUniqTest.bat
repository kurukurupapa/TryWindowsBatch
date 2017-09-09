@echo off
@setlocal enabledelayedexpansion
rem Sort,Uniq���C�N�R�}���h�̊e�탏�����C�i�[�ł��B

set basedir=%~dp0
set basename=%~n0
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
set inpath=%basedir%\Data\Sample.txt
set outdir=%basedir%\Work
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
@echo on

rem Windows�W���R�}���h
@set outpath=%outdir%\%basename%_sort_for1.txt
set p= & (for /f "delims= eol=" %%a in ('sort %inpath%') do @(if not "%p%"=="%%a" (echo %%a) & set p=%%a)) > %outpath%

rem PowerShell
@rem �G�C���A�X cat -> Get-Content, sort -> Sort-Object
@set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | sort | Get-Unique" > %outpath%

@rem �㏈��
@echo off
start %winmerge% %outdir%\%basename%_sort_for1.txt %outdir%\%basename%_ps.txt



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
