@echo off
@setlocal enabledelayedexpansion
rem Windowsのシンボリックリンクを作成します。
rem
rem 通常、シンボリックリンクは、管理者権限のコマンドプロンプトから、mklinkコマンドを実行して作成しますが、
rem PowerShellのStart-Processコマンドに-Verb runasオプションを付けることで、
rem 通常のコマンドプロンプトから、管理者権限に切り替えてコマンド実行できるようになりました。
rem
rem 参考
rem WindowsのPowerShellを管理者権限で起動する方法 - Qiita https://qiita.com/syui/items/7d42d7e691010ee212fb

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
  echo 使い方：%batname% リンク ターゲット
  exit /b 0
)
set link_path=%~1
set target_path=%~2
set link_short_path=%~s1
set target_short_path=%~s2

:MAIN
call :LOG 処理開始します。



rem コマンドの組み立て
rem まず、cmd.exe実行直後にカレントディレクトリを移動させる。
rem 空白を含むパスを考慮して「\"」で括っている。「"」だけ（エスケープなし）だとダメだった。
rem PowerShellの仕様（？）で「&」も「\"」で括る必要があった。
rem 補足
rem cmdを実行するとカレントディレクトリがC:\WINDOWS\system32になってしまった。
rem カレントディレクトリを指定してcmdを起動することはできない模様。
set list="cd",\"%CD%\",\"&&\"

rem mklinkコマンドを組み立てる。
rem 空白を含むパスを考慮して、mklink実行時に「"」括りのパス名を渡したかったが、
rem PowerShellが「"」を除去してしまうようで、mklinkの実行時には「"」を渡せなかった。
rem 試行錯誤して、「\」でエスケープしたり、「"」を二重にしたり、「'」括ったりしたけどダメだった。
rem そのため、空白を含むパスの場合、短い名前を使うことにする。
rem なお、下記の短い名前を取得する実装では絶対パスに変換されてしまう。
rem あと、リンクパスのうち、mklinkで作成するパス部分に空白を含む場合、
rem 短い名前が割り当てられていないので、処理できない。
echo "%link_path%"|findstr /c:" " > nul
if %errorlevel%==0 (
  set link_path=%link_short_path%
  echo "!link_path!"|findstr /c:" " > nul
  if !errorlevel!==0 (
    echo リンクパスに空白を含んでいるため、当バッチファイルでは処理できません。
    echo 代替案
    echo リンクパスに空白を含まないように見直す。
    echo 管理者権限でコマンドプロンプトを起動して、mklinkコマンドでシンボリックリンクを作成する。
    echo 管理者権限が使えないなら、mklinkコマンドでハードリンク、ジャンクションリンクを検討する。
    goto ERROR
  )
  echo リンクパスを短い名前に変換したため、絶対パスになります。
)
echo "%target_path%"|findstr /c:" " > nul
if %errorlevel%==0 (
  set target_path=%target_short_path%
  echo ターゲットパスを短い名前に変換したため、絶対パスになります。
)
set list=%list%,"mklink","%link_path%","%target_path%"
rem ターゲットがディレクトリの場合、「/d」オプションが必要。
if exist "%target_path%\" (
  set list=%list%,"/d"
)

rem 実行するとUACの確認ダイアログが表示される。
rem その後、コマンドプロンプトウインドウが表示され、コマンド実行後すぐに閉じられる。
rem コマンド実行でエラーが発生しても見逃してしまうので、必要なら"/c"→"/k"に変更して、ウインドウを閉じないようにする。
powershell.exe -Command Start-Process -FilePath "cmd" -ArgumentList "/c",%list% -Verb runas
dir "%link_path%"



:END
call :LOG 正常終了です。
exit /b 0

:ERROR
call :LOG 異常終了です。
exit /b 1

:LOG
echo %DATE% %TIME% %basename% %1 1>&2
exit /b 0

:EOF
