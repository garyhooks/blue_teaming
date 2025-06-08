### Get earliest and latest times:

> index=index_name | stats min(_time) as earliest_time | eval earliest_time=strftime(earliest_time, "%Y-%m-%d %H:%M:%S")

> index=index_name | stats max(_time) as latest_time | eval latest_time=strftime(latest_time, "%Y-%m-%d %H:%M:%S")

### Create Timestamp

> | eval CustomTimestamp=strftime(_time, "%Y-%m-%d %H:%M:%S")

### M365 Email Parsing

```
source="purview_log.csv" 
| spath input=AuditData path=ClientIP 
| spath input=AuditData path=SessionId
| mvexpand AuditData
| eval _raw=AuditData
| spath AffectedItems{}.ParentFolder output=ParentFolder
| spath AffectedItems{}.ParentFolder{}.Path output=Path
| spath AffectedItems{}.Attachments output=Attachments
| spath AffectedItems{}.Subject output=Subject
| eval CustomTimestamp=strftime(_time, "%Y-%m-%d %H:%M:%S")
```

> C:\Program Files\Splunk\bin\splunk.exe add index events

Change default search range:

> http://127.0.0.1:8000/en-US/manager/system/searchprefs

Overview of timeline:

> index=events | convert timeformat="%Y-%m-%d" ctime(_time) AS date | timechart count by date

Line chart:

```
index=events ComputerName=* Account_Name=*** EventCode IN ($event_code_input$) | convert timeformat="%Y-%m-%d" ctime(_time) AS date 
| timechart count by EventCode
| rename "4625" AS "Failed Login (4625)", "4624" AS "Successful Login (4624)", 
"4672" AS "Logon with Admin Rights (4672)",
"4720" AS "Account was created (4720)",
"4769" AS "Kerberos ticket requested (4769)",
"4770" AS "Kerberos ticket renewed (4770)",
"5140" AS "Network share object accessed (5140)"
```

Good commands - https://github.com/EvolvingSysadmin/Splunk-Tools

Create a Visualization of activity based on date:

> index=blah EventCode=4625 | convert timeformat="%Y-%m-%d" ctime(_time) AS date | timechart count by date

If you have a filesize limit, you can split the files up using this command:
```
split -b 500m TheBigFile.csv chosen_prefix-
```
This will then output all the files with the chosen_prefix and an incremental hex value afterwards

A better command is this:
```spl
find . -maxdepth 1 -type f -name "start_of_filename_*.csv" -exec split -b 500m {} {} \;
```
This will split into 500mb sizes, and will retain the original file names
For example:
File: HugeFile.csv becomes HugeFile.csvaa / HugeFile.csvab / HugeFile.csvac and so on



dedup = Removes the events that contain an identical combination of values for the fields that you specify
table = formats the specified fields into a table format

> host=* | dedup index | table index
> src="10.10.24.2" dest="MainServer01" | table time, src, dest, user

Search for failed password authentication across organisation
> fail* password | stats count by src, dest, user, sourcetype | sort - count | where count >2 

### Starting Commands

#### AbuseDB
Documentation: https://splunkbase.splunk.com/app/7173

IP Abuse Scores 
```
index=iis 
| dedup c_ip
| head 20
| search abuseipdb mode=blacklist ip=c_ip age=365
| sort - abuseipdb_abuseScore
| table c_ip abuseipdb_abuseScore
abuseipdb_company
abuseipdb_country
abuseipdb_domain
abuseipdb_nbrReports
abuseipdb_tor
abuseipdb_type
abuseipdb_usage


IP Confidence Score
```
index=iis 
| dedup c_ip
| head 20
| abuseipdb mode=blacklist ip=c_ip age=365
| sort - abuseipdb_abuseScore
| table *
```

Search for executables within a custom string field
```
$index$ | search  "Device Custom String2"="*evil.exe*" OR "File Name"="*other_evil.exe*"
| rename "Device Custom String2" as processdetails
| eval processdetails=replace(processdetails, "\n","")
| table  _time,"Destination Address", "Destination Host Name","Destination User Name", "File Name", "File Path",processdetails
| dedup  _time,processdetails | sort -_time
```

Find login attempts with mispelled or bad passwords
```
$index$| search "Device Custom String1"="User logon with misspelled or bad password"
| table _time, "Destination Host Name", "Destination User Name", "Device Custom String1", "Device Custom String4", "Source Address"
| sort -_time
| dedup _time, "Destination Host Name", "Destination User Name", "Device Custom String1", "Device Custom String4", "Source Address"
```

Detect Kerberoasting
> index=events EventCode=4769 Service_Name!="*$" Ticket_Encryption_Type=0x17

> time analysis 
| bucket

Single Value in Dashboard - where no results received use this to input 0 instead of error:
> | appendpipe [stats count | where count=0]
