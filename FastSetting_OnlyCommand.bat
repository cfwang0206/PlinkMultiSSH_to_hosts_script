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

REM echo �z�ثe�� TFTP Server �O %TFTP_SERVER%�A�Х��T�w tftp ���A�����`�}�ҡC
pause
FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ %Hosts_File%"`) do (
    set "var=%%a"
    SETLOCAL EnableDelayedExpansion
    set "var=!var:*:=!"
    SET check=0
    echo ���� !var! �D���O�_�}��...
    ping !var! -n 1 -w 100 | find "TTL=" > nul && SET check=1
    IF !check! == 1 (
    echo %date% %time%  !var! �������` > log\debug.log 2>>&1
    echo %date% %time%  = ���b�}�l�ƥ� !var! = >> log\debug.log 2>>&1
 echo y | start /B /wait plink.exe -v -ssh !var! -l %login% -pw %pass%  %Extend_Command% >log\host_!var!_debug.log 2>>&1
    echo %date% %time%  = !var! �ƥ����� = >> log\debug.log 2>>&1
    echo %date% %time% * !var! OK * >> log\done.log
    ENDLOCAL
   ) ELSE ( 
           echo %date% %time% *!var! DOWN* >> log\failurelog.log
           )
  )
GOTO END

:END
cls
echo �������`�M��p�U:
type log\failurelog.log
echo.
echo.
echo �]�w�����M��p�U:
type log\done.log
pause