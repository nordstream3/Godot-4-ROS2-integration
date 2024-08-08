extends Camera3D

# initialize ROS viewport node
var ros_viewport = ViewPort.new()

@onready var my_timer = $"../Timer2"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Spin ros node
	ros_viewport.create("godot_image_node1", "image1")
	ros_viewport.spin_some()

	my_timer.timeout.connect(_on_timer_timeout1)
	my_timer.wait_time = 0.05
	my_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout1() -> void:
	# Wait until the frame has finished before getting the texture.
	#RenderingServer.call()
	await RenderingServer.frame_post_draw
	# Retrieve the captured image.
	var img = get_viewport().get_texture().get_image()
	img.convert(Image.FORMAT_RGB8)
	# publish image to ROS
	ros_viewport.pubImage(img)
	#ros_viewport.spin_some()
