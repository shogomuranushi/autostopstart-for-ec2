#!/bin/sh

Action=$1
case $Action
   start )
      Time=`date -v-5M +%H`
   ;;
   stop )
      Time=`date -v+5M +%H`
   ;;
esac

# All region & All Acount
#Region=`aws ec2 describe-regions |jq -r '.Regions[].RegionName'`
AllAcount=`cat ~/.aws/config |grep "^\[" |sed -e "s/\]//g" -e "s/\[//g"`

for Acount in ${Acount[@]}
do
   for Instance in `aws ec2 --profile $Acount describe-instances --filter "Name=tag:$Action,Values=$Time" |jq -r '.Reservations[].Instances[].InstanceId'`
   do
      aws ec2 $Action-instances --instance-ids $Instance
   done
done

exit
