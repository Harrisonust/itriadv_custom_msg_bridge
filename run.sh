#!/bin/sh
ROS1_INSTALL_PATH=/opt/ros/noetic
ROS2_INSTALL_PATH=/opt/ros/galactic
ITRIADV1_DIR=/home/itri/itriadv
ITRIADV2_DIR=/home/itri/itriadv2
BRIDGE_DIR=/home/itri/bridge_ws

clean_all_ros_var() {
    unset "${!ROS@}"
}

# build msgs under itriadv
source $ROS1_INSTALL_PATH/setup.bash
cd $ITRIADV1_DIR
catkin_make --only-pkg-with-deps msgs

clean_all_ros_var


# build msgs under itriadv2
source $ROS2_INSTALL_PATH/setup.bash     # setup ros2 env
cp mapping_rules.yaml $ITRIADV2_DIR/src/msgs/
cp CMakeLists.txt $ITRIADV2_DIR/src/msgs/
cp package.xml $ITRIADV2_DIR/src/msgs/
cd $ITRIADV2_DIR
colcon build --symlink-install --packages-select msgs

clean_all_ros_var

# build ros1_bridge under bridge_ws
source $ROS1_INSTALL_PATH/setup.bash 
source $ROS2_INSTALL_PATH/setup.bash 
source $ITRIADV1_DIR/devel/setup.bash
source $ITRIADV2_DIR/install/setup.bash
cd $BRIDGE_DIR
colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure

source $BRIDGE_DIR/install/setup.bash
ros2 run ros1_bridge dynamic_bridge --bridge-all-topics
