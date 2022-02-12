extends Spatial


var crystal_count = 0
var positions = null

onready var crystal_positions = [$Socket/SocketMesh/CrystalPos1, $Socket/SocketMesh/CrystalPos2, $Socket/SocketMesh/CrystalPos3]

var start_transform: Transform
var target_transform: Transform
func interpolate_transform(weight: float):
	self.transform = start_transform.interpolate_with(target_transform, weight)
	
func move_to_transform(target_transform_arg: Transform):
	# maybe these two methods can be combined / are interchangable with the new
	# transform.interpolate_with call
	self.target_transform = target_transform_arg
	# back up current transform as starting point for interpolation
	self.start_transform = Transform(transform)
	
	var distance: float = transform.origin.distance_to(target_transform_arg.origin)
	var duration = 2.5
	
	$Tween.reset_all()  
	$Tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	$Tween.interpolate_method(self, "interpolate_transform", 0.0, 1.0, duration, Tween.TRANS_LINEAR)
	$Tween.start()


func open() -> void:
	# TODO have sand particles flying
	# TODO play cool sound
	
	# move doormesh down towards ground
	var start = $Door.transform
	# works under the assumption that door is perfecly upright
	var move_depth = $Door/DoorMesh.scale.y
	var end = start.translated(Vector3(0, -move_depth, 0))
	
	$Tween.reset_all()
	$Tween.interpolate_property($Door, "transform", start, end, 2.5)
	$Tween.start()
	
#	yield($Tween, "tween_all_completed")
#	$CollisionShape.disabled = true


func add_crystal():
	crystal_count += 1
	
	if crystal_count == 3:
		open()

const Crystal = preload("res://Objects/Crystal.tscn")
func _on_CrystalDetector_body_entered(body: Node) -> void:
	print(body, " entered CrystalDetector")
	
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
			crystal.scale *= 20
			get_tree().current_scene.add_child(crystal)
			crystal.global_transform.origin = player.global_transform.origin
			var pos = crystal_positions[i + current_crystal_count]
			crystal.move_towards(pos.global_transform.origin)
			crystal.connect("movement_done", self, "add_crystal")
			
		player.number_of_crystals = 0
		

	
	# check how many Crystal the player holds
	
	# have Crystals flying towards door
	
	# check if the door has 3 


func _on_Button_pressed() -> void:
	open()
