rem @echo off
rem ��ȡ�������������ڴ�
rem ���Ϊ�ļ���
set processName=%1
set resultFile=%2
:init
rem �жϲ���
if "%processName%" equ "" goto errEnd
if "%resultFile%" equ "" goto errEnd


for /l %%a in (1,1,10) do (
    for /f "tokens=5 delims= " %%i in ('tasklist ^|findstr "%processName%"') do (
        echo %date% %time:~0,8%>>out.txt
        echo %%a>>out.txt
        for /f "tokens=1,2 delims=," %%j in ("%%i") do (
            if "%%j%%k" neq "" (
                echo executeMemory:%%j%%k>>%resultFile%
                goto end
            )
        )                       
    ) 
)
:err
echo %date% %time:~0,8%>>debug.txt
echo ��ȡ%processName%�ڴ�ʧ��>>debug.txt
goto end
:errEnd
echo %date% %time:~0,8%>>debug.txt
echo �ղ��� from getUserMemory>>debug.txt

:end
exit