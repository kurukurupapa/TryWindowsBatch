@echo off
@setlocal enabledelayedexpansion
rem wget�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set outdir=%CD%
set url=http://www.google.co.jp/
rem echo on

rem GnuWin32
set outpath=%outdir%\%basename%_gnuwin32.txt
del /q index.html > nul 2>&1
%gnubin%\wget %url%
move /y index.html %outpath% > nul

rem Windows�W���R�}���h
rem ���ł��Ȃ��Ǝv���B

rem PowerShell
set outprefix=%outdir%\%basename%_ps_
rem   ��.NET Framework�g�p�B
powershell -Command "(New-Object Net.WebClient).DownloadFile('%url%', '%outprefix%Net-WebClient.txt')"
rem   ��PowerShell 3.0�ȍ~�B
powershell -Command "Invoke-WebRequest -Uri %url% -OutFile %outprefix%Invoke-WebRequest.txt"
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outprefix%Net-WebClient.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outprefix%Net-WebClient.txt)
fc %outdir%\%basename%_gnuwin32.txt %outprefix%Invoke-WebRequest.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outprefix%Invoke-WebRequest.txt)

rem Ruby
set outpath=%outdir%\%basename%_ruby.txt
ruby -ropen-uri -e "open('%url%'){|w| open('%outpath%','wb'){|f| f.puts w.read}}"
rem Check
fc %outdir%\%basename%_gnuwin32.txt %outpath% > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %outdir%\%basename%_gnuwin32.txt %outpath%)

rem �㏈��
echo off



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
