#!/bin/bash
#Author: perry
#sendsms script by speeduploop


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
echo "4) exit"

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
    adb shell sendsms $receive_number $mask_whitespace
    exec bash
    ;;

  3)

    adb pull /data/local/storage/permanent/chrome/idb/226660312ssm.sqlite

    ;;

  4)
  exec bash

  ;;


esac
