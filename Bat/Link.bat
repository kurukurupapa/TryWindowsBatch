@echo off
@setlocal enabledelayedexpansion
rem Windows�̃V���{���b�N�����N���쐬���܂��B
rem
rem �ʏ�A�V���{���b�N�����N�́A�Ǘ��Ҍ����̃R�}���h�v�����v�g����Amklink�R�}���h�����s���č쐬���܂����A
rem PowerShell��Start-Process�R�}���h��-Verb runas�I�v�V������t���邱�ƂŁA
rem �ʏ�̃R�}���h�v�����v�g����A�Ǘ��Ҍ����ɐ؂�ւ��ăR�}���h���s�ł���悤�ɂȂ�܂����B
rem
rem �Q�l
rem Windows��PowerShell���Ǘ��Ҍ����ŋN��������@ - Qiita https://qiita.com/syui/items/7d42d7e691010ee212fb

set basedir=%~dp0
set basename=%~n0
set batdir=%~dp0
set batname=%~n0%~x0
set datestr=%DATE:/=%
set timestrtmp=%TIME: =0%
set timestr=%timestrtmp:~0,2%%timestrtmp:~3,2%%timestrtmp:~6,2%
set timestamp=%datestr%-%timestr%

:INIT
if "%~1"==""   set help=1
if "%~1"=="/?" set help=1
if "%help%"=="1" (
  echo �g�����F%batname% �����N �^�[�Q�b�g
  exit /b 0
)
set link_path=%~1
set target_path=%~2
set link_short_path=%~s1
set target_short_path=%~s2

:MAIN
call :LOG �����J�n���܂��B



rem �R�}���h�̑g�ݗ���
rem �܂��Acmd.exe���s����ɃJ�����g�f�B���N�g�����ړ�������B
rem �󔒂��܂ރp�X���l�����āu\"�v�Ŋ����Ă���B�u"�v�����i�G�X�P�[�v�Ȃ��j���ƃ_���������B
rem PowerShell�̎d�l�i�H�j�Łu&�v���u\"�v�Ŋ���K�v���������B
rem �⑫
rem cmd�����s����ƃJ�����g�f�B���N�g����C:\WINDOWS\system32�ɂȂ��Ă��܂����B
rem �J�����g�f�B���N�g�����w�肵��cmd���N�����邱�Ƃ͂ł��Ȃ��͗l�B
set list="cd",\"%CD%\",\"&&\"

rem mklink�R�}���h��g�ݗ��Ă�B
rem �󔒂��܂ރp�X���l�����āAmklink���s���Ɂu"�v����̃p�X����n�������������A
rem PowerShell���u"�v���������Ă��܂��悤�ŁAmklink�̎��s���ɂ́u"�v��n���Ȃ������B
rem ���s���낵�āA�u\�v�ŃG�X�P�[�v������A�u"�v���d�ɂ�����A�u'�v�������肵�����ǃ_���������B
rem ���̂��߁A�󔒂��܂ރp�X�̏ꍇ�A�Z�����O���g�����Ƃɂ���B
rem �Ȃ��A���L�̒Z�����O���擾��������ł͐�΃p�X�ɕϊ�����Ă��܂��B
rem ���ƁA�����N�p�X�̂����Amklink�ō쐬����p�X�����ɋ󔒂��܂ޏꍇ�A
rem �Z�����O�����蓖�Ă��Ă��Ȃ��̂ŁA�����ł��Ȃ��B
echo "%link_path%"|findstr /c:" " > nul
if %errorlevel%==0 (
  set link_path=%link_short_path%
  echo "!link_path!"|findstr /c:" " > nul
  if !errorlevel!==0 (
    echo �����N�p�X�ɋ󔒂��܂�ł��邽�߁A���o�b�`�t�@�C���ł͏����ł��܂���B
    echo ��ֈ�
    echo �����N�p�X�ɋ󔒂��܂܂Ȃ��悤�Ɍ������B
    echo �Ǘ��Ҍ����ŃR�}���h�v�����v�g���N�����āAmklink�R�}���h�ŃV���{���b�N�����N���쐬����B
    echo �Ǘ��Ҍ������g���Ȃ��Ȃ�Amklink�R�}���h�Ńn�[�h�����N�A�W�����N�V���������N����������B
    goto ERROR
  )
  echo �����N�p�X��Z�����O�ɕϊ��������߁A��΃p�X�ɂȂ�܂��B
)
echo "%target_path%"|findstr /c:" " > nul
if %errorlevel%==0 (
  set target_path=%target_short_path%
  echo �^�[�Q�b�g�p�X��Z�����O�ɕϊ��������߁A��΃p�X�ɂȂ�܂��B
)
set list=%list%,"mklink","%link_path%","%target_path%"
rem �^�[�Q�b�g���f�B���N�g���̏ꍇ�A�u/d�v�I�v�V�������K�v�B
if exist "%target_path%\" (
  set list=%list%,"/d"
)

rem ���s�����UAC�̊m�F�_�C�A���O���\�������B
rem ���̌�A�R�}���h�v�����v�g�E�C���h�E���\������A�R�}���h���s�シ���ɕ�����B
rem �R�}���h���s�ŃG���[���������Ă��������Ă��܂��̂ŁA�K�v�Ȃ�"/c"��"/k"�ɕύX���āA�E�C���h�E����Ȃ��悤�ɂ���B
powershell.exe -Command Start-Process -FilePath "cmd" -ArgumentList "/c",%list% -Verb runas
dir "%link_path%"



:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
call :LOG �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:EOF
