#!/bin/bash

dir="/home/dsibenik/Downloads/Burza/"

echo "Date from (%d.%m.%Y)"
read date_from
echo "Date to (%d.%m.%Y)"
read date_to

readarray stocks < $dir"stock_names.txt"
for i in ${stocks[@]}
do
  link="http://zse.hr/export.aspx?ticker="$i"&reporttype=&DateTo="$date_to"&DateFrom="$date_from"&range=&lang=en&version=2"
  chromium $link
  sleep 3
  mv "/home/dsibenik/Downloads/zse_export_"$i".xlsx" $dir"data/"$i".xlsx"
done

./returns_mon.R
cat ./output.txt
