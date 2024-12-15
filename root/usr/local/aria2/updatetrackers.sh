#! /bin/sh

if [ "$ARIA2_TRACKERS_UPDATE_AUTO" == "true" ]; then
  curl -so /tmp/trackers_all.txt "$ARIA2_TRACKERS_LIST_URL"
  if [ -e "/tmp/trackers_all.txt" ]; then
    Newtrackers="bt-tracker=$(awk NF /tmp/trackers_all.txt|sed ":a;N;s/\n/,/g;ta")"
    Oldtrackers="$(grep bt-tracker= /config/aria2.conf)"
    if [ "$Newtrackers" == "$Oldtrackers" ]; then
      echo trackers文件一样,不需要更新。
    else
      sed -i 's@'"$Oldtrackers"'@'"$Newtrackers"'@g' /config/aria2.conf
      chown aria2:aria2 /config/aria2.conf
      #kill aria2
      if pgrep -f aria2.conf > /dev/null; then
          pkill -f aria2.conf
      fi
      echo 已更新trackers。
    fi
    rm /tmp/trackers_all.txt
  else
    echo 更新文件未正确下载，更新未成功，请检查网络。
  fi
else
  echo 未设定自动更新trackers。
fi
