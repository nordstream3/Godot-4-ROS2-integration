extends Node3D

@export var smooth_speed = 0.5
var direction = Vector3.FORWARD

@onready var mobile_carrier = $"../uploads_files_2883707_warehouse6/Mobile_carrier-rigid"
#@onready var mobile_carrier = $"../../../uploads_files_2883707_warehouse6/Mobile_carrier-rigid/Mobile_carrier-rigid"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var current_velocity = mobile_carrier.linear_velocity
	current_velocity.y = 0
	direction = lerp(direction, -current_velocity.normalized(), smooth_speed * delta)
	global_transform.basis = _get_relations_from_direction(direction)

func _get_relations_from_direction(look_direction: Vector3):
	look_direction = look_direction.normalized()
	var x_axis = look_direction.cross(Vector3.UP)
	return Basis(x_axis, Vector3.UP, -look_direction)
