@echo off
rem VBScript���Ăяo���܂��B

set basedir=%~dp0
set basename=%~n0
set batname=%~n0%~x0
set mainname=%basename:VbsTest=%
set logpath=%basedir%\%mainname%.log

echo ���O�F%logpath%
type nul > "%logpath%"

echo --- >> "%logpath%"
echo �����Ȃ� >> "%logpath%"
cscript //Nologo "%basedir%\%mainname%.vbs" >> "%logpath%" 2>&1
echo errorlevel=%errorlevel% >> "%logpath%"

echo --- >> "%logpath%"
echo �s������ >> "%logpath%"
cscript //Nologo "%basedir%\%mainname%.vbs" 123 err %basedir%\Data\Sjis-CrLf-10kB.txt >> "%logpath%" 2>&1
echo errorlevel=%errorlevel% >> "%logpath%"

echo --- >> "%logpath%"
echo ���̓t�@�C���Ȃ� >> "%logpath%"
cscript //Nologo "%basedir%\%mainname%.vbs" 123 byte %basedir%\Nothing.txt >> "%logpath%" 2>&1
echo errorlevel=%errorlevel% >> "%logpath%"

echo --- >> "%logpath%"
echo Byte�P�� >> "%logpath%"
copy %basedir%\Data\Sjis-CrLf-10kB.txt %basedir%\Work\Sjis-CrLf-10kB_%mainname%-byte.txt
cscript //Nologo "%basedir%\%mainname%.vbs" 1024 byte %basedir%\Work\Sjis-CrLf-10kB_%mainname%-byte.txt >> "%logpath%" 2>&1
echo errorlevel=%errorlevel% >> "%logpath%"

echo --- >> "%logpath%"
echo �s�P�� >> "%logpath%"
copy %basedir%\Data\Sjis-CrLf-10kB.txt %basedir%\Work\Sjis-CrLf-10kB_%mainname%-line.txt
cscript //Nologo "%basedir%\%mainname%.vbs" 100 line %basedir%\Work\Sjis-CrLf-10kB_%mainname%-line.txt >> "%logpath%" 2>&1
echo errorlevel=%errorlevel% >> "%logpath%"

echo --- >> "%logpath%"
echo �g���qcsv >> "%logpath%"
copy %basedir%\Data\Sjis-CrLf-Small.txt %basedir%\Work\Sjis-CrLf-Small_%mainname%.csv
cscript //Nologo "%basedir%\%mainname%.vbs" 1024 byte %basedir%\Work\Sjis-CrLf-Small_%mainname%.csv >> "%logpath%" 2>&1
echo errorlevel=%errorlevel% >> "%logpath%"
echo --- >> "%logpath%"
echo �g���q�Ȃ� >> "%logpath%"
copy %basedir%\Data\Sjis-CrLf-Small.txt %basedir%\Work\Sjis-CrLf-Small_%mainname%
cscript //Nologo "%basedir%\%mainname%.vbs" 1024 byte %basedir%\Work\Sjis-CrLf-Small_%mainname% >> "%logpath%" 2>&1
echo errorlevel=%errorlevel% >> "%logpath%"

rem ���ʏo��
type %logpath%

exit /b 0
