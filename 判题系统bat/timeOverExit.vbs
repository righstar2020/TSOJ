Set shell = Wscript.createobject("wscript.shell")
Set agr = Wscript.Arguments
'ע���������ansi
a = shell.run ("timeOverExit.bat "&agr(0)&" "&agr(1)&" "&agr(2),0)
