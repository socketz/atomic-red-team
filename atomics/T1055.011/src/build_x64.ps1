# Change directory to $PSScriptRoot
cd $PSScriptRoot

& 'C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\Tools\Launch-VsDevShell.ps1' -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -InformationAction SilentlyContinue -OutVariable out | Out-Null

# compiling xbin
echo "Compiling xbin.exe"
cl -nologo -Os $PSScriptRoot\xbin.cpp


Move-Item -Path $PSScriptRoot\xbin.exe -Destination $PSScriptRoot\..\bin\xbin.exe -Confirm:$false -Force

# x64 version
cl -DWINDOW -D_WIN64 -c -nologo -Os -O2 -Gm- -GR- -EHa -Oi -GS- -w $PSScriptRoot\payload.c
link /order:@$PSScriptRoot\extrabytes_x64.txt /entry:WndProc /fixed $PSScriptRoot\payload.obj -nologo -subsystem:console -nodefaultlib -stack:0x100000,0x100000
$"$PSScriptRoot\..\bin\xbin.exe" $PSScriptRoot\payload.exe .text

echo "Compiling T1055.011_x64.exe"
cl -DWINDOW -D_WIN64 -D_MSC_VER -nologo -Os -O2 -Gm- -GR- -EHa -Oi -GS- -w $PSScriptRoot\ewm.c

Rename-Item -Path $PSScriptRoot\ewm.exe -NewName $PSScriptRoot\T1055.011_x64.exe -Confirm:$false -Force
Move-Item -Path $PSScriptRoot\T1055.011_x64.exe -Destination $PSScriptRoot\..\bin\T1055.011_x64.exe -Confirm:$false -Force
Move-Item -Path $PSScriptRoot\payload.exe64.bin -Destination $PSScriptRoot\..\bin\payload.exe_x64.bin -Confirm:$false -Force

echo "Cleaning files"
Remove-Item -Path $PSScriptRoot\*.obj
Remove-Item -Path $PSScriptRoot\*.exe