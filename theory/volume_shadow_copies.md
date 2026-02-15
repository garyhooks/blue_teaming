## Key Points

* These are basically snapshots of the live system
* They are block level rather than files and are in chunks
* They are stored under *System Volume Information*
* Not taken at any particular cadence or frequency

### Forensics and use-case

* They can be deleted by an attacker:
> vssadmin delete shadows /all /quiet
or
> wmic shadowcopy delete

* Useful for ransomware investigations, or where log clearing/anti-forensics has taken place

### Viewing vss

* Easiest tool is vscmount by Zimmerman - command below will mount ALL vss snapshots into the chosen directory

> vscmount -dl <drive_letter> --mp <mounting_point>

For example:

> vscmount -dl C --mp \demo

Will mount all vss snapshots in C:\demo_c\* 
