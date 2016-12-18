' テキストファイルを分割します。
' 入力テキストファイルには、シフトJIS、CRLFを想定しています。

' 参考サイト
' VBScript でシフト JIS の文字列のバイト数を数える (unibon)
' http://www.geocities.co.jp/SiliconValley/4334/unibon/asp/len.html

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Dim fso
Init

' 引数チェック
Dim help, debug
help = False
debug = False
If WScript.Arguments.Count = 0 Then
  help = True
ElseIf WScript.Arguments(0) = "/?" Then
  help = True
End If
If help Then
  WScript.Echo "使い方：cscript " & scriptName & " 分割サイズ 単位 ファイル"
  WScript.Quit
End If
If WScript.Arguments.Count <> 3 Then
  WScript.Echo "引数の数が不正です。"
  WScript.Quit 1
End If
Dim splitSize, splitUnit, inPath
splitSize = WScript.Arguments(0)
splitUnit = WScript.Arguments(1)
inPath = WScript.Arguments(2)

Select Case LCase(splitUnit)
  Case "byte"
    ' 何もしない
  Case "line"
    ' 何もしない
  Case Else
    WScript.Echo "不正な引数です。arg=" + splitUnit
    WScript.Quit 1
End Select

' 主処理
Log "開始します。"


' 準備
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim inFile, outFile, outPath, sizeCount, fileCount
Set inFile = Nothing
Set outFile = Nothing
sizeCount = 0
fileCount = 0

' 入力ファイルオープン
Set inFile = fso.OpenTextFile(inPath, ForReading)

' 入力ファイル読み込み
Do Until inFile.AtEndOfStream
  ' 1行読み込み
  Dim line
  line = inFile.ReadLine
  Select Case LCase(splitUnit)
    Case "byte"
      sizeCount = sizeCount + LenSjis(line) + LenSjis(vbNewLine)
    Case "line"
      sizeCount = sizeCount + 1
  End Select

  ' 出力ファイルオープン
  If outFile Is Nothing Then
    fileCount = fileCount + 1
    outPath = GetOutPath(inPath, fileCount)
    Set outFile = OpenFile(outPath)
  End If

  ' 出力ファイル書き込み
  outFile.WriteLine line

  ' 出力ファイルクローズ
  If (sizeCount >= splitSize * fileCount) Or (inFile.AtEndOfStream) Then
    CloseFile outPath, outFile
    Set outFile = Nothing
  End If
Loop

' 出力ファイルクローズ
If Not outFile Is Nothing Then
  CloseFile outPath, outFile
  Set outFile = Nothing
End If

' 入力ファイルクローズ
inFile.Close
Set inFile = Nothing


Set fso = Nothing
Log "正常終了です。"
WScript.Quit 0

' --------------------------------------------------

' ShiftJIS文字列のバイト数を取得
Function LenSjis(str)
  Dim size, i, c
  size = 0
  For i = 0 To Len(str) - 1
    c = Mid(str, i + 1, 1)
    If (Asc(c) And &HFF00) = 0 Then
      size = size + 1
    Else
      size = size + 2
    End If
  Next
  LenSjis = size
End Function

' 出力パスの組み立て
Function GetOutPath(inPath, count)
  Dim ext
  ext = fso.GetExtensionName(inPath)
  If Len(ext) > 0 Then
    ext = "." & ext
  End If
  GetOutPath = fso.GetParentFolderName(inPath) & "\" & fso.GetBaseName(inPath) & "." & count & ext
End Function

' ファイルオープン
Function OpenFile(outPath)
  Dim file
  Set file = fso.OpenTextFile(outPath, ForWriting, True)
  Set OpenFile = file
End Function

' ファイルクローズ
Sub CloseFile(outPath, file)
  file.Close
  Set file = Nothing
  WScript.Echo "分割後ファイル=" & outPath
End Sub

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
  If debug Then
    WScript.Echo Now() & " " & scriptName & " " & msg
  End If
End Sub
