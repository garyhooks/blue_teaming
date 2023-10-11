## Resources:
https://www.youtube.com/watch?v=borfuQGrB8g
https://attack.mitre.org/software/S0154/

## rundll32

Any process can be used and this can be set within the config file, using *set spawnto_x86*  

## Memory Detection

Review processes and child/parent processes  
Particularly with something like rundll32.exe being spawned by PowerShell.exe or other executables  
Sometimes WMI may be spawned by PowerShell and then rundll32.exe  

> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 pstree

View DLLs being used by rundll process 
Using this command will output the command line which should load DLLs 
> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 dlllist -p 1234

Search for all command lines. Filter for syswow64 usage which is used to run 32-bit code applications. 
This is often used by Metasploit, Cobalt Strike and other malware.  
> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 cmdline | grep -B2 -i syswow64

Search process for injected beacons  
Look for permissions, in particularly *PAGE_EXECUTE_READWRITE* - this is rare and can be indicative of an issue
Want to find:  
1) PAGE_EXECUTE_READWRITE  
2) Memory section not backed with a file on the disk  
3) Memory section contains either shellcode or PE File  (NOTE: a defence mechanism is that the header (4096 bytes) are NULL bytes and appear to be unused) 
> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 malfind -p 1234

## Yara Scanning

Florian Roth produces a lot of Yara scripts, particularly for Cobalt Strike

## Pipes

Named pipes can be named anything and it's an easy way for malware to find
Although named pipes can be changed, they're often not - like general malware, often threat actors use default settings
Cobalt Strike uses default named pipes including:
* \\.\pip\MSSE-####-server
* \\<target>\pip\msagent_##
* \\.\pipe\status_##
* \\.\pipe\postex_ssh_####
* \\.\pipe\####### (7-10 characters)
* \\.\pipe\postex_####

These can be found using handles in volatility. Pay particular attention to IP addresses.
> volatility_2.6_win64_standalone.exe -f PhysicalMemory --profile=Win2012R2x64 handles -p 1234 -t file | grep -i pipe

## Sysmon

If in use within an environment it can be very useful, such as for named pipes. Within the configuration you can turn on "Named Pipe Detection" and you will start to receive Event ID 17 (Pipe Connected) and 18 (Pipe Created). 

## PowerShell

Cobalt Strike makes heavy use of this. Will often utilise:
* winrm
* wmi
* psinject
* powerpick (does not use powershell.exe - injects directly to memory)
* powershell-import
* psexec_psh

PowerShell auditing and logging should be enabled using Administrative Template under Group Policy
Default logging is available under Powershell.evtx and PowerShell/Operational event logs

*Download Cradle* is used by Cobalt Strike, PowerShell Empire and PowerSploit. Usually the host will connect remotely, download script and run. 

### Other indicators with PowerShell
* Look out for a connection to loopback/127/0.0.1
*-EncodedCommand* may be used within the PowerShell commandline
*IEX* or Invoke-Expression which often connects to a remote domain
* Which UserId ran the command?

## Event Logs

4103: Module/Pipeline output  
4104: Codes or Scripts executed by PowerShell - pay particular attention to *Warning* events  
