extends Spatial


signal movement_done


func grow():
	$MoveThis.remove_from_group("interactable")
	var init_scale = Vector3(.1,.1,.1)
	$GrowTween.interpolate_property(self, "scale", init_scale, scale, 1.8, Tween.TRANS_BACK, Tween.EASE_OUT)
	$GrowTween.start()
	scale = init_scale
	yield(get_tree().create_timer(1.5), "timeout")
	$MoveThis.add_to_group("interactable")

func _ready():
	$Dance.play("dance")
	$Rotate.play("rotate")
#	$MoveThis.connect("started_interacting", self, "start_interacting")
	pass

# CAREFUL this is not directly called but instead "MoveThis" is interacted with
func start_interacting(player: Player):
	player.crystal_collected(self)
	SoundManager.get_node("PickupSound").play()
	
var start_transform: Transform
var target_transform: Transform
# made this global hope this works
func interpolate_transform(weight: float):
	self.global_transform = start_transform.interpolate_with(target_transform, weight)
	
func move_to_global_transform(global_target_transform: Transform):
	# maybe these two methods can be combined / are interchangable with the new
	# transform.interpolate_with call
	self.target_transform = global_target_transform
	# back up current transform as starting point for interpolation
	self.start_transform = Transform(global_transform)
	
	var duration = 1.6
	$Tween.reset_all()  
	$Tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	$Tween.interpolate_method(self, "interpolate_transform", 0.0, 1.0, duration, Tween.TRANS_LINEAR)
	$Tween.start()
	$FlyingSound.play()


func move_towards(target_position_global: Transform):
#	$Tween.reset_all()	
#	var start = self.global_transform
#	var target = Transform(self.global_transform)
#	target.origin = target_position_global
#	$Tween.interpolate_property(self, "global_transform", start, target, 1.2)
#	$Tween.start()
	move_to_global_transform(target_position_global)
	yield($Tween, "tween_all_completed")
	emit_signal("movement_done", self)
#	print("crystal ", name, " movement done")
