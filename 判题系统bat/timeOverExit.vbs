Set shell = Wscript.createobject("wscript.shell")
Set agr = Wscript.Arguments
'×¢Òâ±àÂëÎÊÌâansi
a = shell.run ("timeOverExit.bat "&agr(0)&" "&agr(1)&" "&agr(2),0)
