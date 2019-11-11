dateToday="$(date +%F)"
nowHour="$(date +%H)"
nowMinute="$(date +%M)"
nowTime="$(date +%H:%M)"
#rootDir="$(pwd)
rootDir="/home/brownie/Vagrant/meetingApp/bin"
outputDir="$(dirname $rootDir)/html/one"
dataDir="$rootDir/meetingRoomOne/$dateToday/timeBooked"

if [[ -d $rootDir/meetingRoomOne/$dateToday/timeBooked ]]; then
bookingTimes=($(find $dataDir -type d -printf '%f\n' | sort | grep -v "\." | grep '^[0-9]' | xargs))
else
echo "Contact Receptionist" | tee $outputDir/meetingRoomOneTime
echo "Contact Receptionist" | tee $outputDir/meetingRoomOneNextTime
echo "Vacant" | tee $outputDir/meetingRoomOneAgenda
echo "Vacant" | tee $outputDir/meetingRoomOneNextAgenda
echo "" | tee $outputDir/meetingRoomOneName
echo "" | tee $outputDir/meetingRoomOneNextName
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
  echo $meetingStartTime - $meetingEndTime | tee $outputDir/meetingRoomOneTime
  sed -n 1p meetingRoomOne/$dateToday/timeBooked/$meetingTime/meetingData | tee $outputDir/meetingRoomOneName
  sed -n 2p meetingRoomOne/$dateToday/timeBooked/$meetingTime/meetingData | tee $outputDir/meetingRoomOneAgenda
  upcomingStartTime=$(echo ${bookingTimes[$upcomingIndex]} | cut -d"-" -f1)
  upcomingEndTime=$(echo ${bookingTimes[$upcomingIndex]} | cut -d"-" -f2)
  upcomingTime=$(echo $upcomingStartTime - $upcomingEndTime)
  if [[ -n $upcomingStartTime ]]; then
    echo $upcomingTime | tee $outputDir/meetingRoomOneNextTime
    sed -n 1p meetingRoomOne/$dateToday/timeBooked/$upcomingStartTime-$upcomingEndTime/meetingData | tee $outputDir/meetingRoomOneNextName
    sed -n 2p meetingRoomOne/$dateToday/timeBooked/$upcomingStartTime-$upcomingEndTime/meetingData | tee $outputDir/meetingRoomOneNextAgenda
  else
    echo "Contact Receptionist" | tee $outputDir/meetingRoomOneNextTime
    echo "" | tee $outputDir/meetingRoomOneNextName
    echo "Vacant" | tee $outputDir/meetingRoomOneNextAgenda
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
      echo "Contact Receptionist" | tee $outputDir/meetingRoomOneTime
      echo "" | tee $outputDir/meetingRoomOneName
      echo "Vacant" | tee $outputDir/meetingRoomOneAgenda
      echo "$startHour:$startMinute - $endHour:$endMinute" | tee $outputDir/meetingRoomOneNextTime
      sed -n 1p meetingRoomOne/$dateToday/timeBooked/$upcomingTime/meetingData | tee $outputDir/meetingRoomOneNextName
      sed -n 2p meetingRoomOne/$dateToday/timeBooked/$upcomingTime/meetingData | tee $outputDir/meetingRoomOneNextAgenda
      break;
    fi
  done
fi
