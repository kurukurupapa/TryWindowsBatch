@echo off
@setlocal enabledelayedexpansion
rem Grep���C�N�R�}���h�i�e�L�X�g�t�@�C���̍s���o�j�̊e�탏�����C�i�[�ł��B

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
rem �L���u^�v�͍s�A�������B�G�X�P�[�v�������Ƃ��́u^^�v�Ƃ���B
set inpath=%basedir%\Data\Sample.txt
set pattern=abc
set pattern2=�T���v��
set pattern_space=a pen
set pattern_re=^^a.*z$
set pattern_re2=�T.*��
set outdir=%CD%
set winmerge=D:\Apps\WinMerge\WinMergeU.exe /s
@echo on

rem GnuWin32
grep %pattern% %inpath%
@set outpath=%outdir%\%basename%_gnuwin32.txt
grep -E "(%pattern_re%|%pattern_re2%)" %inpath% > %outpath%
@set outpath=%outdir%\%basename%_gnuwin32_not.txt
grep -v -E "(%pattern_re%|%pattern_re2%)" %inpath% > %outpath%

rem Windows�W���R�}���h
findstr %pattern% %inpath%
findstr "%pattern% %pattern2%" %inpath%
findstr /c:"%pattern_space%" %inpath%
@set outpath=%outdir%\%basename%_findstr.txt
findstr /r "%pattern_re% %pattern_re2%" %inpath% > %outpath%
@set outpath=%outdir%\%basename%_findstr_v.txt
findstr /v /r "%pattern_re% %pattern_re2%" %inpath% > %outpath%

rem PowerShell
@rem Select-String�͓��̓t�@�C����UTF-8�Ƃ��ēǂݍ��ށBSJIS��ǂݍ��ނɂ�Get-Content��ʂ��B
@rem �G�C���A�X cat -> Get-Content
powershell -Command "cat %inpath% | Select-String -Pattern '%pattern_re%'"
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern%', '%pattern2%', '%pattern_space%') -SimpleMatch -CaseSensitive"
@set outpath=%outdir%\%basename%_ps.txt
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern_re%', '%pattern_re2%') -CaseSensitive" > %outpath%
@set outpath=%outdir%\%basename%_ps_not.txt
powershell -Command "cat %inpath% | Select-String -Pattern @('%pattern_re%', '%pattern_re2%') -CaseSensitive -NotMatch" > %outpath%

rem Ruby
@rem �f�t�H���g�̊O��/�����G���R�[�f�B���O��Windows-31J�̖͗l�B���̂��ߓ��͏o�̓t�@�C����Windows-31J�ƌ��Ȃ��B
@rem �K�v�Ȃ�ruby�R�}���h��-E�I�v�V�����ŃG���R�[�f�B���O���w�肷��B
@rem �������C�i�[�ŏ�����Ruby�X�N���v�g�́AWindows����Ruby��UTF-8�œn���ARuby��Windows-31J�ŉ��߂��悤�Ƃ��A�s�����ȏ�ԂƂȂ�͗l�B
@rem ���̂��߁A�X�N���v�g�̓��{�ꕶ����ɂ͖����I��UTF-8���w�肷��B
@set outpath=%outdir%\%basename%_ruby.txt
ruby -ne "BEGIN{re=Regexp.new('(%pattern_re%|%pattern_re2%)'.force_encoding('UTF-8').encode('Windows-31J'))}; puts $_ if $_ =~ re" %inpath% > %outpath%
@set outpath=%outdir%\%basename%_ruby_not.txt
ruby -ne "BEGIN{re=Regexp.new('(%pattern_re%|%pattern_re2%)'.force_encoding('UTF-8').encode('Windows-31J'))}; puts $_ if $_ ^!~ re" %inpath% > %outpath%

@echo off
rem �㏈��
start %winmerge% %outdir%\%basename%_gnuwin32.txt %outdir%\%basename%_findstr.txt
start %winmerge% %outdir%\%basename%_gnuwin32.txt %outdir%\%basename%_ps.txt
start %winmerge% %outdir%\%basename%_gnuwin32.txt %outdir%\%basename%_ruby.txt
start %winmerge% %outdir%\%basename%_gnuwin32_not.txt %outdir%\%basename%_findstr_v.txt
start %winmerge% %outdir%\%basename%_gnuwin32_not.txt %outdir%\%basename%_ps_not.txt
start %winmerge% %outdir%\%basename%_gnuwin32_not.txt %outdir%\%basename%_ruby_not.txt



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
