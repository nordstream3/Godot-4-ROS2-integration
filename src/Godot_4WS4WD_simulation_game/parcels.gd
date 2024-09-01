extends Node3D

@onready var cage = $"../warehouse/Cube_002"
@onready var pck1 = $"../warehouse/Cube_001"
@onready var pck2 = $"../warehouse/cardboard_simple"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 10:
		var newInstance_pck1 = pck1.duplicate()
		newInstance_pck1.position = cage.position
		newInstance_pck1.position.z -= i*0.1
		newInstance_pck1.position.x += 0.1
		add_child(newInstance_pck1)
		await get_tree().create_timer(0.2).timeout

	for i in 10:
		var newInstance_pck1 = pck1.duplicate()
		newInstance_pck1.position = cage.position
		newInstance_pck1.position.z -= i*0.1
		newInstance_pck1.position.x -= 0.1
		add_child(newInstance_pck1)
		await get_tree().create_timer(0.2).timeout

	for i in 10:
		var newInstance_pck1 = pck1.duplicate()
		newInstance_pck1.position = cage.position
		newInstance_pck1.position.z -= i*0.1
		newInstance_pck1.position.x += 0.1
		add_child(newInstance_pck1)
		await get_tree().create_timer(0.2).timeout

	for i in 10:
		var newInstance_pck1 = pck1.duplicate()
		newInstance_pck1.position = cage.position
		newInstance_pck1.position.z -= i*0.1
		newInstance_pck1.position.x -= 0.1
		add_child(newInstance_pck1)
		await get_tree().create_timer(0.2).timeout
