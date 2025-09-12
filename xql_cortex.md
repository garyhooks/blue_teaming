

### Common presets:
- xdr_process
- xdr_file
- xdr_loginevents
- xdr_network
- xdr_dns
- xdr_registry
- xdr_module
- xdr_alerts

> preset = xdr_file | filter action_file_name contains "readme.txt"

> preset = xdr_login_events | filter agent_hostname contains "server"

> preset = xdr_login_events | filter agent_hostname contains "server" and outcome!="SUCCESS"

> preset = xdr_login_events | filter agent_hostname contains "server" and outcome!="SUCCESS" | _time, agent_hostname, actor_effective_username, auth_result, logon_type, source_ip


You can also do this to discover fields, but also search **within a time frame**:

```
preset = xdr_login_events
| filter agent_hostname contains "server"
    and outcome != "SUCCESS"
    and _time >= now() - 10d
| limit 50
```


```
| filter
    agent_hostname = "PDTIN207699" and
    action_process_image_name = "powershell.exe" and
    action_process_image_command_line contains "AnonymousPipeClientStream" and
    action_process_image_command_line contains "Invoke-Expression"
| fields
    _time,
    actor_effective_username,
    action_process_image_command_line,
    actor_process_image_name,
    actor_process_command_line,
    
//All other systems
 preset = xdr_process
| filter
action_process_image_name = "powershell.exe" and
action_process_image_command_line contains "AnonymousPipeClientStream" and
action_process_image_command_line contains "Invoke-Expression" and
action_process_image_command_line contains "p.Dispose()"
| comp count() by agent_hostname
```



 
 
