' VBScript�I�u�W�F�N�g���g���Ă݂܂��B

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


WScript.Echo "WScript.Interactive=" & WScript.Interactive
WScript.Echo "WScript.Name=" & WScript.Name
WScript.Echo "WScript.Path=" & WScript.Path
WScript.Echo "WScript.FullName=" & WScript.FullName

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
