' ファイル/フォルダのバックアップを作成します。

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
  WScript.Echo "使い方：cscript " & scriptName & " [/?] ファイル/フォルダ ..."
  WScript.Quit
End If

' 主処理
Log "開始します。"


Dim arg
For Each arg In WScript.Arguments
  Dim dir, name, ext, outPath
  If fso.FolderExists(arg) Then
    dir = fso.GetParentFolderName(arg)
    name = fso.GetFileName(arg)
    outPath = fso.BuildPath(dir, name & "_bk" & timestampStr)
    fso.CopyFolder arg, outPath
  ElseIf fso.FileExists(arg) Then
    dir = fso.GetParentFolderName(arg)
    name = fso.GetBaseName(arg)
    ext = fso.GetExtensionName(arg)
    If Len(ext) > 0 Then
      ext = "." & ext
    End If
    outPath = fso.BuildPath(dir, name & "_bk" & timestampStr & ext)
    fso.CopyFile arg, outPath
  Else
    WScript.Echo "ファイル/フォルダではありません。arg=" & arg
  End If
Next


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
  If debug Then
    WScript.Echo Now() & " " & scriptName & " " & msg
  End If
End Sub
