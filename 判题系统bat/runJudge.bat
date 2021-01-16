@echo off
setlocal enabledelayedexpansion
rem ��ִ���ļ�
set exeFilePath=%1
rem �������������ļ�
set inputFile=%2
rem �û����е����
set outputFile=%3
rem �����ļ�
set judgeFile=%4
rem �����������ļ�
set resultFile=%5
rem ��ʱ����ļ�
set tempOutputFile=%6
rem ʱ������(ƽ��)
set /a limitTime=%7


:runExe
rem ���output�ļ�
cd . >%outputFile%
rem �������delims��Ȼ���Կո���Ϊ�ָ�
rem ÿ������������$���Ž�β
set num = 0
rem ����ƽ����ʱ
set /a avaTime=0
rem ��ú�ʱ��λms
rem �� 0~9
set /a sTime1=%time:~7,1%
rem 100ms 0~9
set /a sTime2=%time:~9,1%
rem 10ms 0~9
set /a sTime3=%time:~10,1%
rem ��ʼʱ�䵥λms
set /a sTime=%sTime1%*1000+%sTime2%*100+%sTime3%*10
rem ���temp
cd .>%tempOutputFile%
for /f  "delims=" %%i in (%inputFile%) do (
    if not '%%i' equ '$' (
        
        echo %%i>>%tempOutputFile%
    ) else (
        call %exeFilePath% <%tempOutputFile% >>%outputFile%
        set /a num+=1
        rem ���temp
        cd .>%tempOutputFile%
    )

)
:getTime
rem ��ú�ʱ��λms
rem �� 0~9
set /a eTime1=%time:~7,1%
rem 100ms 0~9
set /a eTime2=%time:~9,1%
rem 10ms 0~9
set /a eTime3=%time:~10,1%
rem ����ʱ�䵥λms
set /a eTime=%eTime1%*1000+%eTime2%*100+%eTime3%*10
rem ��ú�ʱ
rem ע��ʱ��ѭ��
set costTime=0
if %eTime% GEQ %sTime% (
    set /a costTime=%eTime%-%sTime%
) else (
    set /a costTime=%eTime%-%sTime%+10000
)
rem ����ƽ����ʱ
set /a avaTime=%costTime%/%num%

:chekIsErrExit
rem ����Ƿ��쳣��ֹ
rem ����Ƿ�ʱ
rem �谭�������в����
for /f "tokens=1,2 delims=:" %%a in (%resultFile%) do (
    if "%%a" equ "nowStatus" (
        rem �����ѳ�ʱ��timeOverExit��ֹ
        if "%%b" equ "3" (
            set /a resultStatus=3
            set /a avaTime=%limitTime%
            echo %date% %time:~0,8%>>debug.txt
            echo ���̳�ʱ��ֹ from runJudge.bat>>debug.txt
            goto end
        )
    )

)
:checkTimeLimit
rem ���ʱ������
if %avaTime% GEQ %limitTime% (
    rem ��ʱ
    set /a resultStatus=3
    goto end
)

rem �Ƚϲ��Խ������ȷ���
:compareJudge
fc %outputFile% %judgeFile% >nul
if %errorlevel% equ 0 (
  rem ����ͨ��
  set /a resultStatus=0
) else (
  rem �𰸴���
  set /a resultStatus=2
)
:end
echo %date% %time:~0,8%>>log.txt
echo ��Ŀ������errorlevel:%errorlevel%,ID:%submitProblemId%>>log.txt
echo executeTime:%avaTime%>>%resultFile%
rem ״̬һ����������
echo nowStatus:%resultStatus%>>%resultFile%
exit