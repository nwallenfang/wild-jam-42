extends Spatial

func cling():
	$StaticBody.remove_from_group("interactable")
	$StaticBody.set_deferred("monitoring", false)
	$StaticBody.set_deferred("monitorable", false)
	for collision in $StaticBody.get_children():
		collision.set_deferred("disabled", true)
	$AnimationPlayer.play("cling")
	
func play_cling_sound():
	$ClingSound.play()

const CRYSTAL = preload("res://Objects/Crystal.tscn")

func spawn_crystal():
	var crystal = CRYSTAL.instance()
	get_parent().add_child(crystal)
	crystal.translation = translation + Vector3(0, .3, -.15)
