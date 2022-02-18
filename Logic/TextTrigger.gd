extends Spatial


export var text: String
export var duration: float

func _on_Area_body_entered(body: Node) -> void:
	if body is Player:
		UI.queue_text(text, duration)
		# these TextTriggers are oneshot, so disable monitoring once triggered
		set_deferred("monitoring", false)


func trigger_manually():
	UI.queue_text(text, duration)
	# these TextTriggers are oneshot, so disable monitoring once triggered
	set_deferred("monitoring", false)
