' ZIP�t�@�C����W�J���Ă݂܂��B
' ��ZIP���k���鏈���́A���G�炵���̂ō쐬���Ȃ������B

' �Q�l�T�C�g
' �f�[�^�A�g�Ɠ������Ȋw����u���O: Windows�ŁAOS�W���@�\��zip���k/�𓀂��g�p����iWSH�ҁj
' http://bitdatasci.blogspot.jp/2015/10/windowsoszipwsh.html

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Init

' �����`�F�b�N
'If WScript.Arguments.Count = 0 Then
'  WScript.Echo "�g�����Fcscript " & scriptName & " ZIP�t�@�C��"
'  Quit 0
'End If
'Dim zipPath
'zipPath = WScript.Arguments.Item(0)

' �J�n�`�F�b�N
'If Not CheckStart Then
'  WScript.Quit 1
'End If

' �又��
Log "�J�n���܂��B"


Dim zipPath, workDir
zipPath = scriptDir & "\Data\UnZip01-Dummy.zip"
workDir = scriptDir & "\Work"
WScript.Echo zipPath
WScript.Echo workDir

Dim app, zipFile, folder
Set app = CreateObject("Shell.Application")
Set zipFile = app.NameSpace(zipPath).Items
Set folder = app.NameSpace(workDir)
folder.CopyHere zipFile, &H14


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
