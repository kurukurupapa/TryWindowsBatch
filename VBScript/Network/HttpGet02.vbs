' Web�y�[�W���_�E�����[�h������K�ł��B
'
' �Q�l�ɂ����T�C�g
' �t�@�C�����_�E�����[�h����X�N���v�g�� VBScript �ŏ��� - �����łȂ����L
' http://d.hatena.ne.jp/tt4cs/20120206/1328527888
' WEB�̃t�@�C�����R�}���h���C������_�E�����[�h����X�N���v�g : httpget.vbs : logical�@error
' http://logicalerror.seesaa.net/article/126457978.html

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
Set http = CreateObject("Msxml2.XMLHTTP")
Call http.Open("GET", url, False)
http.SetRequestHeader "Pragma", "no-cache"
http.SetRequestHeader "Cache-Control", "no-cache"
http.SetRequestHeader "If-Modified-Since", "Thu, 01 Jan 1970 00:00:00 GMT"
http.Send
WScript.Echo "Status=" & http.Status
WScript.Echo "ResponseBody=" & Left(http.ResponseBody, 100)

Const adTypeBinary = 1
Const adTypeText = 2
Const adSaveCreateNotExist = 1
Const adSaveCreateOverWrite = 2
Dim stream
Set stream = CreateObject("ADODB.Stream")
stream.Open
stream.Type = adTypeBinary
stream.Write http.ResponseBody
stream.SaveToFile "Work\" & scriptName & ".dat", adSaveCreateOverWrite
stream.Close

Set http = Nothing
Set stream = Nothing


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
