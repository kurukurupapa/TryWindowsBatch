' テキストファイル内の文字列を変換します。
' テキストファイルは、シフトJIS、CRLFの前提です。

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Dim fso
Init

' 引数チェック
Dim help
help = False
If WScript.Arguments.Count = 0 Then
  help = True
ElseIf WScript.Arguments(0) = "/?" Then
  help = True
End If
If help Then
  WScript.Echo "使い方：cscript " & scriptName & " 入力ファイル 出力ファイル 置換前文字列 置換後文字列"
  WScript.Quit
End If
If WScript.Arguments.Count <> 4 Then
  WScript.Echo "引数の数が不正です。"
  WScript.Quit 1
End If
Dim inPath, outPath, before, after
inPath = WScript.Arguments(0)
outPath = WScript.Arguments(1)
before = WScript.Arguments(2)
after = WScript.Arguments(3)

' 主処理
Log "開始します。"



Const ForReading = 1, ForWriting = 2, ForAppending = 8

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



Set fso = Nothing
Log "正常終了です。"
WScript.Quit 0

' --------------------------------------------------

' 初期化処理
Sub Init
  Set fso = CreateObject("Scripting.FileSystemObject")
  scriptName = WScript.ScriptName
  scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)
  dateStr = Year(Date()) & Right("0" & Month(Date()), 2) & Right("0" & Day(Date()), 2)
  timeStr = Right("0" & Hour(Time()), 2) & Right("0" & Minute(Time()), 2) & Right("0" & Second(Time()), 2)
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
