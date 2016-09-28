' ZIPファイルを展開してみます。
' ※ZIP圧縮する処理は、複雑らしいので作成しないかも。

' 参考サイト
' データ連携と統合を科学するブログ: Windowsで、OS標準機能のzip圧縮/解凍を使用する（WSH編）
' http://bitdatasci.blogspot.jp/2015/10/windowsoszipwsh.html

Option Explicit

Dim scriptName, scriptDir
Dim dateStr, timeStr, timestampStr
Init

' 引数チェック
'If WScript.Arguments.Count = 0 Then
'  WScript.Echo "使い方：cscript " & scriptName & " ZIPファイル"
'  Quit 0
'End If
'Dim zipPath
'zipPath = WScript.Arguments.Item(0)

' 開始チェック
'If Not CheckStart Then
'  WScript.Quit 1
'End If

' 主処理
Log "開始します。"


Dim zipPath, workDir
zipPath = scriptDir & "\Data\UnZip01-Dummy.zip"
workDir = scriptDir & "\Work"
WScript.Echo zipPath
WScript.Echo workDir

Dim app, zipFile, folder
Set app = CreateObject("Shell.Application")
Set zipFile = app.NameSpace(zipPath).Items
Set folder = app.NameSpace(workDir)
folder.CopyHere zipFile, &H14


Log "正常終了です。"
Quit 0

' --------------------------------------------------

' 初期化処理
Sub Init
  scriptName = WScript.ScriptName
  scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\") - 1)
  dateStr = Replace(Date(), "/", "")
  timeStr = Replace(Time(), ":", "")
  timestampStr = dateStr & "-" & timeStr
End Sub

' 処理開始チェック
Function CheckStart
  Dim input
  WScript.Echo "開始してよろしいですか？ (y/n[y])"
  input = WScript.StdIn.ReadLine
  CheckStart = (input = "y" Or input = "")
End Function

' 処理中止
Sub Abort
  Log "異常終了です。"
  Quit 1
End Sub

' 終了処理
Sub Quit(code)
  'Pause
  WScript.Quit code
End Sub

' ユーザ確認待ち
Sub Pause
  WScript.Echo "続行するには何かキーを押してください . . ."
  WScript.StdIn.ReadLine
End Sub

' メッセージ出力
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
