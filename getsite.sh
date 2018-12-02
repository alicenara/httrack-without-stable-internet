#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "2 PARAMETERS: ./getsite.sh siteURL nameOfTarFile"
    exit 1
fi

FOLDER=$(echo $1|cut -d "/" -f 3)
COUNT=0
HOUR1=0
MINUTE1=0
HOUR2=0
MINUTE2=0

wait_inet(){
  wget -q --spider http://google.com
  while [ $? -ne 0 ]
  do
    echo "NO INTERNET"
    sleep 30
    wget -q --spider http://google.com
  done
  echo "YES INTERNET"
}

mkdir $FOLDER
cd $FOLDER
touch httrack-logs.txt
HOUR1=$(date +"%H")
MINUTE1=$(date +"%M")
date -R >> httrack-logs.txt
httrack $1 -F "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36" >> httrack-logs.txt
date -R >> httrack-logs.txt
HOUR2=$(date +"%H")
MINUTE2=$(date +"%M")
while [ $COUNT -ne 3 ]
do
  if [ $HOUR1 -eq $HOUR2 ] && [ $MINUTE1 -eq $MINUTE2 ]; then
    COUNT=$(($COUNT+1))
    echo "YAY FAST"
  else
    COUNT=0
    echo "NOO WHYY"
  fi
  wait_inet
  echo "DO IT AGAIN"
  HOUR1=$(date +"%H")
  MINUTE1=$(date +"%M")
  date -R >> httrack-logs.txt
  httrack $1 --continue -F "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36" >> httrack-logs.txt
  date -R >> httrack-logs.txt
  HOUR2=$(date +"%H")
  MINUTE2=$(date +"%M")
done
echo "FINISH!"

echo "TAR" >> httrack-logs.txt
tar czf $2.tar.gz $FOLDER >> httrack-logs.txt
echo "SHA256" >> httrack-logs.txt
sha256sum $2.tar.gz >> httrack-logs.txt
