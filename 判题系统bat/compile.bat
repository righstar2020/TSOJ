@echo off
rem 需编译的文件
set compileFilePath=%1
rem 可执行文件
set exeFilePath=%2
rem 编译错误输出文件
set compileErrFilePath=%3
rem 编译指令
set compileCMD=g++ %compileFilePath% -o %exeFilePath%
rem 编译结果 0 成功 1失败
set /a result=1
:compile
rem 注意括号前后要有空格
if exist %compileFilePath% (
    rem 编译并输出错误,先清空错误输出
    cd .>%compileErrFilePath%
    %compileCMD%>%compileErrFilePath% 2>&1
    goto checkCompile
)

rem 编译文件不存在则编译失败
goto end


:checkCompile
for %%a in ("%compileErrFilePath%") do ( 
    if "%%~za" equ "0" ( 
        rem 编译无误
        set /a result=2
    ) else ( 
        set /a result=1
    ) 
)

:end
echo %result%

exit 