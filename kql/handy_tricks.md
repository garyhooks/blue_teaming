## Data Available

Find time frames available

```kql
DeviceFileEvents
| summarize
MinTimestamp = min(Timestamp),
MaxTimestamp = max(Timestamp)
```
## Find tables where data exists

```kql
search ("dangerous_ioc")
| distinct $table
```
Filter this further to find those which are populated with data:

```kql
union withsource=TableName *
| where isnotempty(RemoteUrl)
| distinct TableName
```

## Date and Time

#### Set Time Parameters 

```kql
let startTime = datetime(2025-09-01T00:00:00Z);
let endTime = datetime(2025-12-04T23:59:59Z);
```

Then use like this:

```kql
AlertInfo
| where Timestamp between (startTime .. endTime)
| where Severity in ("High", "Medium")
| join AlertEvidence on AlertId
| project Timestamp, AlertId, Title, Severity, AccountName, DeviceName, FileName
| order by Timestamp desc
```

#### Time zone changes

You can display the UTC timezones into regionalised time zones (ISO 8601 format) using the query below

```kql
SigninLogs
| extend LocalTimeInTokyo = datetime_utc_to_local(now(), 'Asia/Tokyo')
```
Similarly you can also use **datetime_local_to_utc** if you want to change into UTC. 

There is a full list here: https://learn.microsoft.com/en-us/kusto/query/timezone?view=azure-data-explorer&preserve-view=true

**format_datetime** produces similar output but outputs as a date, allowing you to choose whether to display leading zeros, or the exact format

**datetime_part** allows you to output parts of the date into values such as dayofyear, hour, etc. 

> print datetime_part("week_of_year", now())

#### 


## Obfuscation of results

This is useful as queries will appear in audits and may be visible to others in the client organisation. It may be a sensitive investigation and disclosing details of it may be best avoided.

**adding the letter h** before the string you are targetting will obfsucate the results. 

E.g.

```kql
SigninLogs
| where UserDisplayName has h'bob.smith@company.com'
```

This will output the results but the UserDisplayName will be asterix and not the clear text.



