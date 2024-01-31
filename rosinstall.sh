#!/bin/sh
echo INSTALL ROS 
apt-get install ros-noetic-mavros ros-noetic-mavros-extras ros-noetic-mavros-msgs -y
apt-get install ros-noetic-image-geometry -y
apt-get install ros-noetic-resource-retriever -y

wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
bash ./install_geographiclib_datasets.sh

echo CLONE GRIDBOARD
cd /home/ubuntu/catkin_ws/src/
git clone https://github.com/AlexandrShipovsky/aruco_gridboard.git

cd -

echo $PWD CP FILES

rm /opt/ros/noetic/share/mavros/launch/px4_pluginlists.yaml
rm /opt/ros/noetic/share/mavros/launch/apm_config.yaml

cp $PWD/mavros_launch/px4_pluginlists.yaml /opt/ros/noetic/share/mavros/launch/px4_pluginlists.yaml
cp $PWD/mavros_launch/apm_config.yaml /opt/ros/noetic/share/mavros/launch/apm_config.yaml

cd /home/ubuntu/catkin_ws/



echo INSTALL PYTHON
apt install python-is-python3
pip3 install pymavlink

echo MAKE
source /opt/ros/noetic/setup.bash
catkin_make

apt-get install ros-noetic-robot-upstart -y

echo SLEEP_10

sleep 10
source /home/ubuntu/catkin_ws/devel/setup.bash
rosrun robot_upstart install aruco_gridboard/launch/detection_rpicam.launch

cd -

cp -f $PWD/aruco.service /etc/systemd/system/multi-user.target.wants/aruco.service

cp -f /home/ubuntu/catkin_ws/src/aruco_gridboard/data/camerav1_640x480.yaml /opt/ros/noetic/share/raspicam_node/camera_info/camerav1_640x480.yaml
cp -f /home/ubuntu/catkin_ws/src/aruco_gridboard/data/camerav1_640x480.launch /opt/ros/noetic/share/raspicam_node/launch/camerav1_640x480.launch

systemctl daemon-reload
systemctl start aruco
