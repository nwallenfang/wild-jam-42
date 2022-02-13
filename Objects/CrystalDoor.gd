extends Spatial


var crystal_count = 0
var positions = null

onready var crystals = [$SlidingDoor/Crystal1, $SlidingDoor/Crystal2, $SlidingDoor/Crystal3]

var start_transform: Transform
var target_transform: Transform
# made this global hope this works
func interpolate_transform(weight: float):
	self.transform = start_transform.interpolate_with(target_transform, weight)
	
func move_to_transform(target_transform_arg: Transform):
	# maybe these two methods can be combined / are interchangable with the new
	# transform.interpolate_with call
	self.target_transform = target_transform_arg
	# back up current transform as starting point for interpolation
	self.start_transform = Transform(transform)
	
	var _distance: float = transform.origin.distance_to(target_transform_arg.origin)
	
	# crystals should 
	
	var duration = 2.5
	
	$Tween.reset_all()  
	$Tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	$Tween.interpolate_method(self, "interpolate_transform", 0.0, 1.0, duration, Tween.TRANS_LINEAR)
	$Tween.start()


func open() -> void:
	print("open")
	# TODO have sand particles flying
	# TODO play cool sound
	yield(get_tree().create_timer(2.4), "timeout")
	# move doormesh down towards ground
	var start = $SlidingDoor.transform
	# works under the assumption that door is perfecly upright
	var move_depth = 4
	var end = start.translated(Vector3(0, -move_depth, 0))
	
	$Tween.reset_all()
	$Tween.interpolate_property($SlidingDoor, "transform", start, end, 2.5)
	$Tween.start()
	


func add_crystal(crystal: Node):
	# move crystal to new parent (CrystalDoor/SlidingDoor)
	crystals[crystal_count].visible = true
	crystal_count += 1
	
	crystal.queue_free()
	if crystal_count == 3:
		open()

const Crystal = preload("res://Objects/Crystal.tscn")
func _on_CrystalDetector_body_entered(body: Node) -> void:
	if body is Player:
		# instantiate crystals from player position and move them towards
		# maybe rotate them a couple of times while they are moving
		# play some ding sound
		
		var player = body as Player
		var current_crystal_count: int = int(crystal_count)
		
		for i in range(player.number_of_crystals):
			var crystal = Crystal.instance()
			# the instanced crystal shouldn't be picked up
			# and shouldn't collide
#			crystal.get_node("PickUpArea/CollisionShape").disabled = true
			crystal.get_node("CollisionShape").disabled = true
			# TODO rotate crystals
			get_tree().current_scene.add_child(crystal)
			crystal.global_transform.origin = player.global_transform.origin
			var pos = crystals[i + current_crystal_count]
			crystal.move_towards(pos.global_transform)
			crystal.connect("movement_done", self, "add_crystal")
			
			yield(get_tree().create_timer(0.3), "timeout")
			
		player.number_of_crystals = 0


func _on_Button_pressed() -> void:
	open()
