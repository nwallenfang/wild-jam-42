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

	
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP)
	
	var just_landed = is_on_floor() and snap_vector == Vector3.ZERO
	if just_landed:
		snap_vector = Vector3.DOWN

	acceleration = Vector3.ZERO 

