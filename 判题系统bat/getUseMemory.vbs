Set shell = Wscript.createobject("wscript.shell")
Set agr = Wscript.Arguments
'×¢Òâ±àÂëÎÊÌâansi
a = shell.run ("getUseMemory.bat "&agr(0)&" "&agr(1),0)
