' �t�@�C���ǂݍ��݂̗��K�ł��B
' ��x�ɑS���e��ǂݍ��݂܂��B

Option Explicit

Dim scriptName, scriptDir
Init

' �����`�F�b�N
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments.Item(0) = "/?" Then
    WScript.Echo "�g�����Fcscript " & scriptName
    WScript.Quit
  End If
End If

' �又��
Log "�J�n���܂��B"


Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso, file
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile(WScript.ScriptFullName, ForReading)
WScript.Echo Left(file.ReadAll, 100)
file.Close


Log "����I���ł��B"

' --------------------------------------------------

' ����������
Sub Init
  scriptName = WScript.ScriptName
  scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\") - 1)
End Sub

' ���b�Z�[�W�o��
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
