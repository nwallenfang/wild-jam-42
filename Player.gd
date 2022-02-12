extends PhysicsMover3D

class_name Player

enum State {
	DEFAULT,
	INTERACTING
}

var state = State.DEFAULT

# camera parameters
var cam_acceleration = 40
var mouse_sensitivity = 0.1

# movement parameters
export var CONTROLS_ENABLED := true
export var move_acceleration = 280.0
export var air_acceleration = 70.0
export var jump_total_acceleration = 3000.0
export var ground_dampening = 0.7

onready var camera = $Head/Camera
onready var head = $Head

var node_currently_interacting_with: Node


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

#
#	for coords in [top_left, top_right, bot_left, bot_right]:
#		# always shoot from cross hair position (center of screen)
##		var screen_point: Vector2 = get_viewport().size / 2.0
#		var screen_point: Vector2 = coords
#		var from = camera.project_ray_origin(screen_point)
#		var to = from + camera.project_ray_normal(screen_point) * interact_distance
#
#		var angle = Vector3.UP.angle_to(camera.project_ray_normal(screen_point))
#		var cross = Vector3.UP.cross(camera.project_ray_normal(screen_point)).normalized()
#		print("normal: ", camera.project_ray_normal(screen_point))
#		print("angle: ", angle)
#		print("cross: ", cross)
#
#
#
#		var cyl: Spatial = scene.instance()
#		get_tree().get_current_scene().add_child(cyl)
#		cyl.global_transform.origin = from
#		cyl.rotate(cross, angle)	


onready var scene: PackedScene = preload("res://DebugCyl.tscn")
const interact_distance: float = 100.0
func on_pressed_interact():
	# Cast a ray from center of camera viewport into the world (?)
	var camera = $Head/Camera
	var vp = get_viewport().size
	var top_left = Vector2(0, 0)
	var top_right = Vector2(vp.x, 0)
	var bot_left = Vector2(vp.x, vp.y)
	var bot_right = Vector2(0, vp.y)
	var center = Vector2(vp.x/2, vp.y/2)
	
	for coords in [center]:
		# always shoot from cross hair position (center of screen)
#		var screen_point: Vector2 = get_viewport().size / 2.0
		var screen_point: Vector2 = coords
		var from = camera.project_ray_origin(screen_point)
		var to = from + camera.project_ray_normal(screen_point) * interact_distance
		
		var angle = Vector3.UP.angle_to(camera.project_ray_normal(screen_point))
		var cross = Vector3.UP.cross(camera.project_ray_normal(screen_point)).normalized()
		print("normal: ", camera.project_ray_normal(screen_point))
		print("angle: ", angle)
		print("cross: ", cross)

		

		var cyl: Spatial = scene.instance()
		get_tree().get_current_scene().add_child(cyl)
		cyl.global_transform.origin = from
		cyl.rotate(cross, angle)	
#	cyl.rotate(camera.project_ray_normal(screen_point), deg2rad(-45.0))

	
	
		var directState = PhysicsServer.space_get_direct_state(camera.get_world().get_space())
		var result = directState.intersect_ray(from, to, [self])
	
		var node_to_interact_with: Node = result.get("collider") as Node
		if node_to_interact_with != null and node_to_interact_with.is_in_group("interactable"):
			# have some kind of contract that ever node belonging to interactable
			# has start_interacting() and stop_interacting()
			node_currently_interacting_with = node_to_interact_with
			node_currently_interacting_with.call("start_interacting")
			state = State.INTERACTING

var jump_frame_count := -1
func handle_input(delta):
	if Input.is_action_just_pressed("interact"):
		on_pressed_interact()
	
	var h_rot = global_transform.basis.get_euler().y
	
	if not CONTROLS_ENABLED:
		return
	
	
	var raw_direction := Vector3.ZERO
	raw_direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	raw_direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	
	var move_direction = raw_direction.rotated(Vector3.UP, h_rot).normalized()

	if is_on_floor():
		add_acceleration(move_acceleration * move_direction)
	else:
		# get ourselves some nice air strafing
		add_acceleration(air_acceleration * move_direction)
	
	var start_jumping = is_on_floor() and Input.is_action_just_pressed("jump")
	if start_jumping:
		start_jumping_kine()
		# spread acceleration evenly (we can try unevenly later)
		add_acceleration(jump_total_acceleration * Vector3.UP)


func state_default(delta):
	handle_input(delta)
	execute_movement(delta)
	
func state_interacting(_delta):
	if not Input.is_action_pressed("interact"):
		node_currently_interacting_with.call("stop_interacting")
		state = State.DEFAULT


func match_state(delta):
	match state:
		State.DEFAULT:
			state_default(delta)
		State.INTERACTING:
			state_interacting(delta)


func _physics_process(delta: float) -> void:
	match_state(delta)
	
func _process(delta):
	#camera physics interpolation to reduce physics jitter on high refresh-rate monitors
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_acceleration * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
	
		
func _input(event):
	#get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
