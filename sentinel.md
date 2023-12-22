

### Sign In Logs

```kql
SigninLogs
| where TimeGenerated > ago(3d)
| project TimeGenerated, Location, IPAddress, UserAgent
```

```
SigninLogs
| where TimeGenerated > ago(1d)
| where ResultType != 0
| project TimeGenerated, ResultType, ResultDescription, UserPrincipalName, AppDisplayName
```

Find logins where an error occurs, and they are NOT a member of the organisation:
```
SigninLogs
| where TimeGenerated > ago(1d)
| where ResultType != 0
| where UserType != "Member"
| project TimeGenerated, ResultType, ResultDescription, UserPrincipalName, UserType, AppDisplayName
```

IPAddress
User Display Name: Bob Jones
UserPrincipalName: first.last@company.com
UserType: Member or Guest
ResultType: 0 = Successful 
AppDisplayName: Office365, TeamViewer, Windows Sign In, etc. 
