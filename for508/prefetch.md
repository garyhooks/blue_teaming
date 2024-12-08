# Overview

.pf file is created the first time an application is run
The cache manager monitors all files and directories, and records them into each respective .pf file

The filenames are listed as **FILENAME**-**HEX REPRESENTATION OF HASH OF FILE PATH**.pf
Note: for Windows applications, such as svchost - the hex includes the fullpath AND command line arguments

If an application fails to start or run properly, the prefetch file may still be created 

## Timestamps
Windows 8+ will create up to 9 execution times:
1) The created time of the file from the filesystem
2) The last run time
3) 7 other times/dates

In Windows explorer and filesystem view, the timestamps shown are around 10 seconds AFTER the actual execution. This is due to the prefetcher service monitoring everything and then storing it afterwards. 
Using EZ tools, the timestamp is the raw/correct value and the above can be ignored

## Storage and Locations

There are limitations depending on OS:

| OS | Maximum Entries |
|---|---|
| Windows 7 | 128 |
| Windows 8+ | 1024 |

By default in Windows Servers, pre-fetchhing is turned off

## Removal of Prefetch files

Due to the limitations above, if an application is not run for a long time, it may have the pre-fetch file deleted
So therefore, we always say "the first time we know of this file being executed is..." 
