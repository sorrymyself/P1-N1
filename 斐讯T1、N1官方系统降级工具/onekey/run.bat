@echo off
title �ѶT1��N1�ٷ�ϵͳ��������

:MAINMENU
cls
color F2
echo          �X�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�[
echo          �U                �ѶT1��N1�ٷ�ϵͳ��������                �U
echo          �U                   2018-9-29  by webpad                   �U
echo          �U                                                          �U
echo          �U ���������������粢�������IP��ַ,T1�������п���Զ�̵���, �U
echo          �U        N1��������ʹ��������Ĵι̼��汾�Ŵ�adb       �U
echo          �U                                                          �U
echo          �U   �����߽�����boot����������������ϵͳ���汾�Ų���ı�,  �U
echo          �U            ���ѿ�ʹ���ն�reboot���������ˢģʽ          �U
echo          �U                                                          �U
echo          �U  �밴��ѡ�����:                                         �U
echo          �U                 [1]--- T1����                            �U
echo          �U                                                          �U
echo          �U                 [2]--- N1����                            �U
echo          �U                                                          �U
echo          �U                 [3]--- ���ӽ�����ˢģʽ                  �U
echo          �U                                                          �U
echo          �U                 [0]--- �˳�                              �U
echo          �^�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�T�a                          

:SEL
set select=
set /p select= �밴���ּ�0��3���س�---^>%=%
if /i "%select%"=="1" goto T1
if /i "%select%"=="2" goto N1
if /i "%select%"=="3" goto UPDATE
if /i "%select%"=="0" goto END
echo ������Ч�򳬳�ѡ��Χ������������
goto SEL

:T1
echo *
echo *
echo *
echo ��ѡ���� T1����
goto ADB
:T1X
echo *
echo *
echo *
echo ��ע����ѡ���� T1����
echo ��ע����ѡ���� T1����
echo ��ע����ѡ���� T1����
echo T1 T1 T1 ����������鲢�˶Ժ����ͺţ�
adb devices -l | findstr "q201" > nul
if %ERRORLEVEL% NEQ 0 ECHO �����ͺż����� && goto END
echo *
echo *
echo *
echo ���������ʼT1����... & pause > nul
adb push t1\boot.img /sdcard/boot.img
adb shell dd if=/sdcard/boot.img of=/dev/block/boot
adb shell rm -f /sdcard/boot.img
echo *
echo *
echo *
echo boot����������ϣ����������У��˴��ڿ��Թر�
echo ���ӽ���������ٴ����б�����ѡ�� 3 ������ˢģʽ
adb reboot
goto END

:N1
echo *
echo *
echo *
echo ��ѡ���� N1����
goto ADB
:N1X
echo *
echo *
echo *
echo ��ע����ѡ���� N1����
echo ��ע����ѡ���� N1����
echo ��ע����ѡ���� N1����
echo N1 N1 N1 ����������鲢�˶Ժ����ͺţ�
adb devices -l | findstr "p230" > nul
if %ERRORLEVEL% NEQ 0 ECHO �����ͺż����� && goto END
echo *
echo *
echo *
echo ���������ʼN1����... & pause > nul
adb push n1\boot.img /sdcard/boot.img
adb shell dd if=/sdcard/boot.img of=/dev/block/boot
adb shell rm -f /sdcard/boot.img
echo *
echo *
echo *
echo boot����������ϣ����������У��˴��ڿ��Թر�
echo ���ӽ���������ٴ����б�����ѡ�� 3 ������ˢģʽ
adb reboot
goto END

:UPDATE
echo *
echo *
echo *
echo ��ѡ���� ������ˢģʽ
goto ADB
:UPDATEX
echo *
echo *
echo *
echo ����USB˫��ͷ�����Ӻ��Ӻ͵��ԣ������������... & pause > nul
echo *
echo *
echo *
echo ��������������ˢģʽ���˴��ڿ��Թر�
echo �����ӽ�����recovery��˵��USB˫��ͷ��������
adb reboot update & goto END

:ADB
cd data
set /p ip=��������ӵ�����IP��ַ��
adb kill-server
if "%ip%" == "" echo ��ʾ����������ȷ��IP��ַ && goto END
echo ��ʼͨ���������ADB���ӡ���
adb connect %ip%
adb devices -l | findstr "q201 p230" >nul 
if %ERRORLEVEL% NEQ 0 echo ���Ӳ���ʧ�ܣ�&&goto END
adb shell setprop service.phiadb.root 1
adb shell setprop service.adb.root 1
adb kill-server
:second
echo �ȴ���������...
choice /t 3 /d y /n >nul 
adb connect %ip%
adb devices -l | findstr "q201 p230" >nul 
if %ERRORLEVEL% NEQ 0 echo ��������ʧ�ܣ��ٴγ���...&&goto second
adb remount
if /i "%select%"=="1" goto T1X
if /i "%select%"=="2" goto N1X
if /i "%select%"=="3" goto UPDATEX
echo ����ѡ��Χ�������������... & pause > nul
goto MAINMENU

:END
set select=
echo ��������˳�... & pause > nul
exit