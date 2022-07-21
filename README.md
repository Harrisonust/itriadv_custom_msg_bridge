# ros1_bridge instruction for itriadv custom msg

總共會牽涉到三個workspace: 
1. itriadv(ros1)
2. itriadv2(ros2)
3. bridge_ws(ros2, to be created)

在itriadv跟itriadv2底下分別要有符合ros1 ros2命名規則的 msgs package

## Preparation
1. Check env variables by 
    ```sh
    printenv | grep -i ros
    ```
2. Comment out all ros-related environmental variables in zshrc/bashrc or other places.
   After cleaning, if there are still ROS env variables set somewhere automatically, you can try the following commands to locate their position:
   
      ```sh
      zsh -xl                                              # for zsh
      PS4='+$BASH_SOURCE> ' BASH_XTRACEFD=7 bash -xl 7>&2  # for bash
      ```
      
    (If you are using autoware image, there is a high chance that the env vairables are sourced in /etc/bash.bashrc)

3. Set handy env variables
    ```sh
    export ROS1_INSTALL_PATH=/opt/ros/noetic
    export ROS2_INSTALL_PATH=/opt/ros/galactic
    ```

## Build msgs under itriadv
```sh
source $ROS1_INSTALL_PATH/setup.bash     # setup ros1 env
cd ~/itriadv
catkin_make --only-pkg-with-deps msgs
```

## Build msgs under itriadv2
```sh
source $ROS2_INSTALL_PATH/setup.bash     # setup ros2 env
cp mapping_rules.yaml /home/itri/itriadv2/src/msgs/
cp CMakeLists.txt /home/itri/itriadv2/src/msgs/
cp package.xml /home/itri/itriadv2/src/msgs/
cd ~/itriadv2
colcon build --symlink-install --packages-select msgs
```

## Build ros1_bridge under bridge_ws
```sh
source $ROS1_INSTALL_PATH/setup.bash 
source $ROS2_INSTALL_PATH/setup.bash 
source ~/itriadv/devel/setup.bash
source ~/itriadv2/install/setup.bash

mkdir -p ~/bridge_ws/src
cd ~/bridge_ws/src/
git clone git@github.com:ros2/ros1_bridge.git
cd ~/bridge_ws
colcon build --symlink-install --packages-select ros1_bridge --cmake-force-configure
```

## Execute ros1_bridge
```sh
source $ROS1_INSTALL_PATH/setup.bash 
source $ROS2_INSTALL_PATH/setup.bash 
source ~/itriadv/devel/setup.bash
source ~/itriadv2/install/setup.bash
source ~/bridge_ws/install/setup.bash
ros2 run ros1_bridge dynamic_bridge --bridge-all-topics
```

