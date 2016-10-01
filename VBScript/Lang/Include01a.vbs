' 外部VBScriptを読み込む練習です。
' 当スクリプトは呼び出し側です。

' 参考サイト
' VBScriptで悩んだことメモ - Qiita
' http://qiita.com/honeniq/items/88462b12d2244480026a

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


Include scriptDir & "\Include01b.vbs"
WScript.Echo "結果=" & Include01bFunction(1, 2)


Log "正常終了です。"

' --------------------------------------------------

Sub Include(path)
	ExecuteGlobal ReadFile(path)
End Sub

Function ReadFile(path)
	Const ForReading = 1, ForWriting = 2, ForAppending = 8
	Dim fso, stream, text

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set stream = fso.OpenTextFile(path, ForReading)
	text = stream.ReadAll()
	stream.Close
	Set stream = Nothing
	Set fso = Nothing

	ReadFile = text
End Function

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
