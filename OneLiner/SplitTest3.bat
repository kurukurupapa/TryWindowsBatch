@echo off
@setlocal enabledelayedexpansion
rem split�R�}���h���C�N�̊e�탏�����C�i�[�ł��B�i�p�t�H�[�}���X�e�X�g�j

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
set incsv=.\dummy_10MB.csv
set incsv2=.\dummy_1000MB.csv
set column=6
set outdir=.
rem echo on

rem --- �L�[���[�h�Ńt�@�C������
rem GnuWin32
set outprefix=%outdir%\%basename%_key_gnuwin32_
set outprefix2=%outprefix:\=\\%
del /q %outprefix%*
echo %DATE% %TIME% GnuWin32 START %incsv%
set start=%DATE% %TIME%
%gnubin%\awk -F "," "NR>1 { print $0 >> \"%outprefix2%\" $%column% \".csv\" }" %incsv%
set end=%DATE% %TIME%
echo %DATE% %TIME% GnuWin32 END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"

echo %DATE% %TIME% GnuWin32 START %incsv2%
set start=%DATE% %TIME%
%gnubin%\awk -F "," "NR>1 { print $0 >> \"%outprefix2%\" $%column% \".csv\" }" %incsv2%
set end=%DATE% %TIME%
echo %DATE% %TIME% GnuWin32 END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"

rem PowerShell �t�@�C���ǋL����
set outprefix=%outdir%\%basename%_key_ps_append_
del /q %outprefix%*
echo %DATE% %TIME% PowerShell �t�@�C���ǋL���� START %incsv%
set start=%DATE% %TIME%
powershell -Command "cat %incsv% | Select-Object -Skip 1 | %%{ Out-File -Append -Encoding Default -InputObject $_ ('%outprefix%'+($_.Split(',')[%column%-1])+'.csv') }"
set end=%DATE% %TIME%
echo %DATE% %TIME% PowerShell �t�@�C���ǋL���� END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"

rem PowerShell �n�b�V������
set outprefix=%outdir%\%basename%_key_ps_hash_
echo %DATE% %TIME% PowerShell �n�b�V������ START %incsv%
set start=%DATE% %TIME%
powershell -Command "$hash=@{}; cat %incsv% | Select-Object -Skip 1 | %%{ $key=$_.Split(',')[%column%-1]; if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Set-Content -Value $hash[$k] ('%outprefix%'+$k+'.csv') }"
set end=%DATE% %TIME%
echo %DATE% %TIME% PowerShell �n�b�V������ END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"

echo %DATE% %TIME% PowerShell �n�b�V������ START %incsv2%
set start=%DATE% %TIME%
powershell -Command "$hash=@{}; cat %incsv2% | Select-Object -Skip 1 | %%{ $key=$_.Split(',')[%column%-1]; if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Set-Content -Value $hash[$k] ('%outprefix%'+$k+'.csv') }"
set end=%DATE% %TIME%
echo %DATE% %TIME% PowerShell �n�b�V������ END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"

rem PowerShell �t�@�C���ǋL�����E�n�b�V�������̃n�C�u���b�h
set outprefix=%outdir%\%basename%_key_ps_hybrid_
set block=100000
del /q %outprefix%*
echo %DATE% %TIME% PowerShell �t�@�C���ǋL�����E�n�b�V�������̃n�C�u���b�h START %incsv%
set start=%DATE% %TIME%
powershell -Command "cat %incsv% -ReadCount %block% | %%{ $hash=@{}; $_ | %%{ $key=$_.Split(',')[%column%-1]; if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Out-File -Append -Encoding Default -InputObject $hash[$k] ('%outprefix%'+$k+'.csv') }}"
set end=%DATE% %TIME%
echo %DATE% %TIME% PowerShell �t�@�C���ǋL�����E�n�b�V�������̃n�C�u���b�h END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"

echo %DATE% %TIME% PowerShell �t�@�C���ǋL�����E�n�b�V�������̃n�C�u���b�h START %incsv2%
set start=%DATE% %TIME%
powershell -Command "cat %incsv2% -ReadCount %block% | %%{ $hash=@{}; $_ | %%{ $key=$_.Split(',')[%column%-1]; if(^!$hash.ContainsKey($key)){ $hash[$key]=[Collections.ArrayList]@() }; $hash[$key].Add($_)>$null }; foreach($k in $hash.Keys){ Out-File -Append -Encoding Default -InputObject $hash[$k] ('%outprefix%'+$k+'.csv') }}"
set end=%DATE% %TIME%
echo %DATE% %TIME% PowerShell �t�@�C���ǋL�����E�n�b�V�������̃n�C�u���b�h END
powershell -Command "$t=New-TimeSpan '%start%' '%end%'; $t.TotalMinutes.ToString('0.#')+'��'"

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
