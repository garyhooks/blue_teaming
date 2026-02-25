# Phishing / Impersonation Domain Investigation Playbook

## Initial Triage and Reporting

1. Confirm site status using:
   curl -I http://DOMAIN
   curl -I https://DOMAIN

2. Identify A record (or use centralops.net)
   dig DOMAIN
   Record IP address and TTL

3. Identify hosting provider:
   whois IP
   or
   whois -h whois.cymru.com " -v IP"

4. Identify registrar (available on centralops.net also)
   whois DOMAIN

5. Report to hosting provider's abuse team with:
   - Full URL
   - IP address
   - Timestamps (UTC)
   - Screenshots or evidence

6. Submit registrar abuse report

7. Report malicious usage to the following entities:

   A. Submit to Google Safe Browsing  
   B. Submit to Microsoft Security Intelligence  
   C. Submit to Netcraft  
   D. Submit to PhishTank (NOTE: account is needed and at present unable to signup due to new registrations being disabled)  
   E. Submit to NCSC - https://www.ncsc.gov.uk/collection/phishing-scams/report-scam-website  
   F. Submit to Anti-Phishing Working Group (APWG) — reporting to eCrime using the email reportphishing@apwg.org. This ensures the domain is shared amongst threat intelligence feeds used by browsers and security vendors  

8. Conditional reporting where applicable:
   - Cloudflare - often sites are hosted behind the cloudflare infrastructure. Where that's the case, report to them - https://abuse.cloudflare.com/
   - Certificate Authority - they can revoke the certificate which will not disable the site, but will make it appear less credible and not fully secured
   - ICANN - If a site has not been removed or if the registrar is ignoring this, report to ICANN - https://icann-nsp.my.site.com/compliance/s/abuse-domain

9. Search VirusTotal for domain and URL
   Record:
   - Detection ratio
   - First submission date
   - Obtain historical DNS by checking Relationships -> Resolutions tab - record all historical IPs and dates
   - Also note the community comments

10. Search AbuseIPDB for reputational information

11. View and save source code of the index page. In addition, identify any clear indications or differences from original, such as tracking cookies, embedded content, etc.

12. Identify underlying technology and framework (such as Wordpress, templating system, Wix)
	- Check for presence of /wp-admin directory or other pages which could indicate technology 
	- Check Wappalyzer (Chrome Add-on) which can identify most of this information

13. Screenshot key findings for evidence preservation


## Domain and DNS Analysis

1. Review DNS record and TTL (or check centralops)
   dig DOMAIN A
   dig DOMAIN AAAA
   dig DOMAIN CNAME

2. Identify nameservers:
   dig DOMAIN NS

3. Check DNSSEC presence:
   dig DOMAIN DS
   If no DS record → DNSSEC not enabled.

4. Check for wildcard DNS:
   dig RANDOMSTRING.DOMAIN

   If NXDOMAIN → no wildcard
   If resolves → wildcard likely configured
      Where a wildcard DNS record is configured, non-existent subdomains will still resolve, which can support scalable phishing deployment and is behaviour commonly seen in phishing campaigns

5. Record domain registration details:
   whois DOMAIN
   Note:
   - Creation date
   - Updated date
   - Expiry date
   Pay attention to the times too - where they are seconds apart it can support it being an automated action

6. Compare domain creation date with first malicious sighting - is there any association?


## IP and Infrastructure Review

1. Confirm ASN:
   whois -h whois.cymru.com " -v IP"

2. Review ASN owner and scale:
   bgpview.io/ip/IP
   or
   dnslytics ASN search

3. Perform reverse IP lookup and pivot for related domains and associated campaigns:
   - Use the results from above (Reverse IP lookup on VirusTotal, DNSlytics, ViewDNS) to locate other domains on the same IP
   - Domains sharing the same nameservers — DNSlytics, SecurityTrails
   - VirusTotal Graph view for infrastructure relationships
   - Look for domains registered in clusters with very similar timestamps — this can indicate automated campaign registration

4. Search IP in:  (accounts needed with these platforms)
   Shodan
   Censys

5. Assess hosting churn:
   List historical IPs from VirusTotal
   Note frequency of changes and hosting providers
   Can indicate wide-spread use or involvement with threat groups

6. Review certificate history in Censys:
   Use Censys
   Record:
   - Issuer
   - Validity dates
   - Rotation frequency
   - Search for certificate fingerprint reuse
   - Query fingerprint_sha256="VALUE"


## Email Infrastructure Review

1. Identify relevant records:
   dig DOMAIN MX  (Mail servers)
   dig DOMAIN TXT  (SPF record)
   dig _dmarc.DOMAIN TXT  (DMARC check)
   dig selector._domainkey.DOMAIN TXT   (DKIM - is selector known from the email header?)

2. If phishing email observed:
   - Extract full email headers
   - Confirm SPF result
   - Identify sending IP
   - Confirm provider alignment

3. Determine whether domain is mail-enabled and capable of outbound phishing.


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

6. Search google for the site URL, IP. Utilise combined keywords alongside this such as "scam", "abuse", "malware" etc - is the site reported online anywhere else?

7. Consider dark web searches - although not always required and is dependent on the situation and circumstances

8. Document findings and formally close investigation if:
   - Site offline
   - Reports submitted
   - No further active infrastructure observed.
