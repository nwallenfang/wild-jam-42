extends Spatial

func _ready() -> void:
	pass

signal was_opened

var fade_duration = 0.5
func start_fading():
	for node in [$Meshes/Grabber, $Meshes/Plank]:
		var mat = node.mesh.surface_get_material(0).duplicate(false)
		node.set("material/0", mat)
		mat.set("flags_transparent", true)
		mat.set("params_cull_mode", SpatialMaterial.CULL_BACK)
		mat.set("params_depth_draw_mode", SpatialMaterial.DEPTH_DRAW_ALWAYS)
		$FadeTween.interpolate_property(mat, "albedo_color", Color.white, Color.transparent, fade_duration)
	$FadeTween.start()
	yield($FadeTween, "tween_all_completed")
	emit_signal("was_opened")
	queue_free()

func open():
	$AnimationPlayer.play("open")
