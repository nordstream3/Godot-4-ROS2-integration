extends Node3D

@export var MAX_STEER = 0.9
@export var ENGINE_POWER = 300

@onready var vehicle = $"../Vehicle/Wheels"
var wheels: Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 4:
		wheels.append( vehicle.get_child(i) )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	"""
	for i in 2:
		var front_wheel = wheels[i] #as VehicleWheel3D
		front_wheel.steering = move_toward(front_wheel.steering, Input.get_axis("move_right", "move_left") * MAX_STEER, delta)
		front_wheel.engine_force = Input.get_axis("move_forward", "move_backward") * ENGINE_POWER
	
		var rear_wheel = wheels[i+2] #as VehicleWheel3D
		rear_wheel.steering = move_toward(rear_wheel.steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta)
		rear_wheel.engine_force = Input.get_axis("move_forward", "move_backward") * ENGINE_POWER
	"""
