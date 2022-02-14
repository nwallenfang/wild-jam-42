extends StaticBody


signal movement_done


func start_interacting(player: Player):
	player.crystal_collected(self)
	
	
func stop_interacting():
	pass


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
