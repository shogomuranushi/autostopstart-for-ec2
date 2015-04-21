#!/bin/sh

Action=$1
case $Action
   start )
      Time=`date -v+5M +%H`
   ;;
   stop )
      Time=`date -v-5M +%H`
   ;;
esac

# All region
Region=`aws ec2 describe-regions |jq -r '.Regions[].RegionName'`
# All Acount
AllAcount=`cat ~/.aws/config |grep "^\[" |sed -e "s/\]//g" -e "s/\[//g"`


for Instance in `aws ec2 describe-instances --filter "Name=tag:$Action,Values=$Time" |jq -r '.Reservations[].Instances[].InstanceId'`
do
	aws ec2 $Action-instances --instance-ids $Instance
done

exit
