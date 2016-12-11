' �e�L�X�g�t�@�C�����̕������ϊ����܂��B
' �e�L�X�g�t�@�C���́A�V�t�gJIS�ACRLF�̑O��ł��B

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Dim fso
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
  WScript.Echo "�g�����Fcscript " & scriptName & " ���̓t�@�C�� �o�̓t�@�C�� �u���O������ �u���㕶����"
  WScript.Quit
End If
If WScript.Arguments.Count <> 4 Then
  WScript.Echo "�����̐����s���ł��B"
  WScript.Quit 1
End If
Dim inPath, outPath, before, after
inPath = WScript.Arguments(0)
outPath = WScript.Arguments(1)
before = WScript.Arguments(2)
after = WScript.Arguments(3)

' �又��
Log "�J�n���܂��B"



Const ForReading = 1, ForWriting = 2, ForAppending = 8

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



Set fso = Nothing
Log "����I���ł��B"
WScript.Quit 0

' --------------------------------------------------

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
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
