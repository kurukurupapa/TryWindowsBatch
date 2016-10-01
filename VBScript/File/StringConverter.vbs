' テキストファイル内の文字列を変換します。
' テキストファイルは、シフトJIS、CRLFの前提です。

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Init

' 引数チェック
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments(0) = "/?" Then
    WScript.Echo "使い方：cscript " & scriptName & " 入力ファイル 出力ファイル 置換前文字列 置換後文字列"
    WScript.Quit
  End If
End If
If WScript.Arguments.Count <> 4 Then
  WScript.Echo "引数の数が不正です。"
  Abort
End If
Dim inPath, outPath, before, after
inPath = WScript.Arguments(0)
outPath = WScript.Arguments(1)
before = WScript.Arguments(2)
after = WScript.Arguments(3)

' 主処理
Log "開始します。"



Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")

' ファイル読み込み
Dim inFile, outFile, inLine, outLine
Set inFile = fso.OpenTextFile(inPath, ForReading)
Set outFile = fso.OpenTextFile(outPath, ForWriting, True)
Do Until inFile.AtEndOfStream
  inLine = inFile.ReadLine
  outLine = Replace(inLine, before, after)
  outFile.WriteLine(outLine)
Loop
outFile.Close
inFile.Close



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
