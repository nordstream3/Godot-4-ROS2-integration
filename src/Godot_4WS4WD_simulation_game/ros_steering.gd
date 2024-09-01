extends Node3D

@export var STEER_BUTTON_SENSITIVITY: float = 0.1
@export var SPEED_BUTTON_SENSITIVITY: float = 0.2
@export var MAX_SPEED: float = 5
@export var MAX_STEER: float = 3.14

@export var swerve: bool = false
@export var front_wheel_steering: bool = true

@onready var car_wheels = $"../Vehicle/Wheels"
@onready var foo = $"../Vehicle/Wheels/RR_Wheel"
@onready var my_timer = $"Timer"

static var x1 = 0.0  # left/right axis.
static var y1 = 0.01 # forward/backward axis.
static var x2 = 0.0  # rotation axis.

var W: float
var H: float
var origin_is_set = false
var origin = Vector2(0,0)
var speed = 1.0
var dir = Vector2(0, 1)

var ros_cmd_listener = CmdListener.new()
var wheels: Array[Node] = []
var spd_array = [0,0,0,0]
var angle_speed = [[0.,0.],[0.,0.],[0.,0.],[0.,0.]]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 4:
		var wheel = car_wheels.get_child(i)
		wheels.append(wheel)

	W = abs(wheels[0].transform.origin.x)
	H = abs(wheels[0].transform.origin.z)

	my_timer.timeout.connect(_on_timer_timeout1)
	my_timer.wait_time = 0.08
	my_timer.start()


func get_axis(cmd, neg, pos) -> int:
	if cmd.is_empty():
		return 0
	for i in cmd:
		if i == neg:
			return -1
		elif i == pos:
			return 1
	return 0


func _on_timer_timeout1() -> void:
	# Spin
	ros_cmd_listener.spin_some()
	var cmd_data_str = ros_cmd_listener.get_cmd()
	var keys = []

	if cmd_data_str != "NOCMD":

		if cmd_data_str == "end":
			origin_is_set = false;
		else:
			var split_str = cmd_data_str.split("[")
			var keys_raw = split_str[1].split("]")[0].split(",")
			for i in keys_raw:
				i = i.lstrip(" \"\'").rstrip(" \"\'")
				keys.append(i)
			var mouse_pos = split_str[2].split("]")[0].split_floats(",")
			dir = Vector2(mouse_pos[0], mouse_pos[1])

			if not origin_is_set:
				origin = dir
				origin_is_set = true

			dir = (dir - origin).normalized()
			dir[1] = -dir[1]

	x2 = move_toward(x2, get_axis(keys, "Key.left", "Key.right") * MAX_STEER, STEER_BUTTON_SENSITIVITY)

	var axis = get_axis(keys, "Key.down", "Key.up")
	if axis*speed < 0:
		speed = move_toward(speed, axis * MAX_SPEED, SPEED_BUTTON_SENSITIVITY*3)
	else:
		speed = move_toward(speed, axis * MAX_SPEED, SPEED_BUTTON_SENSITIVITY)

	if swerve:
		var unit: float
		if speed == 0:
			speed = 0.01
			unit = 0
		else:
			unit = speed / abs(speed)
		x1 = dir[0] * abs(speed)
		y1 = dir[1] * abs(speed)
		if unit == 0:
			speed = 0

		var steering_coords = swerve_calculation()

		for i in steering_coords.size():
			angle_speed[i] = get_angle_speed(steering_coords[i])

		for i in wheels.size():
			wheels[i].rotation.y = angle_speed[i][0]
			wheels[i].velocity_input = angle_speed[i][1] * unit
			var spd = -angle_speed[i][1] * unit
			if spd_array[i]*spd < 0 or abs(spd) < 0.1:
				wheels[i].get_child(0).set_instance_shader_parameter("Speed", 0)
			else:
				wheels[i].get_child(0).set_instance_shader_parameter("Speed", spd)
			spd_array[i] = spd

	else:
		var a_s = get_angle_speed(dir)


"""
	* Calculates the speeds and the angles of the swerve chassis depending on the 3 axis inputs.
	* <p>
	* Mainly inspired by the brilliant Ether from Chief Delphi.
	*
	* @param x1 The left/right axis.
	* @param y1 The forward/backward axis.
	* @param x2 The rotation axis.
	* @param W  Width of the chassis.
	* @param H  Height of the chassis.
	* @return A float[][], where each index is a vector of the speed and direction of the motor.
	* @see <a href="https://www.chiefdelphi.com/media/papers/2426">Derivation of Inverse Kinematics for Swerve drive</a>
"""
func swerve_calculation(): # x1, y1, x2, W, H

	var variables = [
		x1 - x2 * H,
		x1 + x2 * H,
		y1 - x2 * W,
		y1 + x2 * W
	]

	"""
	var speeds = [
		sqrt(variables[1] * variables[1] + variables[3] * variables[3]),
		sqrt(variables[1] * variables[1] + variables[2] * variables[2]),
		sqrt(variables[0] * variables[0] + variables[3] * variables[3]),
		sqrt(variables[0] * variables[0] + variables[2] * variables[2])
	]
	
	var max_motor_speed = -INF
	for speed in speeds:
		if speed > max_motor_speed:
			max_motor_speed = speed

	if max_motor_speed > 1:
		for i in range(len(speeds)):
			variables[i] /= max_motor_speed"""

	return [
		[variables[1], variables[3]],
		[variables[1], variables[2]],
		[variables[0], variables[3]],
		[variables[0], variables[2]]
	]

func get_angle_speed(p):
	var s = sqrt(p[0]*p[0] + p[1]*p[1])
	var a
	if s == 0:
		a = 0
	else:
		a = acos(p[1]/s)
	if p[0] > 0:
		a *= -1
	return [a, s]
