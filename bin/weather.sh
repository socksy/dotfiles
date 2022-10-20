#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f "/tmp/current_weather.txt"  ||  $(($(date +%s) - $(stat /tmp/current_weather.txt -c %Y))) -gt 600 ]]; then
  curl -s http://rss.accuweather.com/rss/liveweather_rss.asp\?metric\=1\&locCode=neukolln | grep "Currently in" | tr -d "\r" | sed -e "s/.*<description>Currently in .*: \(.\) &#176;C \(.*\)$/\1°C \2/" > /tmp/current_weather.txt 
fi

cat /tmp/current_weather.txt
#curl -s http://rss.accuweather.com/rss/liveweather_rss.asp\?metric\=1\&loccode=neukolln | grep "Currently in" | tr -d "\n" | sed -e "s/.*<description>Currently in .*: \(.\) &#176;C \(.*\)$/\1°C \2/"
