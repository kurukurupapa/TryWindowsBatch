# Windows PowerShell
# テンプレート
#
# コマンドプロンプトからの実行方法
#   powershell .\Template.ps1 ABC 123
# セキュリティエラーが出るときは、コマンドプロンプトを管理者権限で起動し、次のコマンドを実行する。
#   powershell -Command "Set-ExecutionPolicy RemoteSigned"


# コマンドライン引数の取得
param([string]$arg1, [int]$arg2)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"


# 使用方法を出力する。
# return - なし
function U-Write-Usage() {
  Write-Output @"
使い方：$psName 引数1 引数2
"@
}

# 主処理を実行する。
# return - なし
function U-Main() {
  Write-Output "baseDir=$baseDir"
  Write-Output "psName=$psName"
  Write-Output "psBaseName=$psBaseName"
  Write-Output "timestamp=$timestamp"
  Write-Output "args=$args"
}


$baseDir = Convert-Path $(Split-Path $MyInvocation.InvocationName -Parent)
$psName = Split-Path $MyInvocation.InvocationName -Leaf
$psBaseName = $psName -replace "\.ps1$", ""
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

# 設定ファイル読み込み
$iniPath = "${baseDir}\${psBaseName}.ini"
if (Test-Path -PathType Leaf $iniPath) {
  Write-Debug "設定ファイル読み込み $iniPath"
  $ini = @{}
  Get-Content $iniPath | %{ $ini += ConvertFrom-StringData $_ }
}


$help = $false
if ($arg1 -eq $null -or $arg1 -eq "") { $help = $true }
if ($arg2 -eq $null -or $arg2 -eq 0) { $help = $true }
if ($help) {
  U-Write-Usage
  exit 0
}

Write-Verbose "$psName Start"
U-Main
Write-Verbose "$psName End"

exit 0
