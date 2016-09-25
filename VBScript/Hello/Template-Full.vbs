' VBScriptのテンプレートです。

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Init

' 引数チェック
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments.Item(0) = "/?" Then
    WScript.Echo "使い方：cscript " & scriptName
    WScript.Quit
  End If
End If

' 開始チェック
'If Not CheckStart Then
'  WScript.Quit 1
'End If

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
Quit 0

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

' 処理開始チェック
Function CheckStart
  Dim input
  WScript.Echo "開始してよろしいですか？ (y/n[y])"
  input = WScript.StdIn.ReadLine
  CheckStart = (input = "y" Or input = "")
End Function

' 処理中止
Sub Abort
  Log "異常終了です。"
  Quit 1
End Sub

' 終了処理
Sub Quit(code)
  'Pause
  WScript.Quit code
End Sub

' ユーザ確認待ち
Sub Pause
  WScript.Echo "続行するには何かキーを押してください . . ."
  WScript.StdIn.ReadLine
End Sub

' メッセージ出力
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
