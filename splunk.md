

dedup = Removes the events that contain an identical combination of values for the fields that you specify
table = formats the specified fields into a table format

> host=* | dedup index |table index

Search for failed password authentication across organisation
> fail* password | stats count by src, dest, user, sourcetype | sort - count | where count >2 
