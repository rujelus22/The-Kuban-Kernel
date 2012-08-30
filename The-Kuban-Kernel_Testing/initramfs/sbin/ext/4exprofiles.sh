#!/system/bin/sh
#
#The Kuban ExTweaks Profile Script V2.0
#8-23-12
#Reworked the entire script
#Added functions to allow for more variables and priorities.
#
#Created by RUJELUS22

source "/data/.kuban/default.profile"

OFF_MODE ()
{
	AWAKE=`cat /sys/power/wait_for_fb_wake`
	if [ $AWAKE = "awake" ];
	then
		CPU_SECONDCORE_ON
		SCREEN_ON_VM
		GESTURES_ON
		ON_BATT_HELPER
	fi
	SLEEPING=`cat /sys/power/wait_for_fb_sleep`
	if [ $SLEEPING = "sleeping" ];  
	then
		SCREEN_OFF_VM
		GESTURES_OFF
		CPU_SECONDCORE_OFF
		OFF_BATT_HELPER
	fi
CHOOSE
}
SCREEN_ON_MODE ()
{
	if [ $enabled = 1 ];
	then
		echo $scaling_governor > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo $scaling_max_freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo $scaling_min_freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	fi
	if [ $enabled = 0 ];
	then
		: # do nothing
	fi
}
SCREEN_OFF_MODE ()
{
	if [ $screen_off_enabled = 1 ];
	then
		echo $scaling_governor_sleep > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo $scaling_max_freq_sleep > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo $scaling_min_freq_sleep > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	fi
	if [ $screen_off_enabled = 0 ];
	then
		: # do nothing
	fi
}
CHARGING_MODE ()
{
	if [ $charging_enabled = 1 ];
	then
		echo $scaling_governor_charging > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo $scaling_max_freq_charging > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo $scaling_min_freq_charging > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	fi
	if [ $charging_enabled = 0 ];
	then
		: # do nothing
	fi
}
LOWBATTERY_MODE ()
{
	if [ $Lowbatt_enabled = 1 ];
	then
		echo $scaling_governor_batt > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
		echo $scaling_max_freq_batt > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo $scaling_min_freq_batt > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	fi
	if [ $Lowbatt_enabled = 0 ];
	then
		: # do nothing
	fi
}
SIO_SCREEN_ON ()
{
	if [ $io_enabled = 1 ];
	then
		echo $scheduler > /sys/block/mmcblk0/queue/scheduler
	fi
	if [ $io_enabled = 0 ];
	then
		: # do nothing
	fi
}
SIO_SCREEN_OFF ()
{
	if [ $io_enabled = 1 ];
	then
		echo $scheduleroff > /sys/block/mmcblk0/queue/scheduler
	fi
	if [ $io_enabled = 0 ];
	then
		: # do nothing
	fi
}
GESTURES_OFF ()
{
	pkill -f "6gestures.sh"
	pkill -f "/sys/devices/virtual/misc/touch_gestures/wait_for_gesture"
}
GESTURES_ON ()
{
	/sbin/busybox sh /data/.kuban/6gestures.sh
}
BOOST_WAKEUP ()
{
	if [ $scaling_max_freq \> 800000 ]; then
		echo $scaling_max_freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	else
		echo 1200000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq
		echo 800000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	fi
}
SCREEN_OFF_VM ()
{
	echo 0 > /proc/sys/vm/dirty_expire_centisecs;
	echo 0 > /proc/sys/vm/dirty_writeback_centisecs;
}
SCREEN_ON_VM ()
{
	echo $dirty_expire_centisecs > /proc/sys/vm/dirty_expire_centisecs;
	echo $dirty_writeback_centisecs > /proc/sys/vm/dirty_writeback_centisecs;
}
CPU_SECONDCORE_ON ()
{
	if [ "${secondcore}" == "hotplug" ]; then
		echo "on" > /sys/devices/virtual/misc/second_core/hotplug_on;
	else
		echo "off" > /sys/devices/virtual/misc/second_core/hotplug_on;
	fi;

	if [ "${secondcore}" == "always-off" ]; then
		echo "off" > /sys/devices/virtual/misc/second_core/second_core_on;
	fi;

	if [ "${secondcore}" == "always-on" ]; then
		echo "on" > /sys/devices/virtual/misc/second_core/second_core_on;
	fi;

	echo on > /sys/devices/virtual/misc/second_core/second_core_on;
	echo $load_h0 > /sys/module/stand_hotplug/parameters/load_h0;
	echo $load_l1 > /sys/module/stand_hotplug/parameters/load_l1;
}
CPU_SECONDCORE_OFF ()
{
	echo off > /sys/devices/virtual/misc/second_core/hotplug_on;
	echo off > /sys/devices/virtual/misc/second_core/second_core_on;
}
OFF_BATT_HELPER ()
{
	echo $rateoff > /sys/module/stand_hotplug/parameters/rate
	echo "5" > /proc/sys/kernel/panic
}
ON_BATT_HELPER ()
{
	echo $rate > /sys/module/stand_hotplug/parameters/rate
	echo $panic > /proc/sys/kernel/panic
}

SCREEN_OFF_CHARGING_LOWBATT ()
{
#Screen Off - Charging - Low Batt - Screen On
	BATTERY_LEVEL=`cat /sys/class/power_supply/battery/capacity`
	source "/data/.kuban/default.profile"
	AWAKE=`cat /sys/power/wait_for_fb_wake`
	if [ $AWAKE = "awake" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SIO_SCREEN_ON
				SCREEN_ON_VM
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				SCREEN_ON_MODE
				SIO_SCREEN_ON
				SCREEN_ON_VM
				GESTURES_ON
			fi
		fi
		if [ $CHARCHING = Charging ];
		then
			CPU_SECONDCORE_ON
			BOOST_WAKEUP
			ON_BATT_HELPER
			sleep 5
			CHARGING_MODE
			SIO_SCREEN_ON
			SCREEN_ON_VM
			GESTURES_ON
		fi
		AWAKE=	
	fi
	SLEEPING=`cat /sys/power/wait_for_fb_sleep`
	if [ $SLEEPING = "sleeping" ]; 
	then
		SIO_SCREEN_OFF
		SCREEN_OFF_VM
		SCREEN_OFF_MODE
		GESTURES_OFF
		CPU_SECONDCORE_OFF
		OFF_BATT_HELPER
	SLEEPING=
	fi    
CHOOSE
}
SCREEN_OFF_LOWBATT_CHARGING ()
{
#Screen Off - Low Batt - Charging - Screen On
	BATTERY_LEVEL=`cat /sys/class/power_supply/battery/capacity`
	source "/data/.kuban/default.profile"
	AWAKE=`cat /sys/power/wait_for_fb_wake`
	if [ $AWAKE = "awake" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				SCREEN_ON_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
		fi
		if [ $CHARCHING = Charging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				CHARGING_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
		fi
		AWAKE=	
	fi
	SLEEPING=`cat /sys/power/wait_for_fb_sleep`
	if [ $SLEEPING = "sleeping" ]; 
	then
		SIO_SCREEN_OFF
		SCREEN_OFF_VM
		SCREEN_OFF_MODE
		GESTURES_OFF
		CPU_SECONDCORE_OFF
		OFF_BATT_HELPER
	SLEEPING=
	fi    
CHOOSE
}
CHARGING_LOWBATT_SCREEN_OFF ()
{
#Charging - Low Batt - Screen Off - Screen On
	BATTERY_LEVEL=`cat /sys/class/power_supply/battery/capacity`
	source "/data/.kuban/default.profile"
	AWAKE=`cat /sys/power/wait_for_fb_wake`
	if [ $AWAKE = "awake" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				SCREEN_ON_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
		fi
		if [ $CHARCHING = Charging ];
		then
			CPU_SECONDCORE_ON
			BOOST_WAKEUP
			ON_BATT_HELPER
			sleep 5
			CHARGING_MODE
			SCREEN_ON_VM
			SIO_SCREEN_ON
			GESTURES_ON
		fi
		AWAKE=	
	fi
	SLEEPING=`cat /sys/power/wait_for_fb_sleep`
	if [ $SLEEPING = "sleeping" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				SIO_SCREEN_OFF
				SCREEN_OFF_VM
				LOWBATTERY_MODE
				GESTURES_OFF
				CPU_SECONDCORE_OFF
				OFF_BATT_HELPER
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				SIO_SCREEN_OFF
				SCREEN_OFF_VM
				SCREEN_OFF_MODE
				GESTURES_OFF
				CPU_SECONDCORE_OFF
				OFF_BATT_HELPER
			fi
		fi
		if [ $CHARCHING = Charging ];
		then
			SIO_SCREEN_OFF
			SCREEN_OFF_VM
			CHARGING_MODE
			GESTURES_OFF
			CPU_SECONDCORE_OFF
			OFF_BATT_HELPER
		fi	
	SLEEPING=
	fi    
CHOOSE
}
CHARGING_SCREEN_OFF_LOWBATT ()
{
#Charging - Screen Off - Low Batt - Screen On
	BATTERY_LEVEL=`cat /sys/class/power_supply/battery/capacity`
	source "/data/.kuban/default.profile"
	AWAKE=`cat /sys/power/wait_for_fb_wake`
	if [ $AWAKE = "awake" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				SCREEN_ON_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
		fi
		if [ $CHARCHING = Charging ];
		then
			CPU_SECONDCORE_ON
			BOOST_WAKEUP
			ON_BATT_HELPER
			sleep 5
			CHARGING_MODE
			SCREEN_ON_VM
			SIO_SCREEN_ON
			GESTURES_ON
		fi
		AWAKE=	
	fi
	SLEEPING=`cat /sys/power/wait_for_fb_sleep`
	if [ $SLEEPING = "sleeping" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			SIO_SCREEN_OFF
			SCREEN_OFF_VM
			SCREEN_OFF_MODE
			GESTURES_OFF
			CPU_SECONDCORE_OFF
			OFF_BATT_HELPER
		fi
		if [ $CHARCHING = Charging ];
		then
			SIO_SCREEN_OFF
			SCREEN_OFF_VM
			CHARGING_MODE
			GESTURES_OFF
			CPU_SECONDCORE_OFF
			OFF_BATT_HELPER
		fi
	SLEEPING=
	fi    
CHOOSE
}
LOWBATT_CHARGING_SCREEN_OFF ()
{
#Low Batt - Charging - Screen Off - Screen On
	BATTERY_LEVEL=`cat /sys/class/power_supply/battery/capacity`
	source "/data/.kuban/default.profile"
	AWAKE=`cat /sys/power/wait_for_fb_wake`
	if [ $AWAKE = "awake" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				SCREEN_ON_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
		fi
		if [ $CHARCHING = Charging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				CHARGING_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
		fi
		AWAKE=	
	fi
	SLEEPING=`cat /sys/power/wait_for_fb_sleep`
	if [ $SLEEPING = "sleeping" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				SIO_SCREEN_OFF
				SCREEN_OFF_VM
				LOWBATTERY_MODE
				GESTURES_OFF
				CPU_SECONDCORE_OFF
				OFF_BATT_HELPER
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				SIO_SCREEN_OFF
				SCREEN_OFF_VM
				SCREEN_OFF_MODE
				GESTURES_OFF
				CPU_SECONDCORE_OFF
				OFF_BATT_HELPER
			fi	
		fi
		if [ $CHARCHING = Charging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				SIO_SCREEN_OFF
				SCREEN_OFF_VM
				LOWBATTERY_MODE
				GESTURES_OFF
				CPU_SECONDCORE_OFF
				OFF_BATT_HELPER
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				SIO_SCREEN_OFF
				SCREEN_OFF_VM
				CHARGING_MODE
				GESTURES_OFF
				CPU_SECONDCORE_OFF
				OFF_BATT_HELPER
			fi	
		fi
	SLEEPING=
	fi    
CHOOSE
}
LOWBATT_SCREEN_OFF_CHARGING ()
{
#Low Batt - Screen Off - Charging - Screen On
	BATTERY_LEVEL=`cat /sys/class/power_supply/battery/capacity`
	source "/data/.kuban/default.profile"
	AWAKE=`cat /sys/power/wait_for_fb_wake`
	if [ $AWAKE = "awake" ]; 
	then
	CHARCHING=`cat /sys/class/power_supply/battery/status`
		if [ $CHARCHING = Discharging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				SCREEN_ON_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
		fi
		if [ $CHARCHING = Charging ];
		then
			if [ $BATTERY_LEVEL -le $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				LOWBATTERY_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
			if [ $BATTERY_LEVEL -gt $lowbatt ];
			then
				CPU_SECONDCORE_ON
				BOOST_WAKEUP
				ON_BATT_HELPER
				sleep 5
				CHARGING_MODE
				SCREEN_ON_VM
				SIO_SCREEN_ON
				GESTURES_ON
			fi
		fi
		AWAKE=	
	fi
	SLEEPING=`cat /sys/power/wait_for_fb_sleep`
	if [ $SLEEPING = "sleeping" ]; 
	then
		if [ $BATTERY_LEVEL -le $lowbatt ];
		then
			SIO_SCREEN_OFF
			SCREEN_OFF_VM
			GESTURES_OFF	
			LOWBATTERY_MODE
			CPU_SECONDCORE_OFF
			OFF_BATT_HELPER
		fi
		if [ $BATTERY_LEVEL -gt $lowbatt ];
		then
			SIO_SCREEN_OFF
			SCREEN_OFF_VM
			GESTURES_OFF
			SCREEN_OFF_MODE
			CPU_SECONDCORE_OFF
			OFF_BATT_HELPER
		fi
	SLEEPING=
	fi    
CHOOSE
}

CHOOSE ()
{
source "/data/.kuban/default.profile"
if [ $enabled = 0 ];
then
	OFF_MODE
fi
if [ $enabled = 1 ];
then
	if [ $priority1 = screenoff ] && [ $priority2 = charging ] && [ $priority3 = lowbatt ]; 
	then
		SCREEN_OFF_CHARGING_LOWBATT
	fi
	if [ $priority1 = screenoff ] && [ $priority2 = lowbatt ] && [ $priority3 = charging ]; 
	then
		SCREEN_OFF_LOWBATT_CHARGING
	fi
	if [ $priority1 = charging ] && [ $priority2 = lowbatt ] && [ $priority3 = screenoff ]; 
	then
		CHARGING_LOWBATT_SCREEN_OFF
	fi
	if [ $priority1 = charging ] && [ $priority2 = screenoff ] && [ $priority3 = lowbatt ]; 
	then
		CHARGING_SCREEN_OFF_LOWBATT
	fi
	if [ $priority1 = lowbatt ] && [ $priority2 = charging ] && [ $priority3 = screenoff ]; 
	then
		LOWBATT_CHARGING_SCREEN_OFF
	fi
	if [ $priority1 = lowbatt ] && [ $priority2 = screenoff ] && [ $priority3 = charging ]; 
	then
		LOWBATT_SCREEN_OFF_CHARGING
	fi
fi
}


CHOOSE

