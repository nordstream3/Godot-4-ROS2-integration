extends RayCast3D

@onready var car: RigidBody3D = get_parent().get_parent()

var previous_spring_length: float = 0.0
var error_sum: float = 0.0
var velocity_input: float = 0.0

func _ready() -> void:
	add_exception(car)
	DebugDraw3D.scoped_config().set_thickness(0.005) #.set_center_brightness(0.6)


"""func _physics_process(delta: float) -> void:

	if is_colliding():
		var collision_point = get_collision_point()
		suspension(delta, collision_point)
		#acceleration(collision_point)
		apply_z_force(delta, collision_point)
		apply_x_force(delta, collision_point)"""

func apply_x_force(delta, collision_point):
	var dir: Vector3 = global_basis.x
	#var tire_world_vel: Vector3 = get_point_velocity(global_position)
	var state = PhysicsServer3D.body_get_direct_state( car.get_rid() )
	var tire_world_vel = state.get_velocity_at_local_position( global_position - car.global_position )
	var lateral_vel: float = dir.dot(tire_world_vel)
	var x_force: float
	var col
	if abs(lateral_vel/delta) > car.lateral_transition_velocity:
		x_force = (-lateral_vel/abs(lateral_vel)) * car.lateral_tire_dynamic_friction
		#x_force = -lateral_vel * car.lateral_tire_dynamic_friction
		col = Color.RED
		get_child(0).set_instance_shader_parameter("red_on", 1)

	else:
		x_force = -lateral_vel * car.lateral_tire_static_friction
		col = Color.GREEN
		get_child(0).set_instance_shader_parameter("red_on", 0)

	car.apply_impulse(delta * (dir * x_force), collision_point - car.global_position)

	if car.debug:
		DebugDraw3D.draw_arrow(global_position, global_position + (dir * x_force)/10., col, 0.01, true)


func get_point_velocity(point: Vector3) -> Vector3:
	return car.linear_velocity + car.angular_velocity.cross(point - car.global_position)


func apply_z_force(delta, collision_point):
	var dir: Vector3 = -global_basis.z
	#var tire_world_vel: Vector3 = get_point_velocity(global_position)
	var state = PhysicsServer3D.body_get_direct_state( car.get_rid() )
	var tire_world_vel = state.get_velocity_at_local_position( global_position - car.global_position )

	var error = velocity_input - dir.dot(tire_world_vel)
	error_sum = error_sum * car.i_decay + error
	var z_force = (car.p * error + car.i * error_sum) * dir * car.mass

	#var z_force = dir.dot(tire_world_vel) * car.mass / 10
	car.apply_impulse(delta * z_force, collision_point - car.global_position)
	if car.debug:
		DebugDraw3D.draw_arrow(global_position, global_position + (z_force)/10., Color.BLUE_VIOLET, 0.01, true)
		#var point = Vector3(collision_point.x, collision_point.y, collision_point.z)
		#DebugDraw3D.draw_arrow(point, point + (z_force/10.), Color.BLUE_VIOLET, 0.01, true)


func suspension(delta, collision_point):
	# The direction the force will be applied
	var susp_dir = global_basis.y
	var raycast_origin = global_position
	var raycast_dest = collision_point
	var distance = raycast_dest.distance_to(raycast_origin)
	var spring_length = clamp(distance - car.wheel_radius, 0, car.suspension_rest_dist)
	var spring_force = car.spring_strength * (car.suspension_rest_dist - spring_length)
	var spring_velocity = (previous_spring_length - spring_length) / delta
	var damper_force = car.spring_damper * spring_velocity
	var suspension_force = basis.y * (spring_force + damper_force)
	previous_spring_length = spring_length
	var point = Vector3(collision_point.x, collision_point.y + car.wheel_radius, collision_point.z)
	car.apply_impulse(delta * (susp_dir * suspension_force), point - car.global_position)

	if car.debug:
		#DebugDraw3D.draw_sphere(point, 0)
		DebugDraw3D.draw_arrow(global_position, to_global(position + Vector3(-position.x, (suspension_force.y / 100.), -position.z)), Color.GREEN, 0.01, true)
		DebugDraw3D.draw_line_hit_offset(global_position, to_global(position + Vector3(-position.x, -1, -position.z)), true, distance, 0.01, Color.RED, Color.RED)
