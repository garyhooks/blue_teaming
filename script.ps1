Write-Host "


 ██▓ ██▀███      █     █░ ██▓▒███████▒ ▄▄▄       ██▀███  ▓█████▄ 
▓██▒▓██ ▒ ██▒   ▓█░ █ ░█░▓██▒▒ ▒ ▒ ▄▀░▒████▄    ▓██ ▒ ██▒▒██▀ ██▌
▒██▒▓██ ░▄█ ▒   ▒█░ █ ░█ ▒██▒░ ▒ ▄▀▒░ ▒██  ▀█▄  ▓██ ░▄█ ▒░██   █▌
░██░▒██▀▀█▄     ░█░ █ ░█ ░██░  ▄▀▒   ░░██▄▄▄▄██ ▒██▀▀█▄  ░▓█▄   ▌
░██░░██▓ ▒██▒   ░░██▒██▓ ░██░▒███████▒ ▓█   ▓██▒░██▓ ▒██▒░▒████▓ 
░▓  ░ ▒▓ ░▒▓░   ░ ▓░▒ ▒  ░▓  ░▒▒ ▓░▒░▒ ▒▒   ▓▒█░░ ▒▓ ░▒▓░ ▒▒▓  ▒ 
 ▒ ░  ░▒ ░ ▒░     ▒ ░ ░   ▒ ░░░▒ ▒ ░ ▒  ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ▒  ▒ 
 ▒ ░  ░░   ░      ░   ░   ▒ ░░ ░ ░ ░ ░  ░   ▒     ░░   ░  ░ ░  ░ 
 ░     ░            ░     ░    ░ ░          ░  ░   ░        ░    
                             ░                            ░      


Author: Gary Hooks
Date: 15 April 2024
GitHub: https://github.com/garyhooks

***********************************************************************"

<# VARIABLE SET UP #>
$evidence_source = Read-Host -Prompt "Enter the drive letter where the evidence is hosted (e.g. H/M/R): [Default: H]"
if ([string]::IsNullOrWhiteSpace($Interesting)) {
    $evidence_source = "H"
}
$output_directory= "D:\TESTINGSCRIPT"
$mytools = "D:\@gary_tools"

<#
# KAPE
Write-Host "[*] Running Kape..."
Write-Host "$mytools\kape\kape.exe --tsource ${evidence_source}: --tdest $output_directory $output_directory\ --tflush --target !SANS_Triage --vss"
Invoke-Expression -Command "$mytools\kape\kape.exe --tsource ${evidence_source}: --tdest $output_directory --tflush --target !SANS_Triage --vss"

# EvtxECmd: Put all event logs into single CSV
Write-Host `n"[*] Creating a single CSV file... "
Invoke-Expression -Command "$mytools\EvtxECmd\EvtxECmd.exe -d $output_directory\eventlogs\ --csv $output_directory\ --csvf all_eventlogs.csv"

# Hayabusa
Write-Host `n"[*] Running Hayabusa..."
Invoke-Expression -Command "$mytools\hayabusa-2.14.0-win-x64\hayabusa-2.14.0-win-x64.exe $hayabusa_directory update-rules"
Invoke-Expression -Command "$mytools\hayabusa-2.14.0-win-x64\hayabusa-2.14.0-win-x64.exe csv-timeline --directory $output_directory\${evidence_source}\Windows\System32\winevt\logs --output $output_directory\hayabusatimeline.csv --exclude-status deprecated,unsupported --min-level medium --no-wizard"

# Chainsaw
Write-Host `n"[*] Running Chainsaw now..."
Invoke-Expression -Command "$mytools\chainsaw\chainsaw_x86_64-pc-windows-msvc.exe hunt $output_directory\${evidence_source}\Windows\System32\winevt\logs -s $mytools\chainsaw\sigma\ --mapping $mytools\chainsaw\mappings\sigma-event-logs-all.yml -r $mytools\chainsaw\rules --csv --output $output_directory\chainsaw --skip-errors"

# Shimcache/AppComatCache
Write-Host `n"[*] Parsing Shimcache now..."
Invoke-Expression -Command "$mytools\AppCompatCacheParser.exe -f $output_directory\${evidence_source}\Windows\System32\config\SYSTEM -t --csv $output_directory\AppCompatCache\ --csvf shimcache.csv"

# Shimcache/Amcache
Write-Host `n"[*] Parsing Amcache now..."
Invoke-Expression -Command "$mytools\AmcacheParser.exe -f $output_directory\${evidence_source}\Windows\appcompat\Programs\Amcache.hve -i --csv $output_directory\AmCacheResults\ --csvf amcache.csv"
#>

# Events Ripper: https://github.com/keydet89/Events-Ripper
Write-Host `n"[*] Running Events Ripper now..."
cd "$mytools\Events-Ripper\"
#Invoke-Expression -Command "$mytools\Events-Ripper\wevtx.bat $output_directory\${evidence_source}\Windows\System32\winevt\logs\*.evtx $output_directory\all_eventlogs.txt"
Invoke-Expression -Command "$mytools\Events-Ripper\erip.exe -f $output_directory\all_eventlogs.txt -a" > event_ripper_results.csv

# CSV formatting and changing
 

#https://github.com/secure-cake/rapid-endpoint-investigations/blob/main/KAPE_Rapid_Triage_Excel_Output_Rev3.ps1


# SPlunk
#splunk.exe install app D:\downloads\have-i-been-pwned-domain-search_111.tgz
