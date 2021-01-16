@echo off
rem 更新数据库的函数
:readInfo
rem 读取编译错误信息
setlocal enabledelayedexpansion
set judgeMessage=未知错误
if %2 equ 0 set judgeMessage=评测通过
if %2 equ 1 set judgeMessage=%3
if %2 equ 2 set judgeMessage=答案错误
if %2 equ 3 set judgeMessage=运行超时
if %2 equ 4 set judgeMessage=内存超限

:updateSQL
rem 数据库名
set database=onlinejudge
rem 表名
set table=submit_code_table
set id=%1
rem 登录指令
set "loginSQL=mysql --user=root --password=YOURPASSWORD"
set "querySQL=update %table% set judge_status=%2,judge_message='%judgeMessage%',execute_time=%4,execute_memory=%5 where id=%id%"
set "unknownErrSQL=update %table% set judge_status=2,judge_message='unknown error' where id=%id%"
if "%id%" equ "" (
  echo %date% %time:~0,8%>>debug.txt
  echo ID不能为空>>debug.txt
  echo ID不能为空
  goto end
)
echo %date% %time:~0,8%>>sqlLog.txt
(
   echo use %database%;
  @echo %querySQL%;
)>>sqlLog.txt
(echo use %database%;%querySQL%;)|%loginSQL%

if %errorlevel% equ 0 (
    echo %date% %time:~0,8%>>log.txt
    echo 更新数据库题目状态成功,ID:%id%>>log.txt
) else (
    echo %date% %time:~0,8%>>log.txt
    echo 数据库更新出错: %errorlevel%,ID:%id%>>log.txt
    echo 请查看错误日志databaseErr.txt>>log.txt
    goto errUpdate
)
goto end
rem 判题程序错误则先更新题目状态为4
:errUpdate
(echo use %database%;%unknownErrSQL%;)|%loginSQL%
:end
