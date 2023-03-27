Output All logs to one csv file
> EvtxECmd.exe -d C:\Users\garyh\Documents\Tools\Zimmerman\EvtxECmd\Logs\ --csv C:\Logs\output\ --csvf eventlogs.csv

Output XML files
> EvtxECmd.exe -f C:\Users\garyh\Documents\Tools\Zimmerman\EvtxECmd\Logs\Security.evtx --xml C:\Logs\output\

Output individual log files
> EvtxECmd.exe -f C:\Users\garyh\Documents\Tools\Zimmerman\EvtxECmd\Logs\Security.evtx --csv C:\Logs\output\ --csvf Security.csv

Output but limit to specific dates (Administrator Privileges needed)
> EvtxECmd.exe -f C:\Users\garyh\Documents\Tools\Zimmerman\EvtxECmd\Logs\Security.evtx --xml C:\Logs\output\ --dt yyyy-MM-dd --sd 2023-01-01 --ed 2023-01-03

### Security.evtx

Event ID 4624 (Account Successfully Logged In)  

+ Type 2 Logon from the keyboard of the device
+ Type 3 Network Login
+ Type 10 Remote Desktop Protocol connections

Event ID 4624: Account Login Successfully
Event ID 4625: Account failed to login
Event ID 4634: Account Logoff 
Event ID 4648: A logon was attempted using explicit credentials  
Event ID 4672: Admin rights
Event ID 5140: A network share object was accessed

### Microsoft-Windows-Taskcheduler/Operational.evtx

ID 106: Task scheduled
ID 200: Task executed
ID 201: Task completed
ID 141: Task removed

### Microsoft-Windows-TerminalServices-LocalSessionManager/Operational

Event ID 21: Remote Desktop Services: Session Logon Successful  
Event ID 23: Remote Desktop Services: Account logoff 
Event ID 24: Remote Desktop Services: Disconnection
Event ID 25: Remote Desktop Services: Successful Reconnection   

### Microsoft-Windows-RemoteDesktopServices-RdpCoreTS/Operational

Event ID 131: The server accepted a new TCP connection from client  

### Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational

Event ID 1149: User Authentication Succeeded   
Event ID 1158: Remote Desktop Services accepted a connection from IP address <ipAddress>   

### XML Manual Searching in event viewer 
  
```
<QueryList>
  <Query Id="0" Path="file://C:\location\of\logs\Security.evtx">
    <Select Path="file://C:\location\of\logs\Security.evtx">
      *[
        EventData[Data[@Name='LogonType']='9']
        and
        System[(EventID='4624')]
       ] 
    </Select>
  </Query>
</QueryList>
```
