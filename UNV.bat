@echo off
TITLE UNV TOOLKIT by fotix
SET LANG=EN
CHCP 936>NUL 2>NUL&&SET LANG=CN 
rem check the system language, if it is not chinese then keep it in english
IF %LANG%==CN ( 
    GOTO menu_cn
) ELSE (
    GOTO menu
)

:menu
ECHO EN

:menu_cn
ECHO    1. 一键解锁 Bootloader
ECHO    2. 进入高级模式
PAUSE>NUL
ECHO %LANG%


PAUSE

:check_EN
ECHO               PLEASE CONNECT YOUR DEVICE
ECHO.
ECHO               Checking out the system information...
adb shell "getprop ro.build.version.number"      > version.info
adb shell "getprop ro.build.version.incremental" > fireos.info
SET VERSION=<version.info
SET STR=%VERSION:~0,3%
SET OS=<fireos.info
ECHO.
PAUSE > NUL
ECHO               Your SYSTEM VERSION is: %OS%
ECHO.
PAUSE > NUL
IF %STR% LSS 324 (
    COLOR 0B
	ECHO               ??????????????????
	ECHO               ?  :-^) PERFECT, SYSTEM AVAILABLE ?
	ECHO               ??????????????????
) ELSE (
    COLOR 0C
    PAUSE
	ECHO               ??????????????????
    ECHO               ?  :-^(  SORRY, DENIED VERSION^!^!^! ?
    ECHO               ??????????????????
    ECHO                PRESS ANY KEY TO QUIT THE SCRIPT
    PAUSE > NUL
    EXIT
)
GOTO :EOF

:check_CN
ECHO               ?????????
ECHO.
ECHO               ??????????...
adb shell "getprop ro.build.version.number"      > version.info
adb shell "getprop ro.build.version.incremental" > fireos.info
SET VERSION=<version.info
SET STR=%VERSION:~0,3%
SET OS=<fireos.info
SET DEVICE=%OS:~0,2%
ECHO.
PAUSE > NUL
ECHO               ??????? : %OS%
ECHO.
PAUSE > NUL
IF %STR% LSS 324 (
    COLOR 0B
	ECHO               ??????????????????
	ECHO               ?  :-^) PERFECT, SYSTEM AVAILABLE ?
	ECHO               ??????????????????
) ELSE (
    COLOR 0C
    PAUSE
	ECHO               ??????????????????
    ECHO               ?  :-^(  SORRY, DENIED VERSION^!^!^! ?
    ECHO               ??????????????????
    ECHO                ?????????
    PAUSE > NUL
    EXIT
)
GOTO :EOF

:rollback
::a rollback script for 1x.3.2.5/6 version on 3rd gen devices
CALL:check_EN
echo *
echo *  USE IT AT YOUR OWN RESPONSIBILITY because rewrite recovery partition.
echo *  
echo *  This batch file works "kindle fire hdx 7" ONLY
echo *  This is tested on version 13.3.2.5 and 13.3.2.6.
echo *
echo *  If do not want rollback, Close this window.
echo *
echo *  IF you want to rollback,
echo *  Put "update-kindle-13.3.1.0_user_310079820.bin" in SAME folder,
echo *  Push Enter key 5 times
echo *
echo *  If it is requested from super su, please allow superuser. 
echo *
PAUSE
@echo on
set FIRMWARE1=update-kindle-%DEVICE%.3.1.0_user_310079820.bin
7z.exe e %FIRMWARE1% "boot.img" "recovery/recovery-from-boot.p" "system/etc/recovery-resource.dat" "system/etc/security/otacerts.zip"&&echo succeed
:: To save space for the script, you need to extract the files from stock firmware by yourself. 
adb shell mkdir /sdcard/recovery
adb push build.prop /sdcard/recovery/build.prop
adb push otacerts.zip /sdcard/recovery/otacerts.zip
adb push boot.img /sdcard/recovery/boot.img
adb push recovery-from-boot.p /sdcard/recovery/recovery-from-boot.p
adb push recovery-resource.dat /sdcard/recovery/recovery-resource.dat
adb push install.sh /sdcard/recovery/install.sh
adb shell sh -v /sdcard/recovery/install.sh
@echo off

:unlockfile
ECHO.
echo                 请确认设备已经连接 PC，并安装 ADB，FASTBOOT 驱动
echo.
echo                            ↓↓↓ 按任意键开始 ↓↓↓
pause>nul
echo      ---------------------------------------------------------------------
echo      1. 正在获取 manfID 和 serial 信息...
adb shell "cat /sys/block/mmcblk0/device/manfid" > manfid.txt
adb shell "cat /sys/block/mmcblk0/device/serial" > serial.txt
set /p manfid=< manfid.txt
set /p serial=< serial.txt
set unlock=0x%manfid:~6,2%%serial:~2,8%
echo            设备 manfid 为：%manfid%
ECHO            设备 manfid 为：%serial%
cublock.exe %manfid% %serial%
pause

