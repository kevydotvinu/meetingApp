export NCURSES_NO_UTF8_ACS=1
INPUT=/tmp/menu.sh.$$
ACTION=/tmp/action.sh.$$
LISTS=/tmp/list.sh.$$
while true; do
	dialog --clear --backtitle "Schedule of Events" \
	--title "[ Meetings ]" \
	--menu "You can use the UP/DOWN arrow keys, the first \n\
	letter of the choice as a hot key, or the \n\
	number keys 1-9 to choose an option.\n\
	Choose Meeting Room:" 15 50 4 \
	1 "Meeting Room I" \
	2 "Meeting Room II" \
	3 "Exit" 2>"${INPUT}"

	menuitem=$(<"${INPUT}")

	# make decsion
	case $menuitem in
		1) DATE=$(dialog --title "Meeting Room I" --backtitle "Schedule of Events" --date-format %F --stdout --calendar Calendar 0 0 0 0)
		   #PWD=$(pwd)
		   PWD=/vagrant/bin
		   ROOM=$PWD/meetingRoomOne

		   dialog --clear --backtitle "Schedule of Events" \
		   --title "[ Meetings I ]" \
		   --menu "Select Action:" 10 30 4 \
		   1 "Booking" \
		   2 "Cancellation" \
		   3 "List Bookings" 2>"${ACTION}"

		   action=$(<"${ACTION}")

		   case $action in
		   	1) mkdir -p $ROOM
		   	   if [ ! -d $PWD/meetingRoomOne/$DATE/timeAvailable ]; then
		   	   	mkdir -p $ROOM/$DATE/timeAvailable
		   	   	while read line
		   	   	do touch $ROOM/$DATE/timeAvailable/$line
		   	   	done < $PWD/timeList
		   	   fi
		   	   declare -a array
		   	   unset array
		   	   i=1 #Index counter for adding to array
		   	   j=1 #Option menu value generator
		   	   while read line
		   	   do
		   	      array[ $i ]=$j
		   	      (( j++ ))
		   	      array[ ($i + 1) ]=$line
		   	      (( i=($i+2) ))

		   	   done < <(find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort) #consume file path provided as argument
		   	   #Define parameters for menu
		   	   TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
		   	   HEIGHT=20
		   	   WIDTH=0
		   	   CHOICE_HEIGHT=16
		   	   BACKTITLE="Schedule of Events"
		   	   TITLE="[ Meeting Room I ]"
		   	   MENU="STARTS:"
		   	   #Build the menu with variables & dynamic content
		   	   startChoice=$(dialog --clear \
		   	                   --backtitle "$BACKTITLE" \
		   	                   --title "$TITLE" \
		   	                   --menu "$MENU" \
		   	                   $HEIGHT $WIDTH $CHOICE_HEIGHT \
		   	                   "${array[@]}" \
		   	                   2>&1 >$TERMINAL)
		   	   if [ ! -z "$startChoice" ]; then
		   	   	STARTS=$(find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort | grep -v "\." | sed -n "$startChoice p")

		   	   	declare -a array
		   	   	unset array
		   	   	i=1 #Index counter for adding to array
		   	   	j=1 #Option menu value generator
		   	   	while read line
		   	   	do
		   	   	   array[ $i ]=$j
		   	   	   (( j++ ))
		   	   	   array[ ($i + 1) ]=$line
		   	   	   (( i=($i+2) ))

		   	   	done < <(find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort) #consume file path provided as argument
		   	   	#Define parameters for menu
		   	   	TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
		   	   	HEIGHT=20
		   	   	WIDTH=0
		   	   	CHOICE_HEIGHT=16
		   	   	BACKTITLE="Schedule of Events"
		   	   	TITLE="[ Meeting Room I ]"
		   	   	MENU="ENDS:"
		   	   	#Build the menu with variables & dynamic content
		   	   	endChoice=$(dialog --clear \
		   	   	                --backtitle "$BACKTITLE" \
		   	   	                --title "$TITLE" \
		   	   	                --menu "$MENU" \
		   	   	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
		   	   	                "${array[@]}" \
		   	   	                2>&1 >$TERMINAL)

		   	   	ENDS=$(find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort | grep -v "\." | sed -n "$endChoice p")
				HR=$(echo "$ENDS-$STARTS" | sed -e 's/:/./g' | bc | cut -d"." -f1)
				HRS=${HR:-00}
				MIN=$(echo "$ENDS-$STARTS" | sed -e 's/:/./g' | bc | cut -d"." -f2)
				MINS=${MIN:-00}
				TIMEDIFF=$(echo "$(echo "$HRS*60" | bc)+$(echo "$MINS")" | bc)
				INDEXDIFF=$(echo "$(echo "$endChoice-$startChoice" | bc)*15" | bc)
		   	   	if [ ! -z "$endChoice" ]; then
		   	   		if [ "$startChoice" -lt "$endChoice" ]; then
						if [ "$TIMEDIFF" -eq "$INDEXDIFF" ]; then

		   	   				Time="Steve Jobs"
		         	   			BookedBy="Kick-Off Meeting"

		         	   			# open fd
		         	   			exec 3>&1

		         	   			# Store data to $VALUES variable
		         	   			VALUES=$(dialog --ok-label "Submit" \
		         	   				  --backtitle "Schedule of Events" \
		         	   				  --title "[ Meeting Room II ]" \
		         	   				  --form "Schedule:" \
		         	   			15 50 0 \
		         	   				"Booked By:" 1 1 "$Time" 1 10 20 0 \
		         	   				"Agenda:" 2 1 "$BookedBy" 2 10 20 0 \
		         	   			2>&1 1>&3)

		         	   			# close fd
		         	   			exec 3>&-

		         	   			# display values just entered
		   	   				if [ ! -z "$VALUES" ]; then
		   	   					mkdir -p $ROOM/$DATE/timeBooked/$STARTS-$ENDS
		   	   					find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort | grep -v "\." | sed -n "$startChoice,$endChoice p" | xargs -i mv $ROOM/$DATE/timeAvailable/{} $ROOM/$DATE/timeBooked/$STARTS-$ENDS/
		         	   					echo "$VALUES" > $ROOM/$DATE/timeBooked/$STARTS-$ENDS/meetingData
		      	   				fi
						else
							dialog --msgbox "Wrong Time Selection" 0 0
						fi
		      	   		else
		   	   	          dialog --msgbox "Wrong Time Selection" 0 0
		   	   		fi
		   	   	fi
		      	   fi
		   	   echo $startChoice $endChoice
		   	   ;;

		      	2) mkdir -p $ROOM/$DATE/timeBooked
		   	   find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" > "${LISTS}"
		   	   if [ -s "${LISTS}" ]; then
		   	   	declare -a array
		   	   	unset array
		   	   	i=1 #Index counter for adding to array
		   	   	j=1 #Option menu value generator
		   	   	while read line
		   	   	do
		   	   	   array[ $i ]=$j
		   	   	   (( j++ ))
		   	   	   array[ ($i + 1) ]=$line
		   	   	   (( i=($i+2) ))

		   	   	done < <(find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | sort | grep -v "\." | grep -v "\/")

		   	   	#Define parameters for menu
		   	   	TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
		   	   	HEIGHT=20
		   	   	WIDTH=0
		   	   	CHOICE_HEIGHT=16
		   	   	BACKTITLE="Schedule of Events"
		   	   	TITLE="[ Meeting Room I ]"
		   	   	MENU="Cancel"
		   	   	#Build the menu with variables & dynamic content
		   	   	cancelChoice=$(dialog --clear \
		   	   	                --backtitle "$BACKTITLE" \
		   	   	                --title "$TITLE" \
		   	   	                --menu "$MENU" \
		   	   	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
		   	   	                "${array[@]}" \
		   	   	                2>&1 >$TERMINAL)
		   	   	if [ ! -z "$cancelChoice" ]; then
		   	   		CANCEL=$(find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" | sort | sed -n "$cancelChoice p")
		   	   		rm $ROOM/$DATE/timeBooked/$CANCEL/meetingData
		   	   		mv $ROOM/$DATE/timeBooked/$CANCEL/*  $ROOM/$DATE/timeAvailable/
		   	   		rm -rf $ROOM/$DATE/timeBooked/$CANCEL
		   	   		#find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" > "${LISTS}"
		      	   	fi
		      	   else
		   		   dialog --msgbox "No Bookings!" 0 0
		   	   fi
		   	   echo "" > "${LISTS}"
		   	   ;;

		      	3) mkdir -p $ROOM/$DATE/timeBooked
		   	   find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" > "${LISTS}"
		   	   if [ -s "${LISTS}" ]; then
		   	   	declare -a array
		   	   	unset array
		   	   	i=1 #Index counter for adding to array
		   	   	j=1 #Option menu value generator
		   	   	while read line
		   	   	do
		   	   	   array[ $i ]=$j
		   	   	   (( j++ ))
		   	   	   array[ ($i + 1) ]=$line
		   	   	   (( i=($i+2) ))

		   	   	done < <(find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" | sort)

		   	   	#Define parameters for menu
		   	   	TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
		   	   	HEIGHT=20
		   	   	WIDTH=0
		   	   	CHOICE_HEIGHT=16
		   	   	BACKTITLE="Schedule of Events"
		   	   	TITLE="[ Meeting Room I ]"
		   	   	MENU="List"
		   	   	#Build the menu with variables & dynamic content
		   	   	listChoice=$(dialog --clear \
		   	   	                --backtitle "$BACKTITLE" \
		   	   	                --title "$TITLE" \
		   	   	                --menu "$MENU" \
		   	   	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
		   	   	                "${array[@]}" \
		   	   	                2>&1 >$TERMINAL)
		   	   	LIST=$(find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" | sort | sed -n "$listChoice p")
		   	   	if [ ! -z "$listChoice" ]; then
		   	   	     dialog --backtitle "Schedule of Events" --title "[ Meeting Room I ]" --textbox "$ROOM/$DATE/timeBooked/$LIST/meetingData" 10 50
		   	   	fi
		      	   else
		   		dialog --msgbox "No Bookings!" 0 0
		   	   fi
		   	   echo "" > "${LISTS}"
		   	   ;;
		   	esac
	 	;;



		2) DATE=$(dialog --title "Meeting Room II" --backtitle "Schedule of Events" --date-format %F --stdout --calendar Calendar 0 0 0 0)
		   #PWD=$(pwd)
			 PWD=/vagrant/bin
		   ROOM=$PWD/meetingRoomTwo

		   dialog --clear --backtitle "Schedule of Events" \
		   --title "[ Meetings II]" \
		   --menu "Select Action:" 10 30 4 \
		   1 "Booking" \
		   2 "Cancellation" \
		   3 "List Bookings" 2>"${ACTION}"

		   action=$(<"${ACTION}")

		   case $action in
		   	1) mkdir -p $ROOM
		   	   if [ ! -d $PWD/meetingRoomTwo/$DATE/timeAvailable ]; then
		   	   	mkdir -p $ROOM/$DATE/timeAvailable
		   	   	while read line
		   	   	do touch $ROOM/$DATE/timeAvailable/$line
		   	   	done < $PWD/timeList
		   	   fi
		   	   declare -a array
		   	   unset array
		   	   i=1 #Index counter for adding to array
		   	   j=1 #Option menu value generator
		   	   while read line
		   	   do
		   	      array[ $i ]=$j
		   	      (( j++ ))
		   	      array[ ($i + 1) ]=$line
		   	      (( i=($i+2) ))

		   	   done < <(find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort) #consume file path provided as argument
		   	   #Define parameters for menu
		   	   TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
		   	   HEIGHT=20
		   	   WIDTH=0
		   	   CHOICE_HEIGHT=16
		   	   BACKTITLE="Schedule of Events"
		   	   TITLE="[ Meeting Room II ]"
		   	   MENU="STARTS:"
		   	   #Build the menu with variables & dynamic content
		   	   startChoice=$(dialog --clear \
		   	                   --backtitle "$BACKTITLE" \
		   	                   --title "$TITLE" \
		   	                   --menu "$MENU" \
		   	                   $HEIGHT $WIDTH $CHOICE_HEIGHT \
		   	                   "${array[@]}" \
		   	                   2>&1 >$TERMINAL)
		   	   if [ ! -z "$startChoice" ]; then
		   	   	STARTS=$(find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort | grep -v "\." | sed -n "$startChoice p")

		   	   	declare -a array
		   	   	unset array
		   	   	i=1 #Index counter for adding to array
		   	   	j=1 #Option menu value generator
		   	   	while read line
		   	   	do
		   	   	   array[ $i ]=$j
		   	   	   (( j++ ))
		   	   	   array[ ($i + 1) ]=$line
		   	   	   (( i=($i+2) ))

		   	   	done < <(find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort) #consume file path provided as argument
		   	   	#Define parameters for menu
		   	   	TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
		   	   	HEIGHT=20
		   	   	WIDTH=0
		   	   	CHOICE_HEIGHT=16
		   	   	BACKTITLE="Schedule of Events"
		   	   	TITLE="[ Meeting Room II ]"
		   	   	MENU="ENDS:"
		   	   	#Build the menu with variables & dynamic content
		   	   	endChoice=$(dialog --clear \
		   	   	                --backtitle "$BACKTITLE" \
		   	   	                --title "$TITLE" \
		   	   	                --menu "$MENU" \
		   	   	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
		   	   	                "${array[@]}" \
		   	   	                2>&1 >$TERMINAL)

		   	   	if [ ! -z "$endChoice" ]; then
		   	   		if [ "$startChoice" -lt "$endChoice" ]; then
		   	   			ENDS=$(find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort | grep -v "\." | sed -n "$endChoice p")

		   	   			Time="Steve Jobs"
		         	   		BookedBy="Kick-Off Meeting"

		         	   		# open fd
		         	   		exec 3>&1

		         	   		# Store data to $VALUES variable
		         	   		VALUES=$(dialog --ok-label "Submit" \
		         	   			  --backtitle "Schedule of Events" \
		         	   			  --title "[ Meeting Room II ]" \
		         	   			  --form "Schedule:" \
		         	   		15 50 0 \
		         	   			"Booked By:" 1 1 "$Time" 1 10 20 0 \
		         	   			"Agenda:" 2 1 "$BookedBy" 2 10 20 0 \
		         	   		2>&1 1>&3)

		         	   		# close fd
		         	   		exec 3>&-

		         	   		# display values just entered
		   	   			if [ ! -z "$VALUES" ]; then
		   	   				mkdir -p $ROOM/$DATE/timeBooked/$STARTS-$ENDS
		   	   				find $ROOM/$DATE/timeAvailable -type f -printf '%f\n' | sort | grep -v "\." | sed -n "$startChoice,$endChoice p" | xargs -i mv $ROOM/$DATE/timeAvailable/{} $ROOM/$DATE/timeBooked/$STARTS-$ENDS/
		         	   				echo "$VALUES" > $ROOM/$DATE/timeBooked/$STARTS-$ENDS/meetingData
		      	   			fi
		      	   		else
		   	   	          dialog --msgbox "Wrong Time Selection" 0 0
		   	   		fi
		   	   	fi
		      	   fi
		   	   echo $startChoice $endChoice
		   	   ;;

		      	2) mkdir -p $ROOM/$DATE/timeBooked
		   	   find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" > "${LISTS}"
		   	   if [ -s "${LISTS}" ]; then
		   	   	declare -a array
		   	   	unset array
		   	   	i=1 #Index counter for adding to array
		   	   	j=1 #Option menu value generator
		   	   	while read line
		   	   	do
		   	   	   array[ $i ]=$j
		   	   	   (( j++ ))
		   	   	   array[ ($i + 1) ]=$line
		   	   	   (( i=($i+2) ))

		   	   	done < <(find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | sort | grep -v "\." | grep -v "\/")

		   	   	#Define parameters for menu
		   	   	TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
		   	   	HEIGHT=20
		   	   	WIDTH=0
		   	   	CHOICE_HEIGHT=16
		   	   	BACKTITLE="Schedule of Events"
		   	   	TITLE="[ Meeting Room II ]"
		   	   	MENU="Cancel"
		   	   	#Build the menu with variables & dynamic content
		   	   	cancelChoice=$(dialog --clear \
		   	   	                --backtitle "$BACKTITLE" \
		   	   	                --title "$TITLE" \
		   	   	                --menu "$MENU" \
		   	   	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
		   	   	                "${array[@]}" \
		   	   	                2>&1 >$TERMINAL)
		   	   	if [ ! -z "$cancelChoice" ]; then
		   	   		CANCEL=$(find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" | sort | sed -n "$cancelChoice p")
		   	   		rm $ROOM/$DATE/timeBooked/$CANCEL/meetingData
		   	   		mv $ROOM/$DATE/timeBooked/$CANCEL/*  $ROOM/$DATE/timeAvailable/
		   	   		rm -rf $ROOM/$DATE/timeBooked/$CANCEL
		   	   		#find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" > "${LISTS}"
		      	   	fi
		      	   else
		   		   dialog --msgbox "No Bookings!" 0 0
		   	   fi
		   	   echo "" > "${LISTS}"
		   	   ;;

		      	3) mkdir -p $ROOM/$DATE/timeBooked
		   	   find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" > "${LISTS}"
		   	   if [ -s "${LISTS}" ]; then
		   	   	declare -a array
		   	   	unset array
		   	   	i=1 #Index counter for adding to array
		   	   	j=1 #Option menu value generator
		   	   	while read line
		   	   	do
		   	   	   array[ $i ]=$j
		   	   	   (( j++ ))
		   	   	   array[ ($i + 1) ]=$line
		   	   	   (( i=($i+2) ))

		   	   	done < <(find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" | sort)

		   	   	#Define parameters for menu
		   	   	TERMINAL=$(tty) #Gather current terminal session for appropriate redirection
		   	   	HEIGHT=20
		   	   	WIDTH=0
		   	   	CHOICE_HEIGHT=16
		   	   	BACKTITLE="Schedule of Events"
		   	   	TITLE="[ Meeting Room II ]"
		   	   	MENU="List"
		   	   	#Build the menu with variables & dynamic content
		   	   	listChoice=$(dialog --clear \
		   	   	                --backtitle "$BACKTITLE" \
		   	   	                --title "$TITLE" \
		   	   	                --menu "$MENU" \
		   	   	                $HEIGHT $WIDTH $CHOICE_HEIGHT \
		   	   	                "${array[@]}" \
		   	   	                2>&1 >$TERMINAL)
		   	   	LIST=$(find $ROOM/$DATE/timeBooked/ -maxdepth 1 -type d -printf '%f\n' | grep -v "\." | grep -v "\/" | sort | sed -n "$listChoice p")
		   	   	if [ ! -z "$listChoice" ]; then
		   	   	     dialog --backtitle "Schedule of Events" --title "[ Meeting Room II ]" --textbox "$ROOM/$DATE/timeBooked/$LIST/meetingData" 10 50
		   	   	fi
		      	   else
		   		dialog --msgbox "No Bookings!" 0 0
		   	   fi
		   	   echo "" > "${LISTS}"
		   	   ;;
		   	esac
	 	;;

		3) echo "Bye";
		   break;
		;;
	esac
done

# if temp files found, delete em
[ -f $INPUT ] && rm $INPUT
[ -f $ACTION ] && rm $ACTION
[ -f $LISTS ] && rm $LISTS
