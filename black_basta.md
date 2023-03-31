https://www.trendmicro.com/vinfo/gb/security/news/ransomware-spotlight/ransomware-spotlight-blackbasta
https://minerva-labs.com/blog/new-black-basta-ransomware-hijacks-windows-fax-service/
https://github.com/threatlabz/ransomware_notes/tree/main/blackbasta

![image](https://user-images.githubusercontent.com/3117532/229059089-1254b7f5-758e-49f9-9597-3a1c1f2d8f61.png)

1) Consider blocking temporarily known ports and protocols used by threat actors to move laterally should be blocked between workstation-to-workstation and workstations-to-(non-Domain Controllers) and non-File Servers include:
 
• SMB (TCP/445, TCP/135, TCP/139)
• Remote Desktop Protocol (TCP/3389)
• Windows Remote Management / Remote PowerShell (TCP/80, TCP/5985, TCP/5986)
• WMI (dynamic port range)
 
 
 
2) Windows Firewall policy needs to be configured to restrict the scope of communications permitted between common endpoints within an environment. This firewall policy can be enforced locally or centrally via Group Policy. 
 
Computer Configuration > Policies > Windows Settings > Security Settings > Windows Firewall with Advanced Security
 
 
 
3) RDP Access
 
Remote Desktop Protocol (RDP) is a common method used by malicious actors to remotely connect to systems, laterally move from the perimeter onto a larger scope of systems, deploy malware and a known attack vector of Dharma ransomware . External-facing systems with RDP open to the Internet have elevated risk. Malicious actors may exploit RDP to gain initial access into an organization, perform lateral movement, invoke ransomware, and potentially access and steal data.
 
3a. If external-facing RDP must be utilized for operational purposes, multi-factor authentication should be enforced for connectivity.
 
3b. RDP and SMB should not be directly exposed for ingress and egress access to/from the Internet. If required for operational purposes, explicit controls should be implemented to restrict the source IP addresses.
 
3c. For external-facing RDP servers, Network Level Authentication (NLA) provides an extra layer of pre-authentication before a connection is established. NLA is also useful for protecting against brute force attacks, which often target open internet-facing RDP servers.
 
Using Group Policy, the setting for NLA can be enabled via:
Computer Configuration > Policies > Administrative Templates > Windows Components > Remote Desktop Services > Remote Desktop Session Host > Security > Require user authentication for remote connections by using Network Level Authentication
 
3d. For external-facing RDP servers, highly-privileged domain and local administrative accounts should not be permitted access to interface with the servers using RDP
 
Using Group Policy, configurable via the following setting: 
Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > User Rights Assignment > Deny log
 
4) Disable Administrative / Hidden Shares
 
Some ransomware variants will attempt to identify administrative or hidden network shares, including those that are not explicitly mapped to a drive letter - and use these for binding to endpoints throughout an environment. As a containment step, an organization may need to quickly disable default administrative or hidden shares from being accessible on endpoints
 
Common administrative and hidden shares on endpoints include: 
•	ADMIN$ 
•	C$ 
•	D$ 
•	IPC$
 
5) Patch SMB
 
Ensure SMB is patched for with latest vulnerability (especially CVE-2020-0796)
 
6) Windows Remote Management (WinRM)
 
Manual operators may leverage Windows Remote Management (WinRM) to propagate ransomware throughout an environment. WinRM is enabled by default on all Windows Server operating systems (since Windows Server 2012 and above), but disabled on all client operating systems (Windows 7 and Windows 10) and older server platforms (Windows Server 2008 R2).
 
PowerShell Remoting (PS Remoting) is a native Windows remote command execution feature that’s built on top of the WinRM protocol
 
PowerShell Command to disable WinRM / PowerShell Remoting on an endpoint: 
Disable-PSRemoting -Force
 
Stop and disable the WinRM Service:
Stop-Service WinRM -PassThruSet-Service WinRM -StartupType Disabled
 
Disable the listener that accepts requests on any IP address:
dir wsman:\localhost\listener 
Remove-Item -Path WSMan:\Localhost\listener\
 
Restore the value of the LocalAccountTokenFilterPolicy to “0” (zero), which enforces UAC token filtering (admin approval mode) for the built-in administrator (RID 500) account.
Set-ItemProperty -Path 
HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system -Name 
LocalAccountTokenFilterPolicy -Value 0
 
7) Stoping Remote Usage of Local Accounts
Local accounts that exist on endpoints are often a common avenue leveraged by attackers to laterally move throughout an environment. This tactic is especially impactful when the password for the built-in local administrator account is configured to the same value across multiple endpoints. 
 
To mitigate the impact of local accounts being leveraged for lateral movement, Microsoft Security Advisory KB28719976 introduced two (2) well-known SIDs that can be leveraged within Group Policy settings to restrict the usage of local accounts for lateral movement. 
• S-1-5-113: NT AUTHORITY\Local account 
• S-1-5-114: NT AUTHORITY\Local account and member of Administrators group 
 
Specifically, the SID “S-1-5-114: NT AUTHORITY\Local account and member of Administrators group” is added to an account’s access token if the local account is a member of the BUILTIN\Administrators group. This is the most beneficial SID to stop an attacker (or ransomware variant) that propagates us.
 
The “FilterAdministratorToken” setting can either enable (1) or disable (0) (default) “Admin Approval” mode for the RID 500 local administrator. When enabled, the access token for the RID 500 local administrator account is filtered and therefore User Account Control (UAC) is enforced for this account (which can ultimately stop attempts to leverage this account for lateral movement across endpoints).
 
Group Policy Setting: 
Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Security Options > User Account Control: Admin Approval Mode for the built-in Administrator account
 
8) Reduce the Exposure of Privileged and Service Accounts
 
For ransomware to be deployed throughout an environment, privileged and service accounts credentials are commonly utilized for lateral movement and mass propagation. Until a thorough investigation has been completed, it may be difficult to determine the specific credentials that are being utilized by a ransomware variant for connectivity to a large scope of systems within an environment.
 
For any accounts that have privileged access throughout an environment, the accounts should not be utilized on standard workstations and laptops, but rather from designated systems (e.g., Privileged Access Workstations (PAWS)) that reside in restricted and protected VLANs and Tiers. 
 
Explicit privileged accounts should be defined for each Tier, and only utilized within the designated Tier. The recommendations for restricting the scope of access for privileged accounts is based upon Microsoft’s guidance for securing privileged access
 
As a quick containment measure, consider blocking any accounts with privileged access from being able to login (remotely or locally) to standard workstations, laptops, and common access servers
 
The settings referenced below are configurable via the Group Policy path of: 
Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > User Rights Assignment
 
Accounts delegated with local or domain privileged access should be explicitly denied access to standard workstations and laptop systems within the context of the following settings 
 
Configured using Group Policy settings: 
• Deny access to this computer from the network (also include S-1-5-114: NT AUTHORITY\Local account and member of Administrators group) 
• Deny log on as a batch job 
• Deny log on as a service 
• Deny log on locally 
• Deny log on through Terminal Services
 
Should also consider enhancing the security of domain-based service accounts - to restrict the capability for the accounts to be used for interactive, remote desktop, and where possible, network-based logons. On endpoints where the service account is not required for interactive or remote logon purposes, Group Policy settings can be used to enforce recommended logon restrictions for limiting the exposure of service accounts. 
 
• Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > User Rights Assignment – Deny log on locally (SeDenyInteractiveLogonRight) – Deny log on through Terminal Services (SeDenyRemoteInteractiveLogonRight)
 
– Deny log on locally (SeDenyInteractiveLogonRight) 
– Deny log on through Terminal Services (SeDenyRemoteInteractiveLogonRight)
 
9) on GPO servers, 
 
•        Ensure if there is any windows Firewall/real time monitoring are enabled   (for domain hosts)
•        Ensure if any new GPO policy have been pushed recently 
 
10) Impacted server/devices 
 
•        Locate any new user been created ( advise keeping only necessary user account - reset existing user to ensure they are not compromised)
 
9) Backup: 
 
•	Ensure all critical servers are having latest backup on backup server, also recommend having physical backup medium (from a known working point before malicious activity).  Critical server along with Backup server image snapshot should be taken to ensure that it can be restored from backup. 

