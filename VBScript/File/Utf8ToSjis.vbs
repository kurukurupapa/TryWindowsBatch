' テキストファイルの文字エンコードを、UTF8からシフトJISへ変換します。

' 参考
' ADODB.Streamを使ったテキストファイルの読み書き | SugiBlog
' http://www.k-sugi.sakura.ne.jp/windows/vb/3650/

Option Explicit

Dim scriptName, scriptDir
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
  WScript.Echo "使い方：cscript " & scriptName & " 入力ファイル 出力ファイル"
  WScript.Quit
End If
If WScript.Arguments.Count <> 2 Then
  WScript.Echo "引数の数が不正です。"
  WScript.Quit 1
End If
Dim inPath, outPath, before, after
inPath = WScript.Arguments(0)
outPath = WScript.Arguments(1)

' 主処理
Log "開始します。"


' ファイル読み込み準備（UTF-8）
Const adModeRead = 1, adModeWrite = 2, adModeReadWrite = 3
Const adTypeBinary = 1, adTypeText = 2
Const adReadAll = -1, adReadLine = -2
Const adCR = 13, adCRLF = -1, adLF = 10
Dim stream
Set stream = CreateObject("ADODB.Stream")
stream.Mode = adModeReadWrite
stream.Type = adTypeText
stream.Charset = "UTF-8"
stream.Open
stream.LoadFromFile(inPath)
stream.Position = 0
stream.LineSeparator = adLf

' ファイル書き込み準備（シフトJIS）
Const ForReading = 1, ForWriting = 2, ForAppending = 8
Dim outFile
Set outFile = fso.OpenTextFile(outPath, ForWriting, True)

' ファイル読み込み/書き込み
Dim line
Do Until stream.EOS
  line = stream.ReadText(adReadLine)
  line = Replace(line, vbCr, "")
  outFile.WriteLine(line)
Loop
stream.Close
outFile.Close

' 後片付け
Set stream = Nothing
Set fso = Nothing


Set fso = Nothing
Log "正常終了です。"
WScript.Quit 0

' --------------------------------------------------

' 初期化処理
Sub Init
  Set fso = CreateObject("Scripting.FileSystemObject")
  scriptName = WScript.ScriptName
  scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)

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
