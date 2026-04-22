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

Search SigninLogs for specific Client IPs and output summary of linked users as table:
```
let client_ips = dynamic(["1.2.3.4", "5.6.7.8", "123.234.345.2"]);
let startTime = datetime(2026-01-01T00:00:00Z);
let endTime = datetime(2026-04-07T23:59:59Z);
SigninLogs
| where IPAddress in (client_ips) 
| where TimeGenerated between (startTime .. endTime)
| where ResultSignature == "FAILURE"
| summarize 
    Count = count(),
    Users = make_set(UserPrincipalName)
    by IPAddress
```
