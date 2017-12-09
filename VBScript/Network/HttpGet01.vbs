' Webページを取得し、標準出力してみます。
Option Explicit

Dim scriptName, scriptDir
Init

' 引数チェック
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments.Item(0) = "/?" Then
    WScript.Echo "使い方：cscript " & scriptName
    WScript.Quit
  End If
End If

' 主処理
Log "開始します。"


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


Log "正常終了です。"

' --------------------------------------------------

' 初期化処理
Sub Init
  scriptName = WScript.ScriptName
  scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\") - 1)
End Sub

' メッセージ出力
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
