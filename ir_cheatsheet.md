
kape.exe --tsource H: --tdest D:\kape_test --tflush --target !SANS_Triage

## Shimcache

> HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache\AppCompatCache

> AppCompatCacheParser.exe -f D:\registry\SYSTEM -t --csv D:\results\AppCompatCache\ --csvf machine_name.csv 

## AmCache 

Get Amcache Hive from \Windows\appcompat\Programs\Amcache.hve
change machine_name to label the results properly

> AmcacheParser.exe -f "D:\Amcache.hve" -i --csv D:\AmCacheResults --csvf machine_name
