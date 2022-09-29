

dedup = Removes the events that contain an identical combination of values for the fields that you specify
table = formats the specified fields into a table format

> host=* | dedup index | table index
> src="10.10.24.2" dest="MainServer01" | table time, src, dest, user

Search for failed password authentication across organisation
> fail* password | stats count by src, dest, user, sourcetype | sort - count | where count >2 
