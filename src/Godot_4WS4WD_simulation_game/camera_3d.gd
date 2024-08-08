extends Camera3D

const MOUSE_SENSITIVITY = 0.002

# initialize ROS viewport node
var ros_viewport = ViewPort.new()
var count = 1

@onready var my_timer = $"../Timer"

# The camera movement speed (tweakable using the mouse wheel).
var move_speed := 0.5

# Stores where the camera is wanting to go (based on pressed keys and speed modifier).
var motion := Vector3()

# Stores the effective camera velocity.
var velocity := Vector3()

# The initial camera node rotation.
var initial_rotation := rotation.y

func _ready() -> void:
	# Initialize the project on the default preset.

	# Spin ros node
	ros_viewport.create("godot_image_node", "image")
	ros_viewport.spin_some()

	my_timer.timeout.connect(_on_timer_timeout)
	my_timer.wait_time = 0.04
	my_timer.start()

func _input(event: InputEvent) -> void:
	# Mouse look (effective only if the mouse is captured).
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Horizontal mouse look.
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY
		# Vertical mouse look, clamped to -90..90 degrees.
		rotation.x = clamp(rotation.x - event.relative.y * MOUSE_SENSITIVITY, deg_to_rad(-90), deg_to_rad(90))

	# Toggle mouse capture
	"""if event.is_action_pressed("toggle_mouse_capture"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed("movement_speed_increase"):
		move_speed = min(1.5, move_speed + 0.1)

	if event.is_action_pressed("movement_speed_decrease"):
		move_speed = max(0.1, move_speed - 0.1)"""


func _process(delta: float) -> void:
	if Input.is_action_pressed("move_forward"):
		motion.z = -1
	elif Input.is_action_pressed("move_backward"):
		motion.z = 1
	else:
		motion.z = 0

	if Input.is_action_pressed("move_left"):
		motion.x = -1
	elif Input.is_action_pressed("move_right"):
		motion.x = 1
	else:
		motion.x = 0

	""" if Input.is_action_pressed("move_up"):
		motion.y = 1
	elif Input.is_action_pressed("move_down"):
		motion.y = -1
	else:
		motion.y = 0 """

	# Normalize motion
	# (prevents diagonal movement from being `sqrt(2)` times faster than straight movement).
	motion = motion.normalized()

	# Speed modifier.
	#if Input.is_action_pressed("move_speed"):
	#	motion *= 2

	# Rotate the motion based on the camera angle.
	motion = motion \
		.rotated(Vector3(0, 1, 0), rotation.y - initial_rotation) \
		.rotated(Vector3(1, 0, 0), cos(rotation.y) * rotation.x) \
		.rotated(Vector3(0, 0, 1), -sin(rotation.y) * rotation.x)

	# Add motion, apply friction and velocity.
	velocity += motion * move_speed
	velocity *= 0.9
	position += velocity * delta


func _on_timer_timeout() -> void:
	# print("godot viewport publishing" + String.chr(count))

	# Wait until the frame has finished before getting the texture.
	await RenderingServer.frame_post_draw
	# Retrieve the captured image.
	var img = get_viewport().get_texture().get_image()
	img.convert(Image.FORMAT_RGB8)
	# publish image to ROS
	ros_viewport.pubImage(img)
	#ros_viewport.spin_some()
	count += 1
