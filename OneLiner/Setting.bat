@echo off
rem �ݒ�t�@�C���ł��B
rem �O���o�b�`�t�@�C������Ăяo����A�ϐ���`����̂ŁA�usetlocal enabledelayedexpansion�v�͋L�q�Ȃ��B

:INIT

:MAIN
call :LOG �����J�n���܂��B

set prjdir=%basedir%\..
set datadir=%basedir%\Data
set expdir=%basedir%\Expectation
set workdir=%basedir%\Work
set performancedir=%TMP%\TryWindowsBatch\OneLiner
set gnubin=D:\Apps\gnuwin32\bin
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
if not exist %workdir% ( mkdir %workdir% )
if not exist %performancedir% ( mkdir %performancedir% )

:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
echo �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% �ݒ�t�@�C�� %1 1>&2
exit /b 0

:EOF
