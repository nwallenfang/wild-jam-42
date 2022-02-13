extends StaticBody


signal movement_done


func start_interacting(player: Player):
	player.crystal_collected(self)
	
	
func stop_interacting():
	pass


#func _on_PickUpArea_body_entered(body: Node) -> void:
#	# body should be a player
##	body = body as Player
#
#	if body.has_method("crystal_collected"):
#		body.call("crystal_collected", self)

func move_towards(target_position_global: Vector3):
	$Tween.reset_all()
	
	var start = self.global_transform
	var target = Transform(self.global_transform)
	target.origin = target_position_global
	$Tween.interpolate_property(self, "global_transform", start, target, 1.2)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	emit_signal("movement_done", self)
#	print("crystal ", name, " movement done")
