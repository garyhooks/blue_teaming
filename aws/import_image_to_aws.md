
## AWS import:

Note that if you get a region error, you either need to update the aws config file in C:\Users\name\.aws\ or add --region us-east-1 or similar to the command below

> aws ec2 import-image --description "test_vm" --license-type "BYOL" --disk-containers "file://C:/users/name/Desktop/containers.json"

## Contents of containers.json

```
[
    {
        "Description": "Don_ELK",
        "Format": "ova",
        "UserBucket": {
            "S3Bucket": "vms",
            "S3Key": "myvm.ova"
        }
    }
]
```

## Check status

The import-task-id will be output from the step before

> aws ec2 describe-import-image-tasks --import-task-ids import-ami-4rejaklj34




