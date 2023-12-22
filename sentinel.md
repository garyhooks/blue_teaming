Useful resource: https://github.com/reprise99/Sentinel-Queries

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

Find phishing attempts and sort by user
```kql
SecurityAlert
| where TimeGenerated > ago (5d)
| where AlertName contains "Phish"
| mv-expand todynamic(Entities)
| extend User = tostring(Entities.MailboxPrimaryAddress)
| summarize ['Count of Phishing Attempts']=count()by User
| order by ['Count of Phishing Attempts'] desc


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
