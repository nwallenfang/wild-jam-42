extends Spatial

func cling():
	$StaticBody.remove_from_group("interactable")
	$AnimationPlayer.play("cling")
	
func play_cling_sound():
	pass

const CRYSTAL = preload("res://Objects/Crystal.tscn")

func spawn_crystal():
	var crystal = CRYSTAL.instance()
	get_parent().add_child(crystal)
	crystal.translation = translation + Vector3(0, .3, -.15)
