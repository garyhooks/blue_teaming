# Cylr:

### Download:
> https://github.com/orlikoski/CyLR/releases/tag/2.2.0

### Disable csrutil
It may be best to disable system integrity protection (SIP) temporarily:

```
1. Restart and put into recovery mode (often command+r)
2. Launch terminal from Utilities menu
3. Run command _csrutil disable_
4. Restart computer
```

To renable do the same but run _csrutil enable_


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



