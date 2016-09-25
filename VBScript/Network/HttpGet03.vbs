' Web�y�[�W���_�E�����[�h������K�ł��B
' �_�E�����[�h�Ώۂ����X�g�t�@�C������I�ׂ�悤�ɂ��Ă݂܂��B

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


Dim scriptBaseName
scriptBaseName = Replace(scriptName, ".vbs", "")

' ���X�g�t�@�C���ǂݍ���
Dim text, lines
text = LoadText(scriptBaseName & ".list")
lines = Split(text, vbNewLine)

' ���X�g����I��
Dim line, count, keyword
Dim columns, url, name, comment
count = 0
keyword = "http"
While count <> 1
  WScript.Echo
  WScript.Echo "�_�E�����[�h�Ώۈꗗ"
  count = 0
  For Each line In lines
    If Len(line) > 0 And Left(line, 1) <> "'" Then
      If InStr(LCase(line), LCase(keyword)) <> 0 Then
        columns = Split(line, ",")
        comment = columns(0)
        url = columns(1)
        name = columns(2)
        count = count + 1
        WScript.Echo count & ". " & comment
      End If
    End If
  Next
  WScript.Echo

  If count = 0 Then
    WScript.Echo "�Y������f�[�^������܂���ł����B"
    WScript.Quit 1
  End If

  If count <> 1 Then
    WScript.Echo "�L�[���[�h����͂��Ă��������B"
    keyword = Trim(WScript.StdIn.ReadLine)
    WScript.Echo
  End If
Wend

' �_�E�����[�h
Dim data
data = HttpGet(url)

' �t�@�C���ۑ�
SaveBinary scriptDir & "\Work\" & name, data


Log "����I���ł��B"

' --------------------------------------------------

Function LoadText(path)
  Const ForReading = 1, ForWriting = 2, ForAppending = 8
  Dim fso, file, text
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set file = fso.OpenTextFile(path, ForReading)
  text = file.ReadAll
  file.Close
  LoadText = text
End Function

Function HttpGet(url)
  Dim http, body

  ' ��Msxml2.XMLHTTP���ƁAZIP��EXE���_�E�����[�h�ł��Ȃ������B
  Set http = CreateObject("Msxml2.ServerXMLHTTP")
  http.Open "GET", url, False
  http.SetRequestHeader "Pragma", "no-cache"
  http.SetRequestHeader "Cache-Control", "no-cache"
  http.SetRequestHeader "If-Modified-Since", "Thu, 01 Jan 1970 00:00:00 GMT"
  Log "HttpGet " & "url=" + url

  http.Send
  Log "Status=" & http.Status
  body = http.ResponseBody
  Set http = Nothing

  HttpGet = body
End Function

Sub SaveBinary(path, data)
  Const adTypeBinary = 1, adTypeText = 2
  Const adSaveCreateNotExist = 1, adSaveCreateOverWrite = 2
  Dim stream

  Set stream = CreateObject("ADODB.Stream")
  stream.Open
  stream.Type = adTypeBinary
  stream.Write data
  stream.SaveToFile path, adSaveCreateOverWrite
  stream.Close
  Set stream = Nothing
End Sub

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
