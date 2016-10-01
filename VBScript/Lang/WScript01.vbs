' VBScriptオブジェクトを使ってみます。

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


WScript.Echo "WScript.Interactive=" & WScript.Interactive
WScript.Echo "WScript.Name=" & WScript.Name
WScript.Echo "WScript.Path=" & WScript.Path
WScript.Echo "WScript.FullName=" & WScript.FullName

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
