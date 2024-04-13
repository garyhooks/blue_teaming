
Record basic information:
1) Operating System
2) Build Number
3) Installation Date
4) Shutdown Date
5) Timezone
6) List of users and GUIDs

## Step 1
Mount image in Arsenal Mounter

## Step 2
Upload Kape to analysis machine
> D:\sftp\kape\kape.exe --tsource H: --tdest D:\kape_output --tflush --target !SANS_Triage
 
## Step 3
Get all event logs into a single CSV

> C:\Tools\Get-ZimmermanTools\EvtxECmd -d D:\kape_output\Windows\System32\winevt\logs --csv D:\ --csvf eventlogs.csv

## Step 4
Hayabusa 

## Shimcache

> HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache\AppCompatCache

> AppCompatCacheParser.exe -f D:\registry\SYSTEM -t --csv D:\results\AppCompatCache\ --csvf machine_name.csv 

## AmCache 

Get Amcache Hive from \Windows\appcompat\Programs\Amcache.hve
change machine_name to label the results properly

> AmcacheParser.exe -f "D:\Amcache.hve" -i --csv D:\AmCacheResults --csvf machine_name
