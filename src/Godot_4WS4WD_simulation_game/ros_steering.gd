extends Node3D

@export var MAX_STEER = 3.14
@export var INC_STEER = 0.1
@export var MAX_POWER = 300
@export var INC_POWER = 1

@onready var vehicle = $"../VehicleBody3D"
@onready var my_timer = $"Timer"

static var x1 = 0.0 #-0.688354576 # left/right axis.
static var y1 = 0.01 #0.725374371 # forward/backward axis.
static var x2 = 0.0 #-0.83 # rotation axis.

static var W = 202.0
static var H = 292.0
static var origin_is_set = false
static var origin = Vector2(0,0)
static var speed = 0
static var dir = Vector2(0, 1)


var ros_cmd_listener = CmdListener.new()
var wheels: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 4:
		wheels.append( vehicle.get_child(i) )

	my_timer.timeout.connect(_on_timer_timeout1)
	my_timer.wait_time = 0.1
	my_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
"""func _process(delta: float) -> void:
	for i in 2:
		var front_wheel = wheels[i] #as VehicleWheel3D
		front_wheel.steering = move_toward(front_wheel.steering, Input.get_axis("move_right", "move_left") * MAX_STEER, delta)
		front_wheel.engine_force = Input.get_axis("move_forward", "move_backward") * ENGINE_POWER
	
		var rear_wheel = wheels[i+2] #as VehicleWheel3D
		rear_wheel.steering = move_toward(rear_wheel.steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta)
		rear_wheel.engine_force = Input.get_axis("move_forward", "move_backward") * ENGINE_POWER
"""

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

	x2 = move_toward(x2, get_axis(keys, "Key.right", "Key.left") * MAX_STEER, INC_STEER)
	speed = move_toward(speed, get_axis(keys, "Key.down", "Key.up") * MAX_POWER, INC_POWER)

	x1 = dir[0] * speed / 100.0
	y1 = dir[1] * speed / 100.0

	print("x1: %f, y1: %f, x2: %f" % [x1, y1, x2])

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
			variables[i] /= max_motor_speed

	return [
		[variables[1], variables[3]],
		[variables[1], variables[2]],
		[variables[0], variables[3]],
		[variables[0], variables[2]]
	]

func get_angle_speed(p):
	var s = sqrt(p[0]*p[0] + p[1]*p[1])
	var a = acos(p[1]/s) #* 180 / PI
	if p[0] > 0:
		a *= -1
	return [a, s]
