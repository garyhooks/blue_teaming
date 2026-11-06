

## Search for Sign-Ins and output First/Last used dates 
```kql
let badIps = dynamic(["123.123.123.1","1.2.3.4");
AADServicePrincipalSignInLogs
| where TimeGenerated between (datetime(2026-10-25) .. now())
| where IPAddress in (badIps) and ResultType == "0"
| where ResultSignature != "FAILURE"
| summarize First=min(TimeGenerated), Last=max(TimeGenerated), SignIns=count(), IPs=dcount(IPAddress),
            Resources=make_set(ResourceDisplayName, 6)
  by Id=tostring(ServicePrincipalId), Name=ServicePrincipalName
| where First < datetime(2026-10-27 02:00)
| extend First=format_datetime(First, "yyyy-MM-dd HH:mm:ss"), Last=format_datetime(Last, "yyyy-MM-dd HH:mm:ss")
| order by First asc
```

## Search Graph logs for App IDs of interest - joining with Principal Names
```kql
let myAppIds = dynamic ([
    "123456-123-123", 
]);
let PrincipalNames =
    AADServicePrincipalSignInLogs
    | where TimeGenerated between (datetime(2026-10-26 23:50) .. datetime(2026-10-27 14:01))
    | where AppId in (myAppIds)
    | summarize ServicePrincipalName = take_any(ServicePrincipalName) by AppId;
MicrosoftGraphActivityLogs
| where TimeGenerated between (datetime(2026-10-26 23:50) .. datetime(2026-10-27 14:01))
| where AppId in (myAppIds)
| where ResponseStatusCode == "200"
| join kind=leftouter PrincipalNames on AppId
| project TimeUTC = format_datetime(TimeGenerated, "yyyy-MM-dd HH:mm:ss"),
          AppId, ServicePrincipalName, IPAddress, RequestMethod, RequestUri,
          ResponseStatusCode, ResponseSizeBytes, Roles, UserAgent
| sort by TimeUTC asc
```

## Search for KeyVault access in AzureDiagnostics 

```kql
let PrincipalNames =
    AADServicePrincipalSignInLogs
    | where TimeGenerated between (datetime(2026-10-26 23:50) .. datetime(2026-10-27 14:01))
    | where AppId in (myAppIds)
    | summarize ServicePrincipalName = take_any(ServicePrincipalName) by AppId;
AzureDiagnostics
| where TimeGenerated between (datetime(2026-10-26 23:50) .. datetime(2026-10-27 14:01))
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where identity_claim_appid_g in (myAppIds)
| where identity_claim_appid_g in (myAppIds)
| where httpStatusCode_d == "200"
| join kind=leftouter PrincipalNames on $left.identity_claim_appid_g == $right.AppId
//| summarize Requests=count() by ServicePrincipalName, Resource, OperationName, CallerIPAddress
//| sort by Requests desc
| project TimeUTC = format_datetime(TimeGenerated, "yyyy-MM-dd HH:mm:ss"),
          ServicePrincipalName, SubscriptionId, Resource, OperationName,
          CallerIPAddress, id_s, clientInfo_s
| sort by TimeUTC asc
```

## Look for Key Values used during authentication

```kql
let serviceId = "123-456-789";
let signins = AADServicePrincipalSignInLogs
| where TimeGenerated between (datetime(2026-10-27 00:10) .. datetime(2026-10-27 00:16))
| where ServicePrincipalId == serviceId
| project TimeGenerated, Source="SignIn", IP=IPAddress,
          Detail=strcat(ResourceDisplayName, " | key ", ServicePrincipalCredentialKeyId);
let kv = AzureDiagnostics
| where TimeGenerated between (datetime(2026-10-27 00:10) .. datetime(2026-10-27 00:16))
| where ResourceProvider == "MICROSOFT.KEYVAULT" and Category == "AuditEvent"
| where identity_claim_oid_g == serviceId
| project TimeGenerated, Source="KeyVault", IP=CallerIPAddress,
          Detail=strcat(OperationName, " | ", Resource);
union signins, kv
| order by TimeGenerated asc
```

## Search for Principal Signins, summarizing output of Count, Unique SPNs, SPNames, APP IDs, Source IPs and First Seen/Last Seen

```kql
AADServicePrincipalSignInLogs 
| where TimeGenerated >= ago(30d) and (IPAddress startswith "123.456." or IPAddress startswith "123.456." or IPAddress startswith "123.456.") | where ResultType == "0"
| summarize SuccessfulSignIns=count(), UniqueSPNs=dcount(ServicePrincipalId), SPNames=make_set(ServicePrincipalName), AppIDs=make_set(AppId), SourceIPs=make_set(IPAddress), FirstSeen=min(TimeGenerated), LastSeen=max(TimeGenerated) by ResourceDisplayName
| project ResourceDisplayName, UniqueSPNs, SuccessfulSignIns, FirstSeen, LastSeen, SPNames
| order by UniqueSPNs desc
```

