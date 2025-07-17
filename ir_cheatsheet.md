# IR Script

################################
1) Mount the evidence source so you have a drive letter 

```
 C:\Tools\Arsenal-Image-Mounter-v3.9.223\aim_cli /mount /fakesig /filename=D:\sftp\uploads\image.E01 /provider=libewf /writeoverlay=D:\sftp\uploads\image.E01.diff /autodelete
```

2) Update the commands below using find+replace   
     
* Evidence Directory <EVIDENCE_DIRECTORY> = D:\sftp\TEST\
* Windows Log Directory <WINDOWSLOGS> = F:\Windows\System32\winevt\Logs    
* Drive Letter <DRIVE_LETTER> = Replace this with the drive letter of where it is mounted in arsenal

**KAPE**
If you want to obtain a Kape output do this:

> D:\sftp\kape\kape.exe --tsource F: --tdest <EVIDENCE_DIRECTORY>\kape_output --tflush --target !SANS_Triage --vss

This also obtains the Volume Shadow copy (--vss)

##### Script Below
```bat
@echo off
:: ==============================
:: Batch Script Configuration
:: ==============================
:: Replace the placeholders with actual values where applicable.
:: Ensure that each variable is correctly formatted.

:: ------------------------------
:: VARIABLE DECLARATIONS
:: ------------------------------
:: EVIDENCE_DIRECTORY - Path to the source directory (e.g., KAPE output).
:: DRIVE_LETTER - The drive letter where evidence (e.g., event logs, registry) is stored.
:: OUTPUTS - Location of results and CSV files.

set EVIDENCE_DIRECTORY=D:\laptop123\
set DRIVE_LETTER=C
set OUTPUTS=%EVIDENCE_DIRECTORY%\OUTPUTS
set LOG_DIRECTORY=%EVIDENCE_DIRECTORY%\OUTPUTS\LOGS\
set MAIN_LOGFILE=%LOG_DIRECTORY%\log.txt

if not exist %OUTPUTS% mkdir %OUTPUTS%
if not exist %LOG_DIRECTORY% mkdir %LOG_DIRECTORY%

:: ==============================
:: END OF CONFIGURATION
:: ==============================

@echo off

echo Script started at %DATE% %TIME% (mm/dd/yyyy hh:mm:ss.ss)
echo Script started at %DATE% %TIME% (mm/dd/yyyy hh:mm:ss.ss) >> %MAIN_LOGFILE%
echo ===========================================================
echo LOG_DIRECTORY = %LOG_DIRECTORY%
echo LOG_DIRECTORY = %LOG_DIRECTORY% >> %LOG_DIRECTORY%\%MAIN_LOGFILE%
echo EVIDENCE_DIRECTORY = %EVIDENCE_DIRECTORY%
echo EVIDENCE_DIRECTORY = %EVIDENCE_DIRECTORY% >> %MAIN_LOGFILE%
echo DRIVE_LETTER = %DRIVE_LETTER%
echo DRIVE_LETTER = %DRIVE_LETTER% >> %MAIN_LOGFILE%
echo OUTPUTS = %EVIDENCE_DIRECTORY%\OUTPUTS\
echo OUTPUTS = %OUTPUTS% >> %MAIN_LOGFILE%
echo ===========================================================
echo. 
echo. >> %MAIN_LOGFILE%

:: Here is a date restricted option - commented out for now 
:: C:\Tools\Get-ZimmermanTools\EvtxECmd\EvtxECmd.exe -d %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\ --csv %OUTPUTS% --csvf "eventlogs--date_restricted.csv" --sd 2024-10-01T00:00:00 --ed 2024-10-20T23:59:59


echo [*] Outputting Windows Event Logs from %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\ to %OUTPUTS%\eventlogs.csv now ...
echo [*] Outputting Windows Event Logs from %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\ to %OUTPUTS%\eventlogs.csv now ... >> %MAIN_LOGFILE%
C:\Tools\Get-ZimmermanTools\EvtxECmd\EvtxECmd.exe -d %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\ --csv %OUTPUTS% --csvf eventlogs.csv >> %LOG_DIRECTORY%\evtxecmd.log 2>&1

echo [*] Running Hayabusa csv-timeline on event log CSV file - located at %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\. Outputs saved to %OUTPUTS%\hayabusa.csv
echo [*] Running Hayabusa csv-timeline on event log CSV file - located at %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\. Outputs saved to %OUTPUTS%\hayabusa.csv >> %MAIN_LOGFILE%
C:\Tools\hayabusa-2.18.0-all-platforms\hayabusa-2.18.0-win-x64.exe csv-timeline --directory %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\ --output "%OUTPUTS%\hayabusa.csv" --exclude-status deprecated,unsupported --min-level medium --no-wizard >> %LOG_DIRECTORY%\hayabusa.log 2>&1

echo [*] Running Hayabusa logon-summary on event log CSV file - located at %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\. Outputs saved to %OUTPUTS%\hayabusa.csv
echo [*] Running Hayabusa logon-summary on event log CSV file - located at %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\. Outputs saved to %OUTPUTS%\hayabusa.csv >> %MAIN_LOGFILE%
C:\Tools\hayabusa-2.18.0-all-platforms\hayabusa-2.18.0-win-x64.exe logon-summary --directory %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\ --output "%OUTPUTS%\hayabusa-logon-summary.csv" --UTC >> %LOG_DIRECTORY%\hayabusa.log 2>&1

echo [*] Running AppCompatCacheParser.exe on event logs inside %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\. Outputs saved to %OUTPUTS%\AppCompatCache.csv
echo [*] Running AppCompatCacheParser.exe on event logs inside %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\winevt\logs\. Outputs saved to %OUTPUTS%\AppCompatCache.csv >> %MAIN_LOGFILE%
C:\Tools\Get-ZimmermanTools\AppCompatCacheParser.exe -f %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\config\SYSTEM -t --csv %OUTPUTS%\ --csvf AppCompatCache.csv >> %LOG_DIRECTORY%\AppCompatCache.log 2>&1

echo [*] Running AmcacheParser.exe on Amcache Hive inside %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\appcompat\Programs\Amcache.hve. Outputs saved to %OUTPUTS%\amcache_outputs.csv
echo [*] Running AmcacheParser.exe on Amcache Hive inside %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\appcompat\Programs\Amcache.hve. Outputs saved to %OUTPUTS%\amcache_outputs.csv >> %MAIN_LOGFILE%
C:\Tools\Get-ZimmermanTools\AmcacheParser.exe -f %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\appcompat\Programs\Amcache.hve --csv %OUTPUTS%\ --csvf amcache_outputs.csv >> %LOG_DIRECTORY%\AmcacheParser.log 2>&1

echo [*] Obtaining Prefetch files using PECmd.exe on %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\Prefetch. Outputs saved to %OUTPUTS%\prefetch\
echo [*] Obtaining Prefetch files using PECmd.exe on %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\Prefetch. Outputs saved to %OUTPUTS%\prefetch\ >> %MAIN_LOGFILE%
C:\Tools\Get-ZimmermanTools\PECmd.exe -d %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\Prefetch --csv %OUTPUTS%\prefetch >> %LOG_DIRECTORY%\PECmd.log 2>&1

echo [*] Obtaining Scrum (System Resource Utilization Monitor) on SRUDB.dat inside %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\SRU\SRUDB.dat and hive %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\config\SOFTWARE. Outputs saved to %OUTPUTS%\srudb\
echo [*] Obtaining Scrum (System Resource Utilization Monitor) on SRUDB.dat inside %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\SRU\SRUDB.dat and hive %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\config\SOFTWARE. Outputs saved to %OUTPUTS%\srudb\ >> %MAIN_LOGFILE%
C:\Tools\Get-ZimmermanTools\SrumECmd.exe -f %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\SRU\SRUDB.dat -r %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Windows\System32\config\SOFTWARE --csv %OUTPUTS%\srudb\ >> %LOG_DIRECTORY%\ScrumECmd.log 2>&1

echo [*] Obtaining LNK files from %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Users\. Outputs saved to %OUTPUTS%\RecentLNKfiles.csv
echo [*] Obtaining LNK files from %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Users\. Outputs saved to %OUTPUTS%\RecentLNKfiles.csv >> %MAIN_LOGFILE%
C:\Tools\Get-ZimmermanTools\LECmd.exe -d %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\Users\ --csv %OUTPUTS% --csvf RecentLNKfiles.csv >> %LOG_DIRECTORY%\LECmd.log 2>&1

echo [*] Creating CSV of the MFT in %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\$MFT. Output saved to %OUTPUTS%\mft.csv
echo [*] Creating CSV of the MFT in %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\$MFT. Output saved to %OUTPUTS%\mft.csv >> %MAIN_LOGFILE%
C:\Tools\Get-ZimmermanTools\MFTECmd.exe -f %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\$MFT --csv %OUTPUTS%\ --csvf mft.csv >> %LOG_DIRECTORY%\MFTEcmd.log 2>&1

echo [*] Obtaining contents of $Recycle.Bin from %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\$Recycle.Bin\. Output saved to %OUTPUTS%\recycle_bin.csv
echo [*] Obtaining contents of $Recycle.Bin from %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\$Recycle.Bin\. Output saved to %OUTPUTS%\recycle_bin.csv >> %MAIN_LOGFILE%
C:\Tools\Get-ZimmermanTools\RBCmd.exe -d %EVIDENCE_DIRECTORY%\%DRIVE_LETTER%\$Recycle.Bin\ --csv %OUTPUTS%\ --csvf %OUTPUTS%\recycle_bin.csv >> %LOG_DIRECTORY%\RBCmd.log 2>&1

echo.
echo ================================================================================
echo.
echo Process Finished at %DATE% %TIME% (mm/dd/yyyy hh:mm:ss.ss)
echo Process Finished at %DATE% %TIME% (mm/dd/yyyy hh:mm:ss.ss) >> %MAIN_LOGFILE%

```

Record basic information:
1) Operating System
2) Build Number
3) Installation Date
4) Shutdown Date
5) Timezone
6) List of users and GUIDs
-- SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList

## Preparatory Steps
Clear screenshots folder   
Create new project task and sync OneNote   
Set objectives and define the plan including what tools to run, what artefacts to focus on and what we're trying to establish    
Set up Local drive for Client and Project ready for any local copies   
Create timeline for key findings with IOCs tab including source/host it relates to  
Open Report, ensuring it is prepared and ready to go
Add macros to Word and Excel for date formats/table formatting    
Plan client update, including status of investigation with hosts examined and key findings   
Update OneNote   

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

> wget https://github.com/keydet89/Events-Ripper/archive/refs/heads/main.zip

> wevtx.bat D:\sftp\spider\EVIDENCE\E\Windows\System32\winevt\logs\*.evtx C:\events.txt

List plugins

> erip -l

Use plugin - like logins, failedlogins, systemnames etc...
> erip -f c:\events.txt -p <plugin> 


## Step 4
Hayabusa 

> C:\Tools\hayabusa-2.18.0-all-platforms\hayabusa-2.18.0-win-x64.exe csv-timeline --directory "D:\\sftp\\spider\\Logs\\" --output "D:\\sftp\\event_logs\\hayabusa\\hayabusa.csv" --exclude-status deprecated,unsupported --min-level medium --no-wizard

Can also create logon summary:

> C:\Tools\hayabusa-2.18.0-all-platforms\hayabusa-2.18.0-win-x64.exe logon-summary --directory "D:\\sftp\\spider\\Logs\\" --output "D:\\sftp\\event_logs\\hayabusa\\logon_summary.csv" --UTC

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
