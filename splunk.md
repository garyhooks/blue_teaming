
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
| abuseipdb mode=check ip=c_ip age=365
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
