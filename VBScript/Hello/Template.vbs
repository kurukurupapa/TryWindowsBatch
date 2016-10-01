' VBScriptのテンプレートです。

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Init

' 引数チェック
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments(0) = "/?" Then
    WScript.Echo "使い方：cscript " & scriptName & " [/?]"
    WScript.Quit
  End If
End If

' 主処理
Log "開始します。"


' ▼▼▼ここに処理を書きます
WScript.Echo "scriptName=" & scriptName
WScript.Echo "scriptDir=" & scriptDir
WScript.Echo "dateStr=" & dateStr
WScript.Echo "timeStr=" & timeStr
WScript.Echo "timestampStr=" & timestampStr
WScript.Echo "currentDir=" & currentDir
' ▲▲▲ここに処理を書きます


Log "正常終了です。"
WScript.Quit 0

' --------------------------------------------------

' 初期化処理
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

' 処理中止
Sub Abort
  Log "異常終了です。"
  WScript.Quit 1
End Sub

' メッセージ出力
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
