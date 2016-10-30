@echo off

REM This script assumes that 'nasm' is in your path

echo | set /p x=Building nefs_mbr...
call nasm src\bootsectors\nefs_mbr.asm -o nefs_mbr.sys && (echo Success) || (echo Error!)

echo | set /p x=Building pxestart...
call nasm src\bootsectors\pxestart.asm -o pxestart.sys && (echo Success) || (echo Error!)

cd src
echo | set /p x=Building boot...
call nasm boot.asm -o ..\boot.sys && (echo Success) || (echo Error!)
cd ..
pause
