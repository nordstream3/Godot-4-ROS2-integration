# Godot-ROS2-Blender Integration repository

This project aims to fuse the powerful open-source game engine Godot 4 with ROS2 (Robot Operating System) framework. Leveraging Godot's modular C++ source code, this integration fits seamlessly into the ROS2 pipeline, providing a supreme platform for developing and testing robotics algorithms in simulated environments.
<div>
<img src="https://github.com/user-attachments/assets/3b0cdcac-ce2d-477f-a930-5dbc7c160f34" width="350" style="float:left; margin-right:10px;">
<img src="https://github.com/user-attachments/assets/fac3542f-1ee2-45be-9fd8-342c4ef00e5b" width="350" style="float:right;">
</div>
<div>
<img src="https://github.com/user-attachments/assets/8f451387-2146-4821-b630-568bd15e4ee7" width="350" style="float:left; margin-right:10px;">
<img src="https://github.com/user-attachments/assets/4ba749a2-1ae8-41bc-afa3-0cc5465fc373" width="350" style="float:right;">
</div>
<div>
<img src="https://github.com/user-attachments/assets/113f7148-e5ad-4ac9-be6f-f37ea868ea11" width="350" style="float:left; margin-right:10px;">
<img src="https://github.com/user-attachments/assets/f65684d4-849c-4168-b79b-bdd8645cb9be" width="350" style="float:right;">
</div>

## This repository contains:

- A C++ ROS2 component build and linked with the C++ Godot 4 source code.
- An example simulation of a mobile robot, created as a Godot 4.4 game.

The example simulation features a **4WS4WD** (4-Wheel Steering, 4-Wheel Driving) setup, where each wheel is configured as a **Swerve Drive**. The robot can be controlled externally through its ROS2 interface. Similarly, it includes a simulated Depth Camera which streams images through its ROS2 node publisher.

## Background

### Godot 4.4 and ROS2

Godot 4.4 is the latest iteration of the Godot game engine, known for its open-source nature, modular architecture, and robust community support. Compared to other popular game engines like Unity and Unreal, Godot stands out due to its lightweight footprint, ease of use, and complete access to its source code. These features make it particularly suitable for integration with other open-source projects, such as ROS2.

Godot's architecture is highly modular, allowing developers to extend or modify its functionality through modules. [Custom Godot modules in C++](https://docs.godotengine.org/en/stable/contributing/development/core_and_modules/custom_modules_in_cpp.html). In the context of ROS2, this modularity enables tight integration with ROS2's middleware, making it possible to run complex simulations and control systems entirely within the Godot environment.

### Create a complete Robotics Application with controls and sensors in a Simulated Environment using Godot 4

The example Robotics Application included in this repository contains a 4WS4WD (4-Wheel Steering, 4-Wheel Driving) configuration, which is an advanced mobile robot setup where each wheel is independently steered and driven, commonly referred to as a **Swerve Drive**. This setup allows for highly maneuverable robots capable of moving in any direction, regardless of their orientation, making them ideal for complex navigation tasks.

Swerve Drive robots are often used in competitive robotics, such as the FIRST Robotics Competition (FRC). The ability to control each wheel's steering angle and speed independently provides unparalleled maneuverability, allowing the robot to rotate on the spot, move sideways, or follow complex paths with precision.

For more information on the 4WS4WD Swerve Drive configuration, consider reviewing the following references:

- [4-Wheel Independent Drive, Independent Steering (Swerve)](https://www.chiefdelphi.com/t/paper-4-wheel-independent-drive-independent-steering-swerve/107383)
- [Swerve Drive Kinematics](https://first.wpi.edu/wpilib/allwpilib/docs/release/java/src-html/edu/wpi/first/math/kinematics/SwerveDriveKinematics.html)
- [Swerve Drive Visualization](https://github.com/xiaoxiae/SwerveDriveVisualisation)

## The Blender-Godot-ROS2 pipeline
What we want for Robotics Simulation is an Open Source true reliable **Game Engine** closely integrated with Blender and ROS2. Use blender for what it's good at - Geometry and Scene Setup. Godot by far has the best integration with Blender compared to other game engines.

### Jolt Physics Engine

While Godot 4 comes with a built-in physics engine, it has been noted that this default engine may not meet the high precision and performance requirements needed for advanced robotics simulations. To address this, this project uses the **Jolt Physics Engine**, a native extension for Godot that provides a more robust and accurate physics simulation environment.

Jolt is known for its high performance and stability, making it well-suited for simulations involving complex physical interactions. For more details on the Jolt Physics Engine and its integration with Godot, refer to the following resources:

- [Jolt Physics Engine for Godot](https://github.com/godot-jolt/godot-jolt)
- [Discussion on Godot 4's Default Physics Engine](https://www.reddit.com/r/godot/comments/16p90a1/godot_4_default_physics_engine_is_a_complete_mess/)

## Features

- **Godot Module for ROS2**: Seamlessly integrate Godot 4 with ROS2 for advanced robotics simulations.
- **Mobile Robot Simulation**: A comprehensive example featuring a 4WS4WD mobile robot with 8 DOF.
- **Jolt Physics Engine**: Utilizes the Jolt Physics Engine for enhanced simulation accuracy and stability.
- **ROS2 Interface**: Control the robot and receive data from a simulated Depth Camera through ROS2.

## Installation

### Prerequisites

- Godot 4.4
- ROS2 (Humble Hawksbill or later)
- Jolt Physics Engine (for Godot)
- rqt_image_view ROS2 add-on

### Building ROS2 from source
You might be able to skip this step, however I had to build ROS2, because of inconsistent libraries on my computer.
Find the instructions for building ROS2 Humble from source [here](https://docs.ros.org/en/humble/Installation/Alternatives/Ubuntu-Development-Setup.html).

### Git Clone & Build additional ROS2 packages

1. 
   ```bash
   cd ~/ros2_humble/src/ros-perception
   git clone https://github.com/ros-perception/vision_opencv.git
   cd ../ros-visualization
   git clone https://github.com/ros-visualization/rqt_image_view.git
   cd ../..
   colcon build --symlink-install

### Download Godot 4.4 source code (at time of writing 4.4 is not yet a release, so just pulling the main branch - latest)

1. Clone repository to a folder of your choice (more info [here](https://docs.godotengine.org/en/stable/contributing/development/compiling/getting_source.html)):
   ```bash
   git clone https://github.com/godotengine/godot.git

### Clone THIS repository

1. Clone repository:
   ```bash
   git clone https://github.com/nordstream3/Godot-4-ROS2-integration.git

2. Edit the "SCsub" file in /path/to/Godot-4-ROS2-integration/src/godot_custom_modules/godot_ros to match your ROS2 distribution and install directory. By default these values are:
   ```bash
   ros_distro = "humble"
   ros_dir = "~/ros2_humble/install"
   
3. Unzip compressed .blend file:
   ```bash
   cd /path/to/Godot-4-ROS2-integration/src/Godot_4WS4WD_simulation_game
   unzip warehouse.blend.zip

4. Build Godot 4.x with ROS2-module:
   ```bash
   cd /path/to/godot-source-code
   scons -j8 verbose=yes disable_exceptions=false SHOWBUILD=1 custom_modules=/path/to/Godot-4-ROS2-integration/src/godot_custom_modules platform=linuxbsd
5. Build Jolt Physics Engine add-on for Godot 4 ([details are here](https://github.com/godot-jolt/godot-jolt)):
   ```bash
   git clone https://github.com/godot-jolt/godot-jolt.git
   cd godot-jolt
   cmake --preset linux-gcc-x64
   cmake --build --preset linux-gcc-x64-distribution
   cmake --build --preset linux-gcc-x64-editor-distribution
   cmake --install build/linux-gcc-x64 --config Distribution --prefix /path/to/Godot-4-ROS2-integration/src/Godot_4WS4WD_simulation_game
   cmake --install build/linux-gcc-x64 --config EditorDistribution --prefix /path/to/Godot-4-ROS2-integration/src/Godot_4WS4WD_simulation_game
   
## Usage
### Running ROS2 integrated 4WS4WD Mobile Robot Simulation (Game)
1. Source ROS2:
   ```bash
   source /path/to/ros2_humble/install/local_setup.bash
2. Run Godot in verbose/debug_info mode:
   ```bash
   ./godot.linuxbsd.editor.x86_64 -v -d
3. Open Godot_4WS4WD_simulation_game and hit the play button to run the game.
4. In a new terminal, subscribe to ROS2 image nodes using "rqt_image_view":
   ```bash
   source /path/to/ros2_humble/install/local_setup.bash
   ros2 run rqt_image_view rqt_image_view

## License
This project is licensed under the GNU General Public License v3.0.

