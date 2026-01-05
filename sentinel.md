Useful resource: https://github.com/reprise99/Sentinel-Queries

### Find time frames available

```kql
DeviceFileEvents
| summarize
MinTimestamp = min(Timestamp),
MaxTimestamp = max(Timestamp)
```

### Sign In Logs

```kql
SigninLogs
| where TimeGenerated > ago(3d)
| project TimeGenerated, Location, IPAddress, UserAgent
```

```kql
SigninLogs
| where TimeGenerated > ago(1d)
| where ResultType != 0
| project TimeGenerated, ResultType, ResultDescription, UserPrincipalName, AppDisplayName
```

Find logins where an error occurs, and they are NOT a member of the organisation. 
Summarize this by the count() of the UserPrincipalName
```kql
SigninLogs
| where TimeGenerated > ago(1d)
| where ResultType != 0
| where UserType != "Member"
| project TimeGenerated, ResultType, ResultDescription, UserPrincipalName, UserType, AppDisplayName
| summarize count() by UserPrincipalName
```

Produce a piechart of the results:
* render piechart/columnchart/barchart/timechart, barchart


##### Key Fields:
* IPAddress
* User Display Name: Bob Jones
* UserPrincipalName: first.last@company.com
* UserType: Member or Guest
* ResultType: 0 = Successful 
* AppDisplayName: Office365, TeamViewer, Windows Sign In, etc. 


### Security Alerts

Find top 20 Alerts and order by the count
```kql
SecurityAlert
| where TimeGenerated > ago (30d)
| where ProviderName != "ASI Scheduled Alerts"
| summarize Count=count() by AlertName
| top 20 by Count
```

Find top 20 alerts where severity is high
```kql
SecurityAlert
| where TimeGenerated > ago (30d)
| where ProviderName != "ASI Scheduled Alerts" and AlertSeverity == "High"
| summarize Count=count() by AlertName
| top 20 by Count
```

Top 20 users generating identity alerts
```kql
SecurityAlert
| where TimeGenerated > ago (30d)
| where ProviderName in ("OATP","IPC","Azure Advanced Threat Protection","MCAS")
| summarize Count=count() by CompromisedEntity
| where CompromisedEntity != "CompromisedEntity" and isnotempty( CompromisedEntity)
| top 20 by Count
```

Top 20 devices triggering high severity defender alerts:
```kql
SecurityAlert
| where TimeGenerated > ago (30d)
| where ProviderName == "MDATP" and AlertSeverity == "High"
| summarize Count=count() by CompromisedEntity
| where CompromisedEntity != "CompromisedEntity" and isnotempty( CompromisedEntity)
| top 20 by Count
```


Emails with malicious URLs after delivery:
```kql
SecurityAlert
| where TimeGenerated > ago(365d)
| where ProviderName == "OATP"
| where AlertName in ("Email messages containing malicious URL removed after delivery​","Email messages containing phish URLs removed after delivery")
| mv-expand todynamic(Entities)
| extend MaliciousURL = tostring(Entities.Url)
| project MaliciousURL
| parse-where MaliciousURL with * "//" ['Malicious Domain'] "/" *
| summarize Count=count() by ['Malicious Domain']
| sort by Count desc 
| render barchart
```


Find phishing attempts and sort by user

```kql
SecurityAlert
| where TimeGenerated > ago (5d)
| where AlertName contains "Phish"
| mv-expand todynamic(Entities)
| extend User = tostring(Entities.MailboxPrimaryAddress)
| summarize ['Count of Phishing Attempts']=count()by User
| order by ['Count of Phishing Attempts'] desc
```

Find suspicious and malicious logins
```kql
SecurityAlert
| extend x = todynamic(Entities)
| mv-expand x
| parse-where x with * '"Address":"' MaliciousIP '"' *
| project AlertTime=TimeGenerated, MaliciousIP, CompromisedEntity
| join kind=inner
    (
    SigninLogs
    | where ResultType in ("0","53003","50158")
    )
    on $left.MaliciousIP == $right.IPAddress
| where CompromisedEntity != UserPrincipalName
| distinct UserPrincipalName, AppDisplayName, IPAddress, UserAgent, ResultType, ResultDescription
```

Find Golden Ticket alerts
```kql
SecurityAlert
| where TimeGenerated > ago(365d)
| where AlertName contains "Golden Ticket"
| mv-expand todynamic(Entities)
| extend AccountName = tostring(Entities.Name)
| extend HostName = tostring(Entities.HostName)
| summarize
    Accounts=make_list_if(AccountName, isnotempty(AccountName)),
    Hosts=make_list_if(HostName, isnotempty(HostName))
    by VendorOriginalId
```
