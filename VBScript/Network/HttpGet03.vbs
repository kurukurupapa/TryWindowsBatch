' Webページをダウンロードする練習です。
' ダウンロード対象をリストファイルから選べるようにしてみます。

Option Explicit

Dim scriptName, scriptDir
Init

' 引数チェック
If WScript.Arguments.Count >= 1 Then
  If WScript.Arguments.Item(0) = "/?" Then
    WScript.Echo "使い方：cscript " & scriptName
    WScript.Quit
  End If
End If

' 主処理
Log "開始します。"


Dim scriptBaseName
scriptBaseName = Replace(scriptName, ".vbs", "")

' リストファイル読み込み
Dim text, lines
text = LoadText(scriptBaseName & ".list")
lines = Split(text, vbNewLine)

' リストから選択
Dim line, count, keyword
Dim columns, url, name, comment
count = 0
keyword = "http"
While count <> 1
  WScript.Echo
  WScript.Echo "ダウンロード対象一覧"
  count = 0
  For Each line In lines
    If Len(line) > 0 And Left(line, 1) <> "'" Then
      If InStr(LCase(line), LCase(keyword)) <> 0 Then
        columns = Split(line, ",")
        comment = columns(0)
        url = columns(1)
        name = columns(2)
        count = count + 1
        WScript.Echo count & ". " & comment
      End If
    End If
  Next
  WScript.Echo

  If count = 0 Then
    WScript.Echo "該当するデータがありませんでした。"
    WScript.Quit 1
  End If

  If count <> 1 Then
    WScript.Echo "キーワードを入力してください。"
    keyword = Trim(WScript.StdIn.ReadLine)
    WScript.Echo
  End If
Wend

' ダウンロード
Dim data
data = HttpGet(url)

' ファイル保存
SaveBinary scriptDir & "\Work\" & name, data


Log "正常終了です。"

' --------------------------------------------------

Function LoadText(path)
  Const ForReading = 1, ForWriting = 2, ForAppending = 8
  Dim fso, file, text
  Set fso = CreateObject("Scripting.FileSystemObject")
  Set file = fso.OpenTextFile(path, ForReading)
  text = file.ReadAll
  file.Close
  LoadText = text
End Function

Function HttpGet(url)
  Dim http, body

  ' ※Msxml2.XMLHTTPだと、ZIPやEXEをダウンロードできなかった。
  Set http = CreateObject("Msxml2.ServerXMLHTTP")
  http.Open "GET", url, False
  http.SetRequestHeader "Pragma", "no-cache"
  http.SetRequestHeader "Cache-Control", "no-cache"
  http.SetRequestHeader "If-Modified-Since", "Thu, 01 Jan 1970 00:00:00 GMT"
  Log "HttpGet " & "url=" + url

  http.Send
  Log "Status=" & http.Status
  body = http.ResponseBody
  Set http = Nothing

  HttpGet = body
End Function

Sub SaveBinary(path, data)
  Const adTypeBinary = 1, adTypeText = 2
  Const adSaveCreateNotExist = 1, adSaveCreateOverWrite = 2
  Dim stream

  Set stream = CreateObject("ADODB.Stream")
  stream.Open
  stream.Type = adTypeBinary
  stream.Write data
  stream.SaveToFile path, adSaveCreateOverWrite
  stream.Close
  Set stream = Nothing
End Sub

' --------------------------------------------------

' 初期化処理
Sub Init
  scriptName = WScript.ScriptName
  scriptDir = Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\") - 1)
End Sub

' メッセージ出力
Sub Log(msg)
  WScript.Echo Now() & " " & scriptName & " " & msg
End Sub
