#!/bin/sh

#ros repo deprecated key fix. should be fixed by replace image!!
sudo apt-key del F42ED6FBAB17C654
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo tee /usr/share/keyrings/ros-archive-keyring.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ros-latest.list > /dev/null
sudo apt update
###########################################

echo INSTALL ROS
apt-get install ros-noetic-mavros ros-noetic-mavros-extras ros-noetic-mavros-msgs   -y
apt-get install ros-noetic-image-geometry                                           -y
apt-get install ros-noetic-resource-retriever                                       -y
apt-get install ros-noetic-serial                                                   -y

wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
bash ./install_geographiclib_datasets.sh



echo CLONE GRIDBOARD
cd /home/ubuntu/catkin_ws/src/

sudo rm -rf /home/ubuntu/catkin_ws/src/bms_manager
sudo rm -rf /home/ubuntu/catkin_ws/src/aruco_gridboard

git clone https://github.com/AlexandrShipovsky/aruco_gridboard.git
git clone https://github.com/Enem-20/bms_manager.git

cd -

echo $PWD CP FILES

rm /opt/ros/noetic/share/mavros/launch/px4_pluginlists.yaml
rm /opt/ros/noetic/share/mavros/launch/apm_config.yaml

cp $PWD/mavros_launch/px4_pluginlists.yaml /opt/ros/noetic/share/mavros/launch/px4_pluginlists.yaml
cp $PWD/mavros_launch/apm_config.yaml /opt/ros/noetic/share/mavros/launch/apm_config.yaml

cd /home/ubuntu/catkin_ws/

echo INSTALL PYTHON DEPENDENCIES
apt update
apt install -y python-is-python3 libxml2-dev libxslt-dev build-essential python3-dev wget
pip3 install future

echo INSTALL pymavlink FROM SOURCE
wget https://files.pythonhosted.org/packages/source/p/pymavlink/pymavlink-2.4.47.tar.gz
tar -xzf pymavlink-2.4.47.tar.gz
tar -xzf pymavlink-2.4.47.tar.gz
(cd pymavlink-2.4.47 && python3 setup.py install)
rm -rf pymavlink-2.4.47 pymavlink-2.4.47.tar.gz

echo MAKE
source /opt/ros/noetic/setup.bash
catkin_make

apt-get install -y ros-noetic-robot-upstart

echo SLEEP_10

sleep 10
source /home/ubuntu/catkin_ws/devel/setup.bash
rosrun robot_upstart install aruco_gridboard/launch/detection_rpicam.launch

cd -

cp -f $PWD/aruco.service /etc/systemd/system/multi-user.target.wants/aruco.service
cp -f /home/ubuntu/catkin_ws/src/bms_manager/bms_manager.service /etc/systemd/system/bms_manager.service

cp -f /home/ubuntu/catkin_ws/src/aruco_gridboard/data/camerav1_640x480.yaml /opt/ros/noetic/share/raspicam_node/camera_info/camerav1_640x480.yaml
cp -f /home/ubuntu/catkin_ws/src/aruco_gridboard/data/camerav1_640x480.launch /opt/ros/noetic/share/raspicam_node/launch/camerav1_640x480.launch

systemctl daemon-reload
systemctl start aruco
systemctl enable bms_manager.service
systemctl start bms_manager.service
