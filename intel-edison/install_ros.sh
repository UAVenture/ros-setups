#!/bin/bash

# The following installation is based on: http://wiki.ros.org/wiki/edison 
# and http://wiki.ros.org/ROSberryPi/Installing%20ROS%20Indigo%20on%20Raspberry%20Pi

if [ `whoami` == "root" ]; then 
  echo "Do not run this as root!"
  exit 1
fi

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu wheezy main" > /etc/apt/sources.list.d/ros-latest.list'


wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -

#   libconsole-bridge-dev
wget http://archive.raspbian.org/raspbian.public.key -O - | sudo apt-key add -

sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install pkg-config

sudo apt-get -y install python-setuptools python-pip python-yaml python-argparse python-distribute python-docutils python-dateutil python-setuptools python-six


sudo pip install rosdep rosinstall_generator wstool rosinstall

sudo rosdep init
rosdep update

mkdir ~/ros_catkin_ws
cd ~/ros_catkin_ws

#   This will install only mavros and not mavros-extras (no image
#   support which the Edison can’t really handle well anyway).
rosinstall_generator ros_comm mavros --rosdistro indigo --deps --wet-only --exclude roslisp --tar > indigo-ros_comm-wet.rosinstall

wstool init src indigo-ros_comm-wet.rosinstall

mkdir ~/ros_catkin_ws/external_src
sudo apt-get -y install checkinstall cmake
sudo sh -c 'echo "deb-src http://mirrordirector.raspbian.org/raspbian/ testing main contrib non-free rpi" >> /etc/apt/sources.list'

sudo sh -c 'echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list'

sudo apt-get -y update

cd ~/ros_catkin_ws/external_src
sudo apt-get -y build-dep console-bridge
apt-get -y source -b console-bridge
sudo dpkg -i libconsole-bridge0.2_*.deb libconsole-bridge-dev_*.deb

sudo apt-get -y install liblz4-dev

cd ~/ros_catkin_ws
#  Python errors after the following command are normal.
rosdep install --from-paths src --ignore-src --rosdistro indigo -y -r --os=debian:wheezy

echo “******************************************************************”
echo “About to start some heavy building. Go have a looong coffee break.”
echo “******************************************************************”

sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/indigo

echo "source /opt/ros/indigo/setup.bash" >> ~/.profile
source ~/.profile

echo "source ~/ros_catkin_ws/devel_isolated/setup.bash" >> ~/.bashrc
source ~/.bashrc

cd ~/ros_catkin_ws

echo ""
echo "*** FINISHED! ***"

