FROM ros:noetic
# Setup all the keys and install packages which need root access.
USER root

RUN . /opt/ros/noetic/setup.sh && \
    apt-get update && \
    apt-get install -y wget gnupg2 lsb-release && \
    apt-get install -y python3-colcon-common-extensions && \
    sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list' && \
    wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - && \
    apt-get update && \
    sudo apt-get install -y gazebo11

RUN sudo apt-get install -y rospack-tools && \
    apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential && \
    apt-get install -y python3-rosdep && \
    apt-get install -y ros-noetic-catkin python3-catkin-tools

RUN . /opt/ros/noetic/setup.sh
ENV ROS_PACKAGE_PATH="/opt/ros/noetic/share"
RUN echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
RUN sudo apt-get install -y ros-noetic-ackermann-msgs
RUN sudo apt-get install -y ros-noetic-base-local-planner
RUN sudo apt-get install -y ros-noetic-laser-filters
RUN sudo apt-get install -y ros-noetic-gazebo-ros
RUN sudo apt-get install -y ros-noetic-joint-limits-interface
RUN sudo apt-get install -y ros-noetic-ros-control
RUN sudo apt-get install -y ros-noetic-rviz
RUN sudo apt-get install -y ros-noetic-xacro

RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc -O - | sudo apt-key add - && \
    sh -c 'echo "deb [arch=$(dpkg --print-architecture)]  http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'


# #Setup agv USER
# RUN groupadd -g 1000 agv && \
#     useradd -d /home/agv -s /bin/bash -m agv -u 1000 -g 1000 && \
#     usermod -aG sudo agv && \
#     echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# USER agv
ARG workspace="agv"
RUN mkdir -p /home/$workspace/src
ENV HOME /home/$workspace
WORKDIR /home/$workspace/


#Setup dependencies

RUN sudo apt-get update &&\
    rosdep update &&\
    rosdep install --from-paths src --ignore-src -y 

RUN echo 'source /opt/ros/noetic/setup.bash' >> ~/.bashrc
