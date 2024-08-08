extends Node3D

@onready var mobile_carrier = $"../uploads_files_2883707_warehouse6/Mobile_carrier-rigid"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



#RigidBody3D::set_axis_velocity


func swerve_calculation(x1, y1, x2, W, H):
	var vector_length = sqrt(W * W + H * H)
	H /= vector_length
	W /= vector_length

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

	var max_motor_speed = max(speeds)

	if max_motor_speed > 1:
		for i in range(len(speeds)):
			variables[i] /= max_motor_speed

	return [
		[variables[1], variables[3]],
		[variables[1], variables[2]],
		[variables[0], variables[3]],
		[variables[0], variables[2]]
	]
