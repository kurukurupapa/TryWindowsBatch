' VBScriptのテンプレートです。

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Dim currentDir
Dim fso
Init

' 引数チェック
Dim arg, help, debug
help = False
debug = False
For Each arg In WScript.Arguments
  If IsOptionArg(arg) Then
    Select Case LCase(arg)
      Case "/?"
        help = True
      Case "/debug"
        debug = True
      Case Else
        WScript.Echo "不正な引数です。arg=" & arg
        WScript.Quit 1
    End Select
  End If
Next
If help Then
  Usage
  WScript.Quit
End If

' 主処理
Log "開始します。"


' ▼▼▼適宜、処理を書き換えます

Dim dirCount, fileCount, unknownCount
dirCount = 0
fileCount = 0
unknownCount = 0

For Each arg In WScript.Arguments
  If Not IsOptionArg(arg) Then
    Proc(arg)
  End If
Next

WScript.Echo "ディレクトリ数: " & dirCount
WScript.Echo "ファイル数:     " & fileCount
WScript.Echo "不明数:         " & unknownCount

' ▲▲▲適宜、処理を書き換えます


Set fso = Nothing
Log "正常終了です。"
WScript.Quit 0

' --------------------------------------------------

' 使用方法
Sub Usage
  WScript.Echo "使い方：cscript " & scriptName & " [/?][/DEBUG] <ファイル|フォルダ> ..."
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

  Set fso = CreateObject("Scripting.FileSystemObject")
End Sub

' 正常終了
Sub QuitNormally
  Log "正常終了です。"
  WScript.Quit 0
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

' オプション引数判定
Function IsOptionArg(arg)
  IsOptionArg = Left(arg, 1) = "/"
End Function
