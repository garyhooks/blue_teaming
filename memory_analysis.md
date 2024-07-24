Good cheatsheet: https://blog.onfvp.com/post/volatility-cheatsheet/

# Volatility 3

```
C:\python37\python.exe C:\Tools\volatility3-develop\vol.py -f "D:\sftp\physical_memory\physical_memory" windows.info.Info > "D:\sftp\physical_memory\windows.Info.txt"
C:\python37\python.exe C:\Tools\volatility3-develop\vol.py -f "D:\sftp\physical_memory\physical_memory" -r pretty windows.getsids > "D:\sftp\physical_memory\getsids.txt"
C:\python37\python.exe C:\Tools\volatility3-develop\vol.py -f "D:\sftp\physical_memory\physical_memory" -r pretty windows.netscan.NetScan > "D:\sftp\physical_memory\netscan.txt"
C:\python37\python.exe C:\Tools\volatility3-develop\vol.py -f "D:\sftp\physical_memory\physical_memory" -r pretty windows.netstat.NetStat > "D:\sftp\physical_memory\netstat.txt"
C:\python37\python.exe C:\Tools\volatility3-develop\vol.py -f "D:\sftp\physical_memory\physical_memory" -r pretty windows.mutantscan.MutantScan > "D:\sftp\physical_memory\mutantscan.txt"
C:\python37\python.exe C:\Tools\volatility3-develop\vol.py -f "D:\sftp\physical_memory\physical_memory" -r pretty windows.malfind.Malfind > "D:\sftp\physical_memory\malfind.txt"
C:\python37\python.exe C:\Tools\volatility3-develop\vol.py -f "D:\sftp\physical_memory\physical_memory" windows.cmdline > "D:\sftp\physical_memory\windows.cmdline.txt"
C:\python37\python.exe C:\Tools\volatility3-develop\vol.py -f "D:\sftp\physical_memory\physical_memory" -r pretty windows.pstree.PsTree > "D:\sftp\physical_memory\PsTree.txt"
```

# Volatility 2

### imageinfo:

This can take several hours depending on the size of the image

> volatility_2.6_win64_standalone.exe imageinfo -f PhysicalMemory

### Check Operating System Version: 

Open Software registry file in Registry Explorer (C\Windows\System32\config\SOFTWARE)
HKLM\Software\Microsoft\Windows NT\CurrentVersion\ProductNamne


### pslist

> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 pslist

### pstree

> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 pstree


### malfind

> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 malfind

Output relevant files into their own directory:

> md malfind_output
> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 malfind -D malfind_output\

#### malfind with Yara Rules

> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 yarascan -y "\yara\*"

### netscan

> vol.py -f C:\Win10x64_xyz.img --profile=Win10x64_xyz netscan >> C:\out.txt

This can be quite a messy output, so you can format it using findstr

> vol.py -f C:\Win10x64_xyz.img --profile=Win10x64_xyz netscan | findstr /i example.exe >> C:\out.txt

psxview

connscan

