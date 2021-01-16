@echo off
rem �������ļ�
set compileFilePath=%1
rem ��ִ���ļ�
set exeFilePath=%2
rem �����������ļ�
set compileErrFilePath=%3
rem ����ָ��
set compileCMD=g++ %compileFilePath% -o %exeFilePath%
rem ������ 0 �ɹ� 1ʧ��
set /a result=1
:compile
rem ע������ǰ��Ҫ�пո�
if exist %compileFilePath% (
    rem ���벢�������,����մ������
    cd .>%compileErrFilePath%
    %compileCMD%>%compileErrFilePath% 2>&1
    goto checkCompile
)

rem �����ļ������������ʧ��
goto end


:checkCompile
for %%a in ("%compileErrFilePath%") do ( 
    if "%%~za" equ "0" ( 
        rem ��������
        set /a result=2
    ) else ( 
        set /a result=1
    ) 
)

:end
echo %result%

exit 