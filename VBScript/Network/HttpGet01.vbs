' Web�y�[�W���擾���A�W���o�͂��Ă݂܂��B
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


Dim url
url = "https://ja.wikipedia.org/wiki/VBScript"
WScript.Echo "url=" & url

Dim http
Set http = WScript.CreateObject("Msxml2.ServerXMLHTTP")
Call http.Open("GET", url, False)
http.Send
WScript.Echo "Status=" & http.Status
WScript.Echo "ResponseBody=" & Left(http.ResponseBody, 100)
Set http = Nothing


Log "����I���ł��B"

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
