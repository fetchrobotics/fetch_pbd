# Fetch Programming by Demonstration

TODO: Travis build status and coveralls testing?

This repository is based on PR2 Programming by Demonstration. This version is for the Fetch Robot.

The original [PR2 Programming by Demonstration](https://github.com/PR2/pr2_pbd) was done by [Maya Cakmak](http://www.mayacakmak.com/) and the [Human-Centered Robotics Lab](https://hcrlab.cs.washington.edu/) at the University of Washington.

## System Requirements
This PbD is designed for Ubuntu 14.04 and ROS Indigo.

## Installing
Clone this repository and build on both your desktop machine and on the robot:
```bash
cd ~/catkin_ws/src
git clone https://github.com/fetchrobotics/sandbox.git
cd ~/catkin_ws
catkin_make
```
Note: The above may not work if other things in the sandbox are broken. Just clone the sandbox somewhere else and copy the fetch_pbd repo ONLY into your workspace.

You also need NodeJs, npm, bower and Polymer installed. To install Nodejs and npm, go [here](https://nodejs.org/en/). npm is installed with Nodejs. Then:
```bash
npm install -g bower
npm install -g polymer-cli
cd /path_to_fetch_pbd/fetch_pbd_interaction/web_interface/fetch-pbd-gui
bower install
```

## Running
### Commands on Fetch Robot
#### Terminal #1
```bash
source ~/catkin_ws/devel/setup.bash
roslaunch fetch_pbd_interaction pbd_backend.launch
```
You can run the backend without the "social gaze" head movements or without the sounds by passing arguments to the launch file:
```bash
source ~/catkin_ws/devel/setup.bash
roslaunch fetch_pbd_interaction pbd_backend.launch social_gaze:=false play_sound:=false
```

#### Terminal #2
```bash
source ~/catkin_ws/devel/setup.bash
roslaunch fetch_pbd_interaction pbd_web_frontend.launch
```
#### Terminal #3
This will open the web interface.
```bash
cd /path_to_fetch_pbd/fetch_pbd_interaction/web_interface/fetch-pbd-gui
polymer serve --hostname 0.0.0.0
```
### Using the GUI
In your browser go to ROBOT_NAME:8080 in your browser to use the GUI.

The main page lists all the available actions.
![Main page](https://cloud.githubusercontent.com/assets/1470402/17989388/c71a3da2-6ae1-11e6-9d2f-894a67e508ca.png)
You can directly run/copy/delete actions from the main page. Or hit the "Edit" button to see more information on that action.

On the "Current Action" screen, most of the buttons are pretty self-explanatory. You can execute the entire action using the "Run" button at the bottom of the screen. This will execute all of the primitives in the order they appear in the Primitive List. You can click on a specific primitive (either the marker or the list item), to highlight the primitive.
![](https://cloud.githubusercontent.com/assets/1470402/17989398/d0602b2e-6ae1-11e6-8add-edcedf6285b6.png)

You can show/hide the markers for each primitive by clicking the marker icon for the primitive in the Primitive List.
![](https://cloud.githubusercontent.com/assets/1470402/17989394/d05bf02c-6ae1-11e6-9446-9847bbd419ea.png)

You can change the order of the primitives by dragging them to a new position in the list. 
![](https://cloud.githubusercontent.com/assets/1470402/17989397/d0608290-6ae1-11e6-98a4-bbb1049e1185.png)

You can edit the position and orientation of certain primitives by clicking the edit icon or by moving the interactive marker.
![](https://cloud.githubusercontent.com/assets/1470402/17989393/d05b87ea-6ae1-11e6-85d7-922c6dc4844a.png)

You can change the frame that certain primitives are relative to by right-clicking the marker.
![](https://cloud.githubusercontent.com/assets/1470402/17989395/d05d657e-6ae1-11e6-8236-459118a70b8a.png)

You can also change the name of the action.
![](https://cloud.githubusercontent.com/assets/1470402/17989396/d05f44d4-6ae1-11e6-9363-f242c5ea15b6.png)

### Code Interface
You can also access the actions you've programmed through code. You still need to run pbd_backend.launch (and you can run the frontend stuff too if you want; it won't hurt). Check out the examples folder.
#### Commands on Fetch
```bash
source ~/catkin_ws/devel/setup.bash
rosrun fetch_pbd_interaction test_session_interface.py
```

## System Overview
### Interaction Node
The pbd_interaction_node.py handles the interaction between speech/GUI and the rest of the system. Changes happen through the update loop in interaction.py and also through the callbacks from speech/GUI commands. interaction.py also subscribes to updates from the pbd_world_node.py, which notifies it of changes in objects in the world. Through callbacks and the update loop, interaction.py hooks in to session.py. session.py handles creating actions and primitives and saving them to the database.

### Arm Control Node
The pbd_arm_control_node.py is how the robot's arm is controlled to execute actions/primitives. It provides a lower level service interface to move the arm. The interaction node interacts with this through the interface in robot.py.

### World Node
The pbd_world_node.py handles the robot's perception of the world. Other nodes ask the world node about the state of the world and can both send and subscribe to updates to the world. Its main function is to provide a list of objects currently in the scene.

### Social Gaze Node
The social_gaze_server.py handles the movements of the robot's head. This is also controlled through the robot.py interface. The sounds are also provided through this interface.

