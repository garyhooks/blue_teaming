


## Grafana and Loki Searching

Go to Explore -> Logs where you can use raw syntax to search 
Remember to enable regex searching where required. 

**SOAP search and XXE**

> (?i)(<!doctype|<!entity|xmltype\(|extractvalue\(|system\s*"(http|file|ftp)|oastify\.com|burpcollaborator\.net)

> SOAP SEARCH - 

> {service_name="nginx"} |= "status=200" |= "/soap"

> {job="loki/nginx"} |= "soap" |= "POST"

**Unicode searches for ../**
> (?i)(\.\./|%2e%2e%2f)

**Searching for local file inclusions**
> {service_name="nginx"} |~ "(\\.\\./)+etc/(passwd|shadow)"

**Status 200 searches**
> {service_name="nginx"} |= "status=200"

**Searching for select/union/whoami queries**
> {service_name="nginx"} |= "status=200" | (?i)(or\s+1=1|select|union|whoami)

**Searching only for queries including either domain1 or domain2**
> {service_name="nginx"} |= "status=200" |~ "(?i)(domain1|domain2)"

**Webshell searching and removing false positives for domain1 and css page**
> {service_name="nginx"} |= "status=200" |~ "(?i)(cmd\\.php|shell\\.php|webshell|eval\\()" != "domain1.com" != "test.css"

**System binary executions**
> {service_name="nginx"} |= "status=200" |~ "(?i)(cmd=|exec\(|system\(|passthru\(|shell_exec|powershell|bash|wget|curl|chmod|chown|python -c|perl -e)"

**Java and Log4Shell**
> {service_name="nginx"} |= "status=200" |~ "(?i)(\$\{jndi:|ldap://|rmi://|dns://|nis://|iiop://)"


