extends RigidBody3D

@export var suspension_rest_dist: float = 0.5
@export var spring_strength: float = 500
@export var spring_damper: float = 30
@export var wheel_radius: float = 0.33

@export var debug: bool = false
#@export var drive_power: float = 20

@export var lateral_tire_static_friction: float = 100
@export var lateral_tire_dynamic_friction: float = 20
@export var lateral_transition_velocity: float = 0.04

@export var p: float = 20.0
@export var i: float = 1.0
@export var i_decay: float = 0.98


#@onready var car: RigidBody3D = get_parent().get_parent()
@onready var WheelNodes = $"../Vehicle/Wheels"


#@onready var car: RigidBody3D = get_parent().get_parent()
var wheels: Array[Node] = []
var numbers = [0, 1, 2, 3]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 4:
		wheels.append( WheelNodes.get_child(i) )

	#add_exception(car)
	DebugDraw3D.scoped_config().set_thickness(0.005) #.set_center_brightness(0.6)


func _physics_process(delta: float) -> void:
	numbers.shuffle()
	for i in numbers:
		var w = wheels[i]
		if w.is_colliding():
			var collision_point = w.get_collision_point()
			w.suspension(delta, collision_point)
			#acceleration(collision_point)
			w.apply_z_force(delta, collision_point)
			w.apply_x_force(delta, collision_point)
