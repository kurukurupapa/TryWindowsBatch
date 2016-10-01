' �e�L�X�g�t�@�C�����̕������ϊ����܂��B
' �e�L�X�g�t�@�C���́A�V�t�gJIS�ACRLF�̑O��ł��B

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Init

' �����`�F�b�N
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments(0) = "/?" Then
    WScript.Echo "�g�����Fcscript " & scriptName & " ���̓t�@�C�� �o�̓t�@�C�� �u���O������ �u���㕶����"
    WScript.Quit
  End If
End If
If WScript.Arguments.Count <> 4 Then
  WScript.Echo "�����̐����s���ł��B"
  Abort
End If
Dim inPath, outPath, before, after
inPath = WScript.Arguments(0)
outPath = WScript.Arguments(1)
before = WScript.Arguments(2)
after = WScript.Arguments(3)

' �又��
Log "�J�n���܂��B"



Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")

' �t�@�C���ǂݍ���
Dim inFile, outFile, inLine, outLine
Set inFile = fso.OpenTextFile(inPath, ForReading)
Set outFile = fso.OpenTextFile(outPath, ForWriting, True)
Do Until inFile.AtEndOfStream
  inLine = inFile.ReadLine
  outLine = Replace(inLine, before, after)
  outFile.WriteLine(outLine)
Loop
outFile.Close
inFile.Close



Log "����I���ł��B"
WScript.Quit 0

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

' �������~
Sub Abort
  Log "�ُ�I���ł��B"
  WScript.Quit 1
End Sub

' ���b�Z�[�W�o��
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
