

# Check sessions where multiple user agents and IPs were used by a single user within a short window of time 

```kql
SigninLogs
| where UserPrincipalName == "donald.trump@thewhitehouse.com"
| project TimeGenerated, IPAddress, Location = tostring(LocationDetails.city),
          OS = tostring(DeviceDetail.operatingSystem),
          Browser = tostring(DeviceDetail.browser),
          ClientAppUsed, SessionId, CorrelationId
```
