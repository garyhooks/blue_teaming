#!/bin/bash
# -----------------------------------------------------------------------------
# Script Name:  copy_snapshots.sh
# Description:  This script copies snapshots between different regions. It also
#		creates volumes from the copied snapshots. 
# Author:       Gary Hooks
# Date:         2024-08-06
# Version:      1.0
# Usage:        bash ./copy_snapshots.sh
# Notes: 	This could be made more elegant, but it was produced in a live 
#		case and as a result, time was limited.
# # -----------------------------------------------------------------------------

###### STEP 1 ######
# Run this from the command line on the AWS Server, run this command:
# 
# aws ec2 describe-snapshots --region ap-northeast-1 --filters Name=tag:Name,Values=*Forensics* --query "Snapshots[*].[SnapshotId,Tags[0].Value]" --output text > filename.txt
# 
# Note: change --region to wherever the original snapshots are. Eg if client uploaded them to us-east-1, change this value
# Note: --filters section above, which will look up only EC2 instances matching a specific name 
# You can change this to match the specific circumstances, for example set the value to =*CLIENT*


###### STEP 2 ######
# Copy the snapshots over to ap-southeast-1 (or which ever region you want to copy the snapshots over to)
# Make sure you change the Key name value in Tags if you want to customise it
# This is important as the tag name makes it clear, so name it something li

# Open up the filename.txt that you made in step 1 which contains the snapshot details
while read -r line; do

# Save snapshot_id and the tag name into variables
snapshot_id=$(echo $line | awk '{print $1}')
name=$(echo $line | awk '{print $2}')

# Now copy the snapshots over to the new region (in this case ap-southeast-1)
# Note the Tags here, contain a plaintext static name (CLIENT)
# Change this as it makes looking at the AWS instances a lot easier and clearer 
aws ec2 copy-snapshot --region ap-southeast-1 --source-region ap-northeast-1 --source-snapshot-id $snapshot_id --description="$name" --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=CLIENT--$name}]"

done < filename.txt

###### STEP 3 ######
# This is virtually identical to Step 1, where we need to save all snapshots you just copied into a text file so we have a list of them 
# Run this from the command line on the AWS Server.
# NOTE: Note the TAG value below - this should match Step 2 as the command below searches on this 
# So if you saved all the copied snapshots as ****MY_NEW_CLIENT**** this should be entered below so it will find all the ones with this tag name
#
# aws ec2 describe-snapshots --region ap-southeast-1 --filters Name=tag:Name,Values=*CLIENT* --query "Snapshots[*].[SnapshotId,Tags[0].Value]" --output text > copied_snapshots.txt
# 
# Note: change --region to wherever the NEW snapshots are


###### STEP 4 ######
# Now we have all the snapshots in the right region we can create volumes from them 

# Open up the filename.txt that you made in step 1 which contains the snapshot details
while read -r line; do

# Save snapshot_id and the tag name into variables
snapshot_id=$(echo $line | awk '{print $1}')
name=$(echo $line | awk '{print $2}')

# Now create volumes in the region where they will be used/examined (in this case ap-southeast-1)
# They will be encrypted with the DFIR key 
# Tags will be set with the $name which was originally set in Step 3 
aws ec2 create-volume --region ap-southeast-1 --availability-zone ap-southeast-1a --snapshot-id $snapshot_id --volume-type gp3 --encrypted --kms-key-id mrk-4fe13d11613a43878537234e3a211e79 --tag-specifications "ResourceType=volume,Tags=[{Key=Name,Value=$name}]"

done < copied_snapshots.txt
