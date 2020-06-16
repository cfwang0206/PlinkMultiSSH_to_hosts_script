@echo off
TITLE 大批設定小工具 103.10.07 cfwang@Hilink
REM 資料來源:
REM [1]http://stackoverflow.com/questions/155932/how-do-you-loop-through-each-line-in-a-text-file-using-a-windows-batch-file
REM [2]GOOGLE 大神
REM
REM 設定環境變數:
SET Script_File=script.txt 
SET Hosts_File=hosts.txt
SET Login=
SET PASS=
SET Extend_Command=execute backup config tftp !var!.conf %TFTP_SERVER%
SETLOCAL DisableDelayedExpansion
REM
REM 建一個 LOG 資料夾，放 LOG,懶的判斷有沒有建過
mkdir log > nul

pause
FOR /F "usebackq delims=" %%a in (`"findstr /n ^^ %Hosts_File%"`) do (
    set "var=%%a"
    SETLOCAL EnableDelayedExpansion
    set "var=!var:*:=!"
    SET check=0
    echo 測試 !var! 主機是否開啟...
    ping !var! -n 1 -w 100 | find "TTL=" > nul && SET check=1
    IF !check! == 1 (
    echo %date% %time%  !var! 網路正常 > debug.log 2>>&1
    echo %date% %time%  = 正在開始備份 !var! = >> debug.log 2>>&1
    REM plink 連線後執行自訂的命令 "Extend_Command"
 echo y | start /B /wait plink.exe -v -ssh !var! -l %login% -pw %pass% %Extend_Command%>host_!var!_debug.log 2>>&1
    echo %date% %time%  = !var! 備份完成 = >> debug.log 2>>&1
    echo %date% %time%  = 開始設定 !var! = >> debug.log 2>>&1
    REM plink 連線後讀取並執行 script 
    start /B /wait  plink.exe -v -ssh !var! -l %login% -pw %pass%  -m %Script_File%  >> host_!var!_debug.log 2>>&1
    echo %date% %time% * !var! OK * >> done.log
    echo = %date% %time%  !var! 設定結束 = >> debug.log 2>>&1
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
echo 網路異常清單如下:
type log\failurelog.log
echo.
echo.
echo 設定完成清單如下:
type log\done.log
pause