rem @echo off
rem 获取进程运行消耗内存
rem 入参为文件名
set processName=%1
set resultFile=%2
:init
rem 判断参数
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
echo 获取%processName%内存失败>>debug.txt
goto end
:errEnd
echo %date% %time:~0,8%>>debug.txt
echo 空参数 from getUserMemory>>debug.txt

:end
exit