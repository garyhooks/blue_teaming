
### Security.evtx

Event ID 4624 (Account Successfully Logged In)
+ Type 2 Logon from the keyboard of the device
+ Type 3 Network Login
+ Type 10 Remote Desktop Protocol connections

Event ID 4625 (Account failed to login)
Event ID 4648: A logon was attempted using explicit credentials


### Microsoft-Windows-TerminalServices-LocalSessionManager/Operational

Event ID 21: Remote Desktop Services: Session Logon Successful
Event ID 25: Remote Desktop Services: Successful Reconnection 

### Microsoft-Windows-RemoteDesktopServices-RdpCoreTS/Operational

Event ID 131: The server accepted a new TCP connection from client 

### Microsoft-Windows-TerminalServices-RemoteConnectionManager/Operational

Event ID 1149: User Authentication Succeeded
Event ID 1158: Remote Desktop Services accepted a connection from IP address <ipAddress>


```<QueryList>
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
