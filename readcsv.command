#!/bin/bash
IFS=","
i = 0
while read f1 f2 
do
count=`expr $count + 1`
echo "$count): $f1 $f2"
done < adressbook.csv