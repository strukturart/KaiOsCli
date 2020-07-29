#!/bin/bash
#store data in 2d arry

HORIZONTALLINE="================================="

select_number () {


declare -A data_arr
declare -a data_arr_index

IFS=","
i=0
while read -r f1 f2 
do
    #count=`expr $count + 1`
    data_arr[$f1]=$f2
    data_arr_index+=($f1)
done < adressbook.csv

#list adressbook
echo -e "\n$HORIZONTALLINE"

count_indexo=0
for i in "${data_arr_index[@]}" 
do
count_indexo=`expr $count_indexo + 1`
echo "$count_indexo) $i ${data_arr[$i]} "
done

#select number
read -e -p "Who do you want to write to ? " number
index_number=${data_arr_index[$number-1]}
receive_number=${data_arr[$index_number]}
}