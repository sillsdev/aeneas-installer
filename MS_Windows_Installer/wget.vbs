Set fso = CreateObject ("Scripting.FileSystemObject")
Set stdout = fso.GetStandardStream (1)
Set stderr = fso.GetStandardStream (2)

if WScript.Arguments.Count < 1 then
  stdout.WriteLine "Usage: wget.vbs <url> <file>"
  WScript.Quit
end if

Set xHttp = CreateObject("WinHttp.WinHttpRequest.5.1")
xHttp.Open "GET", WScript.Arguments(0), False
xHttp.Option(6) = true 'The value of false means do not follow redirects automatically
xHttp.Send()

If xHttp.Status = 200 Then
  Dim testStr
  varByteArray = xHttp.ResponseBody
  For lngCounter = 0 to 256 'UBound(varByteArray) 
    testStr = testStr & Midb(varByteArray,lngCounter + 1,1) & chrb(0)
  Next 
  If InStr(lcase(testStr), "doctype html") Then
    stderr.WriteLine "Error: " & WScript.Arguments(0) & " not found."
  Else
    stdout.WriteLine "Saving: " & WScript.Arguments(1)
    Set bStrm = CreateObject("Adodb.Stream")
    bStrm.Type = 1 '//binary
    bStrm.Open
    bStrm.Write varByteArray
    bStrm.SaveToFile WScript.Arguments(1), 2 '//overwrite
    bStrm.Close
    Set bStrm = Nothing
  End If
Else
  stderr.WriteLine "Error Occurred : " & xHttp.Status & " - " & xHttp.statusText
End If

Set xHttp = Nothing
WScript.Quit
