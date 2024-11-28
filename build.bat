nasm -f Win64 main.asm -o main.obj
link main.obj /entry:mainCRTStartup /subsystem:console /DEBUG kernel32.lib msvcrt.lib
