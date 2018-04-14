@echo off
@setlocal enabledelayedexpansion
rem diff�R�}���h���C�N�̊e�탏�����C�i�[�ł��B

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
set outdir=%workdir%
rem echo on


echo --- CSV�ŃL�[���l�����Ĕ�r
set incsv1=%batdir%\Data\SampleData1.csv
set incsv2=%batdir%\Data\SampleData2.csv

rem PowerShell ����1 �L�[���ڂŃ\�[�g���compare����B
rem ��2��CSV�ԂŁA���݂���L�[�l�̍��ق��傫���Ə�肭��r�ł��Ȃ��\����B
rem �������ł́ACSV�Ƀw�b�_�[����ŁA�J����Group1,Group2,Seq���L�[���ڂƂ��Ă���B
rem set outprefix=%outdir%\%basename%_csv1_ps1_
rem powershell -Command "Import-Csv -Encoding Default %incsv1% | sort -Property Group1,Group2,Seq | ConvertTo-Csv" > %outprefix%1_Sort.csv
rem powershell -Command "Import-Csv -Encoding Default %incsv2% | sort -Property Group1,Group2,Seq | ConvertTo-Csv" > %outprefix%2_Sort.csv
rem powershell -Command "Compare-Object (cat %outprefix%1_Sort.csv) (cat %outprefix%2_Sort.csv) | %{ $_.SideIndicator+','+$_.InputObject }" > %outprefix%Diff.csv

rem PowerShell ����2 �L�[�l�̃}�b�`/�A���}�b�`�𔻒���compare����B
rem ������1�����P���邪�A��肭��r�ł��Ȃ��\�����c��B
rem ���傫�߃t�@�C���������̃������s�����l�����āAsort�����͕ʍs�ɕ����Ă���B
rem �������ł́ACSV�̃J����2,3,1���L�[���ڂƂ��Ă���B
rem set outprefix=%outdir%\%basename%_csv1_ps2_
rem powershell -Command "function key{ $a=$_.Split(','); $a[1],$a[2],$a[0] -join ',' }; $kyes=@(); cat %incsv1% | %{ $keys+=key }; cat %incsv2% | %{ $k=key; if($keys.Contains($k)){ $status='1-KeyMatch' }else{ $status='2-Before' } $status+',('+$k+'),'+$_ }" > %outprefix%1_KeyStatus.csv
rem powershell -Command "function key{ $a=$_.Split(','); $a[1],$a[2],$a[0] -join ',' }; $kyes=@(); cat %incsv2% | %{ $keys+=key }; cat %incsv1% | %{ $k=key; if($keys.Contains($k)){ $status='1-KeyMatch' }else{ $status='3-After'  } $status+',('+$k+'),'+$_ }" > %outprefix%2_KeyStatus.csv
rem powershell -Command "cat %outprefix%1_KeyStatus.csv | sort" > %outprefix%1_KeyStatus_Sort.csv
rem powershell -Command "cat %outprefix%2_KeyStatus.csv | sort" > %outprefix%2_KeyStatus_Sort.csv
rem powershell -Command "Compare-Object (cat %outprefix%1_KeyStatus_Sort.csv) (cat %outprefix%2_KeyStatus_Sort.csv) | sort -Property InputObject | %{ $_.SideIndicator+','+$_.InputObject }" > %outprefix%Diff.csv

echo PowerShell ����3 �L�[�l�̑S�ʂ����compare����B
rem ���傫�߃t�@�C���������̃������s�����l�����āAsort�����͕ʍs�ɕ����Ă���B
rem �������ł́ACSV�̃J����2,3,1���L�[���ڂƂ��Ă���B
set outprefix=%outdir%\%basename%_csv1_ps3
powershell -Command "function key{ $a=$_.Split(','); $a[1],$a[2],$a[0] -join ',' }; cat %incsv1%,%incsv2% | %%{ key }" > %outprefix%_KeyTmp.csv
powershell -Command "cat %outprefix%_KeyTmp.csv | sort | Get-Unique" > %outprefix%_Key.csv
powershell -Command "function key{ $a=$_.Split(','); $a[1],$a[2],$a[0] -join ',' }; $hash=@{}; cat %outprefix%_Key.csv | %%{ $hash[$_]=$_+',' }; cat %incsv1% | %%{ $k=key; $hash.Remove($k); $k+','+$_ }; $hash.Values" > %outprefix%_1_KeyTmp.csv
powershell -Command "function key{ $a=$_.Split(','); $a[1],$a[2],$a[0] -join ',' }; $hash=@{}; cat %outprefix%_Key.csv | %%{ $hash[$_]=$_+',' }; cat %incsv2% | %%{ $k=key; $hash.Remove($k); $k+','+$_ }; $hash.Values" > %outprefix%_2_KeyTmp.csv
powershell -Command "cat %outprefix%_1_KeyTmp.csv | sort" > %outprefix%_1_Key.csv
powershell -Command "cat %outprefix%_2_KeyTmp.csv | sort" > %outprefix%_2_Key.csv
powershell -Command "compare (cat %outprefix%_1_Key.csv) (cat %outprefix%_2_Key.csv) | sort -Property InputObject | %%{ $_.SideIndicator+','+$_.InputObject }" > %outprefix%_Diff.csv


echo --- CSV�ŕs��v�s�𒊏o
echo PowerShell ����1
rem ���ٍs�Ȃ��̏ꍇ
set incsv1=%batdir%\Data\SampleData1.csv
set incsv2=%batdir%\Data\SampleData1.csv
set expected=%batdir%\Data\SampleData_ExpectedDiff1-1.csv
set outprefix=%outdir%\%basename%_csv2_ps1_case1
powershell -Command "$a=(cat %incsv1%); cat %incsv2% | %%{ $i=$a.IndexOf($_); if($i -lt 0){ '=>,'+$_ }else{ $a[$i]=$null }}; $a -ne $null | %%{ '<=,'+$_ }" | sort /+4 > %outprefix%_diff.csv
rem Check
call :CHECK %expected% %outprefix%_diff.csv

rem ���ق��聕incsv2�ǉ��s�ŏI���ꍇ
set incsv1=%batdir%\Data\SampleData1.csv
set incsv2=%batdir%\Data\SampleData2.csv
set expected=%batdir%\Data\SampleData_ExpectedDiff1-2.csv
set outprefix=%outdir%\%basename%_csv2_ps1_case2
powershell -Command "$a=(cat %incsv1%); cat %incsv2% | %%{ $i=$a.IndexOf($_); if($i -lt 0){ '=>,'+$_ }else{ $a[$i]=$null }}; $a -ne $null | %%{ '<=,'+$_ }" | sort /+4 > %outprefix%_diff.csv
rem Check
call :CHECK %expected% %outprefix%_diff.csv

rem ���ق��聕incsv2�폜�s�ŏI���ꍇ
set incsv1=%batdir%\Data\SampleData1.csv
set incsv2=%batdir%\Data\SampleData3.csv
set expected=%batdir%\Data\SampleData_ExpectedDiff1-3.csv
set outprefix=%outdir%\%basename%_csv2_ps1_case3
powershell -Command "$a=(cat %incsv1%); cat %incsv2% | %%{ $i=$a.IndexOf($_); if($i -lt 0){ '=>,'+$_ }else{ $a[$i]=$null }}; $a -ne $null | %%{ '<=,'+$_ }" | sort /+4 > %outprefix%_diff.csv
rem Check
call :CHECK %expected% %outprefix%_diff.csv


echo PowerShell ����2 �\�[�g���1�s����r����B
rem ���ٍs�Ȃ��̏ꍇ
set incsv1=%batdir%\Data\SampleData1.csv
set incsv2=%batdir%\Data\SampleData1.csv
set expected=%batdir%\Data\SampleData_ExpectedDiff1-1.csv
set outprefix=%outdir%\%basename%_csv2_ps2_case1
sort %incsv1% > %outprefix%_1tmp.csv
sort %incsv2% > %outprefix%_2tmp.csv
powershell -Command "$a=(cat %outprefix%_1tmp.csv); $i=0; cat %outprefix%_2tmp.csv | %%{ $s=-1; while($s -lt 0){ $s=if($i -lt $a.Length){ $a[$i].CompareTo($_) }else{ 1 }; if($s -lt 0){ '<=,'+$a[$i]; $i++ }elseif($s -gt 0){ '=>,'+$_ }else{ $i++ }}}" > %outprefix%_diff.csv
rem Check
call :CHECK %expected% %outprefix%_diff.csv

rem ���ق��聕incsv2�ǉ��s�ŏI���ꍇ
set incsv1=%batdir%\Data\SampleData1.csv
set incsv2=%batdir%\Data\SampleData2.csv
set expected=%batdir%\Data\SampleData_ExpectedDiff1-2.csv
set outprefix=%outdir%\%basename%_csv2_ps2_case2
sort %incsv1% > %outprefix%_1tmp.csv
sort %incsv2% > %outprefix%_2tmp.csv
powershell -Command "$a=(cat %outprefix%_1tmp.csv); $i=0; cat %outprefix%_2tmp.csv | %%{ $s=-1; while($s -lt 0){ $s=if($i -lt $a.Length){ $a[$i].CompareTo($_) }else{ 1 }; if($s -lt 0){ '<=,'+$a[$i]; $i++ }elseif($s -gt 0){ '=>,'+$_ }else{ $i++ }}}" > %outprefix%_diff.csv
rem Check
call :CHECK %expected% %outprefix%_diff.csv

rem ���ق��聕incsv2�폜�s�ŏI���ꍇ
set incsv1=%batdir%\Data\SampleData1.csv
set incsv2=%batdir%\Data\SampleData3.csv
set expected=%batdir%\Data\SampleData_ExpectedDiff1-3.csv
set outprefix=%outdir%\%basename%_csv2_ps2_case3
sort %incsv1% > %outprefix%_1tmp.csv
sort %incsv2% > %outprefix%_2tmp.csv
powershell -Command "$a=(cat %outprefix%_1tmp.csv); $i=0; cat %outprefix%_2tmp.csv | %%{ $s=-1; while($s -lt 0){ $s=if($i -lt $a.Length){ $a[$i].CompareTo($_) }else{ 1 }; if($s -lt 0){ '<=,'+$a[$i]; $i++ }elseif($s -gt 0){ '=>,'+$_ }else{ $i++ }}}" > %outprefix%_diff.csv
rem Check
call :CHECK %expected% %outprefix%_diff.csv


rem �㏈��
echo off
del /q %outdir%\%basename%_*tmp.* > nul


:END
call :LOG ����I���ł��B
exit /b 0

:ERROR
echo �ُ�I���ł��B
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:CHECK
fc %1 %2 > nul
if %errorlevel% neq 0 (echo NG & start %winmerge% %1 %2)
exit /b 0

:EOF
