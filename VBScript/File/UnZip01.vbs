' ZIP�t�@�C����W�J���Ă݂܂��B
' ��ZIP���k���鏈���́A���G�炵���̂ō쐬���Ȃ������B

' �Q�l�T�C�g
' �f�[�^�A�g�Ɠ������Ȋw����u���O: Windows�ŁAOS�W���@�\��zip���k/�𓀂��g�p����iWSH�ҁj
' http://bitdatasci.blogspot.jp/2015/10/windowsoszipwsh.html

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

' �又��
Log "�J�n���܂��B"



Dim zipPath, workDir
zipPath = scriptDir & "\Data\UnZip01-Dummy.zip"
workDir = currentDir
WScript.Echo zipPath
WScript.Echo workDir

Dim app, zipFile, folder
Set app = CreateObject("Shell.Application")
Set zipFile = app.NameSpace(zipPath).Items
Set folder = app.NameSpace(workDir)
folder.CopyHere zipFile, &H14



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
