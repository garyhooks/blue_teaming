

**Sessions where multiple user agents and IPs were used by a single user within a short window of time**

```kql
SigninLogs
| where UserPrincipalName == "donald.trump@thewhitehouse.com"
| project TimeGenerated, IPAddress, Location = tostring(LocationDetails.city),
          OS = tostring(DeviceDetail.operatingSystem),
          Browser = tostring(DeviceDetail.browser),
          ClientAppUsed, SessionId, CorrelationId
| order by TimeGenerated desc
```

**Impossible travel or near-simultaneous logins from different locations**

```kql
SigninLogs
| where UserPrincipalName == "donald.trump@thewhitehouse.com"
| extend Location = tostring(LocationDetails.city)
| order by TimeGenerated asc
| project TimeGenerated, IPAddress, Location, Latitude = LocationDetails.geoCoordinates.latitude,
          Longitude = LocationDetails.geoCoordinates.longitude
```

**Detecting shared SessionId or CorrelationId across different devices and IPs**

```kql
SigninLogs
| where UserPrincipalName == "donald.trump@thewhitehouse.com"
| summarize 
    CountBySession = count(),
    DistinctIPs = dcount(IPAddress),
    DistinctUserAgents = dcount(UserAgent),
    AnyIPs = make_set(IPAddress, 5),
    AnyUserAgents = make_set(UserAgent, 5)
  by SessionId
| where DistinctIPs > 1 or DistinctUserAgents > 1
| order by CountBySession desc
```


**Looking for risky or anomalous sign-ins**
```kql
AADUserRiskEvents
| where UserPrincipalName == "donald.trump@thewhitehouse.com"
| project TimeGenerated, RiskEventType, RiskDetail, AdditionalInfo
| order by TimeGenerated desc
```

**Unusual user-agent changes**
```kql
SigninLogs
| where UserPrincipalName == "donald.trump@thewhitehouse.com"
| summarize 
      Count = count(),
      DistinctUserAgents = dcount(UserAgent),
      UserAgents = make_set(UserAgent)
  by IPAddress
| where DistinctUserAgents > 1
```

**Session continuation without authentication (cookie reuse)**

```kql
CloudAppEvents
| where AccountDisplayName == "Donald Trump"
| where ActionType has "Logon" or ActionType has "Access"
| project TimeGenerated, ActionType, IPAddress, UserAgent, SessionData
| order by TimeGenerated desc
```

```kql
CloudAppEvents
| join kind=leftouter (
    SigninLogs 
    | project SigninTime = TimeGenerated, SessionId, IPAddress
) on IPAddress
| where IPAddress contains "123.456.789.123"
| project TimeGenerated, SessionId, IPAddress, UserAgent, ActionType
```

**Identify simultaneous live sessions**

```kql
SigninLogs
| where UserPrincipalName == "donald.trump@thewhitehouse.com"
| summarize FirstSeen=min(TimeGenerated), LastSeen=max(TimeGenerated)
  by SessionId, IPAddress, UserAgent
| order by LastSeen desc
```




