extends Node


const selection_crosshair = preload("res://Assets/Sprites/cross_selection_circle_thick.png")
const default_crosshair_black = preload("res://Assets/Sprites/crosshair_dark.png")
onready var CROSSHAIR: TextureRect

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
			
			
