@echo off
setlocal enabledelayedexpansion
rem 可执行文件
set exeFilePath=%1
rem 判题输入数据文件
set inputFile=%2
rem 用户运行的输出
set outputFile=%3
rem 判题文件
set judgeFile=%4
rem 判题结果数据文件
set resultFile=%5
rem 临时输出文件
set tempOutputFile=%6
rem 时间限制(平均)
set /a limitTime=%7


:runExe
rem 清空output文件
cd . >%outputFile%
rem 必须添加delims不然会以空格作为分隔
rem 每个测试用例以$符号结尾
set num = 0
rem 计算平均耗时
set /a avaTime=0
rem 获得耗时单位ms
rem 秒 0~9
set /a sTime1=%time:~7,1%
rem 100ms 0~9
set /a sTime2=%time:~9,1%
rem 10ms 0~9
set /a sTime3=%time:~10,1%
rem 开始时间单位ms
set /a sTime=%sTime1%*1000+%sTime2%*100+%sTime3%*10
rem 清空temp
cd .>%tempOutputFile%
for /f  "delims=" %%i in (%inputFile%) do (
    if not '%%i' equ '$' (
        
        echo %%i>>%tempOutputFile%
    ) else (
        call %exeFilePath% <%tempOutputFile% >>%outputFile%
        set /a num+=1
        rem 清空temp
        cd .>%tempOutputFile%
    )

)
:getTime
rem 获得耗时单位ms
rem 秒 0~9
set /a eTime1=%time:~7,1%
rem 100ms 0~9
set /a eTime2=%time:~9,1%
rem 10ms 0~9
set /a eTime3=%time:~10,1%
rem 结束时间单位ms
set /a eTime=%eTime1%*1000+%eTime2%*100+%eTime3%*10
rem 获得耗时
rem 注意时间循环
set costTime=0
if %eTime% GEQ %sTime% (
    set /a costTime=%eTime%-%sTime%
) else (
    set /a costTime=%eTime%-%sTime%+10000
)
rem 计算平均耗时
set /a avaTime=%costTime%/%num%

:chekIsErrExit
rem 检查是否被异常终止
rem 检查是否超时
rem 阻碍程序运行不输出
for /f "tokens=1,2 delims=:" %%a in (%resultFile%) do (
    if "%%a" equ "nowStatus" (
        rem 程序已超时被timeOverExit终止
        if "%%b" equ "3" (
            set /a resultStatus=3
            set /a avaTime=%limitTime%
            echo %date% %time:~0,8%>>debug.txt
            echo 进程超时终止 from runJudge.bat>>debug.txt
            goto end
        )
    )

)
:checkTimeLimit
rem 检查时间限制
if %avaTime% GEQ %limitTime% (
    rem 超时
    set /a resultStatus=3
    goto end
)

rem 比较测试结果和正确结果
:compareJudge
fc %outputFile% %judgeFile% >nul
if %errorlevel% equ 0 (
  rem 评测通过
  set /a resultStatus=0
) else (
  rem 答案错误
  set /a resultStatus=2
)
:end
echo %date% %time:~0,8%>>log.txt
echo 题目评测结果errorlevel:%errorlevel%,ID:%submitProblemId%>>log.txt
echo executeTime:%avaTime%>>%resultFile%
rem 状态一定在最后输出
echo nowStatus:%resultStatus%>>%resultFile%
exit