' VBScriptのテンプレートです。

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Init

' 引数チェック
Dim help
help = False
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments(0) = "/?" Then
    help = True
  End If
Else
  help = True
End If
If help Then
  PrintUsage
  WScript.Quit
End If

' 主処理
Log "開始します。"

Dim arg, fso
Dim dirCount, fileCount, unknownCount
dirCount = 0
fileCount = 0
unknownCount = 0
Set fso = CreateObject("Scripting.FileSystemObject")
For Each arg In WScript.Arguments
  Proc(arg)
Next
Set fso = Nothing
PrintResult

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

' 使用方法
Sub PrintUsage
  WScript.Echo "使い方：cscript " & scriptName & " [/?] <ファイル|フォルダ> ..."
End Sub

' 1つのディレクトリ/ファイルの処理
Sub Proc(path)
  If fso.FolderExists(path) Then
    ProcNest(path)
  ElseIf fso.FileExists(path) Then
    ProcFile(path)
  Else
    ProcUnknown(path)
  End If
End Sub

' ディレクトリ再帰
Sub ProcNest(dirPath)
  ProcDir(dirPath)

  Dim folder, subfolder, file
  Set folder = fso.GetFolder(dirPath)
  For Each subfolder In folder.SubFolders
    ProcNest(subfolder)
  Next
  For Each file In folder.Files
    ProcFile(file)
  Next
End Sub

' 1つのディレクトリの処理
Sub ProcDir(dirPath)
  ' ▼▼▼ここにディレクトの処理を書きます
  'Log "ProcDir: " & dirPath
  WScript.Echo "Dir: " & dirPath
  dirCount = dirCount + 1
  ' ▲▲▲ここにディレクトの処理を書きます
End Sub

' 1つのファイルの処理
Sub ProcFile(filePath)
  ' ▼▼▼ここにファイルの処理を書きます
  'Log "ProcFile: " & filePath
  WScript.Echo "File: " & filePath
  fileCount = fileCount + 1
  ' ▲▲▲ここにファイルの処理を書きます
End Sub

' 1つの不明パスの処理
Sub ProcUnknown(arg)
  ' ▼▼▼ここに不明引数の処理を書きます
  'Log "ProcUnknown: " & arg
  WScript.Echo "Unknown: " & arg
  unknownCount = unknownCount + 1
  ' ▲▲▲ここに不明引数の処理を書きます
End Sub

Sub PrintResult
  ' ▼▼▼ここに結果出力処理を書きます
  WScript.Echo "ディレクトリ数: " & dirCount
  WScript.Echo "ファイル数:     " & fileCount
  WScript.Echo "不明数:         " & unknownCount
  ' ▲▲▲ここに結果出力処理を書きます
End Sub
