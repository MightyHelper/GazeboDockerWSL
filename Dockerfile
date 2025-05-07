# Use an official Ubuntu base image
FROM ubuntu:22.04

# Set environment variables to non-interactive
ENV DEBIAN_FRONTEND=noninteractive


# Install necessary packages and update CA certificates
RUN apt-get update && apt-get install -y \
    lsb-release \
    curl \
    gnupg \
    sudo \
    wget \
    build-essential \
    python3-pip \
    git \
    lsb-release \
    software-properties-common \
    ca-certificates \
    locales \
    && rm -rf /var/lib/apt/lists/*
RUN add-apt-repository universe
RUN locale-gen en_US en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	ros-dev-tools \
	ros-humble-desktop \
	ros-humble-gazebo-* \
	ros-humble-cartographer \
	ros-humble-cartographer-ros \
	ros-humble-navigation2 \
	ros-humble-nav2-bringup \
	python3-colcon-common-extensions \
        && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /root/turtlebot3_ws/src
WORKDIR /root/turtlebot3_ws/src/
RUN git clone -b humble https://github.com/ROBOTIS-GIT/DynamixelSDK.git
RUN git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
RUN git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3.git
RUN git clone -b humble https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
WORKDIR /root/turtlebot3_ws
RUN bash -c 'source /opt/ros/humble/setup.bash && colcon build --symlink-install'
RUN echo 'source ~/turtlebot3_ws/install/setup.bash' >> ~/.bashrc
ENV ROS_DOMAIN_ID=30
ENV TURTLEBOT3_MODEL=burger
RUN echo 'source /usr/share/gazebo/setup.sh' >> ~/.bashrc
RUN echo 'source /opt/ros/humble/setup.bash' >> ~/.bashrc
# Entry point to keep the container running with ROS 2 environment
CMD ["bash", "-l"]

