@echo off

rem Subversion�ŁA�R�~�b�g���O�擾���������T���v���o�b�`�t�@�C���ł��B

set basedir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT

:MAIN
svn log http://svn.sourceforge.jp/svnroot/ksandbox/PowerShell/ToolBox

:END
echo ����I���ł��B
rem pause
exit /b 0

:USAGE
echo �g�����F%batname%
exit /b 0

:ERROR
echo �G���[�I���ł��B
exit /b -1

:EOF
