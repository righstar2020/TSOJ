Set shell = Wscript.createobject("wscript.shell")
'Set   objArgs   =   WScript.Arguments
'For   I   =   0   to   objArgs.Count   -   1
'      WScript.Echo   objArgs(I)
'Next
Set agr = Wscript.Arguments
'ע���������ansi
a = shell.run ("judgeMain.bat "&agr(0)&" "&agr(1)&" "&agr(2)&" "&agr(3)&" "&agr(4)&" "&agr(5)&" "&agr(6)&" "&agr(7)&" "&agr(8)&" "&agr(9)&" "&agr(10)&" "&agr(11),0)
'msgbox "���Գ���ɹ��ں�̨����"