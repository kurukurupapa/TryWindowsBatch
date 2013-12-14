@echo off

rem ��̃f�B���N�g���Ԃ̍����t�@�C���𒊏o����Windows�o�b�`�t�@�C���ł��B
rem 
rem ���񎖍�
rem �E�󔒂��܂ރf�B���N�g��/�t�@�C�����́A�l�����Ă��܂���B

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

:MAIN
echo �����J�n���܂��B



set befdir=%1
set aftdir=%2
set outdir=%3
set difflist=%outdir%\diff_list.txt
set filelist=%outdir%\file_list.txt
set filelist2=%outdir%\file_list2.txt
set tmpbat=%outdir%\tmp.bat

echo befdir: %1
echo aftdir: %2
echo outdir: %3

call :MKDIR_PROC %outdir%

rem �������擾����
diff -r -q %befdir% %aftdir% > %difflist%

rem cat %difflist%

rem �ǉ�/�ύX/�폜���ꂽ�t�@�C���̈ꗗ���擾����
cat %difflist% | ^
sed "s!^\(%befdir:\=\\%\)\(/.*\)\?�����ɔ���: \(.*\)$!DEL,\1\2/\3!" | ^
sed "s!^\(%aftdir:\=\\%\)\(/.*\)\?�����ɔ���: \(.*\)$!ADD,\1\2/\3!" | ^
sed "s!^�t�@�C��\(.*\)��\(.*\)�͈Ⴂ�܂�$!MOD,\2!" | ^
sed "s!/!\\!g" > %filelist2%

awk -F, "{print $2}" %filelist2% > %filelist%

rem cat %filelist%

rem �R�s�[�p�ꎞ�o�b�`�t�@�C�����쐬����
cat %filelist% | ^
grep -E "^%aftdir:\=\\%" | ^
sed "s!^%aftdir:\=\\%\\\(.*\)$!.\\\1!" | ^
sed "s!^\(.*\)\\\([^\\]*\)$!call %basedir:\=\\%\\CopyDiff_Copy.bat %aftdir:\=\\% %outdir:\=\\% \1 \2!" > %tmpbat%

rem cat %tmpbat%

rem �R�s�[�p�ꎞ�o�b�`�t�@�C�������s����
call %tmpbat%


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
