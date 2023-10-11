

https://attack.mitre.org/software/S0154/

## rundll32

Any process can be used and this can be set within the config file, using *set spawnto_x86*  

## Memory Detection

Review processes and child/parent processes  
Particularly with something like rundll32.exe being spawned by PowerShell.exe or other executables  
Sometimes WMI may be spawned by PowerShell and then rundll32.exe  

> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 pstree
