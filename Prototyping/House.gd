extends Spatial

func _on_Area_body_entered(body: Node) -> void:
	if body is Player:
		SoundManager.stop_intro_atmosphere()
		$Area/CollisionShape.set_deferred("disabled", true)

