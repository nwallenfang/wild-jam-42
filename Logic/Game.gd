extends Node



func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if Input.is_action_just_pressed("pause"):
			UI.get_node("Center/PauseLabel").visible = not UI.get_node("Center/PauseLabel").visible
			get_tree().paused = not get_tree().paused
			if get_tree().paused:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
