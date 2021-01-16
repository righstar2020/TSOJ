Set shell = Wscript.createobject("wscript.shell")
Set arg = Wscript.Arguments
'×¢Òâ±àÂëÎÊÌâansi

'For   I   =   0   to   arg.Count   -   1
'     WScript.Echo   arg(I)
'Next
a = shell.run ("runJudge.bat "&arg(0)&" "&arg(1)&" "&arg(2)&" "&arg(3)&" "&arg(4)&" "&arg(5)&" "&arg(6),0)