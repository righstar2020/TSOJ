rem @echo off
rem ע���ļ�����Ҫ��ϵͳ����һ����main
rem ע��ע��ʹ��'rem'
rem ��������ļ�
rem �������ļ�
rem �ύ�Ĵ���ID
set submitProblemId=%1
rem �������ļ�
set compileFilePath=%2
rem ��ִ���ļ�
set exeFilePath=%3
rem ����ʱ�Ľ�����
set processName=%4
rem �����������ļ�
set compileErrFilePath=%5
rem �������������ļ�
set inputFile=%6
rem �û����е����
set outputFile=%7
rem ��ʱ����ļ�
set tempOutputFile=%8
rem �����ļ�
set judgeFile=%9

rem ����ʮ������������
rem �����������ļ�
shift /1
set resultFile=%9
rem ʱ������
shift /2
set /a timeLimit=%9
rem �ڴ�����
shift /3
set /a memoryLimit=%9
rem ����״̬
rem -1 �ȴ� 0 ͨ�� 1������� 2�𰸴��� 3���г�ʱ 4�ڴ泬��
set /a resultStatus=1
rem ��ʱǿ�ƹر�ʱ�� 8s
set /a exitTime=8
rem ����ʱ��
set /a executeTime=0
rem ʹ���ڴ�
set /a executeMemory=0
:init
rem �жϲ�������,���в�������Ϊ��
set errArg=��
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
rem ��ʼ��
cd .>%resultFile%
:compile
rem ������
for /f %%i in ('compile.bat %compileFilePath% %exeFilePath% %compileErrFilePath%') do (
    set /a resultStatus=%%i
)

if "%resultStatus%" EQU "2" (
    rem  ����ɹ�
) else (
    echo %date% %time:~0,8%>>debug.txt
    echo ����ʧ��%compileFilePath%>>debug.txt
    goto database
)
:timeOverExit
rem ��ʱ��ǿ���˳�
wscript timeOverExit.vbs %processName% %resultFile% %exitTime%
:getUseMemory
rem ��ȡ�ڴ����� ����
wscript getUseMemory.vbs  %processName% %resultFile%

:runJudge
wscript runJudge.vbs %exeFilePath% %inputFile% %outputFile% %judgeFile% %resultFile% %tempOutputFile% %timeLimit%


:loopReadResult
rem ѭ����ȡ���
rem ע������ӳ�����
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
rem ÿ�εȴ�1s
choice /t 1 /d y /n >nul
goto loopReadResult
:endLoop

if %executeMemory% GEQ %memoryLimit% (
    set /a resultStatus=4
)
:database
rem �˴�Ϊ���ݿ���µĲ���
rem ���ݶ���
rem ע���ַ�����˫���� ""
rem ע�ⲻҪ�ظ�����>>txt
call updateDatabase.bat %submitProblemId% %resultStatus% %compileErrFilePath% %executeTime% %executeMemory% >>dataBaseErr.txt 2>>&1

echo %date% %time:~0,8%>>log.txt
echo ��Ŀ�������,ID:%submitProblemId%>>log.txt
echo ��ĿID:%submitProblemId%,������:%resultStatus%,��ʱ:%executeTime%,�����ڴ�:%executeMemory% >>log.txt

goto end

:errEnd
echo %date% %time:~0,8%>>debug.txt
echo �������%errArg%>>debug.txt
echo ��������
:end
echo ����������
echo ִ�о���������ֹ����
rem taskkill /im cmd.exe /f
exit
