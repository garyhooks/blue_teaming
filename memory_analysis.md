Get volatility: http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_win64_standalone.zip 

### imageinfo:

This can take several hours depending on the size of the image

> volatility_2.6_win64_standalone.exe imageinfo -f PhysicalMemory

### Check Operating Systme Version: 

Open Software registry file in Registry Explorer (C\Windows\System32\config\SOFTWARE)
HKLM\Software\Microsoft\Windows NT\CurrentVersion\ProductNamne


### pslist

> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 pslist

--profile=
pslist 

...

malfind

...

