' �t�@�C���̃n�b�V���iMD5�j���o�͂��܂��B

' �O��
' Microsoft .NET Framework ���C���X�g�[������Ă��邱�ƁB

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Dim fso
Init

' �����`�F�b�N
Dim help, debug
help = False
debug = False
If WScript.Arguments.Count = 0 Then
  help = True
ElseIf WScript.Arguments(0) = "/?" Then
  help = True
End If
If help Then
  WScript.Echo "�g�����Fcscript " & scriptName & " [/?] �t�@�C�� ..."
  WScript.Quit
End If

' �又��
Log "�J�n���܂��B"


Dim arg
For Each arg In WScript.Arguments
  Dim bytes, hash
  bytes = LoadBinary(arg)
  hash = GetMd5(bytes)
  WScript.Echo arg & vbTab & hash
Next


Set fso = Nothing
Log "����I���ł��B"
WScript.Quit 0

' --------------------------------------------------

' MD5�̎Z�o
Function GetMd5(bytes)
  Dim hash, provider
  Set provider = CreateObject("System.Security.Cryptography.MD5CryptoServiceProvider")
  provider.ComputeHash_2(bytes)
  hash = provider.Hash
  Set provider = Nothing

  Dim doc, element, hashStr
  Set doc = CreateObject("MSXML2.DOMDocument")
  Set element = doc.CreateElement("tmp")
  element.DataType = "bin.hex"
  element.NodeTypedValue = hash
  hashStr = element.Text

  GetMd5 = hashStr
End Function

' �o�C�i���t�@�C����ǂݍ���
Function LoadBinary(path)
  Const adTypeBinary = 1, adTypeText = 2
  Dim stream
  Set stream = CreateObject("ADODB.Stream")
  stream.Type = adTypeBinary
  stream.Open
  stream.LoadFromFile(path)
  bytes = stream.Read
  stream.Close
  LoadBinary = bytes
End Function

' ����������
Sub Init
  Set fso = CreateObject("Scripting.FileSystemObject")
  scriptName = WScript.ScriptName
  scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
  dateStr = Year(Date()) & Right("0" & Month(Date()), 2) & Right("0" & Day(Date()), 2)
  timeStr = Right("0" & Hour(Time()), 2) & Right("0" & Minute(Time()), 2) & Right("0" & Second(Time()), 2)
  timestampStr = dateStr & "-" & timeStr

  Dim shell
  Set shell = WScript.CreateObject("WScript.Shell")
  currentDir = shell.CurrentDirectory
End Sub

' �������~
Sub Abort
  Log "�ُ�I���ł��B"
  WScript.Quit 1
End Sub

' ���b�Z�[�W�o��
Sub Log(msg)
  If debug Then
    WScript.Echo Now() & " " & scriptName & " " & msg
  End If
End Sub
