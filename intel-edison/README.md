# Intel Edison Setup

# Before you Start

Before starting with the installation it's a good idea to boot the Edison straight out of the box to make sure it's working. This way we can make sure we have a functional board before proceeding and we won't be mistakenly blaming setup issues if something is wrong here.

Connect one USB cable to the console port and then start your temrminal app (see next section for more information on this). Once you are connected plug in the second USB cable for power and after 15 seconds you should see the system booting. If you want to login the user name is root (no password).

# Flash Debian

To flash Debian carefully follow the instruction here http://ardupilot.org/dev/docs/intel-edison.html


Make sure you have the console USB cable in place and use it so you know when the installation has finished. You MUST NOT remove power before it’s done or it could be bricked. If you don't have a console connection make sure you wait 2 minutes at the end of the installation as it instructs. During this time it is completing the installion which shoudln't be interrupted. If you don't get any update on your console after this message is displayed restart your console terminal connection.

Connect to the console with 115000 8N1, for example: 

`screen /dev/USB0 115200 8N1` 

and login as root (password: edison)



# Post Installation Steps

## Remove droneapi

sudo pip uninstall droneapi

## Update
```
apt-get -y update
apt-get -y upgrade
```


## Add User
`adduser px4`
`passwd px4` (set the password to px4)
`usermod -aG sudo px4`
`usermod -aG dialout px4`

Login as px4 to continue.

# ROS/MAVROS Installation

As ROS packages for the Edison/Ubilinux don't exist we will have to build it from source. This process will take about 1.5 hours but most of it is just waiting for it to build.

A script has been writen to automate the building and installation of ROS. Current testing has been copy-pasting line by line to the console. Willing testers are encouraged to try out running the script:

```
git clone https://github.com/UAVenture/ros-setups
cd ros-setups/intel-edison/
./install_ros.sh
```

If all went well you should have a ROS installtion. Hook your Edison up to the Pixhawk and run a test. See this page for instructions: https://pixhawk.org/peripherals/onboard_computers/intel_edison

# Python Flight App

Once you have a functional ROS setup you can *very carefully* perform an offboard flight using the setpoint_demo.py script. This script assumes that you have already successfully run `roslaunch mavros px4.launch`.

WARNING WARNING: Make sure you can take control via RC transmitter at any time, things can go quite wrong. Also be aware that there isn't any velocity control currently and the multirotor will use max velocity at times. Read the code before you fly so you know what to expect.

Launch the demo by running:

`./setpoint_demo.py`

and once it is running activate offboard control on your RC transmitter.

## Freeing up Space on the Root Partition

Once again we will remove unneeded files from the root partition. You can delete the files in root's home directory (that's /root) or move them to the home partition.
