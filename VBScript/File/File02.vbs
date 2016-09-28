' ファイル読み書きの練習です。
' 行単位で読み込み、書き込みしてみます。

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


Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim name, fso, file
name = scriptName & ".txt"
Set fso = CreateObject("Scripting.FileSystemObject")

' ファイル書き込み
Set file = fso.OpenTextFile(name, ForWriting, True)
file.WriteLine("Hello World!")
file.WriteLine("Hello VBScript!")
file.Close

' ファイル読み込み
Set file = fso.OpenTextFile(name, ForReading)
While Not file.AtEndOfStream
  WScript.Echo file.Line & ":" & file.ReadLine
Wend
file.Close


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
