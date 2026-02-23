# Phishing / Impersonation Domain Investigation Playbook

## Initial Triage and Reporting

1. Confirm site status using:
   curl -I http://DOMAIN
   curl -I https://DOMAIN

2. Identify A record:
   dig DOMAIN
   Record IP address and TTL.

3. Identify hosting provider:
   whois IP
   or
   whois -h whois.cymru.com " -v IP"

4. Report to hosting provider abuse contact with:
   - Full URL
   - IP address
   - Timestamps (UTC)
   - Screenshots or evidence

5. Identify registrar:
   whois DOMAIN
   Submit registrar abuse report.

6. Submit URL/domain to:
   - Google Safe Browsing
   - Microsoft Security Intelligence
   - Netcraft

7. Search VirusTotal for domain and URL.
   Record:
   - Detection ratio
   - First submission date

8. Screenshot key findings for evidence preservation.


## Domain and DNS Analysis

1. Review A record and TTL:
   dig DOMAIN

2. Check for AAAA and CNAME:
   dig DOMAIN AAAA
   dig DOMAIN CNAME

3. Check for wildcard DNS:
   dig RANDOMSTRING.DOMAIN

   If NXDOMAIN → no wildcard.
   If resolves → wildcard likely configured.

4. Identify nameservers:
   dig DOMAIN NS

5. Check DNSSEC presence:
   dig DOMAIN DS
   If no DS record → DNSSEC not enabled.

6. Obtain historical DNS:
   VirusTotal → Relationships → Resolutions
   Record all historical IPs and dates.

7. Record domain registration details:
   whois DOMAIN
   Note:
   - Creation date
   - Updated date
   - Expiry date

8. Compare domain creation date with first malicious sighting.


## IP and Infrastructure Review

1. Confirm ASN:
   whois -h whois.cymru.com " -v IP"

2. Review ASN owner and scale:
   bgpview.io/ip/IP
   or
   dnslytics ASN search

3. Perform reverse IP lookup:
   VirusTotal
   DNSlytics
   ViewDNS

4. Search IP in:
   Shodan
   Censys

5. Assess hosting churn:
   List historical IPs from VirusTotal.
   Note frequency of changes and hosting providers.

6. Review certificate history:
   Use Censys.
   Record:
   - Issuer
   - Validity dates
   - Rotation frequency

7. Search for certificate fingerprint reuse:
   Use Censys Certificates dataset.
   Query fingerprint_sha256="VALUE"


## Email Infrastructure Review

1. Identify MX records:
   dig DOMAIN MX

2. Identify SPF record:
   dig DOMAIN TXT

3. Check DMARC:
   dig _dmarc.DOMAIN TXT

4. Check DKIM (if selector known from email header):
   dig selector._domainkey.DOMAIN TXT

5. If phishing email observed:
   - Extract full email headers
   - Confirm SPF result
   - Identify sending IP
   - Confirm provider alignment

6. Determine whether domain is mail-enabled and capable of outbound phishing.


## Exposure and Operational Assessment

1. Identify first known malicious appearance:
   VirusTotal first submission date
   URLscan search

2. Identify last known activity:
   Certificate validity end date
   Hosting change date

3. Check Wayback Machine for archived content.

4. Determine if domain reverted to parking infrastructure.

5. Assess whether infrastructure indicates:
   - Disposable domain
   - Shared hosting
   - Structured campaign

6. Document findings and formally close investigation if:
   - Site offline
   - Reports submitted
   - No further active infrastructure observed.
