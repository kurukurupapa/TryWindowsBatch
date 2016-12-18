' �e�L�X�g�t�@�C���𕪊����܂��B
' ���̓e�L�X�g�t�@�C���ɂ́A�V�t�gJIS�ACRLF��z�肵�Ă��܂��B

' �Q�l�T�C�g
' VBScript �ŃV�t�g JIS �̕�����̃o�C�g���𐔂��� (unibon)
' http://www.geocities.co.jp/SiliconValley/4334/unibon/asp/len.html

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Dim fso
Init

' �����`�F�b�N
Dim help, debug
help = False
debug = False
If WScript.Arguments.Count = 0 Then
  help = True
ElseIf WScript.Arguments(0) = "/?" Then
  help = True
End If
If help Then
  WScript.Echo "�g�����Fcscript " & scriptName & " �����T�C�Y �P�� �t�@�C��"
  WScript.Quit
End If
If WScript.Arguments.Count <> 3 Then
  WScript.Echo "�����̐����s���ł��B"
  WScript.Quit 1
End If
Dim splitSize, splitUnit, inPath
splitSize = WScript.Arguments(0)
splitUnit = WScript.Arguments(1)
inPath = WScript.Arguments(2)

Select Case LCase(splitUnit)
  Case "byte"
    ' �������Ȃ�
  Case "line"
    ' �������Ȃ�
  Case Else
    WScript.Echo "�s���Ȉ����ł��Barg=" + splitUnit
    WScript.Quit 1
End Select

' �又��
Log "�J�n���܂��B"


' ����
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim inFile, outFile, outPath, sizeCount, fileCount
Set inFile = Nothing
Set outFile = Nothing
sizeCount = 0
fileCount = 0

' ���̓t�@�C���I�[�v��
Set inFile = fso.OpenTextFile(inPath, ForReading)

' ���̓t�@�C���ǂݍ���
Do Until inFile.AtEndOfStream
  ' 1�s�ǂݍ���
  Dim line
  line = inFile.ReadLine
  Select Case LCase(splitUnit)
    Case "byte"
      sizeCount = sizeCount + LenSjis(line) + LenSjis(vbNewLine)
    Case "line"
      sizeCount = sizeCount + 1
  End Select

  ' �o�̓t�@�C���I�[�v��
  If outFile Is Nothing Then
    fileCount = fileCount + 1
    outPath = GetOutPath(inPath, fileCount)
    Set outFile = OpenFile(outPath)
  End If

  ' �o�̓t�@�C����������
  outFile.WriteLine line

  ' �o�̓t�@�C���N���[�Y
  If (sizeCount >= splitSize * fileCount) Or (inFile.AtEndOfStream) Then
    CloseFile outPath, outFile
    Set outFile = Nothing
  End If
Loop

' �o�̓t�@�C���N���[�Y
If Not outFile Is Nothing Then
  CloseFile outPath, outFile
  Set outFile = Nothing
End If

' ���̓t�@�C���N���[�Y
inFile.Close
Set inFile = Nothing


Set fso = Nothing
Log "����I���ł��B"
WScript.Quit 0

' --------------------------------------------------

' ShiftJIS������̃o�C�g�����擾
Function LenSjis(str)
  Dim size, i, c
  size = 0
  For i = 0 To Len(str) - 1
    c = Mid(str, i + 1, 1)
    If (Asc(c) And &HFF00) = 0 Then
      size = size + 1
    Else
      size = size + 2
    End If
  Next
  LenSjis = size
End Function

' �o�̓p�X�̑g�ݗ���
Function GetOutPath(inPath, count)
  Dim ext
  ext = fso.GetExtensionName(inPath)
  If Len(ext) > 0 Then
    ext = "." & ext
  End If
  GetOutPath = fso.GetParentFolderName(inPath) & "\" & fso.GetBaseName(inPath) & "." & count & ext
End Function

' �t�@�C���I�[�v��
Function OpenFile(outPath)
  Dim file
  Set file = fso.OpenTextFile(outPath, ForWriting, True)
  Set OpenFile = file
End Function

' �t�@�C���N���[�Y
Sub CloseFile(outPath, file)
  file.Close
  Set file = Nothing
  WScript.Echo "������t�@�C��=" & outPath
End Sub

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
  If debug Then
    WScript.Echo Now() & " " & scriptName & " " & msg
  End If
End Sub
