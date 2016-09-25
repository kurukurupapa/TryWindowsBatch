' VBScript�̃e���v���[�g�ł��B

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Init

' �����`�F�b�N
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments.Item(0) = "/?" Then
    WScript.Echo "�g�����Fcscript " & scriptName
    WScript.Quit
  End If
End If

' �J�n�`�F�b�N
'If Not CheckStart Then
'  WScript.Quit 1
'End If

' �又��
Log "�J�n���܂��B"


' �����������ɏ����������܂�
WScript.Echo "scriptName=" & scriptName
WScript.Echo "scriptDir=" & scriptDir
WScript.Echo "dateStr=" & dateStr
WScript.Echo "timeStr=" & timeStr
WScript.Echo "timestampStr=" & timestampStr
WScript.Echo "currentDir=" & currentDir
' �����������ɏ����������܂�


Log "����I���ł��B"
Quit 0

' --------------------------------------------------

' ����������
Sub Init
  scriptName = WScript.ScriptName
  scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\") - 1)
  dateStr = Replace(Date(), "/", "")
  timeStr = Replace(Time(), ":", "")
  timestampStr = dateStr & "-" & timeStr

  Dim shell
  Set shell = WScript.CreateObject("WScript.Shell")
  currentDir = shell.CurrentDirectory
End Sub

' �����J�n�`�F�b�N
Function CheckStart
  Dim input
  WScript.Echo "�J�n���Ă�낵���ł����H (y/n[y])"
  input = WScript.StdIn.ReadLine
  CheckStart = (input = "y" Or input = "")
End Function

' �������~
Sub Abort
  Log "�ُ�I���ł��B"
  Quit 1
End Sub

' �I������
Sub Quit(code)
  'Pause
  WScript.Quit code
End Sub

' ���[�U�m�F�҂�
Sub Pause
  WScript.Echo "���s����ɂ͉����L�[�������Ă������� . . ."
  WScript.StdIn.ReadLine
End Sub

' ���b�Z�[�W�o��
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
