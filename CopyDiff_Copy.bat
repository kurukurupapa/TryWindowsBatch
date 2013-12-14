@echo off

rem ��̃f�B���N�g���Ԃ̍����t�@�C���𒊏o����Windows�o�b�`�t�@�C���ł��B

setlocal
set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%1"=="" goto USAGE
if "%2"=="" goto USAGE
if "%3"=="" goto USAGE
if "%4"=="" goto USAGE

:MAIN
echo �����J�n���܂��B



set inbasedir=%1
set outbasedir=%2
set subdir=%3
set subname=%4

set indir=%inbasedir%\%subdir%
set inpath=%indir%\%subname%
set outdir=%outbasedir%\%subdir%
set outpath=%outdir%\%subname%

echo inpath=%inpath%
echo outpath=%outpath%

[ -d %inpath% ]
if %ERRORLEVEL%==0 (
	rem �f�B���N�g���̃R�s�[
	call :MKDIR_PROC %outpath%
	echo xcopy /y /e %inpath% %outpath%
	xcopy /y /e %inpath% %outpath%
) else (
	rem �t�@�C���̃R�s�[
	call :MKDIR_PROC %outdir%
	echo xcopy /y %inpath% %outdir%
	xcopy /y %inpath% %outdir%
)

endlocal
goto END
rem ------------------------------
rem �֐��Q
rem ------------------------------

:MKDIR_PROC
if not exist %1 (
	mkdir %1
)
exit /b 0



:END
echo ����I���ł��B
exit /b 0

:USAGE
echo �g�����F%batname% �ύX�O�f�B���N�g�� �ύX��f�B���N�g�� �o�̓f�B���N�g��
exit /b 0

:ERROR
echo �G���[�I���ł��B
exit /b -1

:EOF
