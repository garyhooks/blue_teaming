# Cylr:

### Download:
> https://github.com/orlikoski/CyLR/releases/tag/2.2.0

### Config file
```
glob  **\Users\**
glob  **\Volumes\**
glob  **\System\**
glob  **\private\**
glob  **\Applications\**
glob  **\Library\**
glob  **\etc\**
glob  **\var\**
```

### Automatic Upload
-c specifies to ONLY use the directories included

-d specifies to use default settings PLUS the extra directories included in configuration file

> sudo ./CyLR -u username -p password -s 8.8.8.8 -of filename.zip -c config.txt

> sudo ./CyLR -u username -p password -s 8.8.8.8 -of filename.zip -d config.txt


# Useful Syntax

Find all accessed files in the last 72 hours:

> sudo find / -atime -72h -ls > output.txt

Run a "stat" on each file to get the access time:

> cat output.txt | while read in; do stat; done > accessTimes.txt

Narrow down the results to a specific date:

> grep "Mar 31 21:" accessTimes.txt


