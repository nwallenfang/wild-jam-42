extends Spatial


var crystal_count = 0
var positions = null

onready var crystals = [$SlidingDoor/Crystal1, $SlidingDoor/Crystal2, $SlidingDoor/Crystal3]
onready var lights = [$SlidingDoor/OmniLight1, $SlidingDoor/OmniLight2, $SlidingDoor/OmniLight3]
onready var tweens = [$LightTw1, $LightTw2, $LightTw3]

func _ready() -> void:
#	$SlidingDoor/Crystal1/.get_node("Dance").stop()
#	$SlidingDoor/Crystal1.get_node("Rotate").stop()
#	$SlidingDoor/Crystal2.get_node("Dance").stop()
#	$SlidingDoor/Crystal2.get_node("Rotate").stop()
#	$SlidingDoor/Crystal3.get_node("Dance").stop()
#	$SlidingDoor/Crystal3.get_node("Rotate").stop()
	pass

var max_energy = 3.9
var grow_dur = 0.4
var shrink_dur = 0.2
func animate_light(light: OmniLight, tween: Tween):
	var _dummy: bool
	light.visible = true
	light.light_energy = 0.0
	_dummy = tween.reset_all()
	_dummy = tween.interpolate_property(light, "light_energy", null, max_energy, Tween.EASE_IN)
	_dummy = tween.start()
	yield(tween, "tween_all_completed")
	
	_dummy = tween.reset_all()
	_dummy = tween.interpolate_property(light, "light_energy", null, 0.0, Tween.EASE_OUT)
	_dummy = tween.start()
	yield(tween, "tween_all_completed")
	
	
	light.visible = false


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
	# TODO have sand particles flying
	yield(get_tree().create_timer(1.5), "timeout")
	$DoorSound.play()
	# move doormesh down towards ground
	var start = $SlidingDoor.transform
	# works under the assumption that door is perfecly upright
	# (what kind of psycho door doesn't stand nicely upright?)
	var move_depth = 4
	var end = start.translated(Vector3(0, -move_depth, 0))
	
	$Tween.reset_all()
	$Tween.interpolate_property($SlidingDoor, "transform", start, end, 2.5)
	$Tween.start()
	


func add_crystal(crystal: Node):
	# move crystal to new parent (CrystalDoor/SlidingDoor)
	crystals[crystal_count].visible = true
	animate_light(lights[crystal_count], tweens[crystal_count])
	crystal_count += 1
	
	
	
	crystal.queue_free()
	if crystal_count == 3:
		open()

const Crystal = preload("res://Objects/Crystal.tscn")
var currently_entered = false
func _on_CrystalDetector_body_entered(body: Node) -> void:
	if body is Player and not currently_entered:
		# instantiate crystals from player position and move them towards
		# maybe rotate them a couple of times while they are moving
		# play some ding sound
		
		var player = body as Player
		var current_crystal_count: int = int(crystal_count)
		
		for i in range(player.number_of_crystals):
			currently_entered = true
			var crystal = Crystal.instance()
			get_tree().current_scene.add_child(crystal)
			crystal.get_node("Dance").call_deferred("stop")
			crystal.get_node("Rotate").call_deferred("stop")
			crystal.get_node("MoveThis/CollisionShape").disabled = true
			crystal.global_transform.origin = player.global_transform.origin
			var pos = crystals[i + current_crystal_count]
			crystal.move_towards(pos.global_transform)
			crystal.connect("movement_done", self, "add_crystal")
			
			yield(get_tree().create_timer(0.8), "timeout")
			
		player.number_of_crystals = 0
		currently_entered = false


func _on_Button_pressed() -> void:
	open()
