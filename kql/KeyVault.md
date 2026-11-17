
## List summary of Operations by UPNs in the environment

```kql
let operationlist = dynamic(
    ["VaultDelete", "KeyDelete", "SecretDelete", "SecretPurge", "KeyPurge", "SecretListDeleted", "CertificateCreate", "CertificatePurge"]);
AzureDiagnostics
| where TimeGenerated > ago(30d)
| where ResourceType == "VAULTS" and ResultType == "Success" 
| where OperationName in (operationlist)
//| project TimeGenerated,  ResourceGroup,  SubscriptionId, ResultType,  KeyVaultName=Resource,  KeyVaultTarget=id_s,  Actor=identity_claim_upn_s,  IPAddressofActor=CallerIPAddress,  OperationName
| summarize OperationCount=count(), ResourceGroupsAffected=make_set(ResourceGroup), Operations=make_set(OperationName) by identity_claim_upn_s
```

