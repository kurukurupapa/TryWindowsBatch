' �t�@�C���ǂݏ����̗��K�ł��B
' �ǂݍ��݁A�������݂��֐������Ă݂܂��B

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


' �_�~�[�f�[�^�쐬
Dim text
text = "Hello World!" & vbNewLine
text = text & "Hello VBScript!" & vbNewLine

Dim path
path = scriptDir & "\Work\" & scriptName & ".txt"

' �t�@�C����������
SaveText path, text

' �t�@�C���ǂݍ���
Dim text2
text2 = LoadText(path)
WScript.Echo text2


Log "����I���ł��B"

' --------------------------------------------------

Sub SaveText(path, text)
  Const ForReading = 1, ForWriting = 2, ForAppending = 8
  Dim fso, file
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set file = fso.OpenTextFile(path, ForWriting, True)
  file.Write(text)
  file.Close
End Sub

Function LoadText(path)
  Const ForReading = 1, ForWriting = 2, ForAppending = 8
  Dim fso, file, text
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set file = fso.OpenTextFile(path, ForReading)
  text = file.ReadAll
  file.Close
  LoadText = text
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
