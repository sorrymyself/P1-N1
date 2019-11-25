@echo off
title 斐讯T1、N1官方系统降级工具

:MAINMENU
cls
color F2
echo          ╔═════════════════════════════╗
echo          ║                斐讯T1、N1官方系统降级工具                ║
echo          ║                   2018-9-29  by webpad                   ║
echo          ║                                                          ║
echo          ║ 盒子连接有线网络并获得内网IP地址,T1在设置中开启远程调试, ║
echo          ║        N1在主界面使用鼠标点击四次固件版本号打开adb       ║
echo          ║                                                          ║
echo          ║   本工具仅降级boot分区，降级重启后系统主版本号不会改变,  ║
echo          ║            但已可使用终端reboot命令进入线刷模式          ║
echo          ║                                                          ║
echo          ║  请按键选择操作:                                         ║
echo          ║                 [1]--- T1降级                            ║
echo          ║                                                          ║
echo          ║                 [2]--- N1降级                            ║
echo          ║                                                          ║
echo          ║                 [3]--- 盒子进入线刷模式                  ║
echo          ║                                                          ║
echo          ║                 [0]--- 退出                              ║
echo          ╚═════════════════════════════╝                          

:SEL
set select=
set /p select= 请按数字键0到3并回车---^>%=%
if /i "%select%"=="1" goto T1
if /i "%select%"=="2" goto N1
if /i "%select%"=="3" goto UPDATE
if /i "%select%"=="0" goto END
echo 输入无效或超出选择范围，请重新输入
goto SEL

:T1
echo *
echo *
echo *
echo 你选择了 T1降级
goto ADB
:T1X
echo *
echo *
echo *
echo 请注意你选择了 T1降级
echo 请注意你选择了 T1降级
echo 请注意你选择了 T1降级
echo T1 T1 T1 请大声喊三遍并核对盒子型号！
adb devices -l | findstr "q201" > nul
if %ERRORLEVEL% NEQ 0 ECHO 盒子型号检测出错！ && goto END
echo *
echo *
echo *
echo 按任意键开始T1降级... & pause > nul
adb push t1\boot.img /sdcard/boot.img
adb shell dd if=/sdcard/boot.img of=/dev/block/boot
adb shell rm -f /sdcard/boot.img
echo *
echo *
echo *
echo boot分区降级完毕，盒子重启中，此窗口可以关闭
echo 盒子进入桌面后再次运行本工具选择 3 进入线刷模式
adb reboot
goto END

:N1
echo *
echo *
echo *
echo 你选择了 N1降级
goto ADB
:N1X
echo *
echo *
echo *
echo 请注意你选择了 N1降级
echo 请注意你选择了 N1降级
echo 请注意你选择了 N1降级
echo N1 N1 N1 请大声喊三遍并核对盒子型号！
adb devices -l | findstr "p230" > nul
if %ERRORLEVEL% NEQ 0 ECHO 盒子型号检测出错！ && goto END
echo *
echo *
echo *
echo 按任意键开始N1降级... & pause > nul
adb push n1\boot.img /sdcard/boot.img
adb shell dd if=/sdcard/boot.img of=/dev/block/boot
adb shell rm -f /sdcard/boot.img
echo *
echo *
echo *
echo boot分区降级完毕，盒子重启中，此窗口可以关闭
echo 盒子进入桌面后再次运行本工具选择 3 进入线刷模式
adb reboot
goto END

:UPDATE
echo *
echo *
echo *
echo 你选择了 进入线刷模式
goto ADB
:UPDATEX
echo *
echo *
echo *
echo 请用USB双公头线连接盒子和电脑，按任意键继续... & pause > nul
echo *
echo *
echo *
echo 盒子已重启到线刷模式，此窗口可以关闭
echo 若盒子进入了recovery，说明USB双公头线有问题
adb reboot update & goto END

:ADB
cd data
set /p ip=请输入盒子的内网IP地址：
adb kill-server
if "%ip%" == "" echo 提示：请输入正确的IP地址 && goto END
echo 开始通过网络进行ADB连接……
adb connect %ip%
adb devices -l | findstr "q201 p230" >nul 
if %ERRORLEVEL% NEQ 0 echo 连接测试失败！&&goto END
adb shell setprop service.phiadb.root 1
adb shell setprop service.adb.root 1
adb kill-server
:second
echo 等待二次连接...
choice /t 3 /d y /n >nul 
adb connect %ip%
adb devices -l | findstr "q201 p230" >nul 
if %ERRORLEVEL% NEQ 0 echo 二次连接失败！再次尝试...&&goto second
adb remount
if /i "%select%"=="1" goto T1X
if /i "%select%"=="2" goto N1X
if /i "%select%"=="3" goto UPDATEX
echo 超出选择范围！按任意键继续... & pause > nul
goto MAINMENU

:END
set select=
echo 按任意键退出... & pause > nul
exit