' VBScript�̊ȈՔŃe���v���[�g�ł��B

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


' ���������ɏ����������܂�����


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
