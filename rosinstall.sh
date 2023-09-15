#!/bin/sh
apt-get install ros-noetic-mavros ros-noetic-mavros-extras ros-noetic-mavros-msgs -y
apt-get install ros-noetic-image-geometry -y
apt-get install ros-noetic-resource-retriever -y

wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
bash ./install_geographiclib_datasets.sh

cd /home/ubuntu/catkin_ws/src/
git clone https://github.com/AlexandrShipovsky/aruco_gridboard.git

rm /opt/ros/noetic/share/mavros/launch/px4_pluginlists.yaml
rm /opt/ros/noetic/share/mavros/launch/apm_config.yaml

cp $PWD/mavros_launch/px4_pluginlists.yaml /opt/ros/noetic/share/mavros/launch/px4_pluginlists.yaml
cp $PWD/mavros_launch/apm_config.yaml /opt/ros/noetic/share/mavros/launch/apm_config.yaml

cd /home/ubuntu/catkin_ws/
catkin_make

apt-get install ros-noetic-robot-upstart -y

rosrun robot_upstart install aruco_gridboard/launch/detection_rpicam.launch

cp -f $PWD/aruco.service /etc/systemd/system/multi-user.target.wants/aruco.service

systemctl daemon-reload
systemctl start aruco