extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var mobile_robot = load("res://mobile_robot.tscn")
	var newInstance = mobile_robot.instantiate()
	newInstance.position.y = 0.5
	add_child(newInstance)
