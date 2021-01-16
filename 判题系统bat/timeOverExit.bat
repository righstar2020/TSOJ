@echo off
rem 程序超时判断 防止程序超时
rem 获取传入参数
set processName=%1
set resultFile=%2
set /a exitTime=%3
rem 设置等待8s关闭评测程序
rem 每个测试用例大概要1s 最多5个用例 选取易错用例
rem ping 127.0.0.1 -n 5 >nul
rem choice指令可以定时
rem 判断参数
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
        echo 程序运行超时%exitTime%s>>debug.txt
        echo %%i进程已终止>>debug.txt
        echo executeTime:%exitTime%000>>%resultFile%
        echo nowStatus:3>>%resultFile%
        rem 循环检测保证程序已被终止
        set /a isFind+=1
        goto loop
    ) else (      
        echo %date% %time:~0,8%>>debug.txt
        echo 超时终止程序结束>>debug.txt
        echo %processName%进程未找到>>debug.txt
        goto end
    )

)



goto end
:errEnd
echo %date% %time:~0,8%>>debug.txt
echo 空参数 from timeOverExit>>debug.txt
:end
rem echo 程序结束 终止进程次数%isFind%
exit