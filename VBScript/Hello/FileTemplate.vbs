' VBScript�̃e���v���[�g�ł��B

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Dim fso
Init

' �����`�F�b�N
Dim arg, help, debug
help = False
debug = False
For Each arg In WScript.Arguments
  If IsOptionArg(arg) Then
    Select Case LCase(arg)
      Case "/?"
        help = True
      Case "/debug"
        debug = True
      Case Else
        WScript.Echo "�s���Ȉ����ł��Barg=" & arg
        WScript.Quit 1
    End Select
  End If
Next
If help Then
  Usage
  WScript.Quit
End If

' �又��
Log "�J�n���܂��B"


' �������K�X�A���������������܂�

Dim dirCount, fileCount, unknownCount
dirCount = 0
fileCount = 0
unknownCount = 0

For Each arg In WScript.Arguments
  If Not IsOptionArg(arg) Then
    Proc(arg)
  End If
Next

WScript.Echo "�f�B���N�g����: " & dirCount
WScript.Echo "�t�@�C����:     " & fileCount
WScript.Echo "�s����:         " & unknownCount

' �������K�X�A���������������܂�


Set fso = Nothing
Log "����I���ł��B"
WScript.Quit 0

' --------------------------------------------------

' �g�p���@
Sub Usage
  WScript.Echo "�g�����Fcscript " & scriptName & " [/?][/DEBUG] <�t�@�C��|�t�H���_> ..."
End Sub

' 1�̃f�B���N�g��/�t�@�C���̏���
Sub Proc(path)
  If fso.FolderExists(path) Then
    ProcNest(path)
  ElseIf fso.FileExists(path) Then
    ProcFile(path)
  Else
    ProcUnknown(path)
  End If
End Sub

' �f�B���N�g���ċA
Sub ProcNest(dirPath)
  ProcDir(dirPath)

  Dim folder, subfolder, file
  Set folder = fso.GetFolder(dirPath)
  For Each subfolder In folder.SubFolders
    ProcNest(subfolder)
  Next
  For Each file In folder.Files
    ProcFile(file)
  Next
End Sub

' 1�̃f�B���N�g���̏���
Sub ProcDir(dirPath)
  ' �����������Ƀf�B���N�g�̏����������܂�
  'Log "ProcDir: " & dirPath
  WScript.Echo "Dir: " & dirPath
  dirCount = dirCount + 1
  ' �����������Ƀf�B���N�g�̏����������܂�
End Sub

' 1�̃t�@�C���̏���
Sub ProcFile(filePath)
  ' �����������Ƀt�@�C���̏����������܂�
  'Log "ProcFile: " & filePath
  WScript.Echo "File: " & filePath
  fileCount = fileCount + 1
  ' �����������Ƀt�@�C���̏����������܂�
End Sub

' 1�̕s���p�X�̏���
Sub ProcUnknown(arg)
  ' �����������ɕs�������̏����������܂�
  'Log "ProcUnknown: " & arg
  WScript.Echo "Unknown: " & arg
  unknownCount = unknownCount + 1
  ' �����������ɕs�������̏����������܂�
End Sub

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

  Set fso = CreateObject("Scripting.FileSystemObject")
End Sub

' ����I��
Sub QuitNormally
  Log "����I���ł��B"
  WScript.Quit 0
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

' �I�v�V������������
Function IsOptionArg(arg)
  IsOptionArg = Left(arg, 1) = "/"
End Function
