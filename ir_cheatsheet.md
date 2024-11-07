# IR Script

################################
1) Mount the evidence source so you have a drive letter 

```
 C:\Tools\Arsenal-Image-Mounter-v3.9.223\aim_cli /mount /fakesig /filename=D:\sftp\uploads\image.E01 /provider=libewf /writeoverlay=D:\sftp\uploads\image.E01.diff /autodelete
```

2) Update the commands below using find+replace
<WINDOWSLOGS> = F:\Windows\System32\winevt\Logs
<EVIDENCE_DIRECTORY> = D:\sftp\TEST\

##### Script Below
```
 D:\sftp\kape\kape.exe --tsource F: --tdest <EVIDENCE_DIRECTORY>\kape_output --tflush --target !SANS_Triage --vss
 C:\Tools\Get-ZimmermanTools\EvtxECmd\EvtxECmd.exe -d <WINDOWSLOGS> --csv <EVIDENCE_DIRECTORY> --csvf eventlogs.csv
 C:\Tools\Get-ZimmermanTools\EvtxECmd\EvtxECmd.exe -d <EVIDENCE_DIRECTORY>\kape_output\F\Windows\System32\winevt\logs\ --csv <EVIDENCE_DIRECTORY> --csvf "eventlogs--date_restricted.csv" --sd 2024-10-01T00:00:00 --ed 2024-10-20T23:59:59
 C:\Tools\hayabusa-2.18.0\hayabusa-2.18.0-win-x64.exe csv-timeline --directory <EVIDENCE_DIRECTORY>\kape_output\F\Windows\System32\winevt\logs\ --output "<EVIDENCE_DIRECTORY>\hayabusa.csv" --exclude-status deprecated,unsupported --min-level medium --no-wizard
 C:\Tools\hayabusa-2.18.0\hayabusa-2.18.0-win-x64.exe logon-summary --directory <EVIDENCE_DIRECTORY>\kape_output\F\Windows\System32\winevt\logs\ --output "<EVIDENCE_DIRECTORY>\hayabusa-logon-summary.csv" --UTC
 C:\Tools\Get-ZimmermanTools\AppCompatCacheParser.exe -f <EVIDENCE_DIRECTORY>\kape_output\F\Windows\System32\config\SYSTEM -t --csv <EVIDENCE_DIRECTORY>\ --AppCompatCache.csv
 C:\Tools\Get-ZimmermanTools\AmcacheParser.exe -f <EVIDENCE_DIRECTORY>\kape_output\F\Windows\appcompat\Programs\Amcache.hve --csv <EVIDENCE_DIRECTORY>\ --csvf amcache_outputs.csv
 C:\Tools\Get-ZimmermanTools\PECmd.exe -d <EVIDENCE_DIRECTORY>\kape_output\F\Windows\Prefetch --csv <EVIDENCE_DIRECTORY>\prefetch.csv
 
 C:\Users\spider\Downloads\chainsaw\chainsaw_x86_64-pc-windows-msvc.exe hunt <EVIDENCE_DIRECTORY>Security.evtx -s C:\Users\spider\Downloads\chainsaw\sigma\ --mapping C:\Users\spider\Downloads\chainsaw\mappings\sigma-event-logs-all.yml -r C:\Users\spider\Downloads\chainsaw\rules\ --csv --output <EVIDENCE_DIRECTORY>\chainsaw_results
```

Record basic information:
1) Operating System
2) Build Number
3) Installation Date
4) Shutdown Date
5) Timezone
6) List of users and GUIDs

## Preparatory Steps
Clear screenshots folder
Create new project task and sync OneNote
Set objectives and define the plan including what tools to run, what artefacts to focus on and what we're trying to establish




## Step 1
Mount image in Arsenal Mounter

> aim_cli /mount /fakesig /filename=D:\myfile.E01 /provider=libewf /writeoverlay=D:\myfile.E01.diff /autodelete

## Step 2
Upload Kape to analysis machine
> D:\sftp\kape\kape.exe --tsource H: --tdest D:\kape_output --tflush --target !SANS_Triage --vss
 
## Step 3
Get all event logs into a single CSV
C:\Tools\Get-ZimmermanTools\EvtxECmd\EvtxECmd.exe -d D:\kape_output\Windows\System32\winevt\logs --csv D:\ --csvf eventlogs.csv

## Step 4
Extract event logs restricted by date:

> C:\Tools\Get-ZimmermanTools\EvtxECmd\EvtxECmd.exe -d "D:\\sftp\\spider\\Logs\\" --csv "D:\\sftp\\event_logs_date_restricted\\" --csvf "NAME_OF_CSV.csv" --sd 2024-06-20T00:00:00 --ed 2024-07-08T23:59:59

Event Ripper

## Step 4
Hayabusa 

> C:\Tools\hayabusa-2.16.0-all-platforms\hayabusa-2.16.0-win-x64.exe csv-timeline --directory "D:\\sftp\\spider\\Logs\\" --output "D:\\sftp\\event_logs\\hayabusa\\hayabusa.csv" --exclude-status deprecated,unsupported --min-level medium --no-wizard

Can also create logon summary:

> C:\Tools\hayabusa-2.16.0-all-platforms\hayabusa-2.16.0-win-x64.exe logon-summary --directory "D:\\sftp\\spider\\Logs\\" --output "D:\\sftp\\event_logs\\hayabusa\\logon_summary.csv" --UTC

## Step 5
Process in X-Ways

## Step 6
Process in Axiom

## Step 7
Index in Splunk

## Prefetch file processing:

> C:\Tools\Get-ZimmermanTools\PECmd.exe -d "D:\sftp\spider\Prefetch" --csv "D:\sftp\outputs\prefetch.csv"

## Shimcache

> HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache\AppCompatCache

> AppCompatCacheParser.exe -f D:\registry\SYSTEM -t --csv D:\results\AppCompatCache\ --csvf machine_name.csv

C:\Tools\Get-ZimmermanTools\AppCompatCacheParser -f "C\Windows\System32\config\SYSTEM" --csv "D:\sftp\outputs" --csvf "shimcache.csv"

## Recycle Bin processing

> C:\Tools\Get-ZimmermanTools\RBCmd.exe -d "C\$Recycle.Bin" --csv D:\sftp\outputs\ --csvf recycle_bin.txt

## AmCache 

Get Amcache Hive from \Windows\appcompat\Programs\Amcache.hve
change machine_name to label the results properly

> C:\Tools\Get-ZimmermanTools\AmcacheParser.exe -f "C\Windows\appcompat\Programs\Amcache.hve" --csv "D:\sftp\amcache_outputs" --csvf "amcache.csv"

# Volume Shadow Copy

--dl: Source Drive (Where have you mounted the image)
--mp: Base directory of where you want to mount the VSS to
--ud: Use VSC creation timestamps 

> VSCMount.exe --dl E: --mp C:\VssRoot --ud

# Memory:

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
