```
aws ec2 describe-volumes --region us-east-1 --filters Name=status,Values=* --query "Volumes[*].[AvailabilityZone, Size, CreateTime, VolumeId, State, Tags[?Key=='Name']|[0].Value]" --output text >> vols.txt

aws ec2 describe-volumes --region eu-west-2 --filters Name=status,Values=* --query "Volumes[*].[AvailabilityZone, Size, CreateTime, VolumeId, State, Tags[?Key=='Name']|[0].Value]" --output text >> vols.txt

aws ec2 describe-volumes --region ap-southeast-1 --filters Name=status,Values=* --query "Volumes[*].[AvailabilityZone, Size, CreateTime, VolumeId, State, Tags[?Key=='Name']|[0].Value]" --output text >> vols.txt

aws ec2 describe-volumes --region ap-southeast-2 --filters Name=status,Values=* --query "Volumes[*].[AvailabilityZone, Size, CreateTime, VolumeId, State, Tags[?Key=='Name']|[0].Value]" --output text >> vols.txt

aws ec2 describe-volumes --region us-east-1 --filters Name=status,Values=* --query "Volumes[*].[AvailabilityZone, Size, CreateTime, VolumeId, State, Tags[?Key=='Name']|[0].Value]" --output text >> vols.txt
```
