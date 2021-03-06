export NCURSES_NO_UTF8_ACS=1
INPUT=/tmp/menu.sh.$$

while true; do
	dialog --clear --backtitle "Schedule of Events" \
	--title "[ Meetings ]" \
	--menu "You can use the UP/DOWN arrow keys, the first \n\
	letter of the choice as a hot key, or the \n\
	number keys 1-9 to choose an option.\n\n\
	Choose Meeting Room:" 15 50 3 \
	1 "Meeting Room I" \
	2 "Meeting Room II" \
	3 "Exit" 2>"${INPUT}"
	
	menuitem=$(<"${INPUT}")
	
	# make decsion 
	case $menuitem in
		1) dialog --title "Meeting Room I" \
		   --backtitle "Schedule of Events" \
		   --yesno "Is it vacant?" 0 0
		   
		   # Get exit status
		   # 0 means user hit [yes] button.
		   # 1 means user hit [no] button.
		   # 255 means user hit [Esc] key.
		   response=$?
		   case $response in
		   	0) echo "Available" > /var/www/html/meetingTimeOne
		   	   echo "" > /var/www/html/meetingBookOne
		   	   ;;
		   	1) Time=""
	           	   BookedBy=""
	           	   
	           	   # open fd
	           	   exec 3>&1
	           	   
	           	   # Store data to $VALUES variable
	           	   VALUES=$(dialog --ok-label "Submit" \
	           	   	  --backtitle "Schedule of Events" \
	           	   	  --title "Meeting Room I" \
	           	   	  --form "Schedule" \
	           	   10 55 0 \
	           	   	"Time: [12:00 PM]" 1 1 "$Time" 1 25 23 0 \
	           	   	"Booked By: [Steve Jobs]" 2 1 "$BookedBy" 2 25 23 0 \
	           	   2>&1 1>&3)
	           	   
	           	   # close fd
	           	   exec 3>&-
	           	   
	           	   # display values just entered
		   	   if [ -n "$VALUES" ]; then
	           	   	echo "$VALUES" | sed -n 1p > /var/www/html/meetingTimeOne
		   	   	echo "$VALUES" | sed -n 2p > /var/www/html/meetingBookOne
		   		 fi
		   	   ;;
		   	255) echo "[ESC] key pressed.";;
		   esac
		   ;;
		
		2) dialog --title "Meeting Room II" \
		   --backtitle "Schedule of Events" \
		   --yesno "Is it vacant?" 0 0
		   
		   # Get exit status
		   # 0 means user hit [yes] button.
		   # 1 means user hit [no] button.
		   # 255 means user hit [Esc] key.
		   response=$?
		   case $response in
		   	0) echo "Available" > /var/www/html/meetingTimeTwo
		   	   echo "" > /var/www/html/meetingBookTwo
		   	   ;;
		   	1) Time=""
	           	   BookedBy=""
	           	   
	           	   # open fd
	           	   exec 3>&1
	           	   
	           	   # Store data to $VALUES variable
	           	   VALUES=$(dialog --ok-label "Submit" \
	           	   	  --backtitle "Schedule of Events" \
	           	   	  --title "Meeting Room II" \
	           	   	  --form "Schedule" \
	           	   10 55 0 \
	           	   	"Time: [12:00 PM]" 1 1 "$Time" 1 25 23 0 \
	           	   	"Booked By: [Steve Jobs]" 2 1 "$BookedBy" 2 25 23 0 \
	           	   2>&1 1>&3)
	           	   
	           	   # close fd
	           	   exec 3>&-
	           	   
	           	   # display values just entered
		   	   if [ -n "$VALUES" ]; then
	           	   	echo "$VALUES" | sed -n 1p > /var/www/html/meetingTimeTwo
		   	   	echo "$VALUES" | sed -n 2p > /var/www/html/meetingBookTwo
		   		 fi
		   	   ;;
		   	255) echo "[ESC] key pressed.";;
		   esac
		   ;;
	
		3) echo "Bye"; break;;
	esac
done
# if temp files found, delete em
[ -f $INPUT ] && rm $INPUT
