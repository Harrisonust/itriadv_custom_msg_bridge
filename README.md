# ros1_bridge instruction for itriadv custom msg

在docker下總共有三個workspace itriadv(ros1) itriadv2(ros2) bridge_ws(ros2)

在itriadv跟itriadv2底下分別要有符合ros1 ros2命名規則的 msgs package

## build msgs under itriadv
`source $ROS1_INSTALL_PATH/setup.bash     # setup ros1 env`
`cd ~/itriadv`
`catkin_make --only-pkg-with-deps msgs`

## build msgs under itriadv2
`source $ROS2_INSTALL_PATH/setup.bash     # setup ros2 env`
`cp mapping_rules.yaml /home/itri/itriadv/src/msgs/`
`cp CMakeLists.txt /home/itri/itriadv/src/msgs/`
`cp package.xml /home/itri/itriadv/src/msgs/`
`cd ~/itriadv2`
`colcon build --symlink-install --packages-select msgs`

## build ros1_bridge under bridge_ws
`source $ROS1_INSTALL_PATH/setup.bash `
`source $ROS2_INSTALL_PATH/setup.bash `
`source ~/itriadv/devel/setup.bash`
`source ~/itriadv2/install/setup.bash`
`cd ~/bridge_ws`
`colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure`

## execute ros1_bridge
`source $ROS1_INSTALL_PATH/setup.bash `
`source $ROS2_INSTALL_PATH/setup.bash `
`source ~/itriadv/devel/setup.bash`
`source ~/itriadv2/install/setup.bash`
`cd ~/bridge_ws`
`source ~/bridge_ws/install/setup.bash`
`ros2 run ros1_bridge dynamic_bridge --bridge-all-1to2-topics`
