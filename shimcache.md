# Overview

Also known as AppCompatCache, this is available on all Windows systems since XP onwards. Depending on the operating system, it can be stored in two different locations:

* XP: HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatibility\AppCompatCache
* Later versions: HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache\AppCompatCache

* Most recent events are at the top
* Entries are only written on shutdown
* Therefore new applications will exist only in memory and not committed to registry until shutdown

## Artefects

* If a file is rewritten to disk, modified or renamed, it will be shimmed again
* If the last modified time of the AppCompatCache entry is not the same as the actual application, it's likely the application has had the modified time altered.
* If the InsertFlag is not set, the application did not execute

## Limitations

There are limitations depending on OS again:

| OS | Maximum Entries |
|---|---|
| XP | 96 |
| Server 2003 | 512 |
| Later versions | 1024 |



## Examining the Shimcache

```
AppCompatCacheParser.exe -f C:\Windows\System32\config\SYSTEM --csv output
```

## Resources
https://medium.com/@mehrnoush/shimcache-amcache-forensic-analysis-99a8a9733772#:~:text=ShimCache%20and%20AmCache%20are%20Windows,and%20when%20they%20were%20executed.   
https://bromiley.medium.com/windows-wednesday-shim-cache-1997ba8b13e7    
https://forensafe.com/blogs/shimcache.html   
