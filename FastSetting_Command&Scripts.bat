@echo off
TITLE �j��]�w�p�u�� 103.10.07 cfwang@Hilink
REM ��ƨӷ�:
REM [1]http://stackoverflow.com/questions/155932/how-do-you-loop-through-each-line-in-a-text-file-using-a-windows-batch-file
REM [2]GOOGLE �j��
REM
REM �]�w�����ܼ�:
SET Script_File=script.txt 
SET Hosts_File=hosts.txt
SET Login=
SET PASS=
SET Extend_Command=execute backup config tftp !var!.conf %TFTP_SERVER%
SETLOCAL DisableDelayedExpansion
REM
REM �ؤ@�� LOG ��Ƨ��A�� LOG,�i���P�_���S���عL
mkdir log > nul

pause
FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ %Hosts_File%"`) do (
    set "var=%%a"
    SETLOCAL EnableDelayedExpansion
    set "var=!var:*:=!"
    SET check=0
    echo ���� !var! �D���O�_�}��...
    ping !var! -n 1 -w 100 | find "TTL=" > nul && SET check=1
    IF !check! == 1 (
    echo %date% %time%  !var! �������` > debug.log 2>>&1
    echo %date% %time%  = ���b�}�l�ƥ� !var! = >> debug.log 2>>&1
    REM plink �s�u�����ۭq���R�O "Extend_Command"
 echo y | start /B /wait plink.exe -v -ssh !var! -l %login% -pw %pass% %Extend_Command%>host_!var!_debug.log 2>>&1
    echo %date% %time%  = !var! �ƥ����� = >> debug.log 2>>&1
    echo %date% %time%  = �}�l�]�w !var! = >> debug.log 2>>&1
    REM plink �s�u��Ū���ð��� script 
    start /B /wait  plink.exe -v -ssh !var! -l %login% -pw %pass%  -m %Script_File%  >> host_!var!_debug.log 2>>&1
    echo %date% %time% * !var! OK * >> done.log
    echo = %date% %time%  !var! �]�w���� = >> debug.log 2>>&1
    ENDLOCAL
   ) ELSE ( 
           echo %date% %time% *!var! DOWN* >> failurelog.log
           )
  )
GOTO END

:END
cls
@mkdir log > nul
@move *.log log > nul
echo �������`�M��p�U:
type log\failurelog.log
echo.
echo.
echo �]�w�����M��p�U:
type log\done.log
pause