

**Accessing external file storage URLs**

```kql
let startTime = datetime(2025-09-01T00:00:00Z);
let endTime = datetime(2025-12-04T23:59:59Z);
DeviceNetworkEvents
| where Timestamp between (startTime .. endTime)
| where RemoteUrl has_any ("dropbox.com", "drive.google.com", "onedrive.live.com", "wetransfer.com", "mega.nz", "box.com")
| where ActionType == "ConnectionSuccess"
| summarize 
    ConnectionCount = count(),
    UniqueDestinations = dcount(RemoteUrl),
    Destinations = make_set(RemoteUrl)
    by InitiatingProcessAccountName, DeviceName
| where ConnectionCount > 50
| order by ConnectionCount desc
```

Similar to above, but include the user account information

```kql
let startTime = datetime(2025-09-01T00:00:00Z);
let endTime = datetime(2025-12-04T23:59:59Z);
DeviceNetworkEvents
| where Timestamp between (startTime .. endTime)
| where RemoteUrl has_any ("dropbox.com", "drive.google.com", "wetransfer.com", "mega.nz", "box.com")
| where RemoteUrl !has "onedrive"
| where ActionType == "ConnectionSuccess"
| summarize 
    ConnectionCount = count(),
    UniqueDestinations = dcount(RemoteUrl),
    Destinations = make_set(RemoteUrl),
    Devices = make_set(DeviceName)
    by InitiatingProcessAccountName
| where ConnectionCount > 30
| join kind=leftouter (
    IdentityInfo
    | summarize arg_max(Timestamp, *) by AccountName
    | project AccountName, JobTitle, Country
) on $left.InitiatingProcessAccountName == $right.AccountName
| order by ConnectionCount desc
```

**Compressing large amounts of data**

```kql
let startTime = datetime(2025-09-01T00:00:00Z);
let endTime = datetime(2025-12-04T23:59:59Z);
DeviceFileEvents
| where Timestamp between (startTime .. endTime)
| where ActionType == "FileCreated"
| where InitiatingProcessAccountName != "system"
| where FileName endswith ".zip"
    or FileName endswith ".7z"
    or FileName endswith ".rar"
    or FileName endswith ".cab"
    or FileName endswith ".gz"
    or FileName endswith ".tar"
| extend FileSizeGB = round(FileSize / 1073741824.0, 0)
| where FileSizeGB >= 5
| project DeviceName, InitiatingProcessAccountName, InitiatingProcessCommandLine, FileName,FolderPath, FileSizeGB
| order by FileSizeGB
```

These results include downloads through browser. They can be removed this by adding the line:

> | where InitiatingProcessFileName !in ("msedge.exe", "chrome.exe", "firefox.exe")

Summarising the TotalGB of archive files created:

```kql
let startTime = datetime(2025-09-01T00:00:00Z);
let endTime = datetime(2025-12-04T23:59:59Z);
DeviceFileEvents
| where Timestamp between (startTime .. endTime)
| where ActionType == "FileCreated"
| where InitiatingProcessAccountName != "system"
| where InitiatingProcessFileName !in ("msedge.exe", "chrome.exe", "firefox.exe")
| where FileName endswith ".zip"
    or FileName endswith ".7z"
    or FileName endswith ".rar"
    or FileName endswith ".cab"
    or FileName endswith ".gz"
    or FileName endswith ".tar"
| where FileName != "MicroStrategy_25.09_IntelligentEnterprise_Windows_11.5.0900.0159.zip"
| extend FileSizeGB = round(FileSize / 1073741824.0, 0)
| where FileSizeGB >= 5
| summarize TotalGB = sum(FileSizeGB) by InitiatingProcessAccountName
```


**Connections to the outside world with suspicious tools**
```kql
let startTime = datetime(2025-09-01T00:00:00Z);
let endTime = datetime(2025-12-04T23:59:59Z);
let suspectApps = dynamic(["AnyDesk.exe", "rustdesk.exe", "Mattermost.exe", "Signal.exe", "MoTTY.exe"]);
DeviceNetworkEvents
| where Timestamp between (startTime .. endTime)
| where InitiatingProcessFileName in (suspectApps)
| where ActionType == "ConnectionSuccess"
| extend Country = tostring(parse_json(AdditionalFields).country)
| summarize 
    ConnectionCount = count(),
    UniqueIPs = dcount(RemoteIP),
    Countries = make_set(Country),
    RemoteIPs = make_set(RemoteIP)
    by InitiatingProcessAccountName, InitiatingProcessFileName
| order by ConnectionCount desc
```

