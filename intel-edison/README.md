# Intel Edison Setup

# Flash Ubilinux

To flash Ubilinux carefully follow the instruction here http://www.emutexlabs.com/ubilinux/29-ubilinux/218-ubilinux-installation-instructions-for-intel-edison

Make sure you have the console USB cable in place and use it so you know when the installation has finished. You MUST NOT remove power before it’s done or it could be bricked. If you don't have a console connection make sure you wait 2 minutes at the end of the installation as it instructs. During this time it is completing the installion which shoudln't be interrupted.

Connect to the console with 115000 8N1, for example: 

`screen /dev/USB0 115200 8N1` 

and login as root (password: edison)


## Post Ubilinux Install
After Ubilinux has been installed you will end up with the following partitions:

```
Filesystem       Size  Used Avail Use% Mounted on
rootfs           1.4G  520M  796M  40% /
/dev/root        1.4G  520M  796M  40% /
devtmpfs         481M     0  481M   0% /dev
tmpfs             97M  288K   96M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
tmpfs            193M     0  193M   0% /run/shm
tmpfs            481M     0  481M   0% /tmp
/dev/mmcblk0p7    32M  5.1M   27M  16% /boot
/dev/mmcblk0p10  1.6G  2.4M  1.6G   1% /home
```

## Post ROS Install
Once ROS is installed there won't be much space left on the root partition. TODO: Add howto on freeing up space.

```
Filesystem       Size  Used Avail Use% Mounted on
rootfs           1.4G  1.3G   27M  98% /
/dev/root        1.4G  1.3G   27M  98% /
devtmpfs         481M     0  481M   0% /dev
tmpfs             97M  296K   96M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
tmpfs            193M     0  193M   0% /run/shm
tmpfs            481M     0  481M   0% /tmp
/dev/mmcblk0p7    32M  5.1M   27M  16% /boot
/dev/mmcblk0p10  1.6G  156M  1.4G  11% /home
```

# Post Installation Steps

## Wifi
Run `wpa_passphrase your-ssid your-wifi-password` to generate pka.
`cd /etc/network`
Edit interfaces
- Change SSID
- Change pka
- Comment out `auto usb0`
- Uncomment `auto wlan0`
- TODO: Static IP
- Save
Run: `ifup wlan0`

## Update
```
apt-get -y update
apt-get -y upgrade
```

## Locales
```
dpkg-reconfigure locales # Select only en_US.UTF8
locale-gen en_US
update-locale
```
Update the `/etc/default/locale` file an ensure `LANG=en_US.UTF-8` then reboot.

## Timezone
`sudo dpkg-reconfigure tzdata`

## Tools
```
apt-get -y install git
apt-get -y install sudo less
```

## Add User
`useradd px4`
`passwd px4` (set the password to px4)
`usermod -aG sudo px4`
`usermod -aG dialout px4`

Login as px4 to continue.

# ROS Installation

As ROS packages for the Edison/Ubilinux don't exist we will have to build it from source. This process will take about 1.5 hours but most of it is just waiting for it to build.

A script has been writen to automate the building and installation of ROS. Current testing has been copy-pasting line by line to the console. Willing testers are encouraged to try out running the script:

`sudo ./install_ros.sh`

If all went well you should have a ROS installtion. Hook your Edison up to the Pixhawk and run a test. See this page (TODO) for instructions.
