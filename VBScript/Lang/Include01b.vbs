' 外部VBScriptを読み込む練習です。
' 当スクリプトは呼ばれる側です。

Option Explicit

' ※呼び元の関数や変数が使用できる。
Log "すぐに実行される処理はありません。"

' --------------------------------------------------

Function Include01bFunction(a, b)
  WScript.Echo "関数が呼び出されました。"
  Include01bFunction = a + b
End Function
