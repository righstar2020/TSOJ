rem @echo off
rem 注意文件名不要和系统命令一样如main
rem 注意注释使用'rem'
rem 判题入口文件
rem 需编译的文件
rem 提交的代码ID
set submitProblemId=%1
rem 需编译的文件
set compileFilePath=%2
rem 可执行文件
set exeFilePath=%3
rem 运行时的进程名
set processName=%4
rem 编译错误输出文件
set compileErrFilePath=%5
rem 判题输入数据文件
set inputFile=%6
rem 用户运行的输出
set outputFile=%7
rem 临时输出文件
set tempOutputFile=%8
rem 判题文件
set judgeFile=%9

rem 超过十个参数则右移
rem 判题结果数据文件
shift /1
set resultFile=%9
rem 时间限制
shift /2
set /a timeLimit=%9
rem 内存限制
shift /3
set /a memoryLimit=%9
rem 判题状态
rem -1 等待 0 通过 1编译错误 2答案错误 3运行超时 4内存超限
set /a resultStatus=1
rem 超时强制关闭时间 8s
set /a exitTime=8
rem 运行时间
set /a executeTime=0
rem 使用内存
set /a executeMemory=0
:init
rem 判断参数错误,所有参数不能为空
set errArg=无
if "%submitProblemId%" equ "" goto errEnd
if "%compileFilePath%" equ "" goto errEnd
if "%exeFilePath%" equ "" goto errEnd
if "%processName%" equ "" goto errEnd
if "%compileErrFilePath%" equ "" goto errEnd
if "%inputFile%" equ "" goto errEnd
if "%outputFile%" equ "" goto errEnd
if "%tempOutputFile%" equ "" goto errEnd
if "%judgeFile%" equ "" goto errEnd
if "%resultFile%" equ "" goto errEnd
if "%timeLimit%" equ "" goto errEnd
if "%memoryLimit%" equ "" goto errEnd
rem 初始化
cd .>%resultFile%
:compile
rem 编译结果
for /f %%i in ('compile.bat %compileFilePath% %exeFilePath% %compileErrFilePath%') do (
    set /a resultStatus=%%i
)

if "%resultStatus%" EQU "2" (
    rem  编译成功
) else (
    echo %date% %time:~0,8%>>debug.txt
    echo 编译失败%compileFilePath%>>debug.txt
    goto database
)
:timeOverExit
rem 超时则强制退出
wscript timeOverExit.vbs %processName% %resultFile% %exitTime%
:getUseMemory
rem 获取内存消耗 程序
wscript getUseMemory.vbs  %processName% %resultFile%

:runJudge
wscript runJudge.vbs %exeFilePath% %inputFile% %outputFile% %judgeFile% %resultFile% %tempOutputFile% %timeLimit%


:loopReadResult
rem 循环读取结果
rem 注意变量延迟问题
for /f "tokens=1,2 delims=:" %%i in (%resultFile%) do (
    if "%%i" equ "executeTime" (
        set /a executeTime=%%j
    )
    if "%%i" equ "executeMemory" (
        set /a executeMemory=%%j
        
    )
    if "%%i" equ "nowStatus" (
        set /a resultStatus=%%j
        goto endLoop
    )

)
rem 每次等待1s
choice /t 1 /d y /n >nul
goto loopReadResult
:endLoop

if %executeMemory% GEQ %memoryLimit% (
    set /a resultStatus=4
)
:database
rem 此处为数据库更新的操作
rem 数据定义
rem 注意字符串加双引号 ""
rem 注意不要重复操作>>txt
call updateDatabase.bat %submitProblemId% %resultStatus% %compileErrFilePath% %executeTime% %executeMemory% >>dataBaseErr.txt 2>>&1

echo %date% %time:~0,8%>>log.txt
echo 题目评测完成,ID:%submitProblemId%>>log.txt
echo 题目ID:%submitProblemId%,评测结果:%resultStatus%,用时:%executeTime%,消耗内存:%executeMemory% >>log.txt

goto end

:errEnd
echo %date% %time:~0,8%>>debug.txt
echo 错误参数%errArg%>>debug.txt
echo 参数错误
:end
echo 评测程序结束
echo 执行究极自身终止程序
rem taskkill /im cmd.exe /f
exit
