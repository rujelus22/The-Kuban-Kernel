#!/sbin/busybox sh
# Logging
#/sbin/busybox cp /data/user.log /data/user.log.bak
#/sbin/busybox rm /data/user.log
#exec >>/data/user.log
#exec 2>&1

mkdir /data/.kuban
chmod 777 /data/.kuban
ccxmlsum=`md5sum /res/customconfig/customconfig.xml | awk '{print $1}'`
if [ "a${ccxmlsum}" != "a`cat /data/.kuban/.ccxmlsum`" ];
then
#  rm -f /data/.kuban/*.profile
  echo ${ccxmlsum} > /data/.kuban/.ccxmlsum
fi
[ ! -f /data/.kuban/default.profile ] && cp /res/customconfig/default.profile /data/.kuban
[ ! -f /data/.kuban/6gestures.sh ] && cp /res/customconfig/6gestures.sh /data/.kuban
if [ /res/customconfig/6gestures.sh -nt /data/.kuban/6gestures.sh ]; then
	cp /res/customconfig/6gestures.sh /data/.kuban
fi

. /res/customconfig/customconfig-helper
read_defaults
read_config

#cpu undervolting
echo "${cpu_undervolting}" > /sys/devices/system/cpu/cpu0/cpufreq/vdd_levels

#change cpu step count
case "${cpustepcount}" in
  5)
    echo 1200 1000 800 500 200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
    ;;
  6)
    echo 1400 1200 1000 800 500 200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
    ;;
  7)
    echo 1500 1400 1200 1000 800 500 200 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
    ;;
  8)
    echo 1600 1400 1200 1000 800 500 200 100 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
    ;;
  9)
    echo 1600 1500 1400 1200 1000 800 500 200 100 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
    ;;
  18)
    echo 1600 1500 1400 1300 1200 1100 1000 900 800 700 600 500 400 300 200 100 50 25 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies
    ;;
esac;

# apply ExTweaks defaults
/res/uci.sh apply

#usb mode
/res/customconfig/actions/usb-mode ${usb_mode}

#start gesture support
/data/.kuban/6gestures.sh
