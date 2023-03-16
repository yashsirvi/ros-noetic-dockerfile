FROM ros:noetic

ARG UNAME="agv"
ARG UID
ARG GID
USER root

RUN . /opt/ros/noetic/setup.sh
RUN sudo apt-get update
RUN sudo apt-get install -y wget gnupg2 lsb-release
RUN sudo apt-get install -y python3-colcon-common-extensions
RUN sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN sudo wget https://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN sudo apt-get update
RUN sudo sudo apt-get install -y gazebo11

RUN sudo apt-get install -y rospack-tools
RUN sudo apt-get install -y python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential
RUN sudo apt-get install -y python3-rosdep
RUN sudo apt-get install -y ros-noetic-catkin python3-catkin-tools

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
RUN sudo apt-get install -y ros-noetic-desktop-full
RUN sudo apt-get install -y ros-noetic-turtlebot3-gazebo
RUN sudo apt-get install -y ros-noetic-joy
RUN sudo apt-get install -y ros-noetic-rosserial
RUN wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc -O - | sudo apt-key add -
# RUN sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)]  http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN sudo apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting git

# Installing ROS dependencies for turtlebot3
RUN sudo sudo apt-get install -y ros-noetic-joy ros-noetic-teleop-twist-joy \
  ros-noetic-teleop-twist-keyboard ros-noetic-laser-proc \
  ros-noetic-rgbd-launch ros-noetic-rosserial-arduino \
  ros-noetic-rosserial-python ros-noetic-rosserial-client \
  ros-noetic-rosserial-msgs ros-noetic-amcl ros-noetic-map-server \
  ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro \
  ros-noetic-compressed-image-transport ros-noetic-rqt* ros-noetic-rviz \
  ros-noetic-gmapping ros-noetic-navigation ros-noetic-interactive-markers

# Installing turtlebot3 packages
RUN sudo apt install -y ros-noetic-dynamixel-sdk \
    ros-noetic-turtlebot3-msgs \
    ros-noetic-turtlebot3

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
RUN sudo apt-get install -y software-properties-common
RUN sudo apt-get update
RUN sudo apt-get install -y python-dev python-pip-whl python3-dev python3-pip
RUN sudo apt-get install -y curl

# #Setup agv USER
RUN groupadd -g 1000 agv && \
    useradd -d /home/agv -s /bin/bash -m agv -u 1000 -g 1000 && \
    usermod -aG sudo agv && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER $UNAME

WORKDIR /home/$UNAME

RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN wget https://starship.rs/install.sh
RUN chmod +x install.sh
RUN sudo ./install.sh --yes
RUN rm install.sh
RUN echo eval \"\$\(starship init zsh\)\" >> ~/.zshrc
RUN mkdir ~/.config && touch ~/.config/starship.toml
RUN starship preset plain-text-symbols > ~/.config/starship.toml

RUN echo source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh >> ~/.zshrc
RUN echo source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh >> ~/.zshrc
RUN echo zstyle \':completion:*\' menu select >> ~/.zshrc

RUN echo 'source /opt/ros/noetic/setup.zsh' >> ~/.zshrc
