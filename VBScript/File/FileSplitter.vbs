' �e�L�X�g�t�@�C���𕪊����܂��B
' ���̓e�L�X�g�t�@�C���ɂ́A�V�t�gJIS�ACRLF��z�肵�Ă��܂��B

' �Q�l�T�C�g
' VBScript �ŃV�t�g JIS �̕�����̃o�C�g���𐔂��� (unibon)
' http://www.geocities.co.jp/SiliconValley/4334/unibon/asp/len.html

Option Explicit

Dim scriptName, scriptDir
Init

' �����`�F�b�N
Dim usageFlag, arg
usageFlag = False
If WScript.Arguments.Count <> 2 Then
  usageFlag = True
End If
For Each arg In WScript.Arguments
  If arg = "/?" Then
    usageFlag = True
  End If
Next
If usageFlag Then
  WScript.Echo "�g�����Fcscript " & scriptName & " �����T�C�Y �t�@�C��"
  WScript.Quit
End If
Dim splitSize, inPath
splitSize = WScript.Arguments(0)
inPath = WScript.Arguments(1)


' �又��
Log "�J�n���܂��B"


' �t�@�C���ǂݍ���
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso, file, sizeCount, fileCount, text
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile(inPath, ForReading)
sizeCount = 0
fileCount = 0
text = ""
Do Until file.AtEndOfStream
  Dim line
  line = file.ReadLine
  'sizeCount = sizeCount + Lenb(line) + Lenb(vbNewLine)
  sizeCount = sizeCount + LenSjis(line) + LenSjis(vbNewLine)
  text = text & line & vbNewLine

  If (sizeCount > splitSize * (fileCount + 1)) Or (file.AtEndOfStream) Then
    ' �t�@�C����������
    fileCount = fileCount + 1
    Save inPath, fileCount, text
    text = ""
  End If
Loop
Log "�g�[�^���T�C�Y=" & sizeCount & "byte"
file.Close


Log "����I���ł��B"

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

' �t�@�C����������
Sub Save(inPath, count, text)
  Dim outPath, file
  outPath = inPath & "." & count & ".txt"
  Set file = fso.OpenTextFile(outPath, ForWriting, True)
  file.Write(text)
  file.Close
  Set file = Nothing
  Log "������t�@�C��=" & outPath & ",�T�C�Y=" & LenSjis(text)
End Sub

' ����������
Sub Init
  scriptName = WScript.ScriptName
  scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\") - 1)
End Sub

' ���b�Z�[�W�o��
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
