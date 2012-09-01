#!/sbin/busybox sh
#
# The Kuban Touch Gestures
#
#8-25-12
#
#Created by RUJELUS22

source "/data/.kuban/default.profile"
if [ $screengestures = 1 ]; then
	echo "
	# Gesture 1 - swipe 1 finger near the top and one near the bottom from left to right
	1:1:(0|150,0|200)     # Top Left
	1:1:(330|480,0|200)   # Top Right
	1:2:(0|150,600|800)   # Bottom Left
	1:2:(330|480,600|800) # Bottom Right

	# Gesture 2 - finger draws an Z starting at the top left
	2:1:(0|150,0|200)      # Top Left
	2:1:(330|480,0|200)    # Top Right
	2:1:(0|150,600|800)    # Bottom Left
	2:1:(330|480,600|800)  # Bottom Right

	# Gesture 3 - 2 Right Arrow
	3:1:(0|150,0|200) # Top Left
	3:1:(300|480,300|500) # Middle Right
	3:2:(0|150,600|800) # Bottom Left
	3:2:(300|480,300|500) # Middle Right

	#Gesture 4 - Upsidown Traingle Counterclockwise
	4:1:(200|280,699|799) # Bottom Middle
	4:1:(0|150,0|200) # Top Left
	4:1:(330|480,0|200) # Top Right
	4:1:(200|280,699|799) # Bottom Middle

	#Gesture 5 - Traingle Counterclockwise
	5:1:(200|280,0|200) # Top Middle
	5:1:(0|150,600|800) # Bottom Left
	5:1:(330|480,600|800)  # Bottom Right
	5:1:(200|280,0|200) # Top Middle

	#Gesture 6 - Diamond starting at the top Clockwise
	6:1:(200|280,0|200) # Top Middle
	6:1:(300|480,300|500) # Right Middle
	6:1:(160|320,699|799)  # Bottom Middle
	6:1:(0|200,300|500) # Left Middle
	6:1:(200|280,0|200) # Top Middle

	# Gesture 7 - \ Bottom right to Top left to Bottom Right
	7:1:(330|480,600|800)  # Bottom Right
	7:1:(0|150,0|200) # Top Left
	7:1:(330|480,600|800)  # Bottom Right

	# Gesture 8 - \ Top left to Bottom right to Top Left
	8:1:(0|150,0|200) # Top Left
	8:1:(330|480,600|800)  # Bottom Right
	8:1:(0|150,0|200) # Top Left

	# Gesture 9 - 1 finger from bottom-left, bottom-right, bottom-left
	9:1:(0|150,600|800)   # bottom left
	9:1:(330|480,600|800) # bottom right
	9:1:(0|150,600|800)   # bottom left

	# Gesture 10 - 1 finger from top-left, top-right, top-left
	10:1:(0|150,0|200)   # top left
	10:1:(330|480,0|200) # top right
	10:1:(0|150,0|200)   # top left

	" > /sys/devices/virtual/misc/touch_gestures/gesture_patterns

	( while [ 1 ]
	do
		Gesture=`cat /sys/devices/virtual/misc/touch_gestures/wait_for_gesture`
		app1="com.android.browser/.BrowserActivity"
		app2="com.android.calendar/.AllInOneActivity"
		app3="com.sec.android.app.camera/.Camera"
		app4="com.android.email/.activity.Welcome"
		app5="com.google.android.apps.maps/com.google.android.maps.MapsActivity"
		app6="com.android.mms/.ui.ConversationComposer"
		app7="com.android.settings/.Settings"
		app8="com.google.android.talk/.BuddyListCombo"
		app9="com.darekxan.extweaks.app/.ExTweaksActivity"
		app10="wimax"
		ges1="on"
		ges2="on"
		ges3="on"
		ges4="on"
		ges5="on"
		ges6="on"
		ges7="on"
		ges8="on"
		ges9="on"
		ges10="on"
	
		if [ "$Gesture" == "1" ]; then
			if [ $ges1 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app1 = recent ]; then
					input keyevent 187
				elif [ $app1 = "music" ]; then
					input keyevent 85
				elif [ $app1 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app1 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app1 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app1 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app1 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app1
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "2" ]; then
			if [ $ges2 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app2 = recent ]; then
					input keyevent 187
				elif [ $app2 = "music" ]; then
					input keyevent 85
				elif [ $app2 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app2 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app2 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app2 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app2 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app2
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "3" ]; then
			if [ $ges3 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app3 = recent ]; then
					input keyevent 187
				elif [ $app3 = "music" ]; then
					input keyevent 85
				elif [ $app3 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app3 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app3 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app3 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app3 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app3
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "4" ]; then
			if [ $ges4 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app4 = recent ]; then
					input keyevent 187
				elif [ $app4 = "music" ]; then
					input keyevent 85
				elif [ $app4 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app4 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app4 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app4 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app4 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app4
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "5" ]; then
			if [ $ges5 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app5 = recent ]; then
					input keyevent 187
				elif [ $app5 = "music" ]; then
					input keyevent 85
				elif [ $app5 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app5 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app5 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app5 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app5 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app5
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "6" ]; then
			if [ $ges6 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app6 = recent ]; then
					input keyevent 187
				elif [ $app6 = "music" ]; then
					input keyevent 85
				elif [ $app6 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app6 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app6 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app6 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app6 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app6
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "7" ]; then
			if [ $ges7 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app7 = recent ]; then
					input keyevent 187
				elif [ $app7 = "music" ]; then
					input keyevent 85
				elif [ $app7 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app7 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app7 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app7 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app7 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app7
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "8" ]; then
			if [ $ges8 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app8 = recent ]; then
					input keyevent 187
				elif [ $app8 = "music" ]; then
					input keyevent 85
				elif [ $app8 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app8 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app8 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app8 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app8 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app8
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "9" ]; then
			if [ $ges9 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app9 = recent ]; then
					input keyevent 187
				elif [ $app9 = "music" ]; then
					input keyevent 85
				elif [ $app9 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app9 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app9 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app9 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app9 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app9
				fi
			fi
			: #do nothing
		elif [ "$Gesture" == "10" ]; then
			if [ $ges10 = "on" ]; then
				service call vibrator 2 i32 100 i32 0
				if [ $app10 = recent ]; then
					input keyevent 187
				elif [ $app10 = "music" ]; then
					input keyevent 85
				elif [ $app10 = "switchapp" ]; then
					previous_task=`dumpsys activity a | grep "Recent #1" | grep -o -E "#[0-9]+ " | cut -c2-`
					service call activity 24 i32 $previous_task i32 2
				elif [ $app10 = "bluetooth" ]; then
					service call bluetooth 1 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call bluetooth 3
					else
						service call bluetooth 4
					fi
				elif [ $app10 = "data" ]; then
					service call connectivity 18 | grep "0 00000000"
					if [ "$?" -eq "0" ]; then
						service call connectivity 19 i32 1
					else
						service call connectivity 19 i32 0
					fi
				elif [ $app10 = "wifi" ]; then
					service call wifi 14 | grep "0 00000001"
					if [ "$?" -eq "0" ]; then
						service call wifi 13 i32 1
					else
						service call wifi 13 i32 0
					fi
				elif [ $app10 = "wimax" ]; then
					service call WiMax 9 | grep "0 00000001" > /dev/null
					if [ "$?" -eq "0" ]; then
						service call WiMax 8 i32 1 > /dev/null
					else
						service call WiMax 8 i32 0 > /dev/null
					fi
				else
					am start $app10
				fi
			fi
			: #do nothing
		fi
	done ) > /dev/null 2>&1 &
fi
