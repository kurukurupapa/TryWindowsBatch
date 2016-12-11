' VBScript�̃e���v���[�g�ł��B

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Init

' �����`�F�b�N
Dim help
help = False
If WScript.Arguments.Count = 0 Then
  help = True
ElseIf WScript.Arguments(0) = "/?" Then
  help = True
End If
If help Then
  WScript.Echo "�g�����Fcscript " & scriptName & " [/?] ����1 ..."
  WScript.Quit
End If

' �又��
Log "�J�n���܂��B"


' �����������ɏ����������܂�
WScript.Echo "scriptName=" & scriptName
WScript.Echo "scriptDir=" & scriptDir
WScript.Echo "dateStr=" & dateStr
WScript.Echo "timeStr=" & timeStr
WScript.Echo "timestampStr=" & timestampStr
WScript.Echo "currentDir=" & currentDir

Dim arg, count
count = 0
For Each arg In WScript.Arguments
  count = count + 1
  WScript.Echo "Arguments[" & count & "]=" & arg
Next
' �����������ɏ����������܂�


Log "����I���ł��B"
WScript.Quit 0

' --------------------------------------------------

' ����������
Sub Init
  scriptName = WScript.ScriptName
  scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\") - 1)
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
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
