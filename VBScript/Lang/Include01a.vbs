' �O��VBScript��ǂݍ��ޗ��K�ł��B
' ���X�N���v�g�͌Ăяo�����ł��B

' �Q�l�T�C�g
' VBScript�ŔY�񂾂��ƃ��� - Qiita
' http://qiita.com/honeniq/items/88462b12d2244480026a

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


Include scriptDir & "\Include01b.vbs"
WScript.Echo "����=" & Include01bFunction(1, 2)


Log "����I���ł��B"

' --------------------------------------------------

Sub Include(path)
	ExecuteGlobal ReadFile(path)
End Sub

Function ReadFile(path)
	Const ForReading = 1, ForWriting = 2, ForAppending = 8
	Dim fso, stream, text

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set stream = fso.OpenTextFile(path, ForReading)
	text = stream.ReadAll()
	stream.Close
	Set stream = Nothing
	Set fso = Nothing

	ReadFile = text
End Function

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
