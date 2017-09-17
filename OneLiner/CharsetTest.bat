@echo off
@setlocal enabledelayedexpansion
rem �����R�[�h�A���s�R�[�h�ϊ��̊e�탏�����C�i�[�ł��B

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
set sjispath=%batdir%\Data\Sample.txt
set sjislfpath=%batdir%\Data\Sample_SJIS_LF.txt
set sjiscrlfpath=%batdir%\Data\Sample.txt
set utf8path=%batdir%\Data\Sample_UTF8_LF.txt
set utf8lfpath=%batdir%\Data\Sample_UTF8_LF.txt
set utf8crlfpath=%batdir%\Data\Sample_UTF8_CRLF.txt
set utf8bomlfpath=%batdir%\Data\Sample_UTF8-BOM_LF.txt
set utf8bomcrlfpath=%batdir%\Data\Sample_UTF8-BOM_CRLF.txt
set crlfpath=%batdir%\Data\Sample.txt
set outdir=%CD%
rem echo on

rem GnuWin32
rem GnuWin32��sed��SJIS��O��ɂ��Ă���͗l�BUTF8��n���Ə������~�܂艞�����Ȃ��Ȃ����B
set outprefix=%outdir%\%basename%_gnuwin32_
rem �����R�[�h�ϊ� SJIS �� UTF-8
%gnubin%\iconv -c -f CP932 -t UTF-8 %sjislfpath% > %outprefix%iconv_UTF8_LF.txt
%gnubin%\iconv -c -f CP932 -t UTF-8 %sjiscrlfpath% > %outprefix%iconv_UTF8_CRLF.txt
rem �����R�[�h�ϊ� UTF-8 �� SJIS
%gnubin%\iconv -c -f UTF-8 -t CP932 %utf8lfpath% > %outprefix%iconv_SJIS_LF.txt
%gnubin%\iconv -c -f UTF-8 -t CP932 %utf8crlfpath% > %outprefix%iconv_SJIS_CRLF.txt
rem ���s�R�[�h�ϊ� CRLF �� LF
%gnubin%\cat %sjiscrlfpath% | %gnubin%\tr -d \r > %outprefix%tr_SJIS_LF.txt
%gnubin%\cat %utf8crlfpath% | %gnubin%\tr -d \r > %outprefix%tr_UTF8_LF.txt
rem ���s�R�[�h�ϊ� CRLF �� LF�iSJIS�O��j
%gnubin%\sed -b "s/\r//g" %sjiscrlfpath% > %outprefix%sed_SJIS_LF.txt
rem ���s�R�[�h�ϊ� LF �� CRLF�iSJIS�O��j
%gnubin%\sed "" %sjislfpath% > %outprefix%sed_SJIS_CRLF.txt
rem Check
fc /b %utf8lfpath% %outprefix%iconv_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%iconv_UTF8_LF.txt)
fc /b %utf8crlfpath% %outprefix%iconv_UTF8_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8crlfpath% %outprefix%iconv_UTF8_CRLF.txt)
fc /b %sjislfpath% %outprefix%iconv_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%iconv_SJIS_LF.txt)
fc /b %sjiscrlfpath% %outprefix%iconv_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%iconv_SJIS_CRLF.txt)
fc /b %sjislfpath% %outprefix%tr_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%tr_SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%tr_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%tr_UTF8_LF.txt)
fc /b %sjislfpath% %outprefix%sed_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%sed_SJIS_LF.txt)
fc /b %sjiscrlfpath% %outprefix%sed_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%sed_SJIS_CRLF.txt)

rem Windows�W���R�}���h
set outprefix=%outdir%\%basename%_win_
rem �����R�[�h�ϊ� UTF-8 �� SJIS
rem TODO ��肭�����Ȃ��B start /min /wait cmd /c chcp 932 ^& cmd /c type %utf8lfpath% ^> %outprefix%chcp_SJIS_LF.txt
rem TODO ��肭�����Ȃ��B start /min /wait cmd /c chcp 932 ^& cmd /c type %utf8crlfpath% ^> %outprefix%chcp_SJIS_CRLF.txt
rem �����R�[�h�ϊ� SJIS �� UTF-8
rem TODO ��肭�����Ȃ��B start /min /wait cmd /c chcp 65001 ^& cmd /u /c type %sjislfpath% ^> %outprefix%chcp_UTF8_LF.txt
rem TODO ��肭�����Ȃ��B start /min /wait cmd /c chcp 65001 ^& cmd /c type %sjiscrlfpath% ^> %outprefix%chcp_UTF8_CRLF.txt
rem Check
rem fc /b %sjislfpath% %outprefix%chcp_SJIS_LF.txt > nul
rem if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%chcp_SJIS_LF.txt)
rem fc /b %sjiscrlfpath% %outprefix%chcp_SJIS_CRLF.txt > nul
rem if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%chcp_SJIS_CRLF.txt)

rem PowerShell
rem Out-File����-Encoding�ɁuByte�v���g���Ȃ��B�uByte�v���g�������Ƃ���Set-Content���g���BSet-Content���ƃ��[�h���b�N��������B
rem PowerShell��UTF-8�́ABOM�t��UTF-8�B
rem .NET Framework��[Text.Encoding]::UTF8�́ABOM�t��UTF-8�B
rem .NET Framework WriteAllText,AppendAllText�̃f�t�H���g�����R�[�h��UTF-8�̖͗l�B�����I�Ɏw�肵�����Ƃ���[Text.UTF8Encoding]$false�Ƃ���B
set outprefix=%outdir%\%basename%_ps_charset_
rem �����R�[�h�ϊ� UTF-8 �� SJIS�i���s�R�[�hLF�o�͔͂ώG�Ȃ̂ŁA�����ł�CRLF�o�݈͂̂����B�j
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | Out-File -Encoding Default %outprefix%Out-File_SJIS_CRLF.txt"
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | Set-Content -Encoding Default %outprefix%Set-Content_SJIS_CRLF.txt"
rem �����R�[�h�ϊ� SJIS �� BOM�t��UTF-8�i���s�R�[�hLF�o�͔͂ώG�Ȃ̂ŁA�����ł�CRLF�o�݈͂̂����B�j
powershell -Command "cat %sjiscrlfpath% | Out-File -Encoding UTF8 %outprefix%Out-File_UTF8-BOM_CRLF.txt"
powershell -Command "cat %sjiscrlfpath% | Set-Content -Encoding UTF8 %outprefix%Set-Content_UTF8-BOM_CRLF.txt"
rem �����R�[�h�ϊ� SJIS �� BOM�Ȃ�UTF-8
powershell -Command "cat %sjiscrlfpath% | %%{ [Text.Encoding]::UTF8.GetBytes($_+\"`n\") } | Set-Content -Encoding Byte %outprefix%Set-Content_UTF8_LF.txt"
powershell -Command "cat %sjiscrlfpath% | %%{ [Text.Encoding]::UTF8.GetBytes($_+\"`r`n\") } | Set-Content -Encoding Byte %outprefix%Set-Content_UTF8_CRLF.txt"
rem Check
fc /b %sjiscrlfpath% %outprefix%Out-File_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%Out-File_SJIS_CRLF.txt)
fc /b %sjiscrlfpath% %outprefix%Set-Content_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%Set-Content_SJIS_CRLF.txt)
fc /b %utf8bomcrlfpath% %outprefix%Out-File_UTF8-BOM_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomcrlfpath% %outprefix%Out-File_UTF8-BOM_CRLF.txt)
fc /b %utf8bomcrlfpath% %outprefix%Set-Content_UTF8-BOM_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomcrlfpath% %outprefix%Set-Content_UTF8-BOM_CRLF.txt)
fc /b %utf8lfpath% %outprefix%Set-Content_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%Set-Content_UTF8_LF.txt)
fc /b %utf8crlfpath% %outprefix%Set-Content_UTF8_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8crlfpath% %outprefix%Set-Content_UTF8_CRLF.txt)

rem ���s�R�[�h�ϊ� CRLF �� LF
rem   ��PowerShell 5.0�ȍ~���g������Ȃ�A�����T���ǂ������B����ȊO�Ȃ�A�����U���Ǝv���B
set outprefix=%outdir%\%basename%_ps_newline_
rem   �������P�BPowerShell 2.0�ȍ~�B�t�@�C���T�C�Y�����̃��������g�p����B�ŏI�s�̉��s��CRLF�ɂȂ��Ă��܂��BNG�B
rem powershell -Command "(cat %sjiscrlfpath%) -join \"`n\" | Out-File -Encoding Default %outprefix%cat-join_Out-File_SJIS_LF.txt"
rem powershell -Command "(cat %sjiscrlfpath%) -join \"`n\" | Set-Content -Encoding Default %outprefix%cat-join_Set-Content_SJIS_LF.txt"
rem powershell -Command "(cat -Encoding UTF8 %utf8crlfpath%) -join \"`n\" | Out-File -Encoding UTF8 %outprefix%cat-join_Out-File_UTF8_LF.txt"
rem powershell -Command "(cat -Encoding UTF8 %utf8crlfpath%) -join \"`n\" | Set-Content -Encoding UTF8 %outprefix%cat-join_Set-Content_UTF8_LF.txt"
rem   �������Q�F.NET Framework WriteAllText�g�p�BPowerShell 2.0�ȍ~�{.NET Framework�B�t�@�C���T�C�Y�����̃��������g�p����B
powershell -Command "$_=(cat %sjiscrlfpath%) -join \"`n\"; [IO.File]::WriteAllText('%outprefix%cat-join_WriteAllText_SJIS_LF.txt',$_+\"`n\",[Text.Encoding]::GetEncoding('SJIS'))"
powershell -Command "$_=(cat -Encoding UTF8 %utf8crlfpath%) -join \"`n\"; [IO.File]::WriteAllText('%outprefix%cat-join_WriteAllText_UTF8_LF.txt',$_+\"`n\",[Text.UTF8Encoding]$false)"
rem   �������R�F.NET Framework WriteAllText�Acat�́u-Raw�v�g�p�BPowerShell 3.0�ȍ~�{.NET Framework�B�t�@�C���T�C�Y�����̃��������g�p����B
powershell -Command "$_=(cat %sjiscrlfpath% -Raw) -Replace \"`r\",\"\"; [IO.File]::WriteAllText('%outprefix%cat-Raw_WriteAllText_SJIS_LF.txt',$_,[Text.Encoding]::GetEncoding('SJIS'))"
powershell -Command "$_=(cat -Encoding UTF8 %utf8crlfpath% -Raw) -Replace \"`r\",\"\"; [IO.File]::WriteAllText('%outprefix%cat-Raw_WriteAllText_UTF8_LF.txt',$_,[Text.UTF8Encoding]$false)"
rem   �������S�FOut-File,Set-Content�́u-NoNewline�v�g�p�APowerShell 5.0�ȍ~�B
powershell -Command "cat %sjiscrlfpath% | %%{ $_+\"`n\" } | Out-File -Encoding Default -NoNewline %outprefix%cat_Out-File-NoNewline_SJIS_LF.txt"
powershell -Command "cat %sjiscrlfpath% | %%{ $_+\"`n\" } | Set-Content -Encoding Default -NoNewline %outprefix%cat_Set-Content-NoNewline_SJIS_LF.txt"
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | %%{ $_+\"`n\" } | Out-File -Encoding UTF8 -NoNewline %outprefix%cat_Out-File-NoNewline_UTF8-BOM_LF.txt"
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | %%{ $_+\"`n\" } | Set-Content -Encoding UTF8 -NoNewline %outprefix%cat_Set-Content-NoNewline_UTF8-BOM_LF.txt"
rem   �������T�F�t�@�C���ǋL�����A.NET Framework�g�p�B�t�@�C���������݂����Ȃ�x���B���܂茻���I�ł͂Ȃ������B
rem del /q %outprefix%cat_AppendAllText_*_LF.txt
rem powershell -Command "cat %sjiscrlfpath% | %%{ [IO.File]::AppendAllText('%outprefix%cat_AppendAllText_SJIS_LF.txt',$_+\"`n\",[Text.Encoding]::GetEncoding('SJIS')) }"
rem powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | %%{ [IO.File]::AppendAllText('%outprefix%cat_AppendAllText_UTF8_LF.txt',$_+\"`n\",[Text.UTF8Encoding]$false) }"
rem   �������U�F�o�C�i���������݁A.NET Framework�g�p�B
powershell -Command "cat %sjiscrlfpath% | %%{ [Text.Encoding]::GetEncoding('SJIS').GetBytes($_+\"`n\") } | Set-Content -Encoding Byte %outprefix%cat_GetBytes_Set-Content_SJIS_LF.txt"
powershell -Command "cat -Encoding UTF8 %utf8crlfpath% | %%{ [Text.Encoding]::UTF8.GetBytes($_+\"`n\") } | Set-Content -Encoding Byte %outprefix%cat_GetBytes_Set-Content_UTF8_LF.txt"
rem Check
rem   �������Q
fc /b %sjislfpath% %outprefix%cat-join_WriteAllText_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat-join_WriteAllText_SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%cat-join_WriteAllText_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%cat-join_WriteAllText_UTF8_LF.txt)
rem   �������R
fc /b %sjislfpath% %outprefix%cat-Raw_WriteAllText_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat-Raw_WriteAllText_SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%cat-Raw_WriteAllText_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%cat-Raw_WriteAllText_UTF8_LF.txt)
rem   �������S
fc /b %sjislfpath% %outprefix%cat_Out-File-NoNewline_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat_Out-File-NoNewline_SJIS_LF.txt)
fc /b %sjislfpath% %outprefix%cat_Set-Content-NoNewline_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat_Set-Content-NoNewline_SJIS_LF.txt)
fc /b %utf8bomlfpath% %outprefix%cat_Out-File-NoNewline_UTF8-BOM_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomlfpath% %outprefix%cat_Out-File-NoNewline_UTF8-BOM_LF.txt)
fc /b %utf8bomlfpath% %outprefix%cat_Set-Content-NoNewline_UTF8-BOM_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomlfpath% %outprefix%cat_Set-Content-NoNewline_UTF8-BOM_LF.txt)
rem   �������U
fc /b %sjislfpath% %outprefix%cat_GetBytes_Set-Content_SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%cat_GetBytes_Set-Content_SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%cat_GetBytes_Set-Content_UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%cat_GetBytes_Set-Content_UTF8_LF.txt)

rem ���s�R�[�h�ϊ� LF �� CRLF
set outprefix=%outdir%\%basename%_ps_newline_
powershell -Command "cat %sjislfpath% | Out-File -Encoding Default %outprefix%cat_Out-File_SJIS_CRLF.txt"
powershell -Command "cat %sjislfpath% | Set-Content -Encoding Default %outprefix%cat_Set-Content_SJIS_CRLF.txt"
powershell -Command "cat -Encoding UTF8 %utf8lfpath% | Out-File -Encoding UTF8 %outprefix%cat_Out-File_UTF8-BOM_CRLF.txt"
powershell -Command "cat -Encoding UTF8 %utf8lfpath% | Set-Content -Encoding UTF8 %outprefix%cat_Set-Content_UTF8-BOM_CRLF.txt"
rem Check
fc /b %sjiscrlfpath% %outprefix%cat_Out-File_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%cat_Out-File_SJIS_CRLF.txt)
fc /b %sjiscrlfpath% %outprefix%cat_Set-Content_SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%cat_Set-Content_SJIS_CRLF.txt)
fc /b %utf8bomcrlfpath% %outprefix%cat_Out-File_UTF8-BOM_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomcrlfpath% %outprefix%cat_Out-File_UTF8-BOM_CRLF.txt)
fc /b %utf8bomcrlfpath% %outprefix%cat_Set-Content_UTF8-BOM_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8bomcrlfpath% %outprefix%cat_Set-Content_UTF8-BOM_CRLF.txt)

rem Perl
rem ActivePerl���Ɓi�H�j�A�t�@�C���ǂݍ��ݎ���CRLF��LF�ɕϊ������͗l�B
set outprefix=%outdir%\%basename%_perl_
rem ���s�R�[�h�ϊ� CRLF �� LF
perl -pne "BEGIN{binmode(STDOUT)}" %sjiscrlfpath% > %outprefix%SJIS_LF.txt
perl -pne "BEGIN{binmode(STDOUT)}" %utf8crlfpath% > %outprefix%UTF8_LF.txt
rem ���s�R�[�h�ϊ� LF �� CRLF
perl -pne "" %sjislfpath% > %outprefix%SJIS_CRLF.txt
perl -pne "" %utf8lfpath% > %outprefix%UTF8_CRLF.txt
rem Check
fc /b %sjislfpath% %outprefix%SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%SJIS_LF.txt)
fc /b %utf8lfpath% %outprefix%UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%UTF8_LF.txt)
fc /b %sjiscrlfpath% %outprefix%SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%SJIS_CRLF.txt)
fc /b %utf8crlfpath% %outprefix%UTF8_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8crlfpath% %outprefix%UTF8_CRLF.txt)

rem Ruby
rem �f�t�H���g�̊O��/�����G���R�[�f�B���O��Windows-31J�̖͗l�B���̂��ߓ��͏o�̓t�@�C����Windows-31J�ƌ��Ȃ��B
rem �K�v�Ȃ�ruby�R�}���h��-E�I�v�V�����ŃG���R�[�f�B���O���w�肷��B
rem �t�@�C���ǂݍ��ݎ���CRLF��LF�ɕϊ������͗l�B
set outprefix=%outdir%\%basename%_ruby_
rem ���s�R�[�h�ϊ� CRLF �� LF
ruby -pne "BEGIN{STDOUT.binmode}" %sjiscrlfpath% > %outprefix%SJIS_LF.txt
ruby -pne "BEGIN{$stdout.binmode}" %sjiscrlfpath% > %outprefix%SJIS_LF2.txt
ruby -pne "BEGIN{STDOUT.binmode}" %utf8crlfpath% > %outprefix%UTF8_LF.txt
ruby -pne "BEGIN{$stdout.binmode}" %utf8crlfpath% > %outprefix%UTF8_LF2.txt
rem ���s�R�[�h�ϊ� LF �� CRLF
ruby -pne "" %sjislfpath% > %outprefix%SJIS_CRLF.txt
ruby -pne "" %utf8lfpath% > %outprefix%UTF8_CRLF.txt
rem Check
fc /b %sjislfpath% %outprefix%SJIS_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%SJIS_LF.txt)
fc /b %sjislfpath% %outprefix%SJIS_LF2.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjislfpath% %outprefix%SJIS_LF2.txt)
fc /b %utf8lfpath% %outprefix%UTF8_LF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%UTF8_LF.txt)
fc /b %utf8lfpath% %outprefix%UTF8_LF2.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8lfpath% %outprefix%UTF8_LF2.txt)
fc /b %sjiscrlfpath% %outprefix%SJIS_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %sjiscrlfpath% %outprefix%SJIS_CRLF.txt)
fc /b %utf8crlfpath% %outprefix%UTF8_CRLF.txt > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %utf8crlfpath% %outprefix%UTF8_CRLF.txt)

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
