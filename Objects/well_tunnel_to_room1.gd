extends Spatial

var onetime := false

func _on_Area_body_entered(body: Node) -> void:
	if body is Player:
		if not onetime:
			$Tween.interpolate_property($OmniLight, "light_energy", 0, .3, 1.5)
			$Tween.start()
			onetime = true
