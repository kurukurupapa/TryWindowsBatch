' テキストファイルを分割します。
' 入力テキストファイルには、シフトJIS、CRLFを想定しています。

' 参考サイト
' VBScript でシフト JIS の文字列のバイト数を数える (unibon)
' http://www.geocities.co.jp/SiliconValley/4334/unibon/asp/len.html

Option Explicit

Dim scriptName, scriptDir
Init

' 引数チェック
Dim usageFlag, arg
usageFlag = False
If WScript.Arguments.Count <> 2 Then
  usageFlag = True
End If
For Each arg In WScript.Arguments
  If arg = "/?" Then
    usageFlag = True
  End If
Next
If usageFlag Then
  WScript.Echo "使い方：cscript " & scriptName & " 分割サイズ ファイル"
  WScript.Quit
End If
Dim splitSize, inPath
splitSize = WScript.Arguments(0)
inPath = WScript.Arguments(1)


' 主処理
Log "開始します。"


' ファイル読み込み
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim fso, file, sizeCount, fileCount, text
Set fso = CreateObject("Scripting.FileSystemObject")
Set file = fso.OpenTextFile(inPath, ForReading)
sizeCount = 0
fileCount = 0
text = ""
Do Until file.AtEndOfStream
  Dim line
  line = file.ReadLine
  'sizeCount = sizeCount + Lenb(line) + Lenb(vbNewLine)
  sizeCount = sizeCount + LenSjis(line) + LenSjis(vbNewLine)
  text = text & line & vbNewLine

  If (sizeCount > splitSize * (fileCount + 1)) Or (file.AtEndOfStream) Then
    ' ファイル書き込み
    fileCount = fileCount + 1
    Save inPath, fileCount, text
    text = ""
  End If
Loop
Log "トータルサイズ=" & sizeCount & "byte"
file.Close


Log "正常終了です。"

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

' ファイル書き込み
Sub Save(inPath, count, text)
  Dim outPath, file
  outPath = inPath & "." & count & ".txt"
  Set file = fso.OpenTextFile(outPath, ForWriting, True)
  file.Write(text)
  file.Close
  Set file = Nothing
  Log "分割後ファイル=" & outPath & ",サイズ=" & LenSjis(text)
End Sub

' 初期化処理
Sub Init
  scriptName = WScript.ScriptName
  scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\") - 1)
End Sub

' メッセージ出力
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
