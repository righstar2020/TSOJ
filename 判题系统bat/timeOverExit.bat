@echo off
rem ����ʱ�ж� ��ֹ����ʱ
rem ��ȡ�������
set processName=%1
set resultFile=%2
set /a exitTime=%3
rem ���õȴ�8s�ر��������
rem ÿ�������������Ҫ1s ���5������ ѡȡ�״�����
rem ping 127.0.0.1 -n 5 >nul
rem choiceָ����Զ�ʱ
rem �жϲ���
if "%processName%" equ "" goto errEnd
if "%resultFile%" equ "" goto errEnd
if "%exitTime%" equ "" goto errEnd
choice /t %exitTime% /d y /n >nul
set /a isFind=0
:loop
for /f "tokens=1 delims= " %%i in ('tasklist ^|findstr "%processName%"') do (
    if "%%i" neq "" (
        taskkill /im %processName% /f
        echo %date% %time:~0,8%>>debug.txt
        echo �������г�ʱ%exitTime%s>>debug.txt
        echo %%i��������ֹ>>debug.txt
        echo executeTime:%exitTime%000>>%resultFile%
        echo nowStatus:3>>%resultFile%
        rem ѭ����Ᵽ֤�����ѱ���ֹ
        set /a isFind+=1
        goto loop
    ) else (      
        echo %date% %time:~0,8%>>debug.txt
        echo ��ʱ��ֹ�������>>debug.txt
        echo %processName%����δ�ҵ�>>debug.txt
        goto end
    )

)



goto end
:errEnd
echo %date% %time:~0,8%>>debug.txt
echo �ղ��� from timeOverExit>>debug.txt
:end
rem echo ������� ��ֹ���̴���%isFind%
exit