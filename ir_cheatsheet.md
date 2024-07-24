
Record basic information:
1) Operating System
2) Build Number
3) Installation Date
4) Shutdown Date
5) Timezone
6) List of users and GUIDs

Clear screenshots folder

## Step 1
Mount image in Arsenal Mounter

> aim_cli /mount /fakesig /filename=D:\myfile.E01 /provider=libewf /writeoverlay=D:\myfile.E01.diff /autodelete

## Step 2
Upload Kape to analysis machine
> D:\sftp\kape\kape.exe --tsource H: --tdest D:\kape_output --tflush --target !SANS_Triage --vss
 
## Step 3
Get all event logs into a single CSV
> C:\Tools\Get-ZimmermanTools\EvtxECmd -d D:\kape_output\Windows\System32\winevt\logs --csv D:\ --csvf eventlogs.csv

Event Ripper

## Step 4
Hayabusa 

## Step 5
Process in X-Ways

## Step 6
Process in Axiom

## Step 7
Index in Splunk



## Shimcache

> HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache\AppCompatCache

> AppCompatCacheParser.exe -f D:\registry\SYSTEM -t --csv D:\results\AppCompatCache\ --csvf machine_name.csv 

## AmCache 

Get Amcache Hive from \Windows\appcompat\Programs\Amcache.hve
change machine_name to label the results properly

> AmcacheParser.exe -f "D:\Amcache.hve" -i --csv D:\AmCacheResults --csvf machine_name


# Volume Shadow Copy

--dl: Source Drive (Where have you mounted the image)
--mp: Base directory of where you want to mount the VSS to
--ud: Use VSC creation timestamps 

> VSCMount.exe --dl E: --mp C:\VssRoot --ud
