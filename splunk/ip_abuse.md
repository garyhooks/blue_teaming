
## AbuseIPDB
Use AbuseIPDB app to look up blacklisted IP addresses
https://docs.abuseipdb.com/?utm_source=splunk&utm_medium=documentation#introduction

```
index="my_index" NOT ("Remote IP"="10.*" OR "Remote IP"="192.168.*" OR "Remote IP"="172.16.*" OR "Remote IP"="172.17.*" OR "Remote IP"="172.18.*" OR "Remote IP"="172.19.*" OR "Remote IP"="172.20.*" OR "Remote IP"="172.21.*" OR "Remote IP"="172.22.*" OR "Remote IP"="172.23.*" OR "Remote IP"="172.24.*" OR "Remote IP"="172.25.*" OR "Remote IP"="172.26.*" OR "Remote IP"="172.27.*" OR "Remote IP"="172.28.*" OR "Remote IP"="172.29.*" OR "Remote IP"="172.30.*" OR "Remote IP"="172.31.*" OR "Remote IP"="127.0.0.1" OR "Remote IP"="")
| stats count by "Remote IP"
| sort - count 
| head 20
| rename "Remote IP" as ip_to_check, count as remote_ip_count
| fields remote_ip_count, ip_to_check
| abuseipdbcheck ip=ip_to_check
| table remote_ip_count, ip_to_check, totalReports, abuseConfidenceScore, isWhitelisted, countryCode, usageType, isp, domain, hostnames, isTor, numDistinctUsers, lastReportedAt
```
