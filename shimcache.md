https://medium.com/@mehrnoush/shimcache-amcache-forensic-analysis-99a8a9733772#:~:text=ShimCache%20and%20AmCache%20are%20Windows,and%20when%20they%20were%20executed.
https://bromiley.medium.com/windows-wednesday-shim-cache-1997ba8b13e7

# Overview

Also known as AppCompatCache, this is available on all Windows systems since XP onwards. Depending on the operating system, it can be stored in two different locations:

* XP: HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatibility\AppCompatCache
* Later versions: HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache\AppCompatCache

## Limitations

There are limitations depending on OS again:

| OS | Maximum Entries |
|---|---|
| XP | 96 |
| Server 2003 | 512 |
| Later versions | 1024 |


