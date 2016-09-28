' ファイル読み書きの練習です。
' 読み込み、書き込みを関数化してみます。

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


' ダミーデータ作成
Dim text
text = "Hello World!" & vbNewLine
text = text & "Hello VBScript!" & vbNewLine

Dim path
path = scriptDir & "\Work\" & scriptName & ".txt"

' ファイル書き込み
SaveText path, text

' ファイル読み込み
Dim text2
text2 = LoadText(path)
WScript.Echo text2


Log "正常終了です。"

' --------------------------------------------------

Sub SaveText(path, text)
  Const ForReading = 1, ForWriting = 2, ForAppending = 8
  Dim fso, file
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set file = fso.OpenTextFile(path, ForWriting, True)
  file.Write(text)
  file.Close
End Sub

Function LoadText(path)
  Const ForReading = 1, ForWriting = 2, ForAppending = 8
  Dim fso, file, text
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set file = fso.OpenTextFile(path, ForReading)
  text = file.ReadAll
  file.Close
  LoadText = text
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
