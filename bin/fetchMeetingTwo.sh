dateToday="$(date +%F)"
nowHour="$(date +%H)"
nowMinute="$(date +%M)"
nowTime="$(date +%H:%M)"
#rootDir="$(pwd)
rootDir="/vagrant/bin"
outputDir="$(dirname $rootDir)/html/one"
dataDir="$rootDir/meetingRoomTwo/$dateToday/timeBooked"

if [[ -d $rootDir/meetingRoomTwo/$dateToday/timeBooked ]]; then
bookingTimes=($(find $dataDir -type d -printf '%f\n' | sort | grep -v "\." | grep '^[0-9]' | xargs))
else
echo "Contact Receptionist" | tee $outputDir/meetingRoomTwoTime
echo "Contact Receptionist" | tee $outputDir/meetingRoomTwoNextTime
echo "Vacant" | tee $outputDir/meetingRoomTwoAgenda
echo "Vacant" | tee $outputDir/meetingRoomTwoNextAgenda
echo "" | tee $outputDir/meetingRoomTwoName
echo "" | tee $outputDir/meetingRoomTwoNextName
fi

for i in ${!bookingTimes[@]}; do
  startHour="$(echo ${bookingTimes[$i]} | cut -d"-" -f1 | cut -d":" -f1)"
  startMinute="$(echo ${bookingTimes[$i]} | cut -d"-" -f1 | cut -d":" -f2)"
  startTime="$startHour:$startMinute"
  endHour="$(echo ${bookingTimes[$i]} | cut -d"-" -f2 | cut -d":" -f1)"
  endMinute="$(echo ${bookingTimes[$i]} | cut -d"-" -f2 | cut -d":" -f2)"
  endTime="$endHour:$endMinute"
  if [[ $nowTime > $startTime ]] || [[ $nowTime == $startTime ]] && [[ $nowTime < $endTime ]] || [[ $nowTime == $endTime ]]; then
    meetingStartTime=${startTime:-NULL}
    meetingEndTime=${endTime:-NULL}
    meetingTime=$meetingStartTime-$meetingEndTime
    meetingTimeIndex=$i
    upcomingIndex=$((i+1))
  fi
done

if [[ -n $meetingTime ]]; then
  echo $meetingStartTime - $meetingEndTime | tee $outputDir/meetingRoomTwoTime
  sed -n 1p meetingRoomTwo/$dateToday/timeBooked/$meetingTime/meetingData | tee $outputDir/meetingRoomTwoName
  sed -n 2p meetingRoomTwo/$dateToday/timeBooked/$meetingTime/meetingData | tee $outputDir/meetingRoomTwoAgenda
  upcomingStartTime=$(echo ${bookingTimes[$upcomingIndex]} | cut -d"-" -f1)
  upcomingEndTime=$(echo ${bookingTimes[$upcomingIndex]} | cut -d"-" -f2)
  upcomingTime=$(echo $upcomingStartTime - $upcomingEndTime)
  if [[ -n $upcomingStartTime ]]; then
    echo $upcomingTime | tee $outputDir/meetingRoomTwoNextTime
    sed -n 1p meetingRoomTwo/$dateToday/timeBooked/$upcomingStartTime-$upcomingEndTime/meetingData | tee $outputDir/meetingRoomTwoNextName
    sed -n 2p meetingRoomTwo/$dateToday/timeBooked/$upcomingStartTime-$upcomingEndTime/meetingData | tee $outputDir/meetingRoomTwoNextAgenda
  else
    echo "Contact Receptionist" | tee $outputDir/meetingRoomTwoNextTime
    echo "" | tee $outputDir/meetingRoomTwoNextName
    echo "Vacant" | tee $outputDir/meetingRoomTwoNextAgenda
  fi
fi

if [[ -z $upcomingIndex ]]; then
  for i in ${!bookingTimes[@]}; do
    startHour="$(echo ${bookingTimes[$i]} | cut -d"-" -f1 | cut -d":" -f1)"
    startMinute="$(echo ${bookingTimes[$i]} | cut -d"-" -f1 | cut -d":" -f2)"
    startTime="$startHour:$startMinute"
    endHour="$(echo ${bookingTimes[$i]} | cut -d"-" -f2 | cut -d":" -f1)"
    endMinute="$(echo ${bookingTimes[$i]} | cut -d"-" -f2 | cut -d":" -f2)"
    endTime="$endHour:$endMinute"
    declare -a dateDiff
    nowDiff="$(date +%H%M)"
    dateDiffValue=$(dateutils.ddiff -i '%H%M' $nowDiff $startHour$startMinute -f %M)
    if [[ $dateDiffValue -gt 0 ]]; then
      dateDiff+=($dateDiffValue)
    fi
    if [[ -n ${dateDiff[0]} ]]; then
      upcomingTime=$startHour:$startMinute-$endHour:$endMinute
      echo "Contact Receptionist" | tee $outputDir/meetingRoomTwoTime
      echo "" | tee $outputDir/meetingRoomTwoName
      echo "Vacant" | tee $outputDir/meetingRoomTwoAgenda
      echo "$startHour:$startMinute - $endHour:$endMinute" | tee $outputDir/meetingRoomTwoNextTime
      sed -n 1p meetingRoomTwo/$dateToday/timeBooked/$upcomingTime/meetingData | tee $outputDir/meetingRoomTwoNextName
      sed -n 2p meetingRoomTwo/$dateToday/timeBooked/$upcomingTime/meetingData | tee $outputDir/meetingRoomTwoNextAgenda
      break;
    fi
  done
fi
