Set shell = Wscript.createobject("wscript.shell")
Set agr = Wscript.Arguments
'ע���������ansi
a = shell.run ("getUseMemory.bat "&agr(0)&" "&agr(1),0)
