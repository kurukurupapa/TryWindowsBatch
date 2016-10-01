' ZIPファイルを展開してみます。
' ※ZIP圧縮する処理は、複雑らしいので作成しないかも。

' 参考サイト
' データ連携と統合を科学するブログ: Windowsで、OS標準機能のzip圧縮/解凍を使用する（WSH編）
' http://bitdatasci.blogspot.jp/2015/10/windowsoszipwsh.html

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

' 主処理
Log "開始します。"



Dim zipPath, workDir
zipPath = scriptDir & "\Data\UnZip01-Dummy.zip"
workDir = currentDir
WScript.Echo zipPath
WScript.Echo workDir

Dim app, zipFile, folder
Set app = CreateObject("Shell.Application")
Set zipFile = app.NameSpace(zipPath).Items
Set folder = app.NameSpace(workDir)
folder.CopyHere zipFile, &H14



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
