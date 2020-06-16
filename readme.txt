用 PLINK "應該"可以批次對主機下命令的懶惰鬼腳本 by afeng

*用途說明:
能讀取存在 hosts.txt 中的主機IP 清單 ,透過 SSH 去遠端做我們要下命令或是執行 script.txt  裡面的事情。


*怎麼用*
1.用記事本開啟需要的版本
FastSetting_CMD.bat - 僅執行命令
FastSetting_CMD&LoadScript.bat - 執行命令與腳本

2.修改需要的範圍
SET Login=#登入帳號
SET PASS=#登入密碼
SET Extend_Command=#執行命令

3.儲存批次檔案

4.執行看看:)

執行步驟說明:
[1]讀取 hosts 中的主機 IP PING 通才做 ,不通的設備會存到 failurelog.log.
[2]執行時候，存一份log 成 host_{IP}_debug.log ,
[3]執行完存放到 done.log 記錄。


== Changelog ==
v0.2 2014/10/07 新增 PING 通才做 SSH 連線動作
                PING 不通記錄到 failurelog.log
                做完存到 done.log
                好像還少了什麼...不管了,反正可以動 :P
                
v0.1 2014/10/06 懶惰鬼腳本第一版
                好像可以動... 可以存 log.
