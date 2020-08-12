#!/bin/bash
#Author: perry
#sendsms script by speeduploop

#CONFIG
#########################
##SD-Backup path
sd_backup_path="sdcard"


#########################


source readcsv.sh


HORIZONTALLINE="================================="
clear

cat << "EOF"
      .              .   .'.     \   /
    \   /      .'. .' '.'   '  -=  o  =-
  -=  o  =-  .'   '              / | \
    / | \                          |
      |                            |
      |                            |
      |                      .=====|
      |=====.                |.---.|
      |.---.|                ||=o=||
      ||=o=||                ||   ||
      ||   ||                ||   ||
      ||   ||                ||___||
      ||___||                |[:::]|
  jgs  |[:::]|                '-----'
      '-----' 

EOF
echo -e "\n$HORIZONTALLINE"
echo "KaiOs Cli"
echo $HORIZONTALLINE
echo "1) reboot device"
echo "2) send sms"
echo "3) backup sms"
echo "4) backup sd-card"
echo "5) backup user data"
echo "6) exit"

echo $HORIZONTALLINE

read -p "Type the option you select: " choice

case $choice in

  1)
    adb shell reboot
    exec bash
    ;;

  2)
    
    #read -e -p "Number: " number
    select_number
    echo $receive_number

    echo $HORIZONTALLINE

    read -p "Text: " text
    mask_whitespace=${text// /"\ "}
    adb shell sendsms $receive_number "$mask_whitespace"
    source kaiOsCli.sh

    ;;

  3)

    adb pull /data/local/storage/permanent/chrome/idb/226660312ssm.sqlite

    ;;
  4)
    if [ -z $sd_backup_path ]
    then
    echo  -e "\e[31mdesination path not set\e[0m"
    else
    adb-sync/adb-sync --reverse --times --delete /sdcard/ "$sd_backup_path"
    source kaiOsCli.sh
    fi
    ;;

  5)
  mkdir local && cd ./local && 
  adb pull /data/local/webapps && 
  adb pull /data/local/permissions.sqlite && 
  adb pull /data/local/storage && 
  adb pull /data/local/config 
  source kaiOsCli.sh

  ;;
  6)
  exec bash

  ;;


esac
