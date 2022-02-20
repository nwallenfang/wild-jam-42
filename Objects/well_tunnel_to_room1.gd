extends Spatial



func _on_Area_body_entered(body: Node) -> void:
	if body is Player:
		$Tween.interpolate_property($OmniLight, "light_energy", 0, .3, 1.5)
		$Tween.start()
