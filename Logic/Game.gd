extends Node


const selection_crosshair = preload("res://Assets/Sprites/cross_selection_circle_thick.png")
const default_crosshair_black = preload("res://Assets/Sprites/crosshair_dark.png")
onready var CROSSHAIR: TextureRect

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

var current = "default"
func change_crosshair(name: String):
	if name != current:
		match name:
			"default":
				CROSSHAIR.texture = default_crosshair_black
				CROSSHAIR.update()
			"selection":
				CROSSHAIR.texture = selection_crosshair
				CROSSHAIR.update()
		current = name
			
			


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if Input.is_action_just_pressed("pause"):
			UI.get_node("Center/PauseLabel").visible = not UI.get_node("Center/PauseLabel").visible
			get_tree().paused = not get_tree().paused
			if get_tree().paused:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
