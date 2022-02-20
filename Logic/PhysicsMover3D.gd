extends KinematicBody

class_name PhysicsMover3D

# no problem if the game runs at a different FPS, it's just for readability
const EXPECTED_FPS := 60

export var FRICTION := 0.85
export var AIR_FRICTION := 0.95
export var OLD_DEFAULT_ACC_STRENGTH := 3500.0
export var GRAVITY := 108.0

var velocity := Vector3.ZERO 
var acceleration := Vector3.ZERO 
var gravity_enabled = true setget set_gravity_enabled
var snap_vector := Vector3.DOWN
var up_vector := Vector3.UP


var floor_max_angle = deg2rad(50.0)
var max_slides = 4
var stop_on_slopes = true

# height of the player collider
# this hard-coded value needs to be changed if the player collider changes
var capsule_height = 1.0
# height the player should be able to overcome
var max_warp_height = 0.3
var min_warp_height = 0.0



func add_acceleration(var added_acc: Vector3):
	acceleration += added_acc
	
func add_plane_acceleration(var added_acc: Vector2):
	acceleration += Vector3(added_acc.x, 0, added_acc.y)
	
	
func set_gravity_enabled(grav: bool):
	gravity_enabled = grav


func get_gravity():
	return -1 * GRAVITY * up_vector

func accelerate_and_move(delta: float, acceleration_direction: Vector3 = Vector3.ZERO, acceleration_strength: float = OLD_DEFAULT_ACC_STRENGTH) -> void:
	var added_acc: Vector3
	if acceleration_direction.is_normalized():
		added_acc = acceleration_direction * acceleration_strength
	else:
		added_acc = acceleration_direction
		
	acceleration += added_acc
		
	execute_movement(delta)
	
func start_jumping_kine():
	snap_vector = Vector3.ZERO

func get_in_plane_acceleration() -> Vector2:
	# returns 2d acceleration vector (x, z), so (left/right, forward/backward)
	return Vector2(acceleration.x, acceleration.z)

func execute_movement(delta: float) -> void:
	if gravity_enabled and not is_on_floor():
		add_acceleration(-GRAVITY * Vector3.UP)
	velocity += acceleration * delta
	# apply friction if on the floor
	if is_on_floor():
		velocity = velocity * pow(FRICTION, delta * EXPECTED_FPS)
	else:
		velocity = velocity * pow(AIR_FRICTION, delta * EXPECTED_FPS)

	if velocity.length() < 0.15:
		# to prevent long sliding down ramps
		velocity = Vector3.ZERO
		
#	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, stop_on_slopes, max_slides, floor_max_angle)
	velocity = move_and_slide(velocity, Vector3.UP, stop_on_slopes, max_slides, floor_max_angle)
	var collision: KinematicCollision = get_last_slide_collision()

	if collision != null:
		var height = capsule_height + (collision.position.y - global_transform.origin.y)
		print(height)
		if height > min_warp_height and height < max_warp_height and Input.is_action_pressed("move_forward"):
			translate(Vector3(0.0, height, 0.0))
	
	var just_landed = is_on_floor() and snap_vector == Vector3.ZERO
	if just_landed:
		snap_vector = Vector3.DOWN

	acceleration = Vector3.ZERO 

