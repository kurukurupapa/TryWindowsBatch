' �t�@�C���ǂݏ����̗��K�ł��B
' �s�P�ʂœǂݍ��݁A�������݂��Ă݂܂��B

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
Dim name, fso, file
name = scriptName & ".txt"
Set fso = CreateObject("Scripting.FileSystemObject")

' �t�@�C����������
Set file = fso.OpenTextFile(name, ForWriting, True)
file.WriteLine("Hello World!")
file.WriteLine("Hello VBScript!")
file.Close

' �t�@�C���ǂݍ���
Set file = fso.OpenTextFile(name, ForReading)
While Not file.AtEndOfStream
  WScript.Echo file.Line & ":" & file.ReadLine
Wend
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
