extends Spatial

func cling():
	$StaticBody.remove_from_group("interactable")
	$AnimationPlayer.play("cling")
	
func play_cling_sound():
	pass

func spawn_crystal():
	pass
