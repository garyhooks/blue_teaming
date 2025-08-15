

#### Date and Time Formatting

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

