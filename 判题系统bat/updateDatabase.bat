@echo off
rem �������ݿ�ĺ���
:readInfo
rem ��ȡ���������Ϣ
setlocal enabledelayedexpansion
set judgeMessage=δ֪����
if %2 equ 0 set judgeMessage=����ͨ��
if %2 equ 1 set judgeMessage=%3
if %2 equ 2 set judgeMessage=�𰸴���
if %2 equ 3 set judgeMessage=���г�ʱ
if %2 equ 4 set judgeMessage=�ڴ泬��

:updateSQL
rem ���ݿ���
set database=onlinejudge
rem ����
set table=submit_code_table
set id=%1
rem ��¼ָ��
set "loginSQL=mysql --user=root --password=YOURPASSWORD"
set "querySQL=update %table% set judge_status=%2,judge_message='%judgeMessage%',execute_time=%4,execute_memory=%5 where id=%id%"
set "unknownErrSQL=update %table% set judge_status=2,judge_message='unknown error' where id=%id%"
if "%id%" equ "" (
  echo %date% %time:~0,8%>>debug.txt
  echo ID����Ϊ��>>debug.txt
  echo ID����Ϊ��
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
    echo �������ݿ���Ŀ״̬�ɹ�,ID:%id%>>log.txt
) else (
    echo %date% %time:~0,8%>>log.txt
    echo ���ݿ���³���: %errorlevel%,ID:%id%>>log.txt
    echo ��鿴������־databaseErr.txt>>log.txt
    goto errUpdate
)
goto end
rem �������������ȸ�����Ŀ״̬Ϊ4
:errUpdate
(echo use %database%;%unknownErrSQL%;)|%loginSQL%
:end
