FROM osrf/ros:noetic-desktop-full
ENV DEBIAN_FRONTEND=noninteractive
ENV TURTLEBOT3_MODEL=burger
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    ros-noetic-dynamixel-sdk ros-noetic-turtlebot3-msgs ros-noetic-turtlebot3 ros-noetic-turtlebot3-simulations \
    && rm -rf /var/lib/apt/lists/*

