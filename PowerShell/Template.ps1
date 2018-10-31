# Windows PowerShell
# �e���v���[�g
#
# �R�}���h�v�����v�g����̎��s���@
#   powershell .\Template.ps1 ABC 123
# �Z�L�����e�B�G���[���o��Ƃ��́A�R�}���h�v�����v�g���Ǘ��Ҍ����ŋN�����A���̃R�}���h�����s����B
#   powershell -Command "Set-ExecutionPolicy RemoteSigned"


# �R�}���h���C�������̎擾
param([string]$arg1, [int]$arg2)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$WarningPreference = "Continue"
$VerbosePreference = "Continue"
$DebugPreference = "Continue"


# �g�p���@���o�͂���B
# return - �Ȃ�
function U-Write-Usage() {
  Write-Output @"
�g�����F$psName ����1 ����2
"@
}

# �又�������s����B
# return - �Ȃ�
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

# �ݒ�t�@�C���ǂݍ���
$iniPath = "${baseDir}\${psBaseName}.ini"
if (Test-Path -PathType Leaf $iniPath) {
  Write-Debug "�ݒ�t�@�C���ǂݍ��� $iniPath"
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
