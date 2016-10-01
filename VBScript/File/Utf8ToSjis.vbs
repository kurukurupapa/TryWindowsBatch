' �e�L�X�g�t�@�C���̕����G���R�[�h���AUTF8����V�t�gJIS�֕ϊ����܂��B

' �Q�l
' ADODB.Stream���g�����e�L�X�g�t�@�C���̓ǂݏ��� | SugiBlog
' http://www.k-sugi.sakura.ne.jp/windows/vb/3650/

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Init

' �����`�F�b�N
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments(0) = "/?" Then
    WScript.Echo "�g�����Fcscript " & scriptName & " ���̓t�@�C�� �o�̓t�@�C��"
    WScript.Quit
  End If
End If
If WScript.Arguments.Count <> 2 Then
  WScript.Echo "�����̐����s���ł��B"
  Abort
End If
Dim inPath, outPath, before, after
inPath = WScript.Arguments(0)
outPath = WScript.Arguments(1)

' �又��
Log "�J�n���܂��B"


' �t�@�C���ǂݍ��ݏ����iUTF-8�j
Const adModeRead = 1, adModeWrite = 2, adModeReadWrite = 3
Const adTypeBinary = 1, adTypeText = 2
Const adReadAll = -1, adReadLine = -2
Const adCR = 13, adCRLF = -1, adLF = 10
Dim stream
Set stream = CreateObject("ADODB.Stream")
stream.Mode = adModeReadWrite
stream.Type = adTypeText
stream.Charset = "UTF-8"
stream.Open
stream.LoadFromFile(inPath)
stream.Position = 0
stream.LineSeparator = adLf

' �t�@�C���������ݏ����i�V�t�gJIS�j
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
Dim outFile
Set outFile = fso.OpenTextFile(outPath, ForWriting, True)

' �t�@�C���ǂݍ���/��������
Dim line
Do Until stream.EOS
  line = stream.ReadText(adReadLine)
  line = Replace(line, vbCr, "")
  outFile.WriteLine(line)
Loop
stream.Close
outFile.Close

' ��Еt��
Set stream = Nothing
Set fso = Nothing


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
